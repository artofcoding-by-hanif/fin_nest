# FinNest AI + Subscriptions Plan (Android first)

Goal: add a Gemini-powered **AI assistant** (chat) and **auto suggestions**
built from the user's expenses, income, transactions, recurring payments,
budgets and savings, and sell it through a **RevenueCat** subscription. Android
only for now.

The plan reuses the architecture already proven in **TankMind**
(`~/Projects/aqualog`): Firebase anonymous auth, Cloud Functions that hold the
Gemini key and check the RevenueCat entitlement server-side, daily quotas in
Firestore, App Check, and a client `SubscriptionService` + paywall.

---

## 1. Key decisions (recommended defaults)

| # | Decision | Recommendation | Why |
|---|---|---|---|
| D1 | Where the Gemini key lives | **Server only**: a Firebase Cloud Functions secret, as in TankMind | A key inside the APK can be extracted in minutes and used on your bill. Server-side is also the only place that can enforce plan limits. |
| D2 | How the app proves who's calling | Firebase **anonymous auth** + **App Check (Play Integrity)** | No login screen needed; the uid links to RevenueCat; App Check blocks scripts and modified APKs. |
| D3 | Identity for purchases | RevenueCat `appUserID` = Firebase uid (same as TankMind) | The function can look up the same customer's entitlement via the RevenueCat REST API. |
| D4 | Firebase project | **New project** `finnest` (not shared with TankMind) | Separate billing, quotas, secrets and Play Integrity setup. |
| D5 | What data goes to Gemini | **Summaries by default**, recent transactions only with consent; never account numbers, notes or bank names | FinNest promises "stored securely on your device". Sending financial data off-device must be explicit, minimal and switchable off. |
| D6 | Free vs paid | Free gets rule-based insights + a small daily AI taste; Premium gets the full AI | Core money tracking stays free (gating it hurts retention); the paid value is clearly the AI. |
| D7 | Model | `gemini-flash-latest` with `gemini-flash-lite-latest` fallback (TankMind's setup) | Fast, cheap, and the alias keeps up with Google's current Flash model. |

**You said you'll provide the Gemini API key.** It goes into Firebase with
`firebase functions:secrets:set GEMINI_API_KEY`. It is never committed to git
or compiled into the app.

---

## 2. Plans and pricing

One entitlement, `premium`, with two products (same as TankMind).

| | Free | Premium |
|---|---|---|
| Expense/income/savings tracking, charts, export | ✓ | ✓ |
| **Smart Insights** (on-device, rule-based) | ✓ | ✓ |
| **AI chat** ("Ask FinNest") | 3 messages / day | 100 / day (fair use) |
| **AI Suggestions feed** (personalised tips) | Preview: 1 card, refreshes weekly | Full feed, refresh any time |
| **AI Monthly Report** (structured review of the month) | – | ✓ |
| **Smart categorisation** (suggest a category from the description) | – | ✓ |
| **Quick add by sentence** ("spent 450 on groceries yesterday") | – | ✓ (phase 2) |

Suggested prices for India (the default currency is INR), set in Play Console:

- `finnest_premium_monthly`: **₹149 / month**
- `finnest_premium_yearly`: **₹999 / year** (about 44% off), with a **7-day free trial**

RevenueCat offerings let you change prices and packages later without an app
update. The limits (3 / 100) are Cloud Function parameters, so they can change
without a release too.

---

## 3. Architecture

```
┌──────────────────────── FinNest app (Android) ────────────────────────┐
│ Drift DB ──▶ FinancialContextBuilder ──▶ AiService ──(callable)──┐    │
│ (on-device)   (summaries, redaction)      chat/insights/report    │    │
│                                                                   │    │
│ InsightsEngine (rules, offline, free)                             │    │
│ SubscriptionService ── purchases_flutter ──▶ Google Play Billing  │    │
│        │  Purchases.logIn(firebaseUid)              │             │    │
└────────┼────────────────────────────────────────────┼─────────────┼────┘
         ▼                                            ▼             ▼
     RevenueCat ◀────────── REST (secret key) ── Cloud Functions (Node 22)
     entitlement "premium"                        aiChat · aiInsights ·
                                                  aiMonthlyReport ·
                                                  aiCategorize · reportAiContent
                                                      │        │
                                                Firestore    Gemini API
                                               (quotas only) (key = secret)
```

The financial data itself stays in the on-device Drift database. Firestore
holds only per-user daily counters and AI-content reports, never transactions.

---

## 4. AI features in detail

### 4.1 Ask FinNest (chat)
- A glass chat screen, opened from the dashboard (new quick action and an "Ask
  FinNest" card) and from each Insights card ("Ask about this").
- Starter prompts as chips: "Where did my money go this month?", "How can I
  save ₹5,000 more?", "Am I on track with my budgets?", "Which subscriptions
  could I cut?"
- Every request sends the **financial context** (section 5) plus the
  conversation. Replies render as markdown (`flutter_markdown_plus`, as in
  TankMind).
- Conversations are saved locally in Drift, so the user keeps their history
  offline and can delete it.
- After each reply: the remaining-quota line ("2 of 3 free messages left
  today"), copy, and **Report** (required by Play's AI-generated content
  policy; TankMind already has `reportAiContent`).
- When the quota runs out, the paywall opens with "Upgrade for 100 messages a
  day".

### 4.2 Smart Insights (free, on-device)
Rules computed from the DAO aggregates that already exist
(`getSpendingTrend`, `getSavingsRate`, `getBudgetProgress`,
`getTopSpendingCategory`, `getWeeklySummary`). No network needed:
- Category spending up more than X% vs the 3-month average
- Budget at 80% or over, with days left in the month
- Savings rate this month vs last month
- Recurring payments due in the next 7 days, and their total
- Unusually large single transaction (over 2× the category median)
- Months where expenses were higher than income

These populate the existing `features/insights` folder and give free users
real value. They also feed the AI prompt as "signals".

### 4.3 AI Suggestions (Premium; free gets a preview)
- The `aiInsights` function returns **structured JSON** (Gemini
  `responseJsonSchema`, the same technique as TankMind's `analyzeTank`):
  ```json
  { "suggestions": [ {
      "id": "...", "type": "save|budget|alert|habit|subscription|goal",
      "title": "Cut dining out by ₹2,000",
      "body": "Food & Dining is 38% above your 3-month average...",
      "impactMonthly": 2000, "priority": 1-3,
      "category": "Food & Dining", "action": "set_budget|view_category|none"
  } ] }
  ```
- Shown as a glass carousel on the dashboard with GlassIcon types. Tapping
  `action` deep-links into the app (for example, `set_budget` opens
  `SetCategoryBudgetScreen` prefilled).
- Cached in Drift (`ai_suggestions`); refreshed on demand, plus a "new
  suggestions available" nudge when the month's data has changed a lot. **No
  background AI calls** (cost, battery, and the user must be signed in and
  consented).
- Free users see one card (refreshed weekly); the rest are blurred behind a
  Premium badge.

### 4.4 AI Monthly Report (Premium)
- On the 1st of the month (or on demand), the `aiMonthlyReport` function
  produces a structured review: score, wins, concerns, category breakdown
  commentary, three goals for next month.
- Rendered as a shareable glass page; saved locally.

### 4.5 Smart categorisation (Premium)
- On Add Expense/Income, once the description is typed, `aiCategorize`
  suggests a category from the user's own category list (sends only the
  description + category names). Batched and debounced to keep quota use low;
  it does **not** count against the chat quota (it has a separate small daily
  cap).

### 4.6 Guardrails (system prompt + UI)
- The model is told: it's a budgeting assistant, not a licensed financial
  advisor. No recommendations to buy or sell specific securities, funds,
  crypto, or insurance products. It may explain general concepts (emergency
  fund, 50/30/20) and the user's own numbers.
- Amounts are always in the user's currency with its symbol; answers stay
  short and practical.
- A persistent footer in the chat: "AI can make mistakes. Not financial
  advice."
- Prompt-injection hardening: transaction descriptions are user text, so the
  data block is labelled as untrusted data, never instructions (TankMind's
  `withTankData` pattern).

---

## 5. Financial context (what the AI sees)

`FinancialContextBuilder` (client) builds a compact JSON. Target is under
about 6k tokens.

```jsonc
{
  "currency": "INR", "today": "2026-11-09", "locale": "en_IN",
  "accounts": [ { "type": "bank", "balance": 245000 } ],          // no names/numbers
  "monthly": [ { "month": "2026-10", "income": 106000, "expense": 48400,
                 "byCategory": { "Food & Dining": 7800, ... } } ], // last 6 months
  "thisMonth": { "income": ..., "expense": ..., "daysLeft": 21,
                 "budgets": [ { "category": "Food & Dining", "limit": 8000, "spent": 6100 } ] },
  "recurring": [ { "description": "Netflix", "amount": 649, "frequency": "monthly",
                   "type": "expense", "next": "2026-11-14" } ],
  "savings": [ { "category": "mutualFund", "invested": 210000, "current": 248000 } ],
  "signals": [ "Food & Dining +38% vs 3-month avg", "Savings rate 54% (last month 41%)" ],
  "recentTransactions": [ { "date": "2026-11-07", "amount": 7800, "type": "expense",
                            "category": "Food & Dining", "description": "Groceries" } ] // consent-gated, max 60
}
```

**Privacy settings (new "AI & Privacy" section in Settings):**
- *AI features* on/off (default off until the first-run consent).
- *Share recent transaction descriptions*: on/off (default on after consent;
  when off, only category totals are sent).
- *Delete AI chat history*.
- Never sent: account numbers, bank/institution names, notes, attachments,
  payees, locations, tags.
- Amounts go as whole currency units (not cents) to save tokens.

**First-run consent sheet**, shown on the first AI use: what is sent, that
Google's Gemini processes it, that nothing is stored on FinNest's servers
except a usage counter, and a link to the privacy policy. Needed for
Play's User Data policy and the Data Safety form.

---

## 6. Backend: Cloud Functions (`functions/`)

Copied from TankMind and adapted. TankMind's structure and tests carry over
almost unchanged:

| File | Change from TankMind |
|---|---|
| `gemini.ts` | **Reuse as is** (retry, model fallback, timeouts, truncated-output detection) |
| `entitlement.ts` | **Reuse as is** (RevenueCat REST lookup, 5-minute cache) |
| `quota.ts` | Generalise to **named buckets**: `chat`, `insights`, `report`, `categorize`, each with its own free/premium limit |
| `validation.ts` | New parsers: `parseFinanceContext` (size caps, number checks, max 60 transactions, max 30 messages × 4k chars) |
| `prompts.ts` | New: `CHAT_SYSTEM_PROMPT`, `INSIGHTS_SCHEMA` + prompt, `REPORT_SCHEMA` + prompt, `CATEGORIZE_SCHEMA`, `withFinanceData()` |
| `index.ts` | Callables: `aiChat`, `aiInsights`, `aiMonthlyReport` (premium only), `aiCategorize` (premium only), `reportAiContent` |

Parameters and secrets: `GEMINI_API_KEY` (secret), `REVENUECAT_SECRET_KEY`
(secret), `GEMINI_MODEL`, `GEMINI_FALLBACK_MODEL`, and limits per bucket
(`AI_CHAT_FREE_DAILY=3`, `AI_CHAT_PREMIUM_DAILY=100`,
`AI_INSIGHTS_FREE_WEEKLY=1`, `AI_INSIGHTS_PREMIUM_DAILY=10`,
`AI_REPORT_PREMIUM_MONTHLY=5`, `AI_CATEGORIZE_PREMIUM_DAILY=200`). All
callables use `enforceAppCheck: true`, region `asia-south1` (Mumbai, closest
to Indian users; TankMind uses `us-central1`), `maxInstances: 10`.

Firestore: `aiUsage/{uid}/{bucket}/{period}` counters with a TTL, and
`aiReports/{id}` for flagged content. Security rules deny all client access
(only the functions write).

Streaming chat: phase 2. Callables support streaming
(`httpsCallable(...).stream()`), which gives a typing effect; v1 uses a plain
request/response like TankMind.

Cost: Flash with about 6k input + 600 output tokens per chat is a fraction of
a rupee per message. At 100 messages a day a heavy Premium user stays far
below the subscription price. The quotas cap the worst case.

---

## 7. App changes (Flutter, Android)

**Dependencies** (versions matching TankMind): `firebase_core`,
`firebase_auth`, `firebase_app_check`, `cloud_functions`,
`purchases_flutter`, `flutter_markdown_plus`, `url_launcher`.

**New / changed code**

```
lib/core/firebase/firebase_bootstrap.dart      init + App Check (debug provider for dev flavor)
lib/core/config/subscription_config.dart       RevenueCat public key, entitlement id, limits
lib/features/subscription/
  data/subscription_service.dart               port from TankMind
  presentation/controllers/subscription_providers.dart   isPremiumProvider, offering, debug override
  presentation/paywall_screen.dart             glass paywall: plan cards, trial badge, restore, terms
  presentation/premium_gate.dart               PremiumGate widget + "Premium" badge
lib/features/ai/
  data/ai_service.dart                         callables, error→message mapping, quota info
  data/financial_context_builder.dart          section 5, redaction, consent
  domain/{chat_message, ai_suggestion, monthly_report}.dart  (freezed)
  presentation/chat_screen.dart, suggestion_carousel.dart, monthly_report_screen.dart,
               ai_consent_sheet.dart, report_ai_content_sheet.dart
lib/features/insights/
  domain/insights_engine.dart                  on-device rules (4.2), unit-tested
  presentation/insights_section.dart
lib/features/settings/...                      Subscription + AI & Privacy sections
```

**Database (Drift schema v10):** new tables `ai_conversations`,
`ai_messages` (role, text, createdAt, isError) and `ai_suggestions` (json,
createdAt, dismissed), and `ai_reports` (monthly reports). Add a migration
test in the existing `migration_test.dart`.

**Android project:**
- Add `<uses-permission android:name="android.permission.INTERNET"/>` to
  **`src/main/AndroidManifest.xml`**. It's only in the debug manifest today,
  so release builds would have no network at all.
- **Release signing:** `release` currently signs with the debug key. Play
  Billing needs a real upload key via an untracked `android/key.properties`.
- `google-services.json` **per flavor** (`android/app/src/development/`,
  `src/staging/`, `src/production/`), since the package names differ
  (`com.finnest.app.dev`, `.staging`, `com.finnest.app`), plus the Google
  Services Gradle plugin.
- `com.android.vending.BILLING` comes in through `purchases_flutter`.
- minSdk stays at Flutter's default (24+), which satisfies RevenueCat and
  Firebase.

**Dev experience:** dev builds can't buy through Play, so Settings (debug
only) gets **Simulate Premium**, like TankMind, and the App Check debug token
is registered for the dev app.

---

## 8. Delivery phases

Each phase ends with analyzer clean, tests passing, and a run on your Galaxy
S9+.

| Phase | Scope | Done when |
|---|---|---|
| **0. Accounts (you)** | Firebase project `finnest` + Blaze plan; Play Console app `com.finnest.app`; RevenueCat project; Gemini key | The checklist in section 9 is complete |
| **1. Foundation** | INTERNET permission, release signing, Firebase per flavor, anonymous auth, App Check, `firebase_bootstrap` | App starts, signs in anonymously, App Check token issued on the device |
| **2. Backend** | `functions/` ported + finance prompts/schemas, bucket quotas, tests (`npm test`), deploy | Calling `aiChat` from the emulator and the device returns a reply; the quota counts down; tests green |
| **3. Insights engine** | On-device rules + Insights section on the dashboard | Free value works offline; unit tests per rule |
| **4. AI chat** | Context builder, consent sheet, AI & Privacy settings, chat UI, history, report flow | Chat answers questions about seeded data; turning off descriptions changes the payload (tested) |
| **5. Subscriptions** | SubscriptionService, providers, paywall, PremiumGate, Settings section, debug override | Internal-test purchase on the S9+ flips Premium; the server sees it (100/day limit applies) |
| **6. AI Suggestions + Monthly Report** | `aiInsights`/`aiMonthlyReport`, carousel, report screen, caching, deep-link actions | Suggestions render, actions navigate; the free preview shows 1 card |
| **7. Smart categorisation** | `aiCategorize` + Add Expense/Income hint chip | Suggestion appears within about 1s of typing a description |
| **8. Release prep** | Data Safety form, privacy policy update, store listing, staged rollout | Internal → closed testing build approved |

Phase 2 (backend) and phase 3 (insights engine) are independent and can run in
parallel.

---

## 9. Your setup checklist (things only you can do)

1. **Firebase**: create project `finnest` → upgrade to **Blaze** (Cloud
   Functions need it) → add 3 Android apps (`com.finnest.app`,
   `com.finnest.app.dev`, `com.finnest.app.staging`) → download each
   `google-services.json`.
2. **Firebase App Check**: enable Play Integrity for the production app; add
   the debug token printed by the dev build.
3. **Firebase Auth**: enable the **Anonymous** provider.
4. **Gemini key**: `firebase functions:secrets:set GEMINI_API_KEY` (type the
   key at the prompt; don't paste it in chat or commit it).
5. **Release keystore**: `keytool -genkey ... -alias finnest` and keep it
   backed up. Losing it means you can't update the app.
6. **Play Console**: create the app `com.finnest.app`, upload the first AAB to
   **Internal testing**, create subscriptions `finnest_premium_monthly` and
   `finnest_premium_yearly` (7-day trial offer on yearly), set prices, and
   create the RevenueCat service account.
7. **RevenueCat**: new project → Android app → import products → entitlement
   `premium` → `default` offering (monthly + annual) → copy the **public
   `goog_` key** (goes in the app) and the **secret key** (goes into
   `firebase functions:secrets:set REVENUECAT_SECRET_KEY`).
8. In RevenueCat, set **"Transfer purchases" behaviour** to transfer to the new
   App User ID, so a reinstall (new anonymous uid) gets Premium back via
   Restore.

---

## 10. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Anonymous uid lost on reinstall or clearing data | Restore purchases re-links via RevenueCat transfer; quotas reset harmlessly; chat history is local anyway |
| Users wary of sending finances to the cloud | Opt-in consent, summaries-only mode, clear "what we send" screen, no server storage of data |
| Gemini overload or latency | Model fallback + retry from TankMind's `gemini.ts`; quota refunded on failure |
| Prompt injection via transaction descriptions | Data block marked untrusted; output schema-constrained for suggestions; descriptions truncated to 80 chars |
| Play policy (AI content, financial apps) | In-app report button, disclaimers, no investment advice, accurate Data Safety form |
| Cost spikes from abuse | App Check + auth + per-bucket quotas + `maxInstances` |
| Hard-coded local `userId = 1` | Not a blocker: the cloud identity (Firebase uid) is separate from the local Drift user id |

---

## 11. Open questions for you

1. **Pricing**: are ₹149/month and ₹999/year with a 7-day trial right, or do
   you want TankMind's prices?
2. **Free AI**: 3 chat messages a day plus a 1-card suggestion preview, or
   should AI be Premium-only with a one-time free trial of 5 messages?
3. **Region**: `asia-south1` (Mumbai) for the functions, or keep
   `us-central1` like TankMind?
4. **Quick add by sentence**: in v1, or phase 2?
5. **Does the existing TankMind Play developer account publish FinNest too?**
   It affects the RevenueCat service-account setup.
