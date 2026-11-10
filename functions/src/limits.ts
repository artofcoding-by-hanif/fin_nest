/**
 * Plan limits per AI feature ("bucket"). Pure functions, no Firebase
 * imports, so they can be unit tested directly.
 *
 * Each bucket counts separately, so a burst of category suggestions never
 * eats into the user's chat allowance.
 */

export type Bucket = "chat" | "insights" | "report" | "categorize";
export type Period = "day" | "week" | "month";

/** One plan's allowance for a bucket; limit 0 means "Premium only" */
export interface Allowance {
  limit: number;
  period: Period;
}

export interface BucketLimits {
  free: Allowance;
  premium: Allowance;
}

/** Limits as configured (Cloud Functions params override the defaults) */
export type LimitTable = Record<Bucket, BucketLimits>;

export const DEFAULT_LIMITS: LimitTable = {
  chat: { free: { limit: 3, period: "day" }, premium: { limit: 100, period: "day" } },
  insights: { free: { limit: 1, period: "week" }, premium: { limit: 10, period: "day" } },
  report: { free: { limit: 0, period: "month" }, premium: { limit: 5, period: "month" } },
  categorize: { free: { limit: 0, period: "day" }, premium: { limit: 200, period: "day" } },
};

export function allowanceFor(table: LimitTable, bucket: Bucket, premium: boolean): Allowance {
  return premium ? table[bucket].premium : table[bucket].free;
}

/**
 * Key for the counter document of a period, in UTC:
 * day "2026-11-10", ISO week "2026-W46", month "2026-11".
 */
export function periodKey(period: Period, now: Date): string {
  const iso = now.toISOString();
  if (period === "day") return iso.slice(0, 10);
  if (period === "month") return iso.slice(0, 7);

  // ISO 8601 week: the week with the year's first Thursday is week 1
  const date = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  const day = date.getUTCDay() || 7; // Monday=1 ... Sunday=7
  date.setUTCDate(date.getUTCDate() + 4 - day); // Thursday of this week
  const yearStart = Date.UTC(date.getUTCFullYear(), 0, 1);
  const week = Math.ceil(((date.getTime() - yearStart) / 86_400_000 + 1) / 7);
  return `${date.getUTCFullYear()}-W${String(week).padStart(2, "0")}`;
}

const PERIOD_WORDS: Record<Period, string> = {
  day: "today",
  week: "this week",
  month: "this month",
};

const RESET_WORDS: Record<Period, string> = {
  day: "It resets at midnight UTC.",
  week: "It resets on Monday (UTC).",
  month: "It resets on the 1st (UTC).",
};

const FEATURE_NAMES: Record<Bucket, string> = {
  chat: "AI chat messages",
  insights: "AI suggestion refreshes",
  report: "AI monthly reports",
  categorize: "category suggestions",
};

/** User-facing message when an allowance is used up */
export function exhaustedMessage(bucket: Bucket, allowance: Allowance, premium: boolean): string {
  const what = FEATURE_NAMES[bucket];
  const when = PERIOD_WORDS[allowance.period];
  if (premium) {
    return `You've reached ${when}'s limit of ${allowance.limit} ${what}. ${RESET_WORDS[allowance.period]}`;
  }
  return `You've used ${when}'s ${allowance.limit} free ${what}. Upgrade to Premium for more, or try again later.`;
}

export function premiumOnlyMessage(bucket: Bucket): string {
  const feature: Record<Bucket, string> = {
    chat: "AI chat",
    insights: "AI suggestions",
    report: "The AI monthly report",
    categorize: "Smart categorisation",
  };
  return `${feature[bucket]} is a Premium feature.`;
}
