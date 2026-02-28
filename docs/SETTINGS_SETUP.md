# App Settings Setup Guide

This guide explains how to set up and use the app settings system in FinNest.

## Overview

The app settings system provides a centralized way to manage user preferences including:
- **Theme Mode** - Light, Dark, or System
- **Currency Format** - Symbol ($), Code (USD), or Symbol + Code ($ USD)
- **Date Format** - MM/DD/YYYY, DD/MM/YYYY, or YYYY-MM-DD
- **Number Format** - 1,234.56, 1.234,56, or 1 234.56
- **Default Currency** - USD, EUR, GBP, etc.
- **Biometric Authentication** - Enable/disable fingerprint or face ID
- **Notifications** - Enable/disable push notifications

## Architecture

```
lib/
├── core/
│   ├── settings/
│   │   └── app_settings.dart          # Settings models and enums
│   ├── services/
│   │   └── settings_service.dart      # Settings persistence service
│   └── providers/
│       └── settings_provider.dart     # Riverpod providers
└── features/
    └── settings/
        └── presentation/
            └── screens/
                └── settings_screen.dart  # Settings UI
```

## Components

### 1. Settings Models (`lib/core/settings/app_settings.dart`)

#### Enums

- **AppThemeMode** - Light, Dark, System
- **CurrencyFormat** - Symbol, Code, SymbolCode
- **DateFormatPreference** - MDY, DMY, YMD
- **NumberFormatPreference** - Comma, Period, Space

#### AppSettings Class

Immutable settings model with:
- All preference fields
- `copyWith()` method for updates
- Default values

### 2. Settings Service (`lib/core/services/settings_service.dart`)

Singleton service that:
- Uses SharedPreferences for persistence
- Provides `getSettings()` to load settings
- Provides `saveSettings()` to persist settings
- Initializes in bootstrap

### 3. Settings Providers (`lib/core/providers/settings_provider.dart`)

Riverpod providers for reactive state management:
- **settingsProvider** - Main settings state notifier
- **themeModeProvider** - Theme mode only
- **currencyFormatProvider** - Currency format only
- **dateFormatProvider** - Date format only
- **numberFormatProvider** - Number format only
- **defaultCurrencyProvider** - Default currency only
- **biometricEnabledProvider** - Biometric enabled only
- **notificationsEnabledProvider** - Notifications enabled only

### 4. Settings Screen (`lib/features/settings/presentation/screens/settings_screen.dart`)

Material 3 settings UI with:
- Organized sections (Appearance, Units & Formats, Security, Notifications)
- List tiles for each setting
- Dialog pickers for selection
- Switch tiles for boolean settings
- Reset to defaults button

## Setup

### 1. Dependencies

Already installed:
```yaml
dependencies:
  shared_preferences: ^2.5.4
  flutter_riverpod: ^2.6.1
```

### 2. Initialization

The settings service is automatically initialized in `bootstrap.dart`:

```dart
await SettingsService.instance.initialize();
```

### 3. Theme Integration

The app theme is automatically connected to settings in `app.dart`:

```dart
final themeMode = ref.watch(themeModeProvider);

MaterialApp(
  themeMode: themeMode.toThemeMode(),
  // ...
)
```

## Usage

### Access Settings in UI

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all settings
    final settings = ref.watch(settingsProvider);
    
    // Or watch specific setting
    final themeMode = ref.watch(themeModeProvider);
    final currency = ref.watch(defaultCurrencyProvider);
    
    return Text('Theme: ${themeMode.displayName}');
  }
}
```

### Update Settings

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    return ElevatedButton(
      onPressed: () {
        // Update theme mode
        settingsNotifier.setThemeMode(AppThemeMode.dark);
        
        // Update currency format
        settingsNotifier.setCurrencyFormat(CurrencyFormat.symbol);
        
        // Update date format
        settingsNotifier.setDateFormat(DateFormatPreference.dmy);
      },
      child: const Text('Update Settings'),
    );
  }
}
```

### Navigate to Settings Screen

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const SettingsScreen(),
  ),
);
```

## Settings Persistence

Settings are automatically persisted to SharedPreferences when updated:

1. User changes a setting in the UI
2. `SettingsNotifier` updates the state
3. `SettingsService.saveSettings()` is called
4. Settings are saved to SharedPreferences
5. UI automatically updates via Riverpod

## Theme Switching

Theme changes are applied immediately:

1. User selects theme mode in settings
2. `themeModeProvider` notifies listeners
3. `MaterialApp` rebuilds with new theme mode
4. App theme changes instantly

## Default Values

Default settings are defined in `AppSettings`:

```dart
const AppSettings({
  this.themeMode = AppThemeMode.system,
  this.currencyFormat = CurrencyFormat.symbol,
  this.dateFormat = DateFormatPreference.mdy,
  this.numberFormat = NumberFormatPreference.comma,
  this.defaultCurrency = 'USD',
  this.biometricEnabled = false,
  this.notificationsEnabled = true,
});
```

## Extending Settings

To add a new setting:

1. Add field to `AppSettings` class
2. Add getter/setter methods to `SettingsService`
3. Add update method to `SettingsNotifier`
4. Add provider if needed
5. Add UI in `SettingsScreen`

Example:

```dart
// 1. Add to AppSettings
class AppSettings {
  final String language;
  // ...
}

// 2. Add to SettingsService
String _getLanguage() {
  return _prefs?.getString('settings.language') ?? 'en';
}

Future<void> _setLanguage(String language) async {
  await _prefs?.setString('settings.language', language);
}

// 3. Add to SettingsNotifier
Future<void> setLanguage(String language) async {
  final newSettings = state.copyWith(language: language);
  state = newSettings;
  await _settingsService.saveSettings(newSettings);
}

// 4. Add provider
final languageProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).language;
});

// 5. Add UI in SettingsScreen
ListTile(
  title: const Text('Language'),
  subtitle: Text(settings.language),
  onTap: () => _showLanguageDialog(context, settings, notifier),
)
```

## Best Practices

1. **Use specific providers** - Watch only the settings you need to minimize rebuilds
2. **Persist immediately** - Settings are saved as soon as they're changed
3. **Provide defaults** - Always have sensible default values
4. **Validate input** - Validate user input before saving (e.g., currency code length)
5. **Handle errors** - Gracefully handle SharedPreferences failures
6. **Test on devices** - Test settings persistence across app restarts

## Next Steps

1. **Add more settings** - Language, font size, etc.
2. **Add validation** - Validate currency codes, date formats, etc.
3. **Add import/export** - Allow users to backup/restore settings
4. **Add cloud sync** - Sync settings across devices
5. **Add analytics** - Track which settings users change most

## See Also

- [SETTINGS_QUICK_REFERENCE.md](./SETTINGS_QUICK_REFERENCE.md) - Quick reference guide
- [SETTINGS_SUMMARY.md](./SETTINGS_SUMMARY.md) - Implementation summary

