import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key for storing onboarding completion status
const String _onboardingCompletedKey = 'onboarding_completed';

/// Provider for onboarding completion status
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final completed = prefs.getBool(_onboardingCompletedKey) ?? false;
  
  if (kDebugMode) {
    debugPrint('Onboarding completed: $completed');
  }
  
  return completed;
});

/// Notifier for managing onboarding state
class OnboardingNotifier extends StateNotifier<AsyncValue<bool>> {
  OnboardingNotifier() : super(const AsyncValue.loading()) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool(_onboardingCompletedKey) ?? false;
      state = AsyncValue.data(completed);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      state = const AsyncValue.data(true);
      
      if (kDebugMode) {
        debugPrint('Onboarding marked as completed');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error completing onboarding: $e');
      }
      state = AsyncValue.error(e, stack);
    }
  }

  /// Reset onboarding (for testing purposes)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, false);
      state = const AsyncValue.data(false);
      
      if (kDebugMode) {
        debugPrint('Onboarding reset');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Error resetting onboarding: $e');
      }
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider for onboarding state notifier
final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<bool>>((ref) {
  return OnboardingNotifier();
});

/// Provider to check if onboarding is completed (reactive)
final isOnboardingCompletedProvider = Provider<bool>((ref) {
  final onboardingState = ref.watch(onboardingNotifierProvider);
  return onboardingState.when(
    data: (completed) => completed,
    loading: () => false,
    error: (_, __) => false,
  );
});

