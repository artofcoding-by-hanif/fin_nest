import 'package:flutter/foundation.dart';
import 'feature_flags.dart';
import 'flavor_config.dart';

/// Feature flag manager for centralized feature control
/// 
/// This class manages feature flags with support for:
/// - Default values per environment (dev/staging/prod)
/// - Remote configuration (Firebase Remote Config, etc.)
/// - Local overrides for testing
/// - Persistent storage of user preferences
class FeatureFlagManager {
  FeatureFlagManager._();
  
  static final FeatureFlagManager _instance = FeatureFlagManager._();
  static FeatureFlagManager get instance => _instance;
  
  // Storage for remote config values
  final Map<String, bool> _remoteFlags = {};
  
  // Storage for local overrides (for testing/debugging)
  final Map<String, bool> _localOverrides = {};
  
  // Listeners for flag changes
  final Map<FeatureFlag, List<VoidCallback>> _listeners = {};
  
  /// Initialize feature flags
  /// Call this during app startup, optionally with remote config
  Future<void> initialize({
    Map<String, bool>? remoteConfig,
  }) async {
    if (remoteConfig != null) {
      _remoteFlags.addAll(remoteConfig);
    }
    
    // TODO: Load local overrides from shared preferences
    // await _loadLocalOverrides();
  }
  
  /// Check if a feature is enabled
  /// 
  /// Priority order:
  /// 1. Local override (for testing)
  /// 2. Remote config (from server)
  /// 3. Default value (based on environment)
  bool isEnabled(FeatureFlag flag) {
    // Check local override first
    if (_localOverrides.containsKey(flag.key)) {
      return _localOverrides[flag.key]!;
    }
    
    // Check remote config
    if (_remoteFlags.containsKey(flag.key)) {
      return _remoteFlags[flag.key]!;
    }
    
    // Fall back to default value
    return _getDefaultValue(flag);
  }
  
  /// Get default value for a feature flag based on current environment
  bool _getDefaultValue(FeatureFlag flag) {
    if (!FlavorConfig.isInitialized) {
      return false;
    }
    
    final flavor = FlavorConfig.instance.flavor;
    
    switch (flag) {
      // Always enabled features
      case FeatureFlag.darkMode:
      case FeatureFlag.offlineMode:
      case FeatureFlag.transactionCategories:
      case FeatureFlag.dashboardWidgets:
      case FeatureFlag.pushNotifications:
      case FeatureFlag.inAppNotifications:
        return true;
      
      // Debug/Development only features
      case FeatureFlag.debugMode:
        return flavor.isDevelopment;
      
      // Beta features (dev + staging)
      case FeatureFlag.betaFeatures:
      case FeatureFlag.aiInsights:
      case FeatureFlag.investmentRecommendations:
        return flavor.isDevelopment || flavor.isStaging;
      
      // Analytics and crash reporting (staging + production)
      case FeatureFlag.analytics:
      case FeatureFlag.crashReporting:
        return flavor.isStaging || flavor.isProduction;
      
      // Production-ready features
      case FeatureFlag.biometricAuth:
      case FeatureFlag.socialLogin:
      case FeatureFlag.recurringTransactions:
      case FeatureFlag.budgetAlerts:
      case FeatureFlag.goalMilestones:
      case FeatureFlag.spendingPatterns:
      case FeatureFlag.cloudSync:
      case FeatureFlag.exportData:
      case FeatureFlag.importData:
        return true;
      
      // Features in development (disabled by default)
      case FeatureFlag.twoFactorAuth:
      case FeatureFlag.customizableDashboard:
      case FeatureFlag.transactionAttachments:
      case FeatureFlag.bulkTransactions:
      case FeatureFlag.budgetRecommendations:
      case FeatureFlag.sharedBudgets:
      case FeatureFlag.goalSharing:
      case FeatureFlag.autoSavings:
      case FeatureFlag.stockTracking:
      case FeatureFlag.cryptoTracking:
      case FeatureFlag.portfolioAnalysis:
      case FeatureFlag.savingsRecommendations:
      case FeatureFlag.financialHealthScore:
      case FeatureFlag.emailNotifications:
      case FeatureFlag.smsNotifications:
      case FeatureFlag.autoSync:
      case FeatureFlag.bankSync:
      case FeatureFlag.profileCustomization:
      case FeatureFlag.multipleProfiles:
        return false;
    }
  }
  
  /// Update remote config values
  /// Call this when fetching new config from server
  void updateRemoteConfig(Map<String, bool> config) {
    _remoteFlags.clear();
    _remoteFlags.addAll(config);
    _notifyAllListeners();
  }
  
  /// Set local override for testing
  /// Only works in debug mode
  void setLocalOverride(FeatureFlag flag, bool value) {
    if (kDebugMode) {
      _localOverrides[flag.key] = value;
      _notifyListeners(flag);
    }
  }
  
  /// Clear local override
  void clearLocalOverride(FeatureFlag flag) {
    if (kDebugMode) {
      _localOverrides.remove(flag.key);
      _notifyListeners(flag);
    }
  }
  
  /// Clear all local overrides
  void clearAllLocalOverrides() {
    if (kDebugMode) {
      _localOverrides.clear();
      _notifyAllListeners();
    }
  }
  
  /// Add listener for flag changes
  void addListener(FeatureFlag flag, VoidCallback listener) {
    _listeners.putIfAbsent(flag, () => []).add(listener);
  }
  
  /// Remove listener
  void removeListener(FeatureFlag flag, VoidCallback listener) {
    _listeners[flag]?.remove(listener);
  }
  
  /// Notify listeners for a specific flag
  void _notifyListeners(FeatureFlag flag) {
    _listeners[flag]?.forEach((listener) => listener());
  }
  
  /// Notify all listeners
  void _notifyAllListeners() {
    _listeners.values.forEach((listeners) {
      listeners.forEach((listener) => listener());
    });
  }
  
  /// Get all flags with their current values (for debugging)
  Map<String, bool> getAllFlags() {
    return Map.fromEntries(
      FeatureFlag.values.map((flag) => MapEntry(flag.key, isEnabled(flag))),
    );
  }
}

