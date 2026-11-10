/// RevenueCat and plan configuration.
///
/// The SDK key is RevenueCat's *public* Android key (starts with `goog_`). It
/// is designed to ship inside the app and is safe to commit. The secret REST
/// key lives only in Cloud Functions (REVENUECAT_SECRET_KEY).
///
/// Leave the key empty to build without subscriptions: everyone is on the
/// free plan and the paywall explains that purchases aren't available yet.
/// It can also be passed at build time:
///   --dart-define=REVENUECAT_ANDROID_KEY=goog_xxx
class SubscriptionConfig {
  SubscriptionConfig._();

  static const String androidApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
    defaultValue: '',
  );

  /// Entitlement that unlocks Premium, as named in the RevenueCat dashboard
  /// (must match ENTITLEMENT_ID in functions/src/index.ts)
  static const String entitlementId = 'premium';

  /// Google Play product ids (for reference; the offering decides what shows)
  static const String monthlyProductId = 'finnest_premium_monthly';
  static const String yearlyProductId = 'finnest_premium_yearly';

  /// Plan limits shown in the paywall. Enforced by the Cloud Functions
  /// (functions/.env.finnest-cf874); keep these in sync.
  static const int freeChatDaily = 3;
  static const int premiumChatDaily = 100;
  static const int premiumInsightsDaily = 10;
  static const int premiumReportsMonthly = 5;
}

/// Public pages the app links to. Empty until the pages exist (Phase 8);
/// links with an empty URL are hidden.
class LegalLinks {
  LegalLinks._();

  static const String privacyPolicy = String.fromEnvironment('PRIVACY_POLICY_URL');
  static const String terms = String.fromEnvironment('TERMS_URL');
}
