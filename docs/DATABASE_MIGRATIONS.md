# Database Migrations Guide

## Overview

This guide explains how to create and manage database migrations in FinNest using Drift. Migrations allow you to evolve your database schema over time while preserving existing data.

## Migration Strategy

FinNest uses a **step-by-step migration strategy** where each schema version has its own migration logic. This allows users to upgrade from any version to the latest version, even if they skip intermediate versions.

### Key Principles

1. **Incremental Versioning** - Schema version increments by 1 for each change
2. **Backward Compatibility** - Migrations support skipping versions (e.g., v1 → v3)
3. **Data Preservation** - All migrations must preserve existing data
4. **Idempotent Operations** - Migrations should be safe to run multiple times
5. **Testing Required** - All migrations must have tests

---

## How to Create a Migration

### Step 1: Modify the Schema

Make your changes to the table definition:

```dart
// lib/core/database/tables/users_table.dart

@DataClassName('UserEntity')
class Users extends Table {
  // ... existing columns ...
  
  // NEW: Add a theme preference column
  TextColumn get theme => text().withDefault(const Constant('light'))();
}
```

### Step 2: Increment Schema Version

Update the schema version in `app_database.dart`:

```dart
@override
int get schemaVersion => 2; // Changed from 1 to 2
```

### Step 3: Run Code Generation

Generate the updated database code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 4: Write Migration Logic

Add migration logic in the `_runMigrations` method:

```dart
Future<void> _runMigrations(Migrator m, int from, int to) async {
  debugPrint('Running migrations from version $from to $to');

  // Version 1 -> 2: Add theme column
  if (from < 2) {
    await _migrateToV2(m);
  }
}

Future<void> _migrateToV2(Migrator m) async {
  debugPrint('Migrating to version 2: Adding theme column');
  
  await m.addColumn(users, users.theme);
}
```

### Step 5: Test the Migration

Write tests to verify the migration works:

```dart
test('Migration from v1 to v2 adds theme column', () async {
  // Create v1 database with test data
  final dbV1 = AppDatabase.test(NativeDatabase.memory());
  
  await dbV1.into(dbV1.users).insert(
    UsersCompanion.insert(
      uid: 'test123',
      email: 'test@example.com',
    ),
  );
  
  await dbV1.close();
  
  // Reopen as v2 (triggers migration)
  final dbV2 = AppDatabase.test(NativeDatabase.memory());
  
  final users = await dbV2.select(dbV2.users).get();
  expect(users.first.theme, 'light'); // Default value
  
  await dbV2.close();
});
```

---

## Common Migration Scenarios

### 1. Adding a Column

**Scenario:** Add a new column to an existing table

```dart
// Step 1: Add column to table definition
TextColumn get newColumn => text().withDefault(const Constant('default'))();

// Step 2: Write migration
Future<void> _migrateToV2(Migrator m) async {
  await m.addColumn(users, users.newColumn);
}
```

### 2. Creating a New Table

**Scenario:** Add a completely new table

```dart
// Step 1: Create table definition
@DataClassName('NotificationEntity')
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Step 2: Add to @DriftDatabase annotation
@DriftDatabase(
  tables: [
    // ... existing tables ...
    Notifications, // NEW
  ],
  daos: [UsersDao, AccountsDao, TransactionsDao],
)

// Step 3: Write migration
Future<void> _migrateToV3(Migrator m) async {
  await m.createTable(notifications);
}
```

### 3. Adding an Index

**Scenario:** Add an index for better query performance

```dart
Future<void> _migrateToV4(Migrator m) async {
  await MigrationHelpers.createIndex(
    m,
    'idx_transactions_date',
    'transactions',
    ['transaction_date'],
  );
  
  // Composite index
  await MigrationHelpers.createIndex(
    m,
    'idx_transactions_user_date',
    'transactions',
    ['user_id', 'transaction_date'],
  );
}
```

### 4. Migrating Data Between Columns

**Scenario:** Split a column into multiple columns

```dart
Future<void> _migrateToV5(Migrator m) async {
  // Add new columns
  await m.addColumn(users, users.firstName);
  await m.addColumn(users, users.lastName);
  
  // Migrate data from displayName to firstName/lastName
  await MigrationHelpers.migrateData(
    m,
    'users',
    'display_name',
    'first_name',
    transformSql: "SUBSTR(display_name, 1, INSTR(display_name, ' ') - 1)",
  );
  
  await MigrationHelpers.migrateData(
    m,
    'users',
    'display_name',
    'last_name',
    transformSql: "SUBSTR(display_name, INSTR(display_name, ' ') + 1)",
  );
}
```

### 5. Seeding Default Data

**Scenario:** Add default categories during migration

