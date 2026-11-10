# Subscriptions Setup (Phase 5, RevenueCat)

Part of [AI_SUBSCRIPTION_PLAN.md](AI_SUBSCRIPTION_PLAN.md). FinNest sells one
**Premium** entitlement through RevenueCat, with a monthly and a yearly plan
(yearly with a 7-day free trial). The app code is done. These are the steps
only you can do.

| | Free | Premium |
|---|---|---|
| All tracking, charts, export, Smart Insights | ✓ | ✓ |
| Ask FinNest (AI chat) | 3 / day | 100 / day |
| AI suggestions feed | 1 card / week | Full feed, 10 refreshes / day |
| AI monthly report | – | 5 / month |
| Smart categorisation | – | ✓ |

```
App ──purchase──▶ Google Play ──▶ RevenueCat ◀──REST (secret key)── aiChat & co.
 │                                    ▲
 └── Purchases.logIn(firebase uid) ───┘
```

The app identifies to RevenueCat with the Firebase anonymous uid, so the AI
functions check the same customer's entitlement on the server. Until these
steps are done, everyone is on the free plan and the paywall says
"Subscriptions aren't available in this build yet". Debug builds have
**Settings → Developer → Simulate Premium** for testing app-side gates.

## 1. Release keystore (once, and back it up)

Play Billing only works for an app uploaded to Play and signed with your
release key.

```bash
keytool -genkey -v -keystore ~/finnest-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Copy `android/key.properties.example` to `android/key.properties` (git-ignored)
and fill it in. Store the `.jks` file and passwords in your password manager.
**Losing them means you can never update the app.**

## 2. Google Play Console

1. **Create app** with package **`com.finnest.app`** (the production flavor).
2. Build and upload the first bundle to **Testing → Internal testing**, and add
   yourself as a tester:

   ```bash
   flutter build appbundle --flavor production -t lib/main.dart --dart-define=FLAVOR=production
   ```

   The output is `build/app/outputs/bundle/productionRelease/app-production-release.aab`.
3. **Monetize → Products → Subscriptions**, create:
   - `finnest_premium_monthly`: base plan `monthly`, auto-renewing, 1 month, **₹149**
   - `finnest_premium_yearly`: base plan `yearly`, auto-renewing, 1 year, **₹999**,
     with an offer: **Free trial, 7 days**, eligibility: new customers
   Activate both and set prices for other countries if you sell there.
4. **Setup → License testing**: add your Google account so test purchases are
   free and renew every few minutes.
5. Create a **service account** for RevenueCat: follow RevenueCat's "Google
   Play service credentials" guide (Google Cloud → service account → JSON key,
   then Play Console → Users and permissions → invite it with financial and
   order permissions). It can take up to 36 hours before Google accepts it.

## 3. RevenueCat dashboard

1. Create a project **FinNest** → add an **Android (Play Store)** app with
   package `com.finnest.app` → upload the service-account JSON.
2. **Products**: import `finnest_premium_monthly` and `finnest_premium_yearly`.
3. **Entitlements**: create **`premium`** (exactly this id) and attach both
   products.
4. **Offerings**: in the `default` offering add packages **$rc_monthly** →
   monthly and **$rc_annual** → yearly. Make it current.
5. **Project settings → Apps → Transfer behaviour**: choose *Transfer to new App
   User ID*, so a reinstall (new anonymous uid) gets Premium back via
   **Restore purchases**.
6. **API keys**:
   - Copy the Android **public** key (`goog_…`) and give it to Claude (or put
     it in `lib/core/config/subscription_config.dart` as the `defaultValue`).
     Public keys are safe to commit.
   - Create a **secret** key (v1 / REST, `sk_…`) for the server. Don't paste it
     in chat.

## 4. Server

Replace the `none` placeholder with the secret key, then redeploy so the
functions pick up the new version:

```bash
firebase functions:secrets:set REVENUECAT_SECRET_KEY --project finnest-cf874
```

```bash
firebase deploy --only functions --project finnest-cf874
```

## Testing

- **App gates and paywall UI**: debug build → Settings → Developer → Simulate
  Premium.
- **Server limits as Premium without buying**: RevenueCat → Customers → search
  your Firebase uid (debug builds log it as `Anonymous sign-in OK (uid …)`) →
  **Grant promotional entitlement** `premium`.
- **Real purchases**: install the internal-testing build from the Play Store
  with a license-tester account. Debug and sideloaded builds can't buy.

## Before release (Phase 8)

The paywall hides its Privacy Policy and Terms links until URLs exist. Pass
them at build time (`--dart-define=PRIVACY_POLICY_URL=… --dart-define=TERMS_URL=…`)
or set them in `subscription_config.dart`. Google Play requires a privacy
policy for subscription apps.
