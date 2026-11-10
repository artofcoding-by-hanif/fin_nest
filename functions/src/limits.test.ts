import assert from "node:assert/strict";
import { test } from "node:test";

import {
  allowanceFor,
  DEFAULT_LIMITS,
  exhaustedMessage,
  periodKey,
  premiumOnlyMessage,
} from "./limits.js";

test("period keys for day, month and ISO week", () => {
  const d = new Date("2026-11-10T23:59:00Z");
  assert.equal(periodKey("day", d), "2026-11-10");
  assert.equal(periodKey("month", d), "2026-11");
  assert.equal(periodKey("week", d), "2026-W46");
});

test("ISO week edges: Jan 1 can belong to the previous year's week", () => {
  // Friday 2027-01-01 is in ISO week 53 of 2026
  assert.equal(periodKey("week", new Date("2027-01-01T12:00:00Z")), "2026-W53");
  // Monday 2026-12-28 is the same week
  assert.equal(periodKey("week", new Date("2026-12-28T00:00:00Z")), "2026-W53");
  // Monday 2027-01-04 starts week 1
  assert.equal(periodKey("week", new Date("2027-01-04T00:00:00Z")), "2027-W01");
  // Sunday stays in the week that started on Monday
  assert.equal(periodKey("week", new Date("2026-11-15T23:00:00Z")), "2026-W46");
});

test("allowances by plan; report and categorize are Premium only", () => {
  assert.deepEqual(allowanceFor(DEFAULT_LIMITS, "chat", false), { limit: 3, period: "day" });
  assert.deepEqual(allowanceFor(DEFAULT_LIMITS, "chat", true), { limit: 100, period: "day" });
  assert.deepEqual(allowanceFor(DEFAULT_LIMITS, "insights", false), { limit: 1, period: "week" });
  assert.equal(allowanceFor(DEFAULT_LIMITS, "report", false).limit, 0);
  assert.equal(allowanceFor(DEFAULT_LIMITS, "categorize", false).limit, 0);
  assert.ok(allowanceFor(DEFAULT_LIMITS, "report", true).limit > 0);
});

test("messages name the feature, the period and the upgrade path", () => {
  const free = exhaustedMessage("chat", { limit: 3, period: "day" }, false);
  assert.match(free, /today's 3 free AI chat messages/);
  assert.match(free, /Upgrade to Premium/);
  const premium = exhaustedMessage("insights", { limit: 10, period: "week" }, true);
  assert.match(premium, /this week's limit of 10/);
  assert.match(premium, /Monday/);
  assert.equal(premiumOnlyMessage("report"), "The AI monthly report is a Premium feature.");
});
