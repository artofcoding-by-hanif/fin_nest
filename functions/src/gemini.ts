import type { GenerateContentConfig, GenerateContentParameters, GenerateContentResponse } from "@google/genai";

/** The part of the GoogleGenAI client this module uses (fakeable in tests) */
export interface ModelsApi {
  generateContent(params: GenerateContentParameters): Promise<GenerateContentResponse>;
}

/** The model stopped before finishing (output limit, safety, ...) */
export class IncompleteResponse extends Error {}

/** Every model attempt failed because the service was overloaded */
export class ModelsBusy extends Error {}

export interface GenerateOptions {
  /** Models to try in order; later ones are fallbacks for overload */
  models: string[];
  contents: GenerateContentParameters["contents"];
  config: GenerateContentConfig;
  /** Stop starting new attempts after this many ms (function timeout guard) */
  budgetMs?: number;
  /** Abandon a single call after this many ms and move to the next model */
  attemptTimeoutMs?: number;
  /** Called after every attempt, for logging */
  onAttempt?: (info: AttemptInfo) => void;
  /** Injected for tests */
  sleep?: (ms: number) => Promise<void>;
  now?: () => number;
}

export interface AttemptInfo {
  model: string;
  ms: number;
  outcome: "ok" | "timeout" | "error";
  status?: number;
  error?: string;
}

/** Transient errors worth retrying on the same model after a pause */
const RETRYABLE_STATUS = new Set([429, 500]);

/** The model is overloaded or too slow right now: switch models at once */
const SWITCH_MODEL_STATUS = new Set([503, 504]);
const BACKOFF_MS = [1_500, 4_000];

function isTimeout(error: unknown): boolean {
  const e = error as { name?: string; message?: string };
  return e?.name === "AbortError" || /abort|timed? ?out/i.test(e?.message ?? "");
}

function statusOf(error: unknown): number | undefined {
  const status = (error as { status?: unknown })?.status;
  return typeof status === "number" ? status : undefined;
}

/**
 * generateContent with the resilience a user-facing feature needs:
 * - switches to the next model as soon as one is overloaded (503) or too
 *   slow (504 / client timeout)
 * - retries rate limits and transient 500s with backoff
 * - drops `thinkingConfig` once if a model rejects it (400)
 * - turns truncated or blocked output into IncompleteResponse instead of
 *   handing back half a JSON document
 */
export async function generateWithRetry(
  api: ModelsApi,
  options: GenerateOptions,
): Promise<GenerateContentResponse> {
  const sleep = options.sleep ?? ((ms: number) => new Promise((r) => setTimeout(r, ms)));
  const now = options.now ?? Date.now;
  const deadline = now() + (options.budgetMs ?? 75_000);
  let lastError: unknown;

  const attemptTimeout = options.attemptTimeoutMs ?? 40_000;

  for (const model of options.models) {
    let config = options.config;

    for (let attempt = 0; attempt <= BACKOFF_MS.length; attempt++) {
      const remaining = deadline - now();
      if (remaining <= 0) break;
      const started = now();
      try {
        const response = await api.generateContent({
          model,
          contents: options.contents,
          config: {
            ...config,
            httpOptions: { ...config.httpOptions, timeout: Math.min(attemptTimeout, remaining) },
          },
        });
        const finish = response.candidates?.[0]?.finishReason;
        if (finish && finish !== "STOP") {
          throw new IncompleteResponse(`Model stopped early: ${finish}`);
        }
        options.onAttempt?.({ model, ms: now() - started, outcome: "ok" });
        return response;
      } catch (error) {
        lastError = error;
        const status = statusOf(error);
        const timedOut =
          (status === undefined && isTimeout(error)) || status === 504;
        options.onAttempt?.({
          model,
          ms: now() - started,
          outcome: timedOut ? "timeout" : "error",
          status,
          error: String(error).slice(0, 300),
        });

        // A model that is overloaded or this slow now will be again in a
        // second; go straight to the next one
        if (timedOut || (status !== undefined && SWITCH_MODEL_STATUS.has(status))) break;

        // Some models don't accept thinking settings; retry once without
        if (status === 400 && config.thinkingConfig) {
          const { thinkingConfig: _unused, ...rest } = config;
          config = rest;
          attempt--;
          continue;
        }
        if (status === undefined || !RETRYABLE_STATUS.has(status)) throw error;
        if (attempt < BACKOFF_MS.length) await sleep(BACKOFF_MS[attempt]);
      }
    }
  }

  throw new ModelsBusy(`All models busy or out of time: ${String(lastError)}`);
}
