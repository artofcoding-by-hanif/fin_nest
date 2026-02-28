import 'package:drift/drift.dart';

/// Helper utilities for database migrations
class MigrationHelpers {
  /// Add a column to a table with a default value
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.addColumnWithDefault(
  ///   m,
  ///   users,
  ///   users.newColumn,
  ///   'default_value',
  /// );
  /// ```
  static Future<void> addColumnWithDefault(
    Migrator m,
    TableInfo table,
    GeneratedColumn<Object> column,
    Object defaultValue,
  ) async {
    await m.addColumn(table, column);

    // Update existing rows with default value
    final updateStatement =
        'UPDATE ${table.actualTableName} '
        'SET ${column.$name} = ?';
    await m.database.customStatement(updateStatement, [defaultValue]);
  }

  /// Add a nullable column to a table
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.addNullableColumn(m, users, users.newColumn);
  /// ```
  static Future<void> addNullableColumn(
    Migrator m,
    TableInfo table,
    GeneratedColumn<Object> column,
  ) async {
    await m.addColumn(table, column);
  }

  /// Create an index on a table column
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.createIndex(
  ///   m,
  ///   'idx_users_email',
  ///   'users',
  ///   ['email'],
  /// );
  /// ```
  static Future<void> createIndex(
    Migrator m,
    String indexName,
    String tableName,
    List<String> columns, {
    bool unique = false,
  }) async {
    final uniqueKeyword = unique ? 'UNIQUE ' : '';
    final columnList = columns.join(', ');
    final statement =
        'CREATE ${uniqueKeyword}INDEX IF NOT EXISTS $indexName '
        'ON $tableName ($columnList)';
    await m.database.customStatement(statement);
  }

  /// Drop an index
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.dropIndex(m, 'idx_users_email');
  /// ```
  static Future<void> dropIndex(Migrator m, String indexName) async {
    final statement = 'DROP INDEX IF EXISTS $indexName';
    await m.database.customStatement(statement);
  }

  /// Rename a column (SQLite doesn't support this directly, so we need to recreate the table)
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.renameColumn(
  ///   m,
  ///   'users',
  ///   'old_name',
  ///   'new_name',
  ///   'TEXT',
  /// );
  /// ```
  static Future<void> renameColumn(
    Migrator m,
    String tableName,
    String oldColumnName,
    String newColumnName,
    String columnType,
  ) async {
    // This is a simplified version. In production, you'd need to:
    // 1. Create a new table with the new column name
    // 2. Copy data from old table to new table
    // 3. Drop old table
    // 4. Rename new table to old table name

    final statement =
        'ALTER TABLE $tableName '
        'RENAME COLUMN $oldColumnName TO $newColumnName';
    await m.database.customStatement(statement);
  }

  /// Migrate data from one column to another
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.migrateData(
  ///   m,
  ///   'users',
  ///   'old_column',
  ///   'new_column',
  /// );
  /// ```
  static Future<void> migrateData(
    Migrator m,
    String tableName,
    String sourceColumn,
    String targetColumn, {
    String? transformSql,
  }) async {
    final value = transformSql ?? sourceColumn;
    final statement = 'UPDATE $tableName SET $targetColumn = $value';
    await m.database.customStatement(statement);
  }

  /// Add a foreign key constraint (for new tables)
  /// Note: SQLite doesn't support adding foreign keys to existing tables
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.addForeignKey(
  ///   m,
  ///   'transactions',
  ///   'user_id',
  ///   'users',
  ///   'id',
  /// );
  /// ```
  static Future<void> addForeignKey(
    Migrator m,
    String tableName,
    String columnName,
    String referencedTable,
    String referencedColumn, {
    String onDelete = 'CASCADE',
    String onUpdate = 'CASCADE',
  }) async {
    // This is informational - foreign keys must be defined when creating the table
    // This method is here for documentation purposes
    throw UnsupportedError(
      'SQLite does not support adding foreign keys to existing tables. '
      'Foreign keys must be defined when creating the table.',
    );
  }

  /// Seed data into a table
  ///
  /// Example:
  /// ```dart
  /// await MigrationHelpers.seedData(
  ///   m,
  ///   'categories',
  ///   ['name', 'type', 'is_system'],
  ///   [
  ///     ['Food', 'expense', 1],
  ///     ['Salary', 'income', 1],
  ///   ],
  /// );
  /// ```
  static Future<void> seedData(
    Migrator m,
    String tableName,
    List<String> columns,
    List<List<dynamic>> rows,
  ) async {
    for (final row in rows) {
      final placeholders = List.filled(row.length, '?').join(', ');
      final columnList = columns.join(', ');
      final statement =
          'INSERT OR IGNORE INTO $tableName ($columnList) '
          'VALUES ($placeholders)';
      await m.database.customStatement(statement, row);
    }
  }
}
