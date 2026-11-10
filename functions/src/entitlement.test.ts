import assert from "node:assert/strict";
import { beforeEach, test } from "node:test";

import { clearEntitlementCache, hasPremium, isEntitlementActive } from "./entitlement.js";

const NOW = Date.parse("2026-11-02T00:00:00Z");

function body(entitlements: Record<string, unknown>) {
  return { subscriber: { entitlements } } as never;
}

beforeEach(() => clearEntitlementCache());

test("active, expired, lifetime and grace-period entitlements", () => {
  const future = "2026-12-01T00:00:00Z";
  const past = "2026-10-01T00:00:00Z";
  assert.equal(isEntitlementActive(body({ premium: { expires_date: future } }), "premium", NOW), true);
  assert.equal(isEntitlementActive(body({ premium: { expires_date: past } }), "premium", NOW), false);
  assert.equal(isEntitlementActive(body({ premium: { expires_date: null } }), "premium", NOW), true);
  assert.equal(
    isEntitlementActive(
      body({ premium: { expires_date: past, grace_period_expires_date: future } }),
      "premium",
      NOW,
    ),
    true,
  );
  assert.equal(isEntitlementActive(body({ other: { expires_date: null } }), "premium", NOW), false);
});

test("skips the lookup when no key is configured", async () => {
  let called = false;
  const fetchImpl = (async () => {
    called = true;
    return new Response("{}");
  }) as typeof fetch;
  assert.equal(await hasPremium("u1", { secretKey: "none", entitlementId: "premium", fetchImpl }), false);
  assert.equal(called, false);
});

test("queries RevenueCat once and caches the answer", async () => {
  const urls: string[] = [];
  const fetchImpl = (async (url: string) => {
    urls.push(url);
    return new Response(JSON.stringify(body({ premium: { expires_date: null } })));
  }) as unknown as typeof fetch;
  const options = { secretKey: "sk_test", entitlementId: "premium", fetchImpl, now: () => NOW };

  assert.equal(await hasPremium("user/1", options), true);
  assert.equal(await hasPremium("user/1", options), true);
  assert.deepEqual(urls, ["https://api.revenuecat.com/v1/subscribers/user%2F1"]);
});

test("reports API failures so the caller can fall back", async () => {
  const fetchImpl = (async () => new Response("nope", { status: 500 })) as typeof fetch;
  await assert.rejects(
    hasPremium("u2", { secretKey: "sk_test", entitlementId: "premium", fetchImpl }),
    /HTTP 500/,
  );
});
