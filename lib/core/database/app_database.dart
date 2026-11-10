import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/users_table.dart';
import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/budgets_table.dart';
import 'tables/budget_categories_table.dart';
import 'tables/goals_table.dart';
import 'tables/recurring_transactions_table.dart';
import 'tables/savings_table.dart';
import 'tables/savings_transactions_table.dart';
import 'tables/ai_chat_tables.dart';
import 'daos/users_dao.dart';
import 'daos/accounts_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/recurring_transactions_dao.dart';
import 'daos/savings_dao.dart';
import 'daos/savings_transactions_dao.dart';
import 'daos/ai_chat_dao.dart';

part 'app_database.g.dart';

/// Main application database
@DriftDatabase(
  tables: [
    Users,
    Accounts,
    Categories,
    Transactions,
    Budgets,
    BudgetCategories,
    Goals,
    RecurringTransactions,
    Savings,
    SavingsTransactions,
    AiConversations,
    AiMessages,
  ],
  daos: [
    UsersDao,
    AccountsDao,
    CategoriesDao,
    TransactionsDao,
    RecurringTransactionsDao,
    SavingsDao,
    SavingsTransactionsDao,
    AiChatDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Constructor
  AppDatabase() : super(_openConnection());

  /// Test constructor for unit tests
  AppDatabase.test(QueryExecutor executor, {int? schemaVersion})
    : super(executor);

  /// Schema version
  @override
  int get schemaVersion => 10;

  /// Migration strategy
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Create all tables
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Run migrations step by step
        await _runMigrations(m, from, to);
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');

        // Log database version info
        if (details.wasCreated) {
          debugPrint('Database created with version $schemaVersion');
          // Seed initial data for new database
          await _seedInitialData();
        } else if (details.hadUpgrade) {
          debugPrint(
            'Database upgraded from version ${details.versionBefore} to ${details.versionNow}',
          );
        }
      },
    );
  }

  /// Run migrations from one version to another
  Future<void> _runMigrations(Migrator m, int from, int to) async {
    debugPrint('Running migrations from version $from to $to');

    // Version 1 -> 2: Seed initial data
    if (from < 2) {
      await _migrateToV2(m);
    }

    // Version 2 -> 3: Add recurring transactions seed data
    if (from < 3) {
      await _migrateToV3(m);
    }

    // Version 3 -> 4: Add loan categories
    if (from < 4) {
      await _migrateToV4(m);
    }

    // Version 4 -> 5: Add Savings table
    if (from < 5) {
      await _migrateToV5(m);
    }

    // Version 5 -> 6: Add SavingsTransactions table
    if (from < 6) {
      await _migrateToV6(m);
    }

    // Version 6 -> 7: Add linkedTransactionId to SavingsTransactions and Savings category
    if (from < 7) {
      await _migrateToV7(m);
    }

    // Version 7 -> 8: Update Savings category color to yellow
    if (from < 8) {
      await _migrateToV8(m);
    }

    // Version 8 -> 9: Add notification fields to recurring transactions
    if (from < 9) {
      await _migrateToV9(m);
    }

    // Version 9 -> 10: Add AI chat history tables
    if (from < 10) {
      await _migrateToV10(m);
    }

    // Add more migrations as needed
    // Always use incremental checks (from < X) to support skipping versions
    // For example, upgrading from v1 to v3 should run both v2 and v3 migrations
  }

  /// Migration to version 2: Seed initial data
  Future<void> _migrateToV2(Migrator m) async {
    debugPrint('Migrating to version 2: Seeding initial data');

    // Seed initial data for existing databases
    await _seedInitialData();
  }

  /// Migration to version 3: Add recurring transactions seed data
  Future<void> _migrateToV3(Migrator m) async {
    debugPrint(
      'Migrating to version 3: Adding recurring transactions seed data',
    );

    // Seed recurring transactions for existing databases
    await _seedDefaultRecurringTransactions();
  }

  /// Migration to version 4: Add loan categories
  Future<void> _migrateToV4(Migrator m) async {
    debugPrint('Migrating to version 4: Adding loan categories');

    // Seed loan categories for existing databases
    await _seedLoanCategories();
  }

  /// Migration to version 5: Add Savings table
  Future<void> _migrateToV5(Migrator m) async {
    debugPrint('Migrating to version 5: Adding Savings table');

    // Create the Savings table
    await m.createTable(savings);

    debugPrint('Savings table created successfully');
  }

  /// Migration to version 6: Add SavingsTransactions table
  Future<void> _migrateToV6(Migrator m) async {
    debugPrint('Migrating to version 6: Adding SavingsTransactions table');

    // Create the SavingsTransactions table
    await m.createTable(savingsTransactions);

    debugPrint('SavingsTransactions table created successfully');
  }

  /// Migration to version 7: Add linkedTransactionId and Savings category
  Future<void> _migrateToV7(Migrator m) async {
    debugPrint(
      'Migrating to version 7: Adding linkedTransactionId field and Savings category',
    );

    // Add linkedTransactionId column to SavingsTransactions table
    await m.addColumn(
      savingsTransactions,
      savingsTransactions.linkedTransactionId,
    );

    // Seed Savings expense category
    await _seedSavingsCategory();

    debugPrint('Migration to v7 completed successfully');
  }

  /// Migration to version 8: Update Savings category color to yellow
  Future<void> _migrateToV8(Migrator m) async {
    debugPrint(
      'Migrating to version 8: Updating Savings category color to yellow',
    );

    // Update the Savings category color to yellow
    await _updateSavingsCategoryColor();

    debugPrint('Migration to v8 completed successfully');
  }

  /// Migration to version 9: Add notification fields to recurring transactions
  Future<void> _migrateToV9(Migrator m) async {
    debugPrint(
      'Migrating to version 9: Adding notification fields to recurring transactions',
    );

    // Add enableNotifications column with default value false
    await customStatement(
      'ALTER TABLE recurring_transactions ADD COLUMN enable_notifications INTEGER NOT NULL DEFAULT 0',
    );

    // Add notificationMinutesBefore column with default value 0
    await customStatement(
      'ALTER TABLE recurring_transactions ADD COLUMN notification_minutes_before INTEGER NOT NULL DEFAULT 0',
    );

    debugPrint('Migration to v9 completed successfully');
  }

  /// Migration to version 10: AI chat history (kept on the device)
  Future<void> _migrateToV10(Migrator m) async {
    debugPrint('Migrating to version 10: Adding AI chat tables');
    await m.createTable(aiConversations);
    await m.createTable(aiMessages);
  }

  /// Seed initial data for new database
  Future<void> _seedInitialData() async {
    debugPrint('Seeding initial data');

    // Seed default user
    await _seedDefaultUser();

    // Seed default categories
    await _seedDefaultCategories();

    // Seed Savings category (savings deposits look it up by name)
    await _seedSavingsCategory();

    // Seed default accounts
    await _seedDefaultAccounts();

    // Seed default recurring transactions
    await _seedDefaultRecurringTransactions();

    debugPrint('Initial data seeded successfully');
  }

  /// Seed default user for testing
  Future<void> _seedDefaultUser() async {
    try {
      await usersDao.createUser(
        UsersCompanion.insert(
          uid: 'demo-user-001',
          email: 'demo@finnest.com',
          displayName: const Value('Demo User'),
        ),
      );
      debugPrint('Default user created');
    } catch (e) {
      debugPrint('User already exists or error: $e');
    }
  }

  /// Seed default expense categories
  Future<void> _seedDefaultCategories() async {
    final defaultCategories = [
      // Expense Categories
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Food & Dining',
        type: CategoryType.expense,
        color: const Value('#FF6B6B'),
        icon: const Value('restaurant'),
        displayOrder: const Value(1),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Transportation',
        type: CategoryType.expense,
        color: const Value('#4ECDC4'),
        icon: const Value('directions_car'),
        displayOrder: const Value(2),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Shopping',
        type: CategoryType.expense,
        color: const Value('#95E1D3'),
        icon: const Value('shopping_bag'),
        displayOrder: const Value(3),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Entertainment',
        type: CategoryType.expense,
        color: const Value('#F38181'),
        icon: const Value('movie'),
        displayOrder: const Value(4),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Bills & Utilities',
        type: CategoryType.expense,
        color: const Value('#AA96DA'),
        icon: const Value('receipt'),
        displayOrder: const Value(5),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Healthcare',
        type: CategoryType.expense,
        color: const Value('#FCBAD3'),
        icon: const Value('local_hospital'),
        displayOrder: const Value(6),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Education',
        type: CategoryType.expense,
        color: const Value('#FFFFD2'),
        icon: const Value('school'),
        displayOrder: const Value(7),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Personal Care',
        type: CategoryType.expense,
        color: const Value('#A8D8EA'),
        icon: const Value('spa'),
        displayOrder: const Value(8),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Home Loan',
        type: CategoryType.expense,
        color: const Value('#FFB6B9'),
        icon: const Value('home'),
        displayOrder: const Value(9),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Car Loan',
        type: CategoryType.expense,
        color: const Value('#FEC8D8'),
        icon: const Value('directions_car'),
        displayOrder: const Value(10),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Personal Loan',
        type: CategoryType.expense,
        color: const Value('#FFDFD3'),
        icon: const Value('account_balance'),
        displayOrder: const Value(11),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Education Loan',
        type: CategoryType.expense,
        color: const Value('#F9E2AF'),
        icon: const Value('school'),
        displayOrder: const Value(12),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Credit Card Payment',
        type: CategoryType.expense,
        color: const Value('#E4C1F9'),
        icon: const Value('credit_card'),
        displayOrder: const Value(13),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Other Loans',
        type: CategoryType.expense,
        color: const Value('#D4A5A5'),
        icon: const Value('payments'),
        displayOrder: const Value(14),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Other',
        type: CategoryType.expense,
        color: const Value('#C7CEEA'),
        icon: const Value('category'),
        displayOrder: const Value(99),
      ),

      // Income Categories
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Salary',
        type: CategoryType.income,
        color: const Value('#90EE90'),
        icon: const Value('work'),
        displayOrder: const Value(1),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Business',
        type: CategoryType.income,
        color: const Value('#98D8C8'),
        icon: const Value('business'),
        displayOrder: const Value(2),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Investments',
        type: CategoryType.income,
        color: const Value('#6BCF7F'),
        icon: const Value('trending_up'),
        displayOrder: const Value(3),
      ),
    ];

    for (final category in defaultCategories) {
      try {
        await categoriesDao.createCategory(category);
      } catch (e) {
        debugPrint('Category already exists or error: $e');
      }
    }
    debugPrint('Default categories created');
  }

  /// Seed loan categories (for migration to v4)
  Future<void> _seedLoanCategories() async {
    final loanCategories = [
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Home Loan',
        type: CategoryType.expense,
        color: const Value('#FFB6B9'),
        icon: const Value('home'),
        displayOrder: const Value(9),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Car Loan',
        type: CategoryType.expense,
        color: const Value('#FEC8D8'),
        icon: const Value('directions_car'),
        displayOrder: const Value(10),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Personal Loan',
        type: CategoryType.expense,
        color: const Value('#FFDFD3'),
        icon: const Value('account_balance'),
        displayOrder: const Value(11),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Education Loan',
        type: CategoryType.expense,
        color: const Value('#F9E2AF'),
        icon: const Value('school'),
        displayOrder: const Value(12),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Credit Card Payment',
        type: CategoryType.expense,
        color: const Value('#E4C1F9'),
        icon: const Value('credit_card'),
        displayOrder: const Value(13),
      ),
      CategoriesCompanion.insert(
        userId: 1,
        name: 'Other Loans',
        type: CategoryType.expense,
        color: const Value('#D4A5A5'),
        icon: const Value('payments'),
        displayOrder: const Value(14),
      ),
    ];

    for (final category in loanCategories) {
      try {
        await categoriesDao.createCategory(category);
      } catch (e) {
        debugPrint('Loan category already exists or error: $e');
      }
    }
    debugPrint('Loan categories created');
  }

  /// Seed Savings category (fresh installs and migration to v7).
  ///
  /// Skips if it already exists: a v1 database upgrading runs both the
  /// initial seed (v2) and the v7 migration, and categories have no unique
  /// constraint to prevent duplicates.
  Future<void> _seedSavingsCategory() async {
    try {
      final existing = await categoriesDao.getCategoriesByType(
        1,
        CategoryType.expense,
      );
      if (existing.any((c) => c.name == 'Savings')) {
        debugPrint('Savings category already exists');
        return;
      }

      await categoriesDao.createCategory(
        CategoriesCompanion.insert(
          userId: 1,
          name: 'Savings',
          type: CategoryType.expense,
          color: const Value('#FFC107'),
          icon: const Value('savings'),
          displayOrder: const Value(8),
        ),
      );
      debugPrint('Savings category created');
    } catch (e) {
      debugPrint('Savings category already exists or error: $e');
    }
  }

  /// Update Savings category color to yellow (for migration to v8)
  Future<void> _updateSavingsCategoryColor() async {
    try {
      // Find the Savings category
      final categories = await categoriesDao.getCategoriesByUserId(1);
      final savingsCategory = categories.firstWhere(
        (c) => c.name == 'Savings' && c.type == CategoryType.expense,
        orElse: () => throw Exception('Savings category not found'),
      );

      // Update the color to yellow
      final updatedCategory = savingsCategory.copyWith(
        color: const Value('#FFC107'),
      );
      await categoriesDao.updateCategory(updatedCategory);

      debugPrint('Savings category color updated to yellow');
    } catch (e) {
      debugPrint('Error updating Savings category color: $e');
    }
  }

  /// Seed default accounts
  Future<void> _seedDefaultAccounts() async {
    final defaultAccounts = [
      AccountsCompanion.insert(
        userId: 1,
        name: 'Cash',
        type: AccountType.cash,
        balanceInCents: const Value(0),
        currency: const Value('USD'),
        color: const Value('#4CAF50'),
        icon: const Value('money'),
        isDefault: const Value(true),
        displayOrder: const Value(1),
      ),
      AccountsCompanion.insert(
        userId: 1,
        name: 'Bank Account',
        type: AccountType.bank,
        balanceInCents: const Value(0),
        currency: const Value('USD'),
        color: const Value('#2196F3'),
        icon: const Value('account_balance'),
        displayOrder: const Value(2),
      ),
      AccountsCompanion.insert(
        userId: 1,
        name: 'Credit Card',
        type: AccountType.creditCard,
        balanceInCents: const Value(0),
        currency: const Value('USD'),
        color: const Value('#FF9800'),
        icon: const Value('credit_card'),
        displayOrder: const Value(3),
      ),
    ];

    for (final account in defaultAccounts) {
      try {
        await accountsDao.createAccount(account);
      } catch (e) {
        debugPrint('Account already exists or error: $e');
      }
    }
    debugPrint('Default accounts created');
  }

  /// Seed default recurring transactions
  Future<void> _seedDefaultRecurringTransactions() async {
    // Calculate next occurrence dates
    final now = DateTime.now();

    // Monthly rent - due on 1st of next month
    final rentDate = DateTime(
      now.month == 12 ? now.year + 1 : now.year,
      now.month == 12 ? 1 : now.month + 1,
      1,
    );

    // Monthly salary - due on 25th of current/next month
    final salaryDate = now.day < 25
        ? DateTime(now.year, now.month, 25)
        : DateTime(
            now.month == 12 ? now.year + 1 : now.year,
            now.month == 12 ? 1 : now.month + 1,
            25,
          );

    // Netflix - due on 15th of current/next month
    final netflixDate = now.day < 15
        ? DateTime(now.year, now.month, 15)
        : DateTime(
            now.month == 12 ? now.year + 1 : now.year,
            now.month == 12 ? 1 : now.month + 1,
            15,
          );

    // Electricity - due on 5th of next month
    final electricityDate = DateTime(
      now.month == 12 ? now.year + 1 : now.year,
      now.month == 12 ? 1 : now.month + 1,
      5,
    );

    // Quarterly insurance - due in 3 months
    final insuranceDate = DateTime(
      now.month + 3 > 12 ? now.year + 1 : now.year,
      now.month + 3 > 12 ? now.month + 3 - 12 : now.month + 3,
      1,
    );

    final defaultRecurringTransactions = [
      // Monthly Rent (Expense)
      RecurringTransactionsCompanion.insert(
        userId: 1,
        accountId: 2, // Bank Account
        categoryId: const Value(1), // Housing category
        type: 0, // Expense
        amountInCents: 150000, // $1,500.00
        description: 'Monthly Rent',
        frequency: RecurrenceFrequency.monthly,
        nextOccurrence: rentDate,
        startDate: DateTime(now.year, now.month, 1),
        payee: const Value('Landlord'),
        notes: const Value('Monthly apartment rent payment'),
        autoCreate: const Value(true),
        daysBeforeToCreate: const Value(3),
        isActive: const Value(true),
      ),

      // Monthly Salary (Income)
      RecurringTransactionsCompanion.insert(
        userId: 1,
        accountId: 2, // Bank Account
        categoryId: const Value(10), // Salary category
        type: 1, // Income
        amountInCents: 500000, // $5,000.00
        description: 'Monthly Salary',
        frequency: RecurrenceFrequency.monthly,
        nextOccurrence: salaryDate,
        startDate: DateTime(now.year, now.month, 1),
        payee: const Value('Employer Inc.'),
        notes: const Value('Monthly salary deposit'),
        autoCreate: const Value(true),
        daysBeforeToCreate: const Value(0),
        isActive: const Value(true),
      ),

      // Netflix Subscription (Expense)
      RecurringTransactionsCompanion.insert(
        userId: 1,
        accountId: 3, // Credit Card
        categoryId: const Value(7), // Entertainment category
        type: 0, // Expense
        amountInCents: 1599, // $15.99
        description: 'Netflix Subscription',
        frequency: RecurrenceFrequency.monthly,
        nextOccurrence: netflixDate,
        startDate: DateTime(now.year, now.month, 1),
        payee: const Value('Netflix'),
        notes: const Value('Premium plan subscription'),
        autoCreate: const Value(true),
        daysBeforeToCreate: const Value(1),
        isActive: const Value(true),
      ),

      // Electricity Bill (Expense)
      RecurringTransactionsCompanion.insert(
        userId: 1,
        accountId: 2, // Bank Account
        categoryId: const Value(3), // Utilities category
        type: 0, // Expense
        amountInCents: 12000, // $120.00
        description: 'Electricity Bill',
        frequency: RecurrenceFrequency.monthly,
        nextOccurrence: electricityDate,
        startDate: DateTime(now.year, now.month, 1),
        payee: const Value('Power Company'),
        notes: const Value('Monthly electricity bill'),
        autoCreate: const Value(true),
        daysBeforeToCreate: const Value(2),
        isActive: const Value(true),
      ),

      // Car Insurance (Expense - Quarterly)
      RecurringTransactionsCompanion.insert(
        userId: 1,
        accountId: 2, // Bank Account
        categoryId: const Value(6), // Transportation category
        type: 0, // Expense
        amountInCents: 30000, // $300.00
        description: 'Car Insurance',
        frequency: RecurrenceFrequency.quarterly,
        nextOccurrence: insuranceDate,
        startDate: DateTime(now.year, now.month, 1),
        payee: const Value('Insurance Co.'),
        notes: const Value('Quarterly car insurance premium'),
        autoCreate: const Value(true),
        daysBeforeToCreate: const Value(7),
        isActive: const Value(true),
      ),
    ];

    for (final recurring in defaultRecurringTransactions) {
      try {
        await recurringTransactionsDao.createRecurringTransaction(recurring);
      } catch (e) {
        debugPrint('Recurring transaction already exists or error: $e');
      }
    }
    debugPrint('Default recurring transactions created');
  }

  /// Close the database
  Future<void> closeDb() async {
    await close();
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finnest.db'));
    return NativeDatabase(file);
  });
}
