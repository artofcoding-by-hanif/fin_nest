import { randomUUID } from "node:crypto";

import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore, Timestamp } from "firebase-admin/firestore";
import { setGlobalOptions } from "firebase-functions/v2";
import { CallableRequest, HttpsError, onCall } from "firebase-functions/v2/https";
import { defineInt, defineSecret, defineString } from "firebase-functions/params";
import { logger } from "firebase-functions";
import { GenerateContentConfig, GoogleGenAI, ThinkingLevel } from "@google/genai";

import { AttemptInfo, generateWithRetry, IncompleteResponse, ModelsBusy } from "./gemini.js";
import { hasPremium } from "./entitlement.js";
import { allowanceFor, Bucket, DEFAULT_LIMITS, LimitTable } from "./limits.js";
import {
  CATEGORIZE_SCHEMA,
  CATEGORIZE_SYSTEM_PROMPT,
  CHAT_SYSTEM_PROMPT,
  INSIGHTS_SCHEMA,
  INSIGHTS_SYSTEM_PROMPT,
  REPORT_SCHEMA,
  REPORT_SYSTEM_PROMPT,
  withFinanceData,
} from "./prompts.js";
import { consumeQuota, Plan, refundQuota } from "./quota.js";
import {
  InvalidInput,
  matchCategory,
  parseCategorizeRequest,
  parseChatRequest,
  parseContextRequest,
  parseMonthlyReportRequest,
  parseReportRequest,
} from "./validation.js";

initializeApp();
// Mumbai: closest to FinNest's users, same location as the Firestore database
setGlobalOptions({ region: "asia-south1", maxInstances: 10 });

/** Set with: firebase functions:secrets:set GEMINI_API_KEY */
const geminiApiKey = defineSecret("GEMINI_API_KEY");

/**
 * RevenueCat secret API key, used to check the Premium entitlement.
 * Set with: firebase functions:secrets:set REVENUECAT_SECRET_KEY
 * (enter "none" until RevenueCat is set up; everyone is then on the free plan)
 */
const revenueCatSecretKey = defineSecret("REVENUECAT_SECRET_KEY");
const ENTITLEMENT_ID = "premium";

/** Model id; the alias tracks Google's current Flash model */
const geminiModel = defineString("GEMINI_MODEL", { default: "gemini-flash-latest" });

/** Used when the main model is overloaded */
const geminiFallbackModel = defineString("GEMINI_FALLBACK_MODEL", {
  default: "gemini-flash-lite-latest",
});

/** Allowances, overridable without a code change (functions/.env or deploy prompt) */
const limitParams = {
  chatFree: defineInt("AI_CHAT_FREE_DAILY", { default: DEFAULT_LIMITS.chat.free.limit }),
  chatPremium: defineInt("AI_CHAT_PREMIUM_DAILY", { default: DEFAULT_LIMITS.chat.premium.limit }),
  insightsFree: defineInt("AI_INSIGHTS_FREE_WEEKLY", { default: DEFAULT_LIMITS.insights.free.limit }),
  insightsPremium: defineInt("AI_INSIGHTS_PREMIUM_DAILY", {
    default: DEFAULT_LIMITS.insights.premium.limit,
  }),
  reportPremium: defineInt("AI_REPORT_PREMIUM_MONTHLY", {
    default: DEFAULT_LIMITS.report.premium.limit,
  }),
  categorizePremium: defineInt("AI_CATEGORIZE_PREMIUM_DAILY", {
    default: DEFAULT_LIMITS.categorize.premium.limit,
  }),
};

function limitTable(): LimitTable {
  return {
    chat: {
      free: { ...DEFAULT_LIMITS.chat.free, limit: limitParams.chatFree.value() },
      premium: { ...DEFAULT_LIMITS.chat.premium, limit: limitParams.chatPremium.value() },
    },
    insights: {
      free: { ...DEFAULT_LIMITS.insights.free, limit: limitParams.insightsFree.value() },
      premium: { ...DEFAULT_LIMITS.insights.premium, limit: limitParams.insightsPremium.value() },
    },
    report: {
      free: DEFAULT_LIMITS.report.free,
      premium: { ...DEFAULT_LIMITS.report.premium, limit: limitParams.reportPremium.value() },
    },
    categorize: {
      free: DEFAULT_LIMITS.categorize.free,
      premium: { ...DEFAULT_LIMITS.categorize.premium, limit: limitParams.categorizePremium.value() },
    },
  };
}

