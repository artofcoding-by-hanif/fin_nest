# Feature Flags System

A comprehensive feature flag system for centralized feature control in FinNest.

## 📋 Overview

The feature flag system allows you to:
- ✅ Enable/disable features centrally
- ✅ Configure features per environment (Dev/Staging/Prod)
- ✅ Support remote configuration (Firebase Remote Config, etc.)
- ✅ Override flags locally for testing
- ✅ React to flag changes in real-time

## 🏗️ Architecture

### Components

1. **FeatureFlag Enum** (`lib/core/config/feature_flags.dart`)
   - Defines all available feature flags
   - Provides metadata (display name, description)

2. **FeatureFlagManager** (`lib/core/config/feature_flag_manager.dart`)
   - Singleton manager for feature flags
   - Handles default values, remote config, and local overrides
   - Priority: Local Override → Remote Config → Default Value

3. **Feature Flag Providers** (`lib/core/config/feature_flag_provider.dart`)
   - Riverpod providers for reactive flag access
   - State management for flag changes

4. **Debug Screen** (`lib/core/widgets/feature_flags_debug_screen.dart`)
   - UI to view and toggle flags (debug mode only)
   - Available in development environment

## 🚀 Usage

### Basic Usage

#### Check if a feature is enabled

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fin_nest/core/config/feature_flags.dart';
import 'package:fin_nest/core/config/feature_flag_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricEnabled = ref.watch(
      watchFeatureFlagProvider(FeatureFlag.biometricAuth)
    );
    
    if (isBiometricEnabled) {
      return BiometricLoginButton();
    }
    
    return StandardLoginButton();
  }
}
```

#### Using FeatureGate Widget

```dart
import 'package:fin_nest/core/widgets/feature_flags_debug_screen.dart';

// Show widget only if feature is enabled
FeatureGate(
  flag: FeatureFlag.biometricAuth,
  child: BiometricLoginButton(),
  fallback: Text('Feature not available'),
)

// Without fallback (hides if disabled)
FeatureGate(
  flag: FeatureFlag.aiInsights,
  child: AIInsightsWidget(),
)
```

#### Using FeatureFlagBuilder

```dart
FeatureFlagBuilder(
  flag: FeatureFlag.darkMode,
  enabled: DarkModeUI(),
  disabled: LightModeUI(),
)
```

#### Using FeatureFlagMixin

```dart
class MyWidget extends ConsumerWidget with FeatureFlagMixin {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isFeatureEnabled(ref, FeatureFlag.betaFeatures)) {
      return BetaFeatureWidget();
    }
    return StandardWidget();
  }
}
```

### Advanced Usage

#### Direct Manager Access

```dart
import 'package:fin_nest/core/config/feature_flag_manager.dart';

final manager = FeatureFlagManager.instance;

// Check if feature is enabled
if (manager.isEnabled(FeatureFlag.cloudSync)) {
  // Perform cloud sync
}

// Get all flags (for debugging)
final allFlags = manager.getAllFlags();
print(allFlags);
```

#### Local Overrides (Debug Mode Only)

```dart
final manager = FeatureFlagManager.instance;

// Enable a feature locally for testing
manager.setLocalOverride(FeatureFlag.aiInsights, true);

// Clear override
manager.clearLocalOverride(FeatureFlag.aiInsights);

// Clear all overrides
manager.clearAllLocalOverrides();
```

#### Remote Configuration

```dart
// Fetch from Firebase Remote Config or your backend
final remoteConfig = await fetchRemoteConfig();

// Update feature flags
FeatureFlagManager.instance.updateRemoteConfig(remoteConfig);

