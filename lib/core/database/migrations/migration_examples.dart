import 'package:drift/drift.dart';
import 'migration_helpers.dart';

/// Example migrations for common scenarios
/// 
/// These are examples to demonstrate how to write migrations.
/// DO NOT use these directly - they are for reference only.
class MigrationExamples {
  /// Example 1: Adding a new column to an existing table
  /// 
  /// Scenario: Add a 'theme' column to the users table
  /// 
  /// Steps:
  /// 1. Add the column to the table definition in users_table.dart
  /// 2. Increment schemaVersion in app_database.dart
  /// 3. Add migration logic in onUpgrade
  /// 
  /// ```dart
  /// if (from < 2) {
  ///   await exampleAddColumn(m);
  /// }
  /// ```
  static Future<void> exampleAddColumn(Migrator m) async {
    // Add a new column with a default value
    // Note: In real code, you'd reference the actual table and column
    await m.database.customStatement(
      'ALTER TABLE users ADD COLUMN theme TEXT DEFAULT "light"',
    );
  }

  /// Example 2: Creating a new table
  /// 
  /// Scenario: Add a new 'notifications' table
  /// 
  /// Steps:
  /// 1. Create the table definition in tables/notifications_table.dart
  /// 2. Add the table to @DriftDatabase annotation in app_database.dart
  /// 3. Increment schemaVersion
  /// 4. Add migration logic in onUpgrade
  /// 
  /// ```dart
  /// if (from < 3) {
  ///   await exampleCreateTable(m);
  /// }
  /// ```
  static Future<void> exampleCreateTable(Migrator m) async {
    // Create a new table
    // Note: In real code, you'd use m.createTable(notifications)
    await m.database.customStatement('''
      CREATE TABLE IF NOT EXISTS notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Example 3: Adding an index for better query performance
  /// 
  /// Scenario: Add index on transactions.transaction_date for faster date queries
  /// 
  /// ```dart
  /// if (from < 4) {
  ///   await exampleAddIndex(m);
  /// }
  /// ```
  static Future<void> exampleAddIndex(Migrator m) async {
    await MigrationHelpers.createIndex(
      m,
      'idx_transactions_date',
      'transactions',
      ['transaction_date'],
    );
    
    // Add composite index for user_id + transaction_date
    await MigrationHelpers.createIndex(
      m,
      'idx_transactions_user_date',
      'transactions',
      ['user_id', 'transaction_date'],
    );
  }

  /// Example 4: Migrating data between columns
  /// 
  /// Scenario: Split 'name' column into 'first_name' and 'last_name'
  /// 
  /// ```dart
  /// if (from < 5) {
  ///   await exampleMigrateData(m);
  /// }
  /// ```
  static Future<void> exampleMigrateData(Migrator m) async {
    // Add new columns
    await m.database.customStatement(
      'ALTER TABLE users ADD COLUMN first_name TEXT',
    );
    await m.database.customStatement(
      'ALTER TABLE users ADD COLUMN last_name TEXT',
    );
    
    // Migrate data (simplified - in real code you'd handle edge cases)
    await m.database.customStatement('''
      UPDATE users 
      SET first_name = SUBSTR(display_name, 1, INSTR(display_name, ' ') - 1),
          last_name = SUBSTR(display_name, INSTR(display_name, ' ') + 1)
      WHERE display_name IS NOT NULL AND INSTR(display_name, ' ') > 0
    ''');
  }

  /// Example 5: Seeding default data
  /// 
  /// Scenario: Add default categories when upgrading to version 6
  /// 
  /// ```dart
  /// if (from < 6) {
  ///   await exampleSeedData(m);
  /// }
  /// ```
  static Future<void> exampleSeedData(Migrator m) async {
    // Seed default expense categories
    await MigrationHelpers.seedData(
      m,
      'categories',
      ['name', 'type', 'is_system', 'color', 'icon'],
      [
        ['Food & Dining', 0, 1, '#FF6B6B', 'restaurant'],
        ['Transportation', 0, 1, '#4ECDC4', 'directions_car'],
        ['Shopping', 0, 1, '#45B7D1', 'shopping_cart'],
        ['Entertainment', 0, 1, '#FFA07A', 'movie'],
        ['Bills & Utilities', 0, 1, '#98D8C8', 'receipt'],
        ['Healthcare', 0, 1, '#F7DC6F', 'local_hospital'],
        ['Education', 0, 1, '#BB8FCE', 'school'],
        ['Other', 0, 1, '#95A5A6', 'more_horiz'],
      ],
    );
    
    // Seed default income categories
    await MigrationHelpers.seedData(
      m,
      'categories',
      ['name', 'type', 'is_system', 'color', 'icon'],
      [
        ['Salary', 1, 1, '#2ECC71', 'attach_money'],
        ['Business', 1, 1, '#3498DB', 'business'],
        ['Investments', 1, 1, '#9B59B6', 'trending_up'],
        ['Gifts', 1, 1, '#E74C3C', 'card_giftcard'],
        ['Other Income', 1, 1, '#95A5A6', 'more_horiz'],
      ],
    );
  }

  /// Example 6: Changing column type (requires table recreation)
  /// 
  /// Scenario: Change balance from INTEGER to REAL (not recommended, but for example)
  /// 
  /// ```dart
  /// if (from < 7) {
  ///   await exampleChangeColumnType(m);
  /// }
  /// ```
  static Future<void> exampleChangeColumnType(Migrator m) async {
    // SQLite doesn't support ALTER COLUMN, so we need to:
    // 1. Create a new table with the new schema
    // 2. Copy data from old table
    // 3. Drop old table
    // 4. Rename new table
    
    // Create temporary table with new schema
    await m.database.customStatement('''
      CREATE TABLE accounts_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        balance_in_cents REAL DEFAULT 0,
        -- ... other columns
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
    
    // Copy data
    await m.database.customStatement('''
      INSERT INTO accounts_new 
      SELECT * FROM accounts
    ''');
    
    // Drop old table
    await m.database.customStatement('DROP TABLE accounts');
    
    // Rename new table
    await m.database.customStatement(
      'ALTER TABLE accounts_new RENAME TO accounts',
    );
  }
}

