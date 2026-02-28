import 'package:flutter/material.dart';

/// App theme mode settings
enum AppThemeMode {
  light,
  dark,
  system;

  /// Convert to Flutter ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Create from Flutter ThemeMode
  static AppThemeMode fromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
    }
  }

  /// Display name for UI
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  /// Icon for UI
  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

/// Currency display format
enum CurrencyFormat {
  symbol, // $1,234.56
  code, // USD 1,234.56
  symbolCode; // $1,234.56 USD

  String get displayName {
    switch (this) {
      case CurrencyFormat.symbol:
        return r'Symbol ($)';
      case CurrencyFormat.code:
        return 'Code (USD)';
      case CurrencyFormat.symbolCode:
        return r'Symbol + Code ($ USD)';
    }
  }
}

/// Date format preference
enum DateFormatPreference {
  mdy, // MM/DD/YYYY
  dmy, // DD/MM/YYYY
  ymd; // YYYY-MM-DD

  String get displayName {
    switch (this) {
      case DateFormatPreference.mdy:
        return 'MM/DD/YYYY';
      case DateFormatPreference.dmy:
        return 'DD/MM/YYYY';
      case DateFormatPreference.ymd:
        return 'YYYY-MM-DD';
    }
  }

  String get pattern {
    switch (this) {
      case DateFormatPreference.mdy:
        return 'MM/dd/yyyy';
      case DateFormatPreference.dmy:
        return 'dd/MM/yyyy';
      case DateFormatPreference.ymd:
        return 'yyyy-MM-dd';
    }
  }
}

/// Number format preference
enum NumberFormatPreference {
  comma, // 1,234.56
  period, // 1.234,56
  space; // 1 234.56

  String get displayName {
    switch (this) {
      case NumberFormatPreference.comma:
        return '1,234.56';
      case NumberFormatPreference.period:
        return '1.234,56';
      case NumberFormatPreference.space:
        return '1 234.56';
    }
  }

  String get thousandsSeparator {
    switch (this) {
      case NumberFormatPreference.comma:
        return ',';
      case NumberFormatPreference.period:
        return '.';
      case NumberFormatPreference.space:
        return ' ';
    }
  }

  String get decimalSeparator {
    switch (this) {
      case NumberFormatPreference.comma:
        return '.';
      case NumberFormatPreference.period:
        return ',';
      case NumberFormatPreference.space:
        return '.';
    }
  }
}

/// App settings model
class AppSettings {
  final AppThemeMode themeMode;
  final CurrencyFormat currencyFormat;
  final DateFormatPreference dateFormat;
  final NumberFormatPreference numberFormat;
  final String defaultCurrency;
  final bool biometricEnabled;
  final bool notificationsEnabled;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.currencyFormat = CurrencyFormat.symbol,
    this.dateFormat = DateFormatPreference.dmy,
    this.numberFormat = NumberFormatPreference.comma,
    this.defaultCurrency = 'INR',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
  });

  AppSettings copyWith({
    AppThemeMode? themeMode,
    CurrencyFormat? currencyFormat,
    DateFormatPreference? dateFormat,
    NumberFormatPreference? numberFormat,
    String? defaultCurrency,
    bool? biometricEnabled,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      currencyFormat: currencyFormat ?? this.currencyFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
