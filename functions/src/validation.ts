/**
 * Input validation for the callable functions. Pure functions, no Firebase
 * imports, so they can be unit tested directly.
 */

export const LIMITS = {
  /** Serialized finance context, in characters (about 6k tokens) */
  contextChars: 24_000,
  /** Messages kept from a chat history (oldest are dropped) */
  historyMessages: 20,
  /** Characters in one chat message */
  messageChars: 4_000,
  /** Transaction description sent for categorisation */
  descriptionChars: 120,
  /** Categories offered to the categoriser */
  categories: 80,
  categoryNameChars: 40,
  /** Characters of AI output attached to a report */
  reportContentChars: 12_000,
  /** Characters in the reporter's optional note */
  reportNoteChars: 500,
} as const;

export class InvalidInput extends Error {}

export type ChatRole = "user" | "model";

export interface ChatMessage {
  role: ChatRole;
  text: string;
}

export type FinanceContext = Record<string, unknown>;

export interface ChatRequest {
  financeContext: FinanceContext | null;
  messages: ChatMessage[];
}

export interface ContextRequest {
  financeContext: FinanceContext;
}

export interface MonthlyReportRequest extends ContextRequest {
  /** "YYYY-MM" */
  month: string;
}

export interface CategorizeRequest {
  description: string;
  type: "expense" | "income";
  categories: string[];
}

function isPlainObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

/**
 * Keys that must never reach the model, whatever the app sends: account and
 * card numbers, bank names, free-text notes, payees, locations, attachments.
 * Matched case-insensitively against every key at any depth.
 */
const BLOCKED_KEY = /^(account_?number|card_?number|iban|ifsc|bank_?name|institution(_?name)?|notes?|payee|location|tags|attachment(_?url)?|external_?id|email|phone(_?number)?|uid)$/i;

/** Deep copy of [value] with blocked keys removed */
export function redactContext(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(redactContext);
  if (isPlainObject(value)) {
    const out: Record<string, unknown> = {};
    for (const [key, v] of Object.entries(value)) {
      if (BLOCKED_KEY.test(key)) continue;
      out[key] = redactContext(v);
    }
    return out;
  }
  return value;
}

function parseContext(value: unknown, required: boolean): FinanceContext | null {
  if (value === undefined || value === null) {
    if (required) throw new InvalidInput("financeContext is required.");
    return null;
  }
  if (!isPlainObject(value)) {
    throw new InvalidInput("financeContext must be an object.");
  }
  const redacted = redactContext(value) as FinanceContext;
  if (JSON.stringify(redacted).length > LIMITS.contextChars) {
    throw new InvalidInput("financeContext is too large.");
  }
  return redacted;
}

function parseMessages(raw: unknown): ChatMessage[] {
  if (!Array.isArray(raw) || raw.length === 0) {
    throw new InvalidInput("messages must be a non-empty array.");
  }
  const messages = raw.slice(-LIMITS.historyMessages).map((m, i) => {
    if (!isPlainObject(m)) throw new InvalidInput(`messages[${i}] is invalid.`);
    if (m.role !== "user" && m.role !== "model") {
      throw new InvalidInput(`messages[${i}].role must be "user" or "model".`);
    }
    if (typeof m.text !== "string" || m.text.trim().length === 0) {
      throw new InvalidInput(`messages[${i}].text must be a non-empty string.`);
    }
    if (m.text.length > LIMITS.messageChars) {
      throw new InvalidInput(`messages[${i}].text is too long.`);
    }
    return { role: m.role, text: m.text.trim() } as ChatMessage;
  });
  if (messages[messages.length - 1].role !== "user") {
    throw new InvalidInput("The last message must be from the user.");
  }
  return messages;
}

export function parseChatRequest(data: unknown): ChatRequest {
  if (!isPlainObject(data)) throw new InvalidInput("Request must be an object.");
  return {
    financeContext: parseContext(data.financeContext, false),
    messages: parseMessages(data.messages),
  };
}

export function parseContextRequest(data: unknown): ContextRequest {
  if (!isPlainObject(data)) throw new InvalidInput("Request must be an object.");
  return { financeContext: parseContext(data.financeContext, true)! };
}

export function parseMonthlyReportRequest(data: unknown): MonthlyReportRequest {
  const { financeContext } = parseContextRequest(data);
  const month = (data as Record<string, unknown>).month;
  if (typeof month !== "string" || !/^\d{4}-(0[1-9]|1[0-2])$/.test(month)) {
    throw new InvalidInput('month must look like "2026-11".');
  }
  return { financeContext, month };
}

export function parseCategorizeRequest(data: unknown): CategorizeRequest {
  if (!isPlainObject(data)) throw new InvalidInput("Request must be an object.");
  const { description, type, categories } = data;
  if (typeof description !== "string" || description.trim().length === 0) {
    throw new InvalidInput("description is required.");
  }
  if (type !== "expense" && type !== "income") {
    throw new InvalidInput('type must be "expense" or "income".');
  }
  if (!Array.isArray(categories) || categories.length === 0) {
    throw new InvalidInput("categories must be a non-empty array.");
  }
  const names = categories
    .slice(0, LIMITS.categories)
    .map((c, i) => {
      if (typeof c !== "string" || c.trim().length === 0) {
        throw new InvalidInput(`categories[${i}] must be a non-empty string.`);
      }
      return c.trim().slice(0, LIMITS.categoryNameChars);
    });
  return {
    description: description.trim().slice(0, LIMITS.descriptionChars),
    type,
    categories: [...new Set(names)],
  };
}

/** The model's category if it is exactly one of the offered names, else null */
export function matchCategory(answer: unknown, categories: string[]): string | null {
  if (typeof answer !== "string") return null;
  const wanted = answer.trim().toLowerCase();
  return categories.find((c) => c.toLowerCase() === wanted) ?? null;
}

export const REPORT_REASONS = ["harmful", "offensive", "inaccurate", "other"] as const;
export type ReportReason = (typeof REPORT_REASONS)[number];

export const REPORT_KINDS = ["chat", "suggestion", "report"] as const;
export type ReportKind = (typeof REPORT_KINDS)[number];

export interface ReportRequest {
  kind: ReportKind;
  reason: ReportReason;
  content: string;
  note: string | null;
}

/** A user's report of AI output they found harmful, offensive or wrong */
export function parseReportRequest(data: unknown): ReportRequest {
  if (!isPlainObject(data)) throw new InvalidInput("Request must be an object.");
  const { kind, reason, content, note } = data;
  if (typeof kind !== "string" || !(REPORT_KINDS as readonly string[]).includes(kind)) {
    throw new InvalidInput(`kind must be one of ${REPORT_KINDS.join(", ")}.`);
  }
  if (typeof reason !== "string" || !(REPORT_REASONS as readonly string[]).includes(reason)) {
    throw new InvalidInput(`reason must be one of ${REPORT_REASONS.join(", ")}.`);
  }
  if (typeof content !== "string" || content.trim().length === 0) {
    throw new InvalidInput("content is required.");
  }
  if (note !== undefined && note !== null && typeof note !== "string") {
    throw new InvalidInput("note must be a string.");
  }
  return {
    kind: kind as ReportKind,
    reason: reason as ReportReason,
    content: content.trim().slice(0, LIMITS.reportContentChars),
    note: typeof note === "string" && note.trim() ? note.trim().slice(0, LIMITS.reportNoteChars) : null,
  };
}
