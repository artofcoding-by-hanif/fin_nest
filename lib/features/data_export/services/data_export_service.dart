import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/tables/accounts_table.dart';
import '../../../core/database/tables/categories_table.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/database/tables/recurring_transactions_table.dart';
import '../../../core/database/tables/budgets_table.dart';
import '../../../core/database/tables/goals_table.dart';
import '../../../core/database/tables/savings_table.dart';
import '../../../core/database/tables/savings_transactions_table.dart';
import '../../../core/services/settings_service.dart';
import '../domain/models/export_data.dart';

/// Service for exporting and importing app data
class DataExportService {
  final AppDatabase _database;
  final SettingsService _settingsService;

  DataExportService({
    required AppDatabase database,
    required SettingsService settingsService,
  }) : _database = database,
       _settingsService = settingsService;

  /// Export all data to ExportData model
  Future<ExportData> exportAllData() async {
    // Get app version
    final packageInfo = await PackageInfo.fromPlatform();

    // Create metadata
    final metadata = ExportMetadata(
      version: '1',
      appVersion: packageInfo.version,
      exportDate: DateTime.now(),
      deviceInfo:
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
    );

    // Export settings
    final appSettings = _settingsService.getSettings();
    final settings = ExportSettings.fromAppSettings(appSettings);

    // Export database data
    final database = await _exportDatabaseData();

    return ExportData(
      metadata: metadata,
      settings: settings,
      database: database,
    );
  }

  /// Export database tables to JSON
  Future<ExportDatabaseData> _exportDatabaseData() async {
    // Export users
    final users = await _database.usersDao.getAllUsers();
    final usersJson = users.map((u) => _userToJson(u)).toList();

    // Export accounts
    final accounts = await _database.select(_database.accounts).get();
    final accountsJson = accounts.map((a) => _accountToJson(a)).toList();

    // Export categories
    final categories = await _database.select(_database.categories).get();
    final categoriesJson = categories.map((c) => _categoryToJson(c)).toList();

    // Export transactions
    final transactions = await _database.select(_database.transactions).get();
    final transactionsJson = transactions
        .map((t) => _transactionToJson(t))
        .toList();

    // Export recurring transactions
    final recurringTransactions = await _database.recurringTransactionsDao
        .getRecurringTransactionsByUserId(1); // TODO: Get actual user ID
    final recurringTransactionsJson = recurringTransactions
        .map((rt) => _recurringTransactionToJson(rt))
        .toList();

    // Export budgets
    final budgets = await _database.select(_database.budgets).get();
    final budgetsJson = budgets.map((b) => _budgetToJson(b)).toList();

    // Export budget categories
    final budgetCategories = await _database
        .select(_database.budgetCategories)
        .get();
    final budgetCategoriesJson = budgetCategories
        .map((bc) => _budgetCategoryToJson(bc))
        .toList();

    // Export goals
    final goals = await _database.select(_database.goals).get();
    final goalsJson = goals.map((g) => _goalToJson(g)).toList();

    // Export savings
    final savings = await _database.select(_database.savings).get();
    final savingsJson = savings.map((s) => _savingToJson(s)).toList();

    // Export savings transactions
    final savingsTransactions = await _database
        .select(_database.savingsTransactions)
        .get();
    final savingsTransactionsJson = savingsTransactions
        .map((st) => _savingsTransactionToJson(st))
        .toList();

    return ExportDatabaseData(
      users: usersJson,
      accounts: accountsJson,
      categories: categoriesJson,
      transactions: transactionsJson,
      recurringTransactions: recurringTransactionsJson,
      budgets: budgetsJson,
      budgetCategories: budgetCategoriesJson,
      goals: goalsJson,
      savings: savingsJson,
      savingsTransactions: savingsTransactionsJson,
    );
  }

  /// Save export data to JSON file
  Future<String> saveExportToFile(ExportData data) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final fileName = 'finnest_export_$timestamp.json';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(data.toJson());
    await file.writeAsString(jsonString);

