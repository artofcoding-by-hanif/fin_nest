import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_config.dart';
import '../services/settings_service.dart';
import '../settings/app_settings.dart';

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  final _settingsService = SettingsService.instance;

  /// Load settings from storage
  Future<void> _loadSettings() async {
    state = _settingsService.getSettings();
  }

  /// Update theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    final newSettings = state.copyWith(themeMode: mode);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update currency format
  Future<void> setCurrencyFormat(CurrencyFormat format) async {
    final newSettings = state.copyWith(currencyFormat: format);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update date format
  Future<void> setDateFormat(DateFormatPreference format) async {
    final newSettings = state.copyWith(dateFormat: format);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update number format
  Future<void> setNumberFormat(NumberFormatPreference format) async {
    final newSettings = state.copyWith(numberFormat: format);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update default currency
  Future<void> setDefaultCurrency(String currency) async {
    final newSettings = state.copyWith(defaultCurrency: currency);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update biometric enabled
  Future<void> setBiometricEnabled(bool enabled) async {
    final newSettings = state.copyWith(biometricEnabled: enabled);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Update notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    final newSettings = state.copyWith(notificationsEnabled: enabled);
    state = newSettings;
    await _settingsService.saveSettings(newSettings);
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    const defaultSettings = AppSettings();
    state = defaultSettings;
    await _settingsService.saveSettings(defaultSettings);
  }
}

/// Provider for app settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

/// Provider for theme mode only
final themeModeProvider = Provider<AppThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});

/// Provider for currency format only
final currencyFormatProvider = Provider<CurrencyFormat>((ref) {
  return ref.watch(settingsProvider).currencyFormat;
});

/// Provider for date format only
final dateFormatProvider = Provider<DateFormatPreference>((ref) {
  return ref.watch(settingsProvider).dateFormat;
});

/// Provider for number format only
final numberFormatProvider = Provider<NumberFormatPreference>((ref) {
  return ref.watch(settingsProvider).numberFormat;
});

/// Provider for default currency only
final defaultCurrencyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).defaultCurrency;
});

/// Provider for biometric enabled only
final biometricEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).biometricEnabled;
});

/// Provider for notifications enabled only
final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).notificationsEnabled;
});

/// Provider for current currency configuration
final currentCurrencyProvider = Provider<CurrencyConfig>((ref) {
  final currencyCode = ref.watch(defaultCurrencyProvider);
  return SupportedCurrencies.getByCodeOrDefault(currencyCode);
});