const callableOptions = {
  secrets: [geminiApiKey, revenueCatSecretKey],
  // Only genuine app builds (or registered debug tokens) may call these
  enforceAppCheck: true,
  // Callables must be publicly invokable at the Cloud Run level; access is
  // controlled by App Check and Firebase Auth inside the function instead
  invoker: "public" as const,
  timeoutSeconds: 120,
  memory: "512MiB" as const,
};

/** Retries stop starting well before the function timeout */
const MODEL_BUDGET_MS = 95_000;

/** One slow call shouldn't eat the whole budget; the fallback gets its turn */
const ATTEMPT_TIMEOUT_MS = 20_000;

/** Low thinking keeps answers fast; output allowance covers thoughts + reply */
const BASE_CONFIG: GenerateContentConfig = {
  thinkingConfig: { thinkingLevel: ThinkingLevel.LOW },
  maxOutputTokens: 8192,
};

function logAttempt(fn: string, uid: string) {
  return (info: AttemptInfo) => logger.info(`${fn} gemini attempt`, { uid, ...info });
}

function requireUser(request: CallableRequest): string {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Sign-in required.");
  return uid;
}

function parse<T>(parser: (data: unknown) => T, data: unknown): T {
  try {
    return parser(data);
  } catch (error) {
    if (error instanceof InvalidInput) throw new HttpsError("invalid-argument", error.message);
    throw error;
  }
}

function models() {
  return new GoogleGenAI({ apiKey: geminiApiKey.value() }).models;
}

function modelList(): string[] {
  return [geminiModel.value(), geminiFallbackModel.value()].filter(
    (m, i, all) => m && all.indexOf(m) === i,
  );
}

/** The user's allowance for [bucket]; the free plan if the lookup fails */
async function planFor(uid: string, bucket: Bucket): Promise<Plan> {
  let premium = false;
  try {
    premium = await hasPremium(uid, {
      secretKey: revenueCatSecretKey.value(),
      entitlementId: ENTITLEMENT_ID,
    });
  } catch (error) {
    logger.warn("Premium lookup failed; applying free limits", { uid, error: String(error) });
  }
  return { bucket, premium, allowance: allowanceFor(limitTable(), bucket, premium) };
}

/**
 * Runs one quota-counted request: takes a unit of the bucket's allowance,
 * refunds it if the request fails, and turns failures into callable errors.
 * Responses include `remaining` and `premium` so the app can show them.
 */
async function metered<T>(
  name: string,
  uid: string,
  bucket: Bucket,
  run: () => Promise<T>,
): Promise<T & { remaining: number; premium: boolean }> {
  const plan = await planFor(uid, bucket);
  let charged = false;
  try {
    const remaining = await consumeQuota(uid, plan);
    charged = true;
    return { ...(await run()), remaining, premium: plan.premium };
  } catch (error) {
    if (charged) await refundQuota(uid, plan).catch(() => undefined);
    if (error instanceof HttpsError) throw error;
    logger.error(`${name} failed`, { uid, error: String(error) });
    if (error instanceof ModelsBusy) {
      throw new HttpsError("unavailable", "The assistant is very busy right now. Please try again in a minute.");
    }
    if (error instanceof IncompleteResponse) {
      throw new HttpsError("unavailable", "The assistant couldn't finish its answer. Please try again.");
    }
    throw new HttpsError("unavailable", "The assistant is unavailable right now. Please try again.");
  }
}

async function generateJson(
  fn: string,
  uid: string,
  prompt: string,
  systemInstruction: string,
  schema: object,
  temperature: number,
): Promise<Record<string, unknown>> {
  const response = await generateWithRetry(models(), {
    models: modelList(),
    contents: [{ role: "user", parts: [{ text: prompt }] }],
    config: {
      ...BASE_CONFIG,
      systemInstruction,
      temperature,
      responseMimeType: "application/json",
      responseJsonSchema: schema,
    },
    budgetMs: MODEL_BUDGET_MS,
    attemptTimeoutMs: ATTEMPT_TIMEOUT_MS,
    onAttempt: logAttempt(fn, uid),
  });
  const text = response.text;
  if (!text) throw new IncompleteResponse("Empty response from model");
  try {
    return JSON.parse(text) as Record<string, unknown>;
  } catch {
    throw new IncompleteResponse("Model returned invalid JSON");
  }
}

/**
 * Chat with the assistant about the user's finances.
 *
 * Request:  { financeContext?: object, messages: [{ role: "user"|"model", text }] }
 * Response: { reply: string, remaining: number, premium: boolean }
 */
