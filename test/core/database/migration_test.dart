import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_nest/core/database/app_database.dart';

/// Test utilities for database migrations
/// 
/// These tests ensure that migrations work correctly and don't lose data.
void main() {
  group('Database Migrations', () {
    late String testDbPath;

    setUp(() {
      // Create a unique test database file for each test
      testDbPath = 'test_${DateTime.now().millisecondsSinceEpoch}.db';
    });

    tearDown(() async {
      // Clean up test database file
      final file = File(testDbPath);
      if (await file.exists()) {
        await file.delete();
      }
    });

    test('Database creates with correct schema version', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      
      expect(db.schemaVersion, 1);
      
      await db.close();
    });

    test('onCreate creates all tables', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      
      // Verify tables exist by querying them
      final users = await db.select(db.users).get();
      final accounts = await db.select(db.accounts).get();
      final categories = await db.select(db.categories).get();
      final transactions = await db.select(db.transactions).get();
      final budgets = await db.select(db.budgets).get();
      final budgetCategories = await db.select(db.budgetCategories).get();
      final goals = await db.select(db.goals).get();
      final recurringTransactions = await db.select(db.recurringTransactions).get();
      
      expect(users, isEmpty);
      expect(accounts, isEmpty);
      expect(categories, isEmpty);
      expect(transactions, isEmpty);
      expect(budgets, isEmpty);
      expect(budgetCategories, isEmpty);
      expect(goals, isEmpty);
      expect(recurringTransactions, isEmpty);
      
      await db.close();
    });

    test('Foreign keys are enabled', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      
      // Check if foreign keys are enabled
      final result = await db.customSelect('PRAGMA foreign_keys').get();
      expect(result.first.data['foreign_keys'], 1);
      
      await db.close();
    });

    // Example migration test (uncomment when you have migrations)
    // test('Migration from v1 to v2 preserves data', () async {
    //   // Create database with version 1
    //   final dbV1 = AppDatabase.forTesting(
    //     NativeDatabase.memory(),
    //     schemaVersion: 1,
    //   );
    //   
    //   // Insert test data
    //   await dbV1.into(dbV1.users).insert(
    //     UsersCompanion.insert(
    //       uid: 'test123',
    //       email: 'test@example.com',
    //     ),
    //   );
    //   
    //   final usersBefore = await dbV1.select(dbV1.users).get();
    //   expect(usersBefore.length, 1);
    //   
    //   await dbV1.close();
    //   
    //   // Reopen database with version 2 (triggers migration)
    //   final dbV2 = AppDatabase.forTesting(
    //     NativeDatabase.memory(),
    //     schemaVersion: 2,
    //   );
    //   
    //   // Verify data is preserved
    //   final usersAfter = await dbV2.select(dbV2.users).get();
    //   expect(usersAfter.length, 1);
    //   expect(usersAfter.first.uid, 'test123');
    //   expect(usersAfter.first.email, 'test@example.com');
    //   
    //   // Verify new column exists with default value
    //   // expect(usersAfter.first.newColumn, 'default_value');
    //   
    //   await dbV2.close();
    // });

    // Example test for skipping versions
    // test('Migration from v1 to v3 (skipping v2) works correctly', () async {
    //   // Create database with version 1
    //   final dbV1 = AppDatabase.forTesting(
    //     NativeDatabase.memory(),
    //     schemaVersion: 1,
    //   );
    //   
    //   // Insert test data
    //   await dbV1.into(dbV1.users).insert(
    //     UsersCompanion.insert(
    //       uid: 'test123',
    //       email: 'test@example.com',
    //     ),
    //   );
    //   
    //   await dbV1.close();
    //   
    //   // Reopen database with version 3 (should run both v2 and v3 migrations)
    //   final dbV3 = AppDatabase.forTesting(
    //     NativeDatabase.memory(),
    //     schemaVersion: 3,
    //   );
    //   
    //   // Verify all migrations were applied
    //   final users = await dbV3.select(dbV3.users).get();
    //   expect(users.length, 1);
    //   
    //   // Verify v2 migration was applied
    //   // expect(users.first.columnFromV2, isNotNull);
    //   
    //   // Verify v3 migration was applied
    //   // final newTable = await dbV3.select(dbV3.newTable).get();
    //   // expect(newTable, isNotEmpty);
    //   
    //   await dbV3.close();
    // });
  });
}

/// Extension on AppDatabase for testing
extension AppDatabaseTesting on AppDatabase {
  /// Create a test database instance
  static AppDatabase forTesting(
    QueryExecutor executor, {
    int? schemaVersion,
  }) {
    return AppDatabase.test(executor, schemaVersion: schemaVersion);
  }
}

