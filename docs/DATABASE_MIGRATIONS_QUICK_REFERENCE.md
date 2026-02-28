# Database Migrations - Quick Reference

## 🚀 Quick Start

### Create a Migration in 5 Steps

1. **Modify schema** - Update table definition
2. **Increment version** - Change `schemaVersion` in `app_database.dart`
3. **Generate code** - Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. **Write migration** - Add logic to `_runMigrations` method
5. **Test** - Write and run migration tests

---

## 📝 Common Operations

### Add a Column

```dart
// 1. Add to table definition
TextColumn get theme => text().withDefault(const Constant('light'))();

// 2. Increment schemaVersion to 2

// 3. Add migration
if (from < 2) {
  await m.addColumn(users, users.theme);
}
```

### Create a Table

```dart
// 1. Create table definition
@DataClassName('NotificationEntity')
class Notifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  // ... more columns
}

// 2. Add to @DriftDatabase annotation
@DriftDatabase(
  tables: [Users, Accounts, Notifications], // Add here
  daos: [UsersDao, AccountsDao],
)

// 3. Increment schemaVersion to 3

// 4. Add migration
if (from < 3) {
  await m.createTable(notifications);
}
```

### Add an Index

```dart
if (from < 4) {
  await MigrationHelpers.createIndex(
    m,
    'idx_users_email',
    'users',
    ['email'],
    unique: true,
  );
}
```

### Seed Default Data

```dart
if (from < 5) {
  await MigrationHelpers.seedData(
    m,
    'categories',
    ['name', 'type', 'is_system'],
    [
      ['Food', 0, 1],
      ['Transport', 0, 1],
    ],
  );
}
```

### Migrate Data

```dart
if (from < 6) {
  // Add new column
  await m.addColumn(users, users.firstName);
  
  // Copy data with transformation
  await MigrationHelpers.migrateData(
    m,
    'users',
    'display_name',
    'first_name',
    transformSql: "SUBSTR(display_name, 1, INSTR(display_name, ' ') - 1)",
  );
}
```

---

## 🧪 Testing Template

```dart
test('Migration from v1 to v2 works', () async {
  // Create v1 database
  final dbV1 = AppDatabase.test(NativeDatabase.memory());
  
  // Insert test data
  await dbV1.into(dbV1.users).insert(
    UsersCompanion.insert(
      uid: 'test123',
      email: 'test@example.com',
    ),
  );
  
  final before = await dbV1.select(dbV1.users).get();
  await dbV1.close();
  
  // Reopen as v2 (triggers migration)
  final dbV2 = AppDatabase.test(NativeDatabase.memory());
  
  // Verify data preserved
  final after = await dbV2.select(dbV2.users).get();
  expect(after.length, before.length);
  expect(after.first.uid, before.first.uid);
  
  // Verify new column
  expect(after.first.newColumn, 'expected_value');
  
  await dbV2.close();
});
```

---

## 🔧 Migration Helpers

| Helper | Use Case |
|--------|----------|
| `addColumnWithDefault` | Add column with default value |
| `addNullableColumn` | Add optional column |
| `createIndex` | Create index for performance |
| `dropIndex` | Remove index |
| `renameColumn` | Rename column |
| `migrateData` | Copy/transform data |
| `seedData` | Insert default data |

---

## ✅ Checklist

Before releasing a migration:

- [ ] Schema version incremented
- [ ] Code generation run
- [ ] Migration logic added
- [ ] Migration tested
- [ ] Data preservation verified
- [ ] Default values set
- [ ] Documentation updated

---

## 🐛 Common Issues

### Migration not running?
- Check schema version was incremented
- Verify condition is `if (from < X)` not `if (from == X)`
- Run code generation

### Data loss?
- Check column names match exactly
- Verify migration preserves data
- Add logging to track steps

### Foreign key error?
- Migrate parent tables first
- Temporarily disable foreign keys if needed

---

## 📚 Full Documentation

See `docs/DATABASE_MIGRATIONS.md` for complete guide with examples and best practices.

---

## 🎯 Example: Complete Migration

```dart
// 1. Add column to users_table.dart
TextColumn get theme => text().withDefault(const Constant('light'))();

// 2. Update app_database.dart
@override
int get schemaVersion => 2; // Changed from 1

// 3. Add migration logic
Future<void> _runMigrations(Migrator m, int from, int to) async {
  if (from < 2) {
    await _migrateToV2(m);
  }
}

Future<void> _migrateToV2(Migrator m) async {
  debugPrint('Migrating to version 2: Adding theme column');
  await m.addColumn(users, users.theme);
}

// 4. Run code generation
// flutter pub run build_runner build --delete-conflicting-outputs

// 5. Test
test('v1 to v2 migration adds theme', () async {
  final db = AppDatabase.test(NativeDatabase.memory());
  final users = await db.select(db.users).get();
  // Verify theme column exists
  await db.close();
});
```

---

**Quick Tip:** Always use `if (from < X)` instead of `if (from == X)` to support version skipping!

