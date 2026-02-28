import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/biometric_auth_service.dart';
import 'settings_provider.dart';

/// State for app lock
class AppLockState {
  final bool isLocked;
  final DateTime? lastBackgroundTime;
  final bool isAuthenticating;

  const AppLockState({
    this.isLocked = false,
    this.lastBackgroundTime,
    this.isAuthenticating = false,
  });

  AppLockState copyWith({
    bool? isLocked,
    DateTime? lastBackgroundTime,
    bool? isAuthenticating,
  }) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      lastBackgroundTime: lastBackgroundTime ?? this.lastBackgroundTime,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
    );
  }
}

/// Notifier for managing app lock state
class AppLockNotifier extends StateNotifier<AppLockState> {
  AppLockNotifier() : super(const AppLockState());

  /// Mark app as locked (when going to background)
  void lockApp() {
    if (kDebugMode) {
      debugPrint('AppLock: Locking app');
    }
    state = state.copyWith(
      isLocked: true,
      lastBackgroundTime: DateTime.now(),
    );
  }

  /// Mark app as unlocked (after successful authentication)
  void unlockApp() {
    if (kDebugMode) {
      debugPrint('AppLock: Unlocking app');
    }
    state = state.copyWith(
      isLocked: false,
      lastBackgroundTime: null,
      isAuthenticating: false,
    );
  }

  /// Set authentication in progress
  void setAuthenticating(bool value) {
    state = state.copyWith(isAuthenticating: value);
  }

  /// Check if app should be locked based on time in background
  /// Returns true if app was in background for more than the grace period
  bool shouldLockApp({Duration gracePeriod = const Duration(seconds: 30)}) {
    if (state.lastBackgroundTime == null) {
      return false;
    }

    final timeSinceBackground = DateTime.now().difference(state.lastBackgroundTime!);
    return timeSinceBackground > gracePeriod;
  }
}

/// Provider for app lock state
final appLockProvider = StateNotifierProvider<AppLockNotifier, AppLockState>(
  (ref) => AppLockNotifier(),
);

/// Provider to check if app is currently locked
final isAppLockedProvider = Provider<bool>((ref) {
  return ref.watch(appLockProvider).isLocked;
});

/// Provider to check if authentication is in progress
final isAuthenticatingProvider = Provider<bool>((ref) {
  return ref.watch(appLockProvider).isAuthenticating;
});

/// Provider to handle app lock authentication
final appLockAuthProvider = Provider<AppLockAuthService>((ref) {
  return AppLockAuthService(ref);
});

/// Service to handle app lock authentication logic
class AppLockAuthService {
  final Ref _ref;

  AppLockAuthService(this._ref);

  /// Authenticate user to unlock app
  /// Returns true if authentication was successful
  Future<bool> authenticate() async {
    final biometricEnabled = _ref.read(biometricEnabledProvider);
    
    if (!biometricEnabled) {
      // If biometric is not enabled, unlock immediately
      _ref.read(appLockProvider.notifier).unlockApp();
      return true;
    }

    final lockNotifier = _ref.read(appLockProvider.notifier);
    lockNotifier.setAuthenticating(true);

    try {
      final biometricService = BiometricAuthService.instance;
      final result = await biometricService.authenticate(
        localizedReason: 'Authenticate to access FinNest',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (result.success) {
        lockNotifier.unlockApp();
        return true;
      } else {
        lockNotifier.setAuthenticating(false);
        if (kDebugMode) {
          debugPrint('AppLock: Authentication failed - ${result.errorMessage}');
        }
        return false;
      }
    } catch (e) {
      lockNotifier.setAuthenticating(false);
      if (kDebugMode) {
        debugPrint('AppLock: Authentication error - $e');
      }
      return false;
    }
  }

  /// Handle app going to background
  void onAppPaused() {
    final biometricEnabled = _ref.read(biometricEnabledProvider);
    
    if (biometricEnabled) {
      _ref.read(appLockProvider.notifier).lockApp();
      if (kDebugMode) {
        debugPrint('AppLock: App paused, locking app');
      }
    }
  }

  /// Handle app coming to foreground
  Future<void> onAppResumed() async {
    final biometricEnabled = _ref.read(biometricEnabledProvider);
    final isLocked = _ref.read(isAppLockedProvider);
    
    if (kDebugMode) {
      debugPrint('AppLock: App resumed, biometric enabled: $biometricEnabled, locked: $isLocked');
    }

    if (biometricEnabled && isLocked) {
      // App is locked, authentication will be handled by the lock screen
      if (kDebugMode) {
        debugPrint('AppLock: App is locked, waiting for authentication');
      }
    }
  }
}

