import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/app_settings.dart';

/// Service for managing app settings using SharedPreferences
class SettingsService {
  static SettingsService? _instance;
  static SettingsService get instance {
    _instance ??= SettingsService._();
    return _instance!;
  }

  SettingsService._();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Settings keys
  static const String _keyThemeMode = 'settings.theme_mode';
  static const String _keyCurrencyFormat = 'settings.currency_format';
  static const String _keyDateFormat = 'settings.date_format';
  static const String _keyNumberFormat = 'settings.number_format';
  static const String _keyDefaultCurrency = 'settings.default_currency';
  static const String _keyBiometricEnabled = 'settings.biometric_enabled';
  static const String _keyNotificationsEnabled =
      'settings.notifications_enabled';

  /// Initialize the settings service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('SettingsService already initialized');
      return;
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('SettingsService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize SettingsService: $e');
      rethrow;
    }
  }

  /// Get current settings
  AppSettings getSettings() {
    if (!_isInitialized || _prefs == null) {
      debugPrint('SettingsService not initialized, returning default settings');
      return const AppSettings();
    }

    return AppSettings(
      themeMode: _getThemeMode(),
      currencyFormat: _getCurrencyFormat(),
      dateFormat: _getDateFormat(),
      numberFormat: _getNumberFormat(),
      defaultCurrency: _getDefaultCurrency(),
      biometricEnabled: _getBiometricEnabled(),
      notificationsEnabled: _getNotificationsEnabled(),
    );
  }

  /// Save settings
  Future<void> saveSettings(AppSettings settings) async {
    if (!_isInitialized || _prefs == null) {
      debugPrint('SettingsService not initialized');
      return;
    }

    await Future.wait([
      _setThemeMode(settings.themeMode),
      _setCurrencyFormat(settings.currencyFormat),
      _setDateFormat(settings.dateFormat),
      _setNumberFormat(settings.numberFormat),
      _setDefaultCurrency(settings.defaultCurrency),
      _setBiometricEnabled(settings.biometricEnabled),
      _setNotificationsEnabled(settings.notificationsEnabled),
    ]);

    debugPrint('Settings saved successfully');
  }

  // Theme Mode
  AppThemeMode _getThemeMode() {
    final value = _prefs?.getString(_keyThemeMode);
    if (value == null) return AppThemeMode.system;
    return AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> _setThemeMode(AppThemeMode mode) async {
    await _prefs?.setString(_keyThemeMode, mode.name);
  }

  // Currency Format
  CurrencyFormat _getCurrencyFormat() {
    final value = _prefs?.getString(_keyCurrencyFormat);
    if (value == null) return CurrencyFormat.symbol;
    return CurrencyFormat.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CurrencyFormat.symbol,
    );
  }

  Future<void> _setCurrencyFormat(CurrencyFormat format) async {
    await _prefs?.setString(_keyCurrencyFormat, format.name);
  }

  // Date Format
  DateFormatPreference _getDateFormat() {
    final value = _prefs?.getString(_keyDateFormat);
    if (value == null) return DateFormatPreference.dmy;
    return DateFormatPreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DateFormatPreference.dmy,
    );
  }

  Future<void> _setDateFormat(DateFormatPreference format) async {
    await _prefs?.setString(_keyDateFormat, format.name);
  }

  // Number Format
  NumberFormatPreference _getNumberFormat() {
    final value = _prefs?.getString(_keyNumberFormat);
    if (value == null) return NumberFormatPreference.comma;
    return NumberFormatPreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NumberFormatPreference.comma,
    );
  }

  Future<void> _setNumberFormat(NumberFormatPreference format) async {
    await _prefs?.setString(_keyNumberFormat, format.name);
  }

  // Default Currency
  String _getDefaultCurrency() {
    return _prefs?.getString(_keyDefaultCurrency) ?? 'INR';
  }

  Future<void> _setDefaultCurrency(String currency) async {
    await _prefs?.setString(_keyDefaultCurrency, currency);
  }

  // Biometric Enabled
  bool _getBiometricEnabled() {
    return _prefs?.getBool(_keyBiometricEnabled) ?? false;
  }

  Future<void> _setBiometricEnabled(bool enabled) async {
    await _prefs?.setBool(_keyBiometricEnabled, enabled);
  }

  // Notifications Enabled
  bool _getNotificationsEnabled() {
    return _prefs?.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> _setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool(_keyNotificationsEnabled, enabled);
  }
}
