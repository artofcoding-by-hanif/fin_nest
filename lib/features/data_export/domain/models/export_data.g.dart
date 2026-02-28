// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExportDataImpl _$$ExportDataImplFromJson(
  Map<String, dynamic> json,
) => _$ExportDataImpl(
  metadata: ExportMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  settings: ExportSettings.fromJson(json['settings'] as Map<String, dynamic>),
  database: ExportDatabaseData.fromJson(
    json['database'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$ExportDataImplToJson(_$ExportDataImpl instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'settings': instance.settings,
      'database': instance.database,
    };

_$ExportMetadataImpl _$$ExportMetadataImplFromJson(Map<String, dynamic> json) =>
    _$ExportMetadataImpl(
      version: json['version'] as String,
      appVersion: json['appVersion'] as String,
      exportDate: DateTime.parse(json['exportDate'] as String),
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$$ExportMetadataImplToJson(
  _$ExportMetadataImpl instance,
) => <String, dynamic>{
  'version': instance.version,
  'appVersion': instance.appVersion,
  'exportDate': instance.exportDate.toIso8601String(),
  'deviceInfo': instance.deviceInfo,
};

_$ExportSettingsImpl _$$ExportSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ExportSettingsImpl(
      themeMode: json['themeMode'] as String,
      currencyFormat: json['currencyFormat'] as String,
      dateFormat: json['dateFormat'] as String,
      numberFormat: json['numberFormat'] as String,
      defaultCurrency: json['defaultCurrency'] as String,
      biometricEnabled: json['biometricEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );

Map<String, dynamic> _$$ExportSettingsImplToJson(
  _$ExportSettingsImpl instance,
) => <String, dynamic>{
  'themeMode': instance.themeMode,
  'currencyFormat': instance.currencyFormat,
  'dateFormat': instance.dateFormat,
  'numberFormat': instance.numberFormat,
  'defaultCurrency': instance.defaultCurrency,
  'biometricEnabled': instance.biometricEnabled,
  'notificationsEnabled': instance.notificationsEnabled,
};

_$ExportDatabaseDataImpl _$$ExportDatabaseDataImplFromJson(
  Map<String, dynamic> json,
) => _$ExportDatabaseDataImpl(
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

Map<String, dynamic> _$$ExportDatabaseDataImplToJson(
  _$ExportDatabaseDataImpl instance,
) => <String, dynamic>{
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

_$ImportResultImpl _$$ImportResultImplFromJson(Map<String, dynamic> json) =>
    _$ImportResultImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      stats: ImportStats.fromJson(json['stats'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ImportResultImplToJson(_$ImportResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'stats': instance.stats,
      'error': instance.error,
    };

_$ImportStatsImpl _$$ImportStatsImplFromJson(Map<String, dynamic> json) =>
    _$ImportStatsImpl(
      usersImported: (json['usersImported'] as num).toInt(),
      accountsImported: (json['accountsImported'] as num).toInt(),
      categoriesImported: (json['categoriesImported'] as num).toInt(),
      transactionsImported: (json['transactionsImported'] as num).toInt(),
      recurringTransactionsImported:
          (json['recurringTransactionsImported'] as num).toInt(),
      budgetsImported: (json['budgetsImported'] as num).toInt(),
      budgetCategoriesImported: (json['budgetCategoriesImported'] as num)
          .toInt(),
      goalsImported: (json['goalsImported'] as num).toInt(),
      savingsImported: (json['savingsImported'] as num).toInt(),
      savingsTransactionsImported: (json['savingsTransactionsImported'] as num)
          .toInt(),
      settingsImported: json['settingsImported'] as bool,
    );

Map<String, dynamic> _$$ImportStatsImplToJson(_$ImportStatsImpl instance) =>
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