export const aiChat = onCall(callableOptions, async (request) => {
  const uid = requireUser(request);
  const { financeContext, messages } = parse(parseChatRequest, request.data);

  return metered("aiChat", uid, "chat", async () => {
    const response = await generateWithRetry(models(), {
      models: modelList(),
      contents: messages.map((m) => ({ role: m.role, parts: [{ text: m.text }] })),
      config: {
        ...BASE_CONFIG,
        systemInstruction: `${CHAT_SYSTEM_PROMPT}\n\n${withFinanceData(financeContext)}`,
        temperature: 0.5,
      },
      budgetMs: MODEL_BUDGET_MS,
      attemptTimeoutMs: ATTEMPT_TIMEOUT_MS,
      onAttempt: logAttempt("aiChat", uid),
    });
    const reply = response.text?.trim();
    if (!reply) throw new IncompleteResponse("Empty response from model");
    return { reply };
  });
});

/**
 * Personalised suggestions feed.
 *
 * Request:  { financeContext: object }
 * Response: { suggestions: [<INSIGHTS_SCHEMA item> + id], remaining, premium }
 */
export const aiInsights = onCall(callableOptions, async (request) => {
  const uid = requireUser(request);
  const { financeContext } = parse(parseContextRequest, request.data);

  return metered("aiInsights", uid, "insights", async () => {
    const result = await generateJson(
      "aiInsights",
      uid,
      `Suggest improvements for this user.\n\n${withFinanceData(financeContext)}`,
      INSIGHTS_SYSTEM_PROMPT,
      INSIGHTS_SCHEMA,
      0.4,
    );
    const items = Array.isArray(result.suggestions) ? result.suggestions : [];
    if (items.length === 0) throw new IncompleteResponse("No suggestions returned");
    return {
      suggestions: items.map((s) => ({ id: randomUUID(), ...(s as Record<string, unknown>) })),
    };
  });
});

/**
 * Structured review of one month (Premium only).
 *
 * Request:  { financeContext: object, month: "YYYY-MM" }
 * Response: { report: <REPORT_SCHEMA>, remaining, premium }
 */
export const aiMonthlyReport = onCall(callableOptions, async (request) => {
  const uid = requireUser(request);
  const { financeContext, month } = parse(parseMonthlyReportRequest, request.data);

  return metered("aiMonthlyReport", uid, "report", async () => {
    const report = await generateJson(
      "aiMonthlyReport",
      uid,
      `MONTH: ${month}\nReview this month.\n\n${withFinanceData(financeContext)}`,
      REPORT_SYSTEM_PROMPT,
      REPORT_SCHEMA,
      0.3,
    );
    return { report: { month, ...report } };
  });
});

/**
 * Suggests a category for a transaction description (Premium only). Sends
 * only the description and the user's category names.
 *
 * Request:  { description, type: "expense"|"income", categories: string[] }
 * Response: { category: string|null, confidence, remaining, premium }
 */
export const aiCategorize = onCall(
  { ...callableOptions, timeoutSeconds: 30, memory: "256MiB" as const },
  async (request) => {
    const uid = requireUser(request);
    const req = parse(parseCategorizeRequest, request.data);

    return metered("aiCategorize", uid, "categorize", async () => {
      const result = await generateJson(
        "aiCategorize",
        uid,
        JSON.stringify({ description: req.description, type: req.type, categories: req.categories }),
        CATEGORIZE_SYSTEM_PROMPT,
        CATEGORIZE_SCHEMA,
        0,
      );
      const category = matchCategory(result.category, req.categories);
      return {
        category,
        confidence: category ? (result.confidence as string) ?? "low" : "low",
      };
    });
  },
);

/** Reports are reviewed by the developer, then deleted by a Firestore TTL */
const REPORT_RETENTION_DAYS = 90;

/**
 * Lets users flag AI output they find harmful, offensive or wrong, as
 * Google Play's AI-generated content policy requires. Stored in
 * `aiReports/{id}` for review; no AI quota is used.
 *
 * Request:  { kind: "chat"|"suggestion"|"report", reason, content, note? }
 * Response: { ok: true }
 */
export const reportAiContent = onCall(
  { enforceAppCheck: true, invoker: "public", timeoutSeconds: 20 },
  async (request) => {
    const uid = requireUser(request);
    const report = parse(parseReportRequest, request.data);

    await getFirestore()
      .collection("aiReports")
      .add({
        ...report,
        uid,
        createdAt: FieldValue.serverTimestamp(),
        expireAt: Timestamp.fromMillis(Date.now() + REPORT_RETENTION_DAYS * 24 * 60 * 60 * 1000),
      });
    logger.info("AI content reported", { uid, kind: report.kind, reason: report.reason });
    return { ok: true };
  },
);
