import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fin_nest/core/theme/app_theme.dart';
import 'package:fin_nest/features/onboarding/domain/models/onboarding_page.dart';
import 'package:fin_nest/features/onboarding/presentation/screens/onboarding_screen.dart';

/// Smoke tests for the onboarding flow.
///
/// The root `App` widget depends on services set up in `bootstrap()`
/// (database, settings, secure storage, notifications), so these tests
/// pump `OnboardingScreen` directly instead.
void main() {
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    required VoidCallback onComplete,
  }) {
    // The app is portrait-only; the default 800x600 test surface is too
    // short for the onboarding layout. Use a typical phone size instead.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    return tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: OnboardingScreen(onComplete: onComplete),
        ),
      ),
    );
  }

  testWidgets('shows the first page with Skip and Next', (tester) async {
    await pumpOnboarding(tester, onComplete: () {});

    expect(find.text(OnboardingPages.pages.first.title), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Get Started'), findsNothing);
  });

  testWidgets('Next advances to the second page', (tester) async {
    await pumpOnboarding(tester, onComplete: () {});

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(OnboardingPages.pages[1].title), findsOneWidget);
  });

  testWidgets('Skip completes onboarding', (tester) async {
    var completed = false;
    await pumpOnboarding(tester, onComplete: () => completed = true);

    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(completed, isTrue);
  });

  testWidgets('last page shows Get Started, which completes onboarding', (
    tester,
  ) async {
    var completed = false;
    await pumpOnboarding(tester, onComplete: () => completed = true);

    for (var i = 0; i < OnboardingPages.pages.length - 1; i++) {
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(find.text(OnboardingPages.pages.last.title), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pump();

    expect(completed, isTrue);
  });
}
