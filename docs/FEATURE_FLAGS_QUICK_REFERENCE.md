# Feature Flags Quick Reference

## 🚀 Quick Start

### 1. Check if a feature is enabled

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fin_nest/core/config/feature_flags.dart';
import 'package:fin_nest/core/config/feature_flag_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(
      watchFeatureFlagProvider(FeatureFlag.biometricAuth)
    );
    
    return isEnabled ? EnabledWidget() : DisabledWidget();
  }
}
```

### 2. Use FeatureGate widget

```dart
FeatureGate(
  flag: FeatureFlag.aiInsights,
  child: AIInsightsWidget(),
  fallback: Text('Coming soon!'), // Optional
)
```

### 3. Use FeatureFlagBuilder

```dart
FeatureFlagBuilder(
  flag: FeatureFlag.darkMode,
  enabled: DarkModeUI(),
  disabled: LightModeUI(),
)
```

## 📋 Common Feature Flags

| Flag | Description | Default (Dev/Staging/Prod) |
|------|-------------|---------------------------|
| `biometricAuth` | Fingerprint/Face login | ✅/✅/✅ |
| `socialLogin` | Google/Apple/Facebook login | ✅/✅/✅ |
| `aiInsights` | AI-powered insights | ✅/✅/❌ |
| `bankSync` | Bank account sync | ❌/❌/❌ |
| `darkMode` | Dark theme | ✅/✅/✅ |
| `betaFeatures` | Beta features access | ✅/✅/❌ |
| `debugMode` | Debug features | ✅/❌/❌ |
| `analytics` | Analytics tracking | ❌/✅/✅ |
| `crashReporting` | Crash reporting | ❌/✅/✅ |

## 🔧 Manager API

```dart
import 'package:fin_nest/core/config/feature_flag_manager.dart';

final manager = FeatureFlagManager.instance;

// Check flag
bool isEnabled = manager.isEnabled(FeatureFlag.biometricAuth);

// Get all flags
Map<String, bool> allFlags = manager.getAllFlags();

// Set local override (debug only)
manager.setLocalOverride(FeatureFlag.aiInsights, true);

// Clear override
manager.clearLocalOverride(FeatureFlag.aiInsights);

// Clear all overrides
manager.clearAllLocalOverrides();

// Update remote config
manager.updateRemoteConfig({
  'biometricAuth': true,
  'aiInsights': false,
});
```

## 🎨 Widget Helpers

### FeatureGate
Shows child only if feature is enabled.

```dart
FeatureGate(
  flag: FeatureFlag.biometricAuth,
  child: BiometricButton(),
  fallback: Text('Not available'), // Optional
)
```

### FeatureFlagBuilder
Shows different widgets based on flag state.

```dart
FeatureFlagBuilder(
  flag: FeatureFlag.darkMode,
  enabled: DarkUI(),
  disabled: LightUI(),
)
```

### FeatureFlagMixin
Mixin for easy flag checking in widgets.

```dart
class MyWidget extends ConsumerWidget with FeatureFlagMixin {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isFeatureEnabled(ref, FeatureFlag.betaFeatures)) {
      return BetaWidget();
    }
    return StandardWidget();
  }
}
```

## 🐛 Debug Screen

**Access**: In development mode, tap "Feature Flags" button on home screen.

**Features**:
- View all feature flags
- See current state (enabled/disabled)
- Toggle flags for testing
- View flag descriptions
- Clear local overrides

## 🌐 Remote Configuration

### Initialize with remote config

```dart
await FeatureFlagManager.instance.initialize(
  remoteConfig: {
    'biometricAuth': true,
    'aiInsights': false,
    'bankSync': true,
  },
);
```

### Update at runtime

```dart
final newConfig = await fetchFromServer();
FeatureFlagManager.instance.updateRemoteConfig(newConfig);
```

## 📊 Priority Order

When checking a feature flag, the system uses this priority:

1. **Local Override** (debug only) - Highest priority
2. **Remote Config** (from server)
3. **Default Value** (based on environment) - Lowest priority

## ✅ Best Practices

1. **Always use feature gates** for new features
2. **Test with local overrides** before deploying
3. **Use descriptive flag names** that match the feature
4. **Clean up old flags** when features are stable
5. **Document flag purpose** in code comments
6. **Monitor flag usage** in analytics

## 🔗 Related Files

- **Main Documentation**: `docs/FEATURE_FLAGS.md`
- **Examples**: `lib/core/config/feature_flag_examples.dart`
- **Implementation**: `lib/core/config/feature_flag_manager.dart`
- **Providers**: `lib/core/config/feature_flag_provider.dart`
- **Debug Screen**: `lib/core/widgets/feature_flags_debug_screen.dart`

## 🆘 Troubleshooting

### Flag not updating in UI
- Make sure you're using `watchFeatureFlagProvider` (reactive)
- Not `featureFlagProvider` (one-time read)

### Can't set local override
- Local overrides only work in debug mode
- Check if `kDebugMode` is true

### Flag always returns false
- Check if FeatureFlagManager is initialized in bootstrap
- Verify FlavorConfig is initialized before FeatureFlagManager

### Debug screen not showing
- Debug screen only appears in development flavor
- Check `FlavorConfig.instance.flavor.isDevelopment`

