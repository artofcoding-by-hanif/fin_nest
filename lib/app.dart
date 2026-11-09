import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_constants.dart';
import 'core/config/flavor_config.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/app_lock_provider.dart';
import 'core/widgets/app_lock_screen.dart';
import 'core/widgets/glass/glass_scaffold.dart';
import 'core/widgets/loading_indicator.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';

/// Main application widget with lifecycle management
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kDebugMode) {
      debugPrint('App: Lifecycle observer added');
    }

    // Hide splash after delay
    _hideSplashAfterDelay();
  }

  Future<void> _hideSplashAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (kDebugMode) {
      debugPrint('App: Lifecycle observer removed');
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (kDebugMode) {
      debugPrint('App: Lifecycle state changed to: ${state.name}');
    }

    final appLockAuth = ref.read(appLockAuthProvider);

    switch (state) {
      case AppLifecycleState.paused:
        // App went to background
        appLockAuth.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        // App came to foreground
        appLockAuth.onAppResumed();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // No action needed for these states
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfig = FlavorConfig.instance;
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: '${AppConstants.appName} - ${flavorConfig.name}',
      debugShowCheckedModeBanner: flavorConfig.flavor.isDevelopment,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.toThemeMode(),
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    // Show splash screen first
    if (_showSplash) {
      return const SplashScreen();
    }

    final isLocked = ref.watch(isAppLockedProvider);
    final onboardingState = ref.watch(onboardingNotifierProvider);

    // Show lock screen if app is locked (but not during onboarding)
    if (isLocked) {
      return onboardingState.when(
        data: (completed) {
          if (completed) {
            return const AppLockScreen();
          }
          // Don't show lock screen during onboarding
          return _buildOnboardingOrDashboard(completed);
        },
        loading: () => const GlassScaffold(body: LoadingIndicator()),
        error: (_, __) => _buildOnboardingOrDashboard(false),
      );
    }

    // Show onboarding or dashboard based on completion status
    return onboardingState.when(
      data: (completed) => _buildOnboardingOrDashboard(completed),
      loading: () => const GlassScaffold(body: LoadingIndicator()),
      error: (_, __) => _buildOnboardingOrDashboard(false),
    );
  }

  Widget _buildOnboardingOrDashboard(bool onboardingCompleted) {
    if (onboardingCompleted) {
      return const DashboardScreen();
    } else {
      return OnboardingScreen(
        onComplete: () {
          ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
        },
      );
    }
  }
}
