import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/settings/app_settings.dart';

part 'export_data.freezed.dart';
part 'export_data.g.dart';

/// Export data model containing all app data
@freezed
class ExportData with _$ExportData {
  const factory ExportData({
    required ExportMetadata metadata,
    required ExportSettings settings,
    required ExportDatabaseData database,
  }) = _ExportData;

  factory ExportData.fromJson(Map<String, dynamic> json) =>
      _$ExportDataFromJson(json);
}

/// Export metadata
@freezed
class ExportMetadata with _$ExportMetadata {
  const factory ExportMetadata({
    required String version,
    required String appVersion,
    required DateTime exportDate,
    required String deviceInfo,
  }) = _ExportMetadata;

  factory ExportMetadata.fromJson(Map<String, dynamic> json) =>
      _$ExportMetadataFromJson(json);
}

/// Export settings
@freezed
class ExportSettings with _$ExportSettings {
  const ExportSettings._();

  const factory ExportSettings({
    required String themeMode,
    required String currencyFormat,
    required String dateFormat,
    required String numberFormat,
    required String defaultCurrency,
    required bool biometricEnabled,
    required bool notificationsEnabled,
  }) = _ExportSettings;

  factory ExportSettings.fromJson(Map<String, dynamic> json) =>
      _$ExportSettingsFromJson(json);

  /// Create from AppSettings
  factory ExportSettings.fromAppSettings(AppSettings settings) {
    return ExportSettings(
      themeMode: settings.themeMode.name,
      currencyFormat: settings.currencyFormat.name,
      dateFormat: settings.dateFormat.name,
      numberFormat: settings.numberFormat.name,
      defaultCurrency: settings.defaultCurrency,
      biometricEnabled: settings.biometricEnabled,
      notificationsEnabled: settings.notificationsEnabled,
    );
  }

  /// Convert to AppSettings
  AppSettings toAppSettings() {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere((e) => e.name == themeMode),
      currencyFormat: CurrencyFormat.values.firstWhere(
        (e) => e.name == currencyFormat,
      ),
      dateFormat: DateFormatPreference.values.firstWhere(
        (e) => e.name == dateFormat,
      ),
      numberFormat: NumberFormatPreference.values.firstWhere(
        (e) => e.name == numberFormat,
      ),
      defaultCurrency: defaultCurrency,
      biometricEnabled: biometricEnabled,
      notificationsEnabled: notificationsEnabled,
    );
  }
}

/// Export database data
@freezed
class ExportDatabaseData with _$ExportDatabaseData {
  const factory ExportDatabaseData({
    required List<Map<String, dynamic>> users,
    required List<Map<String, dynamic>> accounts,
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> transactions,
    required List<Map<String, dynamic>> recurringTransactions,
    required List<Map<String, dynamic>> budgets,
    required List<Map<String, dynamic>> budgetCategories,
    required List<Map<String, dynamic>> goals,
    required List<Map<String, dynamic>> savings,
    required List<Map<String, dynamic>> savingsTransactions,
  }) = _ExportDatabaseData;

  factory ExportDatabaseData.fromJson(Map<String, dynamic> json) =>
      _$ExportDatabaseDataFromJson(json);
}

/// Import result
@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    required bool success,
    required String message,
    required ImportStats stats,
    String? error,
  }) = _ImportResult;

  factory ImportResult.fromJson(Map<String, dynamic> json) =>
      _$ImportResultFromJson(json);
}

/// Import statistics
@freezed
class ImportStats with _$ImportStats {
  const ImportStats._();

  const factory ImportStats({
    required int usersImported,
    required int accountsImported,
    required int categoriesImported,
    required int transactionsImported,
    required int recurringTransactionsImported,
    required int budgetsImported,
    required int budgetCategoriesImported,
    required int goalsImported,
    required int savingsImported,
    required int savingsTransactionsImported,
    required bool settingsImported,
  }) = _ImportStats;

  factory ImportStats.fromJson(Map<String, dynamic> json) =>
      _$ImportStatsFromJson(json);

  /// Get total items imported
  int get totalItems =>
      usersImported +
      accountsImported +
      categoriesImported +
      transactionsImported +
      recurringTransactionsImported +
      budgetsImported +
      budgetCategoriesImported +
      goalsImported +
      savingsImported +
      savingsTransactionsImported;
}
