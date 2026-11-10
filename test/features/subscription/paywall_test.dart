import 'package:fin_nest/core/theme/app_theme.dart';
import 'package:fin_nest/features/subscription/presentation/controllers/subscription_providers.dart';
import 'package:fin_nest/features/subscription/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPaywall(
    WidgetTester tester, {
    PaywallReason reason = PaywallReason.general,
    bool premium = false,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // No RevenueCat key in tests: the service returns no offering
          currentOfferingProvider.overrideWith((ref) async => null),
          isPremiumProvider.overrideWithValue(premium),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: PaywallScreen(reason: reason),
        ),
      ),
    );
    // The aurora animates forever, so pump frames instead of settling
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('without RevenueCat it explains plans are not available', (tester) async {
    await pumpPaywall(tester);
    expect(find.text('Unlock FinNest Premium'), findsOneWidget);
    expect(find.text("Subscriptions aren't available in this build yet."), findsOneWidget);
    expect(find.text('Ask FinNest, all day'), findsOneWidget);
    // Features not built yet are labelled honestly
    expect(find.text('Soon'), findsNWidgets(3));
  });

  testWidgets('the AI-limit reason tailors the headline', (tester) async {
    await pumpPaywall(tester, reason: PaywallReason.aiLimit);
    expect(find.text("You've used today's free AI"), findsOneWidget);
    expect(find.textContaining('3 AI messages a day'), findsOneWidget);
  });

  testWidgets('Premium users see a thank-you and Done', (tester) async {
    await pumpPaywall(tester, premium: true);
    expect(find.text("You're Premium"), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text("Subscriptions aren't available in this build yet."), findsNothing);
  });
}
