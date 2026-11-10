import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/subscription_service.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>(
  (ref) => SubscriptionService.instance,
);

/// Whether the store reports an active Premium entitlement
final storePremiumProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(subscriptionServiceProvider);
  yield service.isPremium;
  yield* service.premiumChanges;
});

/// Debug builds only: pretend to be Premium to test app-side gates without a
/// store purchase (dev builds can't buy through Google Play). The server
/// still applies free limits, since it checks RevenueCat directly.
class DebugPremiumOverride extends Notifier<bool> {
  static const _key = 'debug_premium_override';

  @override
  bool build() {
    if (!kDebugMode) return false;
    SharedPreferences.getInstance().then((prefs) {
      final saved = prefs.getBool(_key) ?? false;
      if (saved != state) state = saved;
    });
    return false;
  }

  Future<void> set(bool value) async {
    if (!kDebugMode) return;
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}

final debugPremiumOverrideProvider =
    NotifierProvider<DebugPremiumOverride, bool>(DebugPremiumOverride.new);

/// The single source of truth for "is this user Premium?" in the UI
final isPremiumProvider = Provider<bool>((ref) {
  if (ref.watch(debugPremiumOverrideProvider)) return true;
  return ref.watch(storePremiumProvider).value ?? false;
});

/// Current RevenueCat offering (null when subscriptions aren't configured)
final currentOfferingProvider = FutureProvider.autoDispose<Offering?>((ref) {
  return ref.watch(subscriptionServiceProvider).currentOffering();
});
