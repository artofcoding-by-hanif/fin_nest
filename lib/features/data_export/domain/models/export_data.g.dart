// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportData _$ExportDataFromJson(Map<String, dynamic> json) => _ExportData(
  metadata: ExportMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  settings: ExportSettings.fromJson(json['settings'] as Map<String, dynamic>),
  database: ExportDatabaseData.fromJson(
    json['database'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ExportDataToJson(_ExportData instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'settings': instance.settings,
      'database': instance.database,
    };

_ExportMetadata _$ExportMetadataFromJson(Map<String, dynamic> json) =>
    _ExportMetadata(
      version: json['version'] as String,
      appVersion: json['appVersion'] as String,
      exportDate: DateTime.parse(json['exportDate'] as String),
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$ExportMetadataToJson(_ExportMetadata instance) =>
    <String, dynamic>{
      'version': instance.version,
      'appVersion': instance.appVersion,
      'exportDate': instance.exportDate.toIso8601String(),
      'deviceInfo': instance.deviceInfo,
    };

_ExportSettings _$ExportSettingsFromJson(Map<String, dynamic> json) =>
    _ExportSettings(
      themeMode: json['themeMode'] as String,
      currencyFormat: json['currencyFormat'] as String,
      dateFormat: json['dateFormat'] as String,
      numberFormat: json['numberFormat'] as String,
      defaultCurrency: json['defaultCurrency'] as String,
      biometricEnabled: json['biometricEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );

Map<String, dynamic> _$ExportSettingsToJson(_ExportSettings instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'currencyFormat': instance.currencyFormat,
      'dateFormat': instance.dateFormat,
      'numberFormat': instance.numberFormat,
      'defaultCurrency': instance.defaultCurrency,
      'biometricEnabled': instance.biometricEnabled,
      'notificationsEnabled': instance.notificationsEnabled,
    };

_ExportDatabaseData _$ExportDatabaseDataFromJson(Map<String, dynamic> json) =>
    _ExportDatabaseData(
      users: (json['users'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      recurringTransactions: (json['recurringTransactions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      budgets: (json['budgets'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      budgetCategories: (json['budgetCategories'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      goals: (json['goals'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      savings: (json['savings'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      savingsTransactions: (json['savingsTransactions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ExportDatabaseDataToJson(_ExportDatabaseData instance) =>
    <String, dynamic>{
      'users': instance.users,
      'accounts': instance.accounts,
      'categories': instance.categories,
      'transactions': instance.transactions,
      'recurringTransactions': instance.recurringTransactions,
      'budgets': instance.budgets,
      'budgetCategories': instance.budgetCategories,
      'goals': instance.goals,
      'savings': instance.savings,
      'savingsTransactions': instance.savingsTransactions,
    };

_ImportResult _$ImportResultFromJson(Map<String, dynamic> json) =>
    _ImportResult(
      success: json['success'] as bool,
      message: json['message'] as String,
      stats: ImportStats.fromJson(json['stats'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ImportResultToJson(_ImportResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'stats': instance.stats,
      'error': instance.error,
    };

_ImportStats _$ImportStatsFromJson(Map<String, dynamic> json) => _ImportStats(
  usersImported: (json['usersImported'] as num).toInt(),
  accountsImported: (json['accountsImported'] as num).toInt(),
  categoriesImported: (json['categoriesImported'] as num).toInt(),
  transactionsImported: (json['transactionsImported'] as num).toInt(),
  recurringTransactionsImported: (json['recurringTransactionsImported'] as num)
      .toInt(),
  budgetsImported: (json['budgetsImported'] as num).toInt(),
  budgetCategoriesImported: (json['budgetCategoriesImported'] as num).toInt(),
  goalsImported: (json['goalsImported'] as num).toInt(),
  savingsImported: (json['savingsImported'] as num).toInt(),
  savingsTransactionsImported: (json['savingsTransactionsImported'] as num)
      .toInt(),
  settingsImported: json['settingsImported'] as bool,
);

Map<String, dynamic> _$ImportStatsToJson(_ImportStats instance) =>
    <String, dynamic>{
      'usersImported': instance.usersImported,
      'accountsImported': instance.accountsImported,
      'categoriesImported': instance.categoriesImported,
      'transactionsImported': instance.transactionsImported,
      'recurringTransactionsImported': instance.recurringTransactionsImported,
      'budgetsImported': instance.budgetsImported,
      'budgetCategoriesImported': instance.budgetCategoriesImported,
      'goalsImported': instance.goalsImported,
      'savingsImported': instance.savingsImported,
      'savingsTransactionsImported': instance.savingsTransactionsImported,
      'settingsImported': instance.settingsImported,
    };
