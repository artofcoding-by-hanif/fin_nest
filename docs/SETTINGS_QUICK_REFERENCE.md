# App Settings - Quick Reference

## Quick Start

### 1. Access Settings

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fin_nest/core/providers/settings_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all settings
    final settings = ref.watch(settingsProvider);
    
    // Or watch specific setting
    final themeMode = ref.watch(themeModeProvider);
    
    return Text('Theme: ${themeMode.displayName}');
  }
}
```

### 2. Update Settings

```dart
final settingsNotifier = ref.read(settingsProvider.notifier);

// Update theme
await settingsNotifier.setThemeMode(AppThemeMode.dark);

// Update currency format
await settingsNotifier.setCurrencyFormat(CurrencyFormat.symbol);

// Update date format
await settingsNotifier.setDateFormat(DateFormatPreference.dmy);

// Update number format
await settingsNotifier.setNumberFormat(NumberFormatPreference.comma);

// Update default currency
await settingsNotifier.setDefaultCurrency('EUR');

// Update biometric
await settingsNotifier.setBiometricEnabled(true);

// Update notifications
await settingsNotifier.setNotificationsEnabled(false);

// Reset to defaults
await settingsNotifier.resetToDefaults();
```

### 3. Navigate to Settings Screen

```dart
import 'package:fin_nest/features/settings/presentation/screens/settings_screen.dart';

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const SettingsScreen(),
  ),
);
```

## Available Settings

| Setting | Type | Default | Options |
|---------|------|---------|---------|
| Theme Mode | `AppThemeMode` | System | Light, Dark, System |
| Currency Format | `CurrencyFormat` | Symbol | Symbol ($), Code (USD), Symbol + Code |
| Date Format | `DateFormatPreference` | MDY | MM/DD/YYYY, DD/MM/YYYY, YYYY-MM-DD |
| Number Format | `NumberFormatPreference` | Comma | 1,234.56, 1.234,56, 1 234.56 |
| Default Currency | `String` | USD | Any 3-letter code |
| Biometric Enabled | `bool` | false | true, false |
| Notifications Enabled | `bool` | true | true, false |

## Providers Reference

### Main Provider

```dart
// Watch all settings
final settings = ref.watch(settingsProvider);

// Access notifier for updates
final notifier = ref.read(settingsProvider.notifier);
```

### Specific Providers

```dart
// Theme mode only
final themeMode = ref.watch(themeModeProvider);

// Currency format only
final currencyFormat = ref.watch(currencyFormatProvider);

// Date format only
final dateFormat = ref.watch(dateFormatProvider);

// Number format only
final numberFormat = ref.watch(numberFormatProvider);

// Default currency only
final currency = ref.watch(defaultCurrencyProvider);

// Biometric enabled only
final biometric = ref.watch(biometricEnabledProvider);

// Notifications enabled only
final notifications = ref.watch(notificationsEnabledProvider);
```

## Enum Values

### AppThemeMode

```dart
AppThemeMode.light      // Light theme
AppThemeMode.dark       // Dark theme
AppThemeMode.system     // Follow system theme

// Properties
mode.displayName        // "Light", "Dark", "System"
mode.icon              // Icons.light_mode, Icons.dark_mode, Icons.brightness_auto
mode.toThemeMode()     // Convert to Flutter ThemeMode
```

### CurrencyFormat

```dart
CurrencyFormat.symbol       // $1,234.56
CurrencyFormat.code         // USD 1,234.56
CurrencyFormat.symbolCode   // $1,234.56 USD

// Properties
format.displayName     // "Symbol ($)", "Code (USD)", "Symbol + Code ($ USD)"
```

### DateFormatPreference

```dart
DateFormatPreference.mdy    // MM/DD/YYYY
DateFormatPreference.dmy    // DD/MM/YYYY
DateFormatPreference.ymd    // YYYY-MM-DD

// Properties
format.displayName     // "MM/DD/YYYY", "DD/MM/YYYY", "YYYY-MM-DD"
format.pattern         // "MM/dd/yyyy", "dd/MM/yyyy", "yyyy-MM-dd"
```

### NumberFormatPreference

```dart
NumberFormatPreference.comma    // 1,234.56
NumberFormatPreference.period   // 1.234,56
NumberFormatPreference.space    // 1 234.56

// Properties
format.displayName          // "1,234.56", "1.234,56", "1 234.56"
format.thousandsSeparator   // ",", ".", " "
format.decimalSeparator     // ".", ",", "."
```

## Common Use Cases

### Format Currency

```dart
final currencyFormat = ref.watch(currencyFormatProvider);
final defaultCurrency = ref.watch(defaultCurrencyProvider);

String formatCurrency(double amount) {
  switch (currencyFormat) {
    case CurrencyFormat.symbol:
      return '\$${amount.toStringAsFixed(2)}';
    case CurrencyFormat.code:
      return '$defaultCurrency ${amount.toStringAsFixed(2)}';
    case CurrencyFormat.symbolCode:
      return '\$${amount.toStringAsFixed(2)} $defaultCurrency';
  }
}
```

### Format Date

```dart
final dateFormat = ref.watch(dateFormatProvider);

String formatDate(DateTime date) {
  return DateFormat(dateFormat.pattern).format(date);
}
```

### Format Number

```dart
final numberFormat = ref.watch(numberFormatProvider);

String formatNumber(double number) {
  final parts = number.toStringAsFixed(2).split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}${numberFormat.thousandsSeparator}',
  );
  return '$intPart${numberFormat.decimalSeparator}${parts[1]}';
}
```

### Check Theme Mode

```dart
final themeMode = ref.watch(themeModeProvider);

if (themeMode == AppThemeMode.dark) {
  // Show dark mode specific UI
}
```

## Testing

### Test Settings Changes

```dart
// In your test or debug screen
ElevatedButton(
  onPressed: () async {
    final notifier = ref.read(settingsProvider.notifier);
    
    // Change theme
    await notifier.setThemeMode(AppThemeMode.dark);
    
    // Verify change
    final settings = ref.read(settingsProvider);
    print('Theme: ${settings.themeMode.displayName}');
  },
  child: const Text('Test Settings'),
)
```

### Test Persistence

```dart
// 1. Change a setting
await notifier.setThemeMode(AppThemeMode.dark);

// 2. Restart the app

// 3. Verify setting persisted
final settings = ref.read(settingsProvider);
assert(settings.themeMode == AppThemeMode.dark);
```

## See Also

- [SETTINGS_SETUP.md](./SETTINGS_SETUP.md) - Complete setup guide
- [SETTINGS_SUMMARY.md](./SETTINGS_SUMMARY.md) - Implementation summary

