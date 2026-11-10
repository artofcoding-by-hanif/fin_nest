import assert from "node:assert/strict";
import { test } from "node:test";
import type { GenerateContentParameters, GenerateContentResponse } from "@google/genai";

import { generateWithRetry, IncompleteResponse, ModelsApi, ModelsBusy } from "./gemini.js";

type Step = { finishReason?: string } | { status: number };

/** Plays back a script of responses/errors and records each call */
function fakeApi(steps: Step[]) {
  const calls: GenerateContentParameters[] = [];
  const api: ModelsApi = {
    async generateContent(params) {
      calls.push(params);
      const step = steps.shift();
      if (!step) throw new Error("unexpected call");
      if ("status" in step) throw Object.assign(new Error(`HTTP ${step.status}`), step);
      return {
        candidates: [{ finishReason: step.finishReason ?? "STOP" }],
      } as unknown as GenerateContentResponse;
    },
  };
  return { api, calls };
}

const base = {
  contents: "hi",
  config: { thinkingConfig: { thinkingBudget: 100 }, maxOutputTokens: 10 },
  sleep: async () => undefined,
};

test("returns the first good response", async () => {
  const { api, calls } = fakeApi([{}]);
  await generateWithRetry(api, { ...base, models: ["main"] });
  assert.equal(calls.length, 1);
  assert.equal(calls[0].model, "main");
});

test("switches model immediately when one is overloaded or too slow", async () => {
  for (const status of [503, 504]) {
    const { api, calls } = fakeApi([{ status }, {}]);
    await generateWithRetry(api, { ...base, models: ["main", "lite"] });
    assert.deepEqual(
      calls.map((c) => c.model),
      ["main", "lite"],
      `status ${status}`,
    );
  }
});

test("retries rate limits on the same model before falling back", async () => {
  const { api, calls } = fakeApi([{ status: 429 }, { status: 500 }, { status: 429 }, {}]);
  await generateWithRetry(api, { ...base, models: ["main", "lite"] });
  assert.deepEqual(
    calls.map((c) => c.model),
    ["main", "main", "main", "lite"],
  );
});

test("drops thinking settings once if the model rejects them", async () => {
  const { api, calls } = fakeApi([{ status: 400 }, {}]);
  await generateWithRetry(api, { ...base, models: ["main"] });
  assert.ok(calls[0].config?.thinkingConfig);
  assert.equal(calls[1].config?.thinkingConfig, undefined);
});

test("does not retry other client errors", async () => {
  const { api } = fakeApi([{ status: 403 }]);
  await assert.rejects(
    generateWithRetry(api, { ...base, config: { maxOutputTokens: 10 }, models: ["main"] }),
    /HTTP 403/,
  );
});

test("reports truncated output instead of returning it", async () => {
  const { api } = fakeApi([{ finishReason: "MAX_TOKENS" }]);
  await assert.rejects(generateWithRetry(api, { ...base, models: ["main"] }), IncompleteResponse);
});

test("gives up as busy when every model stays overloaded", async () => {
  const { api } = fakeApi([{ status: 503 }, { status: 504 }]);
  await assert.rejects(generateWithRetry(api, { ...base, models: ["main", "lite"] }), ModelsBusy);
});

test("stops retrying once the time budget is spent", async () => {
  let clock = 0;
  const { api, calls } = fakeApi([{ status: 429 }, { status: 429 }]);
  await assert.rejects(
    generateWithRetry(api, {
      ...base,
      models: ["main", "lite"],
      budgetMs: 1_000,
      now: () => clock,
      sleep: async (ms) => {
        clock += ms;
      },
    }),
    ModelsBusy,
  );
  assert.equal(calls.length, 1);
});

test("a timed-out call moves straight to the next model", async () => {
  const { api, calls } = fakeApi([]);
  const seen: string[] = [];
  const slowThenFast: ModelsApi = {
    async generateContent(params) {
      calls.push(params);
      if (params.model === "main") throw Object.assign(new Error("Request timed out"), { name: "AbortError" });
      return { candidates: [{ finishReason: "STOP" }] } as unknown as GenerateContentResponse;
    },
  };
  await generateWithRetry(slowThenFast, {
    ...base,
    models: ["main", "lite"],
    onAttempt: (info) => seen.push(`${info.model}:${info.outcome}`),
  });
  assert.deepEqual(seen, ["main:timeout", "lite:ok"]);
  assert.equal(calls[0].config?.httpOptions?.timeout, 40_000);
  void api;
});