// Or during initialization
await FeatureFlagManager.instance.initialize(
  remoteConfig: {
    'biometricAuth': true,
    'aiInsights': false,
    'bankSync': true,
  },
);
```

## 📱 Available Feature Flags

### Authentication Features
- `biometricAuth` - Biometric authentication (fingerprint/face)
- `socialLogin` - Social login (Google, Apple, Facebook)
- `twoFactorAuth` - Two-factor authentication

### Dashboard Features
- `dashboardWidgets` - Dashboard widgets
- `customizableDashboard` - Customizable dashboard layout

### Transaction Features
- `recurringTransactions` - Recurring transactions
- `transactionCategories` - Transaction categories
- `transactionAttachments` - Attach files to transactions
- `bulkTransactions` - Bulk transaction operations

### Budget Features
- `budgetAlerts` - Budget alerts and notifications
- `budgetRecommendations` - AI-powered budget recommendations
- `sharedBudgets` - Share budgets with family/friends

### Goal Features
- `goalMilestones` - Goal milestones tracking
- `goalSharing` - Share goals with others
- `autoSavings` - Automatic savings towards goals

### Investment Features
- `stockTracking` - Stock portfolio tracking
- `cryptoTracking` - Cryptocurrency tracking
- `portfolioAnalysis` - Portfolio analysis and insights
- `investmentRecommendations` - AI investment recommendations

### Insights Features
- `aiInsights` - AI-powered financial insights
- `spendingPatterns` - Spending pattern analysis
- `savingsRecommendations` - Savings recommendations
- `financialHealthScore` - Financial health score

### Notification Features
- `pushNotifications` - Push notifications
- `emailNotifications` - Email notifications
- `smsNotifications` - SMS notifications
- `inAppNotifications` - In-app notifications

### Sync Features
- `cloudSync` - Cloud synchronization
- `autoSync` - Automatic sync
- `bankSync` - Bank account synchronization

### Other Features
- `darkMode` - Dark mode theme
- `offlineMode` - Offline mode support
- `debugMode` - Debug mode features
- `betaFeatures` - Beta features access
- `analytics` - Analytics tracking
- `crashReporting` - Crash reporting

## 🔧 Configuration

### Default Values by Environment

Feature flags have different default values based on the environment:

**Development:**
- Debug features enabled
- Beta features enabled
- Most features enabled for testing

**Staging:**
- Beta features enabled
- Analytics enabled
- Production-like configuration

**Production:**
- Only stable features enabled
- Analytics and crash reporting enabled
- Beta features disabled

### Customizing Defaults

Edit `lib/core/config/feature_flag_manager.dart` in the `_getDefaultValue` method:

```dart
bool _getDefaultValue(FeatureFlag flag) {
  final flavor = FlavorConfig.instance.flavor;
  
  switch (flag) {
    case FeatureFlag.myNewFeature:
      return flavor.isDevelopment; // Only in dev
    // ... other cases
  }
}
```

## 🐛 Debugging

### Access Debug Screen

In development mode, tap the "Feature Flags" button on the home screen to:
- View all feature flags and their states
- Toggle flags on/off for testing
- See flag descriptions
- Clear local overrides

### Programmatic Debugging

```dart
// Get all flags
final allFlags = FeatureFlagManager.instance.getAllFlags();
allFlags.forEach((key, value) {
  print('$key: $value');
});
```

## 🔄 Integration with Remote Config

### Firebase Remote Config Example

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  
  await remoteConfig.fetchAndActivate();
  
  // Convert to feature flags
  final flags = <String, bool>{};
  for (final flag in FeatureFlag.values) {
    flags[flag.key] = remoteConfig.getBool(flag.key);
  }
  
  // Update feature flags
  FeatureFlagManager.instance.updateRemoteConfig(flags);
}
```

## 📝 Best Practices

1. **Always use feature gates** for new features
2. **Test with local overrides** before deploying
3. **Document feature flags** when adding new ones
4. **Clean up old flags** when features are stable
5. **Use remote config** for gradual rollouts
6. **Monitor flag usage** in analytics

## 🎯 Next Steps

1. Integrate with Firebase Remote Config
2. Add analytics for flag usage
3. Implement A/B testing support
4. Add user-specific flag overrides
5. Create admin dashboard for flag management

