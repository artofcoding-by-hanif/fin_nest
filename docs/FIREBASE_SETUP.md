# Firebase & Release Signing Setup (Phase 1)

Part of [AI_SUBSCRIPTION_PLAN.md](AI_SUBSCRIPTION_PLAN.md). The code is in
place; these are the steps only you can do. Until they're done the app runs
exactly as before, fully offline, and logs
`Firebase unavailable, online features disabled`.

## 1. Create the Firebase project

1. <https://console.firebase.google.com> → **Add project** → name it
   `finnest`. Google Analytics is optional.
2. **Upgrade to the Blaze plan** (Settings → Usage and billing). Cloud
   Functions need it in Phase 2. Set a budget alert while you're there.
3. **Authentication → Sign-in method → Anonymous → Enable.**
4. **Firestore Database → Create database** in production mode, location
   `asia-south1` (Mumbai). Only the Cloud Functions will use it, for AI usage
   counters.

## 2. Generate the Firebase settings for each flavor

Install the FlutterFire CLI once. Use Flutter's own `dart`, because the `dart`
on your PATH (`/opt/homebrew/bin/dart`) is an old 2.18 SDK. The `flutterfire`
command also runs whichever `dart` comes first on PATH, so put Flutter's first
in the shell where you run it (or uninstall the Homebrew Dart):

```bash
/Users/hanifmohammed/Projects/development/flutter/bin/dart pub global activate flutterfire_cli
```

```bash
export PATH="/Users/hanifmohammed/Projects/development/flutter/bin:$PATH"
```

```bash
firebase login
```

Then run this for each flavor. It registers the Android app in Firebase and
writes the settings file over the placeholder:

```bash
flutterfire configure --project=finnest-cf874 --platforms=android --android-package-name=com.finnest.app.dev --out=lib/firebase_options_development.dart --yes
```

```bash
flutterfire configure --project=finnest-cf874 --platforms=android --android-package-name=com.finnest.app.staging --out=lib/firebase_options_staging.dart --yes
```

```bash
flutterfire configure --project=finnest-cf874 --platforms=android --android-package-name=com.finnest.app --out=lib/firebase_options_production.dart --yes
```

The project ID is `finnest-cf874` (Firebase added the suffix). **Done on
2026-11-10**: all three files are generated and the three Android apps are
registered.

`flutterfire` also writes `android/app/google-services.json` and adds the
`com.google.gms.google-services` plugin to the Gradle files. **Undo both**:
FinNest reads the Dart files only, and the plugin breaks flavor builds without
a `google-services.json` per flavor. The generated `firebase_options_*.dart` files contain public client
identifiers (not secrets) and are safe to commit.

## 3. App Check

1. Firebase console → **App Check → Apps**.
2. For `com.finnest.app` (production), register **Play Integrity** (it needs
   the app's SHA-256 signing certificate from Play Console → App integrity
   once the app is on Play).
3. For the dev app (`com.finnest.app.dev`), run a debug build and find this
   line in the log:

   ```
   Enter this debug secret into the allow list in the Firebase Console for your project: xxxxxxxx-....
   ```

   Then add it under **App Check → Apps → ⋮ → Manage debug tokens**. To keep
   the same token across reinstalls, pass it at build time:
   `--dart-define=APP_CHECK_DEBUG_TOKEN=<token>`.

App Check isn't *enforced* until the Phase 2 Cloud Functions turn it on, so
nothing breaks while you set this up.

## 4. Check it works

```bash
flutter run -d 22d828cc990b7ece --flavor development -t lib/main_development.dart --dart-define=FLAVOR=development
```

Debug builds print, in this order:

```
Firebase ready (development)
App Check OK (token NNN chars)        ← or FAILED: register the debug token (step 3)
Anonymous sign-in OK (uid abc123...)  ← or FAILED: enable Anonymous auth (step 1.3)
```

## 5. Release signing (needed for Play and Play Billing)

Google Play rejects apps signed with the debug key, and Play Billing only works
for builds signed with your real key and installed from a Play test track.

1. Create an upload keystore **once** and back it up somewhere safe. Losing it
   means you can never update the app:

   ```bash
   keytool -genkey -v -keystore ~/finnest-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Copy `android/key.properties.example` to `android/key.properties` (it's
   git-ignored) and fill in the path and passwords.
3. Build the release bundle:

   ```bash
   flutter build appbundle --flavor production -t lib/main.dart --dart-define=FLAVOR=production
   ```

Without `key.properties`, release builds still work but are signed with the
debug key, and Gradle prints a warning.

---

# Phase 2: AI Cloud Functions

The backend lives in `functions/` (Node 22, TypeScript), ported from TankMind.
Callables, all in `asia-south1` with App Check enforced:

| Function | What it does | Free | Premium |
|---|---|---|---|
| `aiChat` | Chat about the user's finances | 3 / day | 100 / day |
| `aiInsights` | Structured suggestions feed | 1 / week | 10 / day |
| `aiMonthlyReport` | Structured month review | – | 5 / month |
| `aiCategorize` | Category for a description | – | 200 / day |
| `reportAiContent` | Flag bad AI output (no quota) | ✓ | ✓ |

Limits are deploy-time parameters (`AI_CHAT_FREE_DAILY` and others in
`functions/src/index.ts`), so they can change without an app release.
Firestore stores only usage counters (`aiUsage/{uid}/usage/...`) and reports
(`aiReports`). The app has no direct Firestore access (`firestore.rules`).

## 1. Secrets (you)

Type the values at the prompt; don't paste them into chat or commit them:

```bash
firebase functions:secrets:set GEMINI_API_KEY --project finnest-cf874
```

```bash
firebase functions:secrets:set REVENUECAT_SECRET_KEY --project finnest-cf874
```

For `REVENUECAT_SECRET_KEY`, enter `none` until RevenueCat is set up in
Phase 5; everyone is then on the free plan.

## 2. Test and deploy

```bash
npm --prefix functions test
```

```bash
firebase deploy --only functions,firestore:rules --project finnest-cf874
```

The first deploy enables Cloud Functions, Cloud Build, Artifact Registry and
Cloud Run APIs, which takes a few minutes.

## 3. Clean-up policy (once)

Old usage counters and reports carry an `expireAt` field. Turn on Firestore
TTL for it so they delete themselves: Firebase console → Firestore → **TTL**
(or Google Cloud console → Firestore → Time-to-live) → create policies for
collection group **`usage`** and collection group **`aiReports`**, field
**`expireAt`**.

## 4. Check from the phone

In a debug build: Settings → **Developer (debug only)** → **Test AI
connection**. It sends a small made-up sample (not your data) and shows the
reply and the remaining free messages.
