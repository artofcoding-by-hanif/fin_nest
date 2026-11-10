/**
 * Premium lookup via the RevenueCat REST API. The app logs in to RevenueCat
 * with the Firebase uid, so the callable's `request.auth.uid` identifies the
 * same customer here.
 */

const CACHE_MS = 5 * 60_000;
const cache = new Map<string, { premium: boolean; until: number }>();

export interface EntitlementOptions {
  /** RevenueCat secret API key; empty or "none" disables the lookup */
  secretKey: string;
  entitlementId: string;
  fetchImpl?: typeof fetch;
  now?: () => number;
}

interface SubscriberResponse {
  subscriber?: {
    entitlements?: Record<
      string,
      { expires_date?: string | null; grace_period_expires_date?: string | null }
    >;
  };
}

/** Whether the entitlement is active right now (lifetime or unexpired) */
export function isEntitlementActive(
  body: SubscriberResponse,
  entitlementId: string,
  now: number,
): boolean {
  const entitlement = body.subscriber?.entitlements?.[entitlementId];
  if (!entitlement) return false;
  const expiries = [entitlement.expires_date, entitlement.grace_period_expires_date];
  if (entitlement.expires_date == null) return true; // lifetime
  return expiries.some((date) => date != null && Date.parse(date) > now);
}

export async function hasPremium(uid: string, options: EntitlementOptions): Promise<boolean> {
  const key = options.secretKey.trim();
  if (!key || key === "none") return false;

  const now = options.now ?? Date.now;
  const cached = cache.get(uid);
  if (cached && cached.until > now()) return cached.premium;

  const response = await (options.fetchImpl ?? fetch)(
    `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`,
    { headers: { Authorization: `Bearer ${key}`, Accept: "application/json" } },
  );
  if (!response.ok) {
    throw new Error(`RevenueCat lookup failed: HTTP ${response.status}`);
  }

  const premium = isEntitlementActive(
    (await response.json()) as SubscriberResponse,
    options.entitlementId,
    now(),
  );
  cache.set(uid, { premium, until: now() + CACHE_MS });
  return premium;
}

/** Test helper */
export function clearEntitlementCache(): void {
  cache.clear();
}
