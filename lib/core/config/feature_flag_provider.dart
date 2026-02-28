import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature_flags.dart';
import 'feature_flag_manager.dart';

/// Provider for the feature flag manager instance
final featureFlagManagerProvider = Provider<FeatureFlagManager>((ref) {
  return FeatureFlagManager.instance;
});

/// Provider to check if a specific feature is enabled
/// 
/// Usage:
/// ```dart
/// final isEnabled = ref.watch(featureFlagProvider(FeatureFlag.biometricAuth));
/// ```
final featureFlagProvider = Provider.family<bool, FeatureFlag>((ref, flag) {
  final manager = ref.watch(featureFlagManagerProvider);
  return manager.isEnabled(flag);
});

/// State notifier for feature flags that can be updated
/// This allows reactive updates when flags change
class FeatureFlagNotifier extends StateNotifier<Map<String, bool>> {
  FeatureFlagNotifier(this._manager) : super({}) {
    _loadFlags();
  }
  
  final FeatureFlagManager _manager;
  
  void _loadFlags() {
    state = _manager.getAllFlags();
  }
  
  bool isEnabled(FeatureFlag flag) {
    return _manager.isEnabled(flag);
  }
  
  void setLocalOverride(FeatureFlag flag, bool value) {
    _manager.setLocalOverride(flag, value);
    _loadFlags();
  }
  
  void clearLocalOverride(FeatureFlag flag) {
    _manager.clearLocalOverride(flag);
    _loadFlags();
  }
  
  void clearAllOverrides() {
    _manager.clearAllLocalOverrides();
    _loadFlags();
  }
  
  void updateRemoteConfig(Map<String, bool> config) {
    _manager.updateRemoteConfig(config);
    _loadFlags();
  }
}

/// Provider for the feature flag notifier
final featureFlagNotifierProvider = 
    StateNotifierProvider<FeatureFlagNotifier, Map<String, bool>>((ref) {
  final manager = ref.watch(featureFlagManagerProvider);
  return FeatureFlagNotifier(manager);
});

/// Convenience provider to watch a specific feature flag reactively
/// 
/// Usage:
/// ```dart
/// final isBiometricEnabled = ref.watch(watchFeatureFlagProvider(FeatureFlag.biometricAuth));
/// ```
final watchFeatureFlagProvider = Provider.family<bool, FeatureFlag>((ref, flag) {
  final flags = ref.watch(featureFlagNotifierProvider);
  return flags[flag.key] ?? false;
});