```dart
Future<void> _migrateToV6(Migrator m) async {
  await MigrationHelpers.seedData(
    m,
    'categories',
    ['name', 'type', 'is_system', 'color', 'icon'],
    [
      ['Food & Dining', 0, 1, '#FF6B6B', 'restaurant'],
      ['Transportation', 0, 1, '#4ECDC4', 'directions_car'],
      ['Shopping', 0, 1, '#45B7D1', 'shopping_cart'],
    ],
  );
}
```

---

## Migration Helper Utilities

The `MigrationHelpers` class provides common migration operations:

| Method | Purpose | Example |
|--------|---------|---------|
| `addColumnWithDefault` | Add column with default value | Add theme column |
| `addNullableColumn` | Add nullable column | Add optional phone number |
| `createIndex` | Create index for performance | Index on email |
| `dropIndex` | Remove an index | Remove old index |
| `renameColumn` | Rename a column | Rename displayName to name |
| `migrateData` | Copy/transform data | Split name into first/last |
| `seedData` | Insert default data | Add default categories |

See `lib/core/database/migrations/migration_helpers.dart` for full documentation.

---

## Testing Migrations

### Test Structure

```dart
test('Migration from vX to vY preserves data', () async {
  // 1. Create database with old version
  final dbOld = AppDatabase.test(NativeDatabase.memory());
  
  // 2. Insert test data
  await dbOld.into(dbOld.users).insert(...);
  
  // 3. Verify old data
  final dataBefore = await dbOld.select(dbOld.users).get();
  expect(dataBefore.length, 1);
  
  await dbOld.close();
  
  // 4. Reopen with new version (triggers migration)
  final dbNew = AppDatabase.test(NativeDatabase.memory());
  
  // 5. Verify data is preserved
  final dataAfter = await dbNew.select(dbNew.users).get();
  expect(dataAfter.length, 1);
  expect(dataAfter.first.uid, dataBefore.first.uid);
  
  // 6. Verify new schema changes
  expect(dataAfter.first.newColumn, 'expected_value');
  
  await dbNew.close();
});
```

### Running Tests

```bash
flutter test test/core/database/migration_test.dart
```

---

## Best Practices

### ✅ DO

- **Always increment schema version** when changing the schema
- **Test migrations** with real data scenarios
- **Use helper utilities** for common operations
- **Add comments** explaining what each migration does
- **Preserve data** - never delete user data without explicit consent
- **Use default values** when adding non-nullable columns
- **Create indexes** for frequently queried columns
- **Log migration progress** using debugPrint

### ❌ DON'T

- **Don't skip version numbers** - always increment by 1
- **Don't modify old migrations** - they may have already run on user devices
- **Don't delete columns** without a data migration plan
- **Don't assume data format** - always validate before transforming
- **Don't forget to run code generation** after schema changes
- **Don't use raw SQL** unless necessary - use Drift's migration API

---

## Troubleshooting

### Migration Not Running

**Problem:** Migration code isn't executing

**Solution:**
1. Verify schema version was incremented
2. Check that migration is in `_runMigrations` method
3. Ensure condition is `if (from < X)` not `if (from == X)`
4. Run code generation: `flutter pub run build_runner build`

### Data Loss After Migration

**Problem:** User data disappeared after migration

**Solution:**
1. Check migration logic for data preservation
2. Verify column names match exactly
3. Test migration with sample data
4. Add logging to track migration steps

### Foreign Key Constraint Failed

**Problem:** Migration fails with foreign key error

**Solution:**
1. Temporarily disable foreign keys during migration
2. Migrate data in correct order (parent tables first)
3. Verify foreign key references are valid

```dart
Future<void> _migrateToVX(Migrator m) async {
  // Disable foreign keys temporarily
  await m.database.customStatement('PRAGMA foreign_keys = OFF');
  
  // Perform migration
  // ...
  
  // Re-enable foreign keys
  await m.database.customStatement('PRAGMA foreign_keys = ON');
}
```

---

## Migration Checklist

Before releasing a migration to production:

- [ ] Schema version incremented
- [ ] Code generation completed successfully
- [ ] Migration logic added to `_runMigrations`
- [ ] Migration tested with sample data
- [ ] Migration tested for version skipping (e.g., v1 → v3)
- [ ] Data preservation verified
- [ ] Default values set for new columns
- [ ] Indexes created for new columns (if needed)
- [ ] Documentation updated
- [ ] Migration logged with debugPrint

---

## Related Files

- **Migration Helpers**: `lib/core/database/migrations/migration_helpers.dart`
- **Migration Examples**: `lib/core/database/migrations/migration_examples.dart`
- **Migration Tests**: `test/core/database/migration_test.dart`
- **Main Database**: `lib/core/database/app_database.dart`

---

**Status**: ✅ Migration system ready to use