    return filePath;
  }

  /// Share exported file
  Future<void> shareExportFile(String filePath) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'FinNest Data Export',
      text: 'Export of FinNest app data',
    );
  }

  /// Import data from file
  Future<ImportResult> importFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const ImportResult(
          success: false,
          message: 'File not found',
          stats: ImportStats(
            usersImported: 0,
            accountsImported: 0,
            categoriesImported: 0,
            transactionsImported: 0,
            recurringTransactionsImported: 0,
            budgetsImported: 0,
            budgetCategoriesImported: 0,
            goalsImported: 0,
            savingsImported: 0,
            savingsTransactionsImported: 0,
            settingsImported: false,
          ),
          error: 'The selected file does not exist',
        );
      }

      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final exportData = ExportData.fromJson(jsonData);

      // Import settings
      await _settingsService.saveSettings(exportData.settings.toAppSettings());

      // Import database data
      final stats = await _importDatabaseData(exportData.database);

      return ImportResult(
        success: true,
        message: 'Import completed successfully',
        stats: stats.copyWith(settingsImported: true),
      );
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Import failed',
        stats: const ImportStats(
          usersImported: 0,
          accountsImported: 0,
          categoriesImported: 0,
          transactionsImported: 0,
          recurringTransactionsImported: 0,
          budgetsImported: 0,
          budgetCategoriesImported: 0,
          goalsImported: 0,
          savingsImported: 0,
          savingsTransactionsImported: 0,
          settingsImported: false,
        ),
        error: e.toString(),
      );
    }
  }

  /// Import database data
  Future<ImportStats> _importDatabaseData(ExportDatabaseData data) async {
    int usersImported = 0;
    int accountsImported = 0;
    int categoriesImported = 0;
    int transactionsImported = 0;
    int recurringTransactionsImported = 0;
    int budgetsImported = 0;
    int budgetCategoriesImported = 0;
    int goalsImported = 0;
    int savingsImported = 0;
    int savingsTransactionsImported = 0;

    // Import users - check if exists by uid, then update or insert
    for (final userJson in data.users) {
      final uid = userJson['uid'] as String;
      final existingUser = await _database.usersDao.getUserByUid(uid);

      if (existingUser != null) {
        // Update existing user
        final updatedUser = existingUser.copyWith(
          email: userJson['email'] as String,
          displayName: Value(userJson['displayName'] as String?),
          photoUrl: Value(userJson['photoUrl'] as String?),
          currency: userJson['currency'] as String? ?? 'INR',
          language: userJson['language'] as String? ?? 'en',
          biometricEnabled: userJson['biometricEnabled'] as bool? ?? false,
          notificationsEnabled:
              userJson['notificationsEnabled'] as bool? ?? true,
          timezone: Value(userJson['timezone'] as String?),
          lastSyncedAt: Value(
            userJson['lastSyncedAt'] != null
                ? DateTime.parse(userJson['lastSyncedAt'] as String)
                : null,
          ),
        );
        await _database.usersDao.updateUser(updatedUser);
      } else {
        // Insert new user
        await _database.usersDao.createUser(_jsonToUser(userJson));
      }
      usersImported++;
    }

    // Import accounts - insert only if not exists
    for (final accountJson in data.accounts) {
      try {
        await _database
            .into(_database.accounts)
            .insert(
              _jsonToAccount(accountJson),
              mode: InsertMode.insertOrIgnore,
            );
        accountsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing account: ${accountJson['id']}');
        }
      }
    }

    // Import categories - insert only if not exists
    for (final categoryJson in data.categories) {
      try {
        await _database
            .into(_database.categories)
            .insert(
              _jsonToCategory(categoryJson),
              mode: InsertMode.insertOrIgnore,
            );
        categoriesImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing category: ${categoryJson['id']}');
        }
      }
    }

    // Import transactions - insert only if not exists
    for (final transactionJson in data.transactions) {
      try {
        await _database
            .into(_database.transactions)
            .insert(
              _jsonToTransaction(transactionJson),
              mode: InsertMode.insertOrIgnore,
            );
        transactionsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing transaction: ${transactionJson['id']}');
        }
      }
    }

    // Import recurring transactions - insert only if not exists
    for (final rtJson in data.recurringTransactions) {
      try {
        await _database
            .into(_database.recurringTransactions)
            .insert(
              _jsonToRecurringTransaction(rtJson),
              mode: InsertMode.insertOrIgnore,
            );
        recurringTransactionsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint(
            'Skipping existing recurring transaction: ${rtJson['id']}',
          );
        }
      }
    }

    // Import budgets - insert only if not exists
    for (final budgetJson in data.budgets) {
      try {
        await _database
            .into(_database.budgets)
            .insert(_jsonToBudget(budgetJson), mode: InsertMode.insertOrIgnore);
        budgetsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing budget: ${budgetJson['id']}');
        }
      }
    }

    // Import budget categories - insert only if not exists
    for (final bcJson in data.budgetCategories) {
      try {
        await _database
            .into(_database.budgetCategories)
            .insert(
              _jsonToBudgetCategory(bcJson),
              mode: InsertMode.insertOrIgnore,
            );
        budgetCategoriesImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing budget category: ${bcJson['id']}');
        }
      }
    }

    // Import goals - insert only if not exists
    for (final goalJson in data.goals) {
      try {
        await _database
            .into(_database.goals)
            .insert(_jsonToGoal(goalJson), mode: InsertMode.insertOrIgnore);
        goalsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing goal: ${goalJson['id']}');
        }
      }
    }

    // Import savings - insert only if not exists
    for (final savingJson in data.savings) {
      try {
        await _database
            .into(_database.savings)
            .insert(_jsonToSaving(savingJson), mode: InsertMode.insertOrIgnore);
        savingsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing saving: ${savingJson['id']}');
        }
      }
    }

    // Import savings transactions - insert only if not exists
    for (final stJson in data.savingsTransactions) {
      try {
        await _database
            .into(_database.savingsTransactions)
            .insert(
              _jsonToSavingsTransaction(stJson),
              mode: InsertMode.insertOrIgnore,
            );
        savingsTransactionsImported++;
      } catch (e) {
        // Skip if already exists
        if (kDebugMode) {
          debugPrint('Skipping existing savings transaction: ${stJson['id']}');
        }
      }
    }

    return ImportStats(
      usersImported: usersImported,
      accountsImported: accountsImported,
      categoriesImported: categoriesImported,
      transactionsImported: transactionsImported,
      recurringTransactionsImported: recurringTransactionsImported,
      budgetsImported: budgetsImported,
      budgetCategoriesImported: budgetCategoriesImported,
      goalsImported: goalsImported,
      savingsImported: savingsImported,
      savingsTransactionsImported: savingsTransactionsImported,
      settingsImported: false,
    );
  }

  // ========== Entity to JSON converters ==========

  Map<String, dynamic> _userToJson(UserEntity user) {
    return {
      'id': user.id,
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'currency': user.currency,
      'language': user.language,
      'biometricEnabled': user.biometricEnabled,
      'notificationsEnabled': user.notificationsEnabled,
      'timezone': user.timezone,
      'lastSyncedAt': user.lastSyncedAt?.toIso8601String(),
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _accountToJson(AccountEntity account) {
    return {
      'id': account.id,
      'userId': account.userId,
      'name': account.name,
      'type': account.type.name,
      'balanceInCents': account.balanceInCents,
      'currency': account.currency,
      'color': account.color,
      'icon': account.icon,
      'isDefault': account.isDefault,
      'isActive': account.isActive,
      'includeInTotal': account.includeInTotal,
      'displayOrder': account.displayOrder,
      'notes': account.notes,
      'createdAt': account.createdAt.toIso8601String(),
      'updatedAt': account.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _categoryToJson(CategoryEntity category) {
    return {
      'id': category.id,
      'userId': category.userId,
      'name': category.name,
      'type': category.type.name,
      'parentId': category.parentId,
      'color': category.color,
      'icon': category.icon,
      'budgetLimitInCents': category.budgetLimitInCents,
      'isActive': category.isActive,
      'displayOrder': category.displayOrder,
      'createdAt': category.createdAt.toIso8601String(),
      'updatedAt': category.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _transactionToJson(TransactionEntity transaction) {
    return {
      'id': transaction.id,
      'userId': transaction.userId,
      'type': transaction.type.name,
      'status': transaction.status.name,
      'amountInCents': transaction.amountInCents,
      'currency': transaction.currency,
      'description': transaction.description,
      'notes': transaction.notes,
      'transactionDate': transaction.transactionDate.toIso8601String(),
      'categoryId': transaction.categoryId,
      'accountId': transaction.accountId,
      'tags': transaction.tags,
      'attachmentUrl': transaction.attachmentUrl,
      'createdAt': transaction.createdAt.toIso8601String(),
      'updatedAt': transaction.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _recurringTransactionToJson(
    RecurringTransactionEntity rt,
  ) {
    return {
      'id': rt.id,
      'userId': rt.userId,
      'type': rt.type,
      'amountInCents': rt.amountInCents,
      'currency': rt.currency,
      'description': rt.description,
      'notes': rt.notes,
      'categoryId': rt.categoryId,
      'accountId': rt.accountId,
      'frequency': rt.frequency.name,
      'startDate': rt.startDate.toIso8601String(),
      'endDate': rt.endDate?.toIso8601String(),
      'nextOccurrence': rt.nextOccurrence.toIso8601String(),
      'lastOccurrence': rt.lastOccurrence?.toIso8601String(),
      'autoCreate': rt.autoCreate,
      'daysBeforeToCreate': rt.daysBeforeToCreate,
      'isActive': rt.isActive,
      'createdAt': rt.createdAt.toIso8601String(),
      'updatedAt': rt.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _budgetToJson(BudgetEntity budget) {
    return {
      'id': budget.id,
      'userId': budget.userId,
      'name': budget.name,
      'amountInCents': budget.amountInCents,
      'period': budget.period.name,
      'startDate': budget.startDate.toIso8601String(),
      'endDate': budget.endDate.toIso8601String(),
      'rollover': budget.rollover,
      'alertThreshold': budget.alertThreshold,
      'isActive': budget.isActive,
      'createdAt': budget.createdAt.toIso8601String(),
      'updatedAt': budget.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _budgetCategoryToJson(BudgetCategoryEntity bc) {
    return {
      'id': bc.id,
      'budgetId': bc.budgetId,
      'categoryId': bc.categoryId,
      'allocatedAmountInCents': bc.allocatedAmountInCents,
      'createdAt': bc.createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _goalToJson(GoalEntity goal) {
    return {
      'id': goal.id,
      'userId': goal.userId,
      'name': goal.name,
      'description': goal.description,
      'targetAmountInCents': goal.targetAmountInCents,
      'currentAmountInCents': goal.currentAmountInCents,
      'targetDate': goal.targetDate.toIso8601String(),
      'status': goal.status.name,
      'priority': goal.priority,
      'color': goal.color,
      'icon': goal.icon,
      'createdAt': goal.createdAt.toIso8601String(),
      'updatedAt': goal.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _savingToJson(SavingsEntity saving) {
    return {
      'id': saving.id,
      'userId': saving.userId,
      'category': saving.category.index,
      'name': saving.name,
      'currentValueInCents': saving.currentValueInCents,
      'investedAmountInCents': saving.investedAmountInCents,
      'currency': saving.currency,
      'maturityDate': saving.maturityDate?.toIso8601String(),
      'interestRate': saving.interestRate,
      'accountNumber': saving.accountNumber,
      'institutionName': saving.institutionName,
      'notes': saving.notes,
      'isActive': saving.isActive,
      'color': saving.color,
      'icon': saving.icon,
      'createdAt': saving.createdAt.toIso8601String(),
      'updatedAt': saving.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _savingsTransactionToJson(SavingsTransactionEntity st) {
    return {
      'id': st.id,
      'userId': st.userId,
      'savingsId': st.savingsId,
      'type': st.type.index,
      'amountInCents': st.amountInCents,
      'currency': st.currency,
      'transactionDate': st.transactionDate.toIso8601String(),
      'notes': st.notes,
      'units': st.units,
      'pricePerUnitInCents': st.pricePerUnitInCents,
      'isRecurring': st.isRecurring,
      'recurringTransactionId': st.recurringTransactionId,
      'linkedTransactionId': st.linkedTransactionId,
      'createdAt': st.createdAt.toIso8601String(),
      'updatedAt': st.updatedAt.toIso8601String(),
    };
  }

  // ========== JSON to Entity converters ==========

  UsersCompanion _jsonToUser(Map<String, dynamic> json) {
    return UsersCompanion.insert(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: Value(json['displayName'] as String?),
      photoUrl: Value(json['photoUrl'] as String?),
      currency: Value(json['currency'] as String? ?? 'INR'),
      language: Value(json['language'] as String? ?? 'en'),
      biometricEnabled: Value(json['biometricEnabled'] as bool? ?? false),
      notificationsEnabled: Value(
        json['notificationsEnabled'] as bool? ?? true,
      ),
      timezone: Value(json['timezone'] as String? ?? 'UTC'),
      lastSyncedAt: Value(
        json['lastSyncedAt'] != null
            ? DateTime.parse(json['lastSyncedAt'] as String)
            : null,
      ),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  AccountsCompanion _jsonToAccount(Map<String, dynamic> json) {
    return AccountsCompanion.insert(
      userId: json['userId'] as int,
      name: json['name'] as String,
      type: AccountType.values.firstWhere((e) => e.name == json['type']),
      currency: Value(json['currency'] as String),
      balanceInCents: Value(json['balanceInCents'] as int? ?? 0),
      color: Value(json['color'] as String?),
      icon: Value(json['icon'] as String?),
      isDefault: Value(json['isDefault'] as bool? ?? false),
      isActive: Value(json['isActive'] as bool? ?? true),
      includeInTotal: Value(json['includeInTotal'] as bool? ?? true),
      displayOrder: Value(json['displayOrder'] as int? ?? 0),
      notes: Value(json['notes'] as String?),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  CategoriesCompanion _jsonToCategory(Map<String, dynamic> json) {
    return CategoriesCompanion.insert(
      userId: json['userId'] as int,
      name: json['name'] as String,
      type: CategoryType.values.firstWhere((e) => e.name == json['type']),
      parentId: Value(json['parentId'] as int?),
      color: Value(json['color'] as String?),
      icon: Value(json['icon'] as String?),
      budgetLimitInCents: Value(json['budgetLimitInCents'] as int?),
      isActive: Value(json['isActive'] as bool? ?? true),
      displayOrder: Value(json['displayOrder'] as int? ?? 0),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  TransactionsCompanion _jsonToTransaction(Map<String, dynamic> json) {
    return TransactionsCompanion.insert(
      userId: json['userId'] as int,
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amountInCents: json['amountInCents'] as int,
      currency: Value(json['currency'] as String),
      description: json['description'] as String,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      accountId: json['accountId'] as int,
      categoryId: Value(json['categoryId'] as int?),
      status: Value(
        json['status'] != null
            ? TransactionStatus.values.firstWhere(
                (e) => e.name == json['status'],
              )
            : TransactionStatus.completed,
      ),
      notes: Value(json['notes'] as String?),
      tags: Value(json['tags'] as String?),
      attachmentUrl: Value(json['attachmentUrl'] as String?),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  RecurringTransactionsCompanion _jsonToRecurringTransaction(
    Map<String, dynamic> json,
  ) {
    return RecurringTransactionsCompanion.insert(
      userId: json['userId'] as int,
      type: json['type'] as int,
      amountInCents: json['amountInCents'] as int,
      currency: Value(json['currency'] as String),
      description: json['description'] as String,
      categoryId: Value(json['categoryId'] as int?),
      accountId: json['accountId'] as int,
      frequency: RecurrenceFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      nextOccurrence: DateTime.parse(json['nextOccurrence'] as String),
      notes: Value(json['notes'] as String?),
      endDate: Value(
        json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
      ),
      lastOccurrence: Value(
        json['lastOccurrence'] != null
            ? DateTime.parse(json['lastOccurrence'] as String)
            : null,
      ),
      autoCreate: Value(json['autoCreate'] as bool? ?? true),
      daysBeforeToCreate: Value(json['daysBeforeToCreate'] as int? ?? 0),
      isActive: Value(json['isActive'] as bool? ?? true),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  BudgetsCompanion _jsonToBudget(Map<String, dynamic> json) {
    return BudgetsCompanion.insert(
      userId: json['userId'] as int,
      name: json['name'] as String,
      amountInCents: json['amountInCents'] as int,
      period: BudgetPeriod.values.firstWhere((e) => e.name == json['period']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.parse(
              json['startDate'] as String,
            ).add(const Duration(days: 30)),
      rollover: Value(json['rollover'] as bool? ?? false),
      alertThreshold: Value(json['alertThreshold'] as int? ?? 80),
      isActive: Value(json['isActive'] as bool? ?? true),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  BudgetCategoriesCompanion _jsonToBudgetCategory(Map<String, dynamic> json) {
    return BudgetCategoriesCompanion.insert(
      budgetId: json['budgetId'] as int,
      categoryId: json['categoryId'] as int,
      allocatedAmountInCents: json['allocatedAmountInCents'] as int? ?? 0,
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
    );
  }

  GoalsCompanion _jsonToGoal(Map<String, dynamic> json) {
    return GoalsCompanion.insert(
      userId: json['userId'] as int,
      name: json['name'] as String,
      targetAmountInCents: json['targetAmountInCents'] as int,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : DateTime.now().add(const Duration(days: 365)),
      description: Value(json['description'] as String?),
      currentAmountInCents: Value(json['currentAmountInCents'] as int? ?? 0),
      status: Value(
        json['status'] != null
            ? GoalStatus.values.firstWhere((e) => e.name == json['status'])
            : GoalStatus.active,
      ),
      priority: Value(json['priority'] as int? ?? 0),
      color: Value(json['color'] as String?),
      icon: Value(json['icon'] as String?),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  SavingsCompanion _jsonToSaving(Map<String, dynamic> json) {
    return SavingsCompanion.insert(
      userId: json['userId'] as int,
      category: SavingsCategory.values[json['category'] as int],
      name: json['name'] as String,
      currentValueInCents: json['currentValueInCents'] as int? ?? 0,
      investedAmountInCents: json['investedAmountInCents'] as int? ?? 0,
      currency: Value(json['currency'] as String? ?? 'INR'),
      maturityDate: Value(
        json['maturityDate'] != null
            ? DateTime.parse(json['maturityDate'] as String)
            : null,
      ),
      interestRate: Value(json['interestRate'] as int?),
      accountNumber: Value(json['accountNumber'] as String?),
      institutionName: Value(json['institutionName'] as String?),
      notes: Value(json['notes'] as String?),
      isActive: Value(json['isActive'] as bool? ?? true),
      color: Value(json['color'] as String?),
      icon: Value(json['icon'] as String?),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }

  SavingsTransactionsCompanion _jsonToSavingsTransaction(
    Map<String, dynamic> json,
  ) {
    return SavingsTransactionsCompanion.insert(
      userId: json['userId'] as int,
      savingsId: json['savingsId'] as int,
      type: SavingsTransactionType.values[json['type'] as int],
      amountInCents: json['amountInCents'] as int,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      currency: Value(json['currency'] as String? ?? 'INR'),
      notes: Value(json['notes'] as String?),
      units: Value(json['units'] as double?),
      pricePerUnitInCents: Value(json['pricePerUnitInCents'] as int?),
      isRecurring: Value(json['isRecurring'] as bool? ?? false),
      recurringTransactionId: Value(json['recurringTransactionId'] as int?),
      linkedTransactionId: Value(json['linkedTransactionId'] as int?),
      createdAt: Value(DateTime.parse(json['createdAt'] as String)),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
    );
  }
}
