# Database Setup - Drift

## Overview

FinNest uses **Drift** (formerly Moor) as its local database solution. Drift is a reactive persistence library for Flutter and Dart, built on top of SQLite.

## Architecture

### Database Structure

```
lib/core/database/
├── app_database.dart          # Main database class
├── tables/                    # Table definitions
│   ├── users_table.dart
│   ├── accounts_table.dart
│   ├── categories_table.dart
│   ├── transactions_table.dart
│   ├── budgets_table.dart
│   ├── budget_categories_table.dart
│   ├── goals_table.dart
│   └── recurring_transactions_table.dart
└── daos/                      # Data Access Objects
    ├── users_dao.dart
    ├── accounts_dao.dart
    └── transactions_dao.dart
```

## Tables

### 1. Users Table
Stores user profile information.

**Fields:**
- `id` - Primary key
- `uid` - Unique identifier from auth provider
- `email` - User's email
- `displayName` - User's display name
- `phoneNumber` - User's phone number
- `photoUrl` - Profile photo URL
- `currency` - Preferred currency (default: USD)
- `language` - Preferred language (default: en)
- `biometricEnabled` - Biometric auth enabled
- `notificationsEnabled` - Notifications enabled
- `timezone` - User's timezone
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp
- `lastSyncedAt` - Last sync timestamp

### 2. Accounts Table
Stores financial accounts (bank, cash, credit card, etc.).

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `name` - Account name
- `type` - Account type (cash, bank, creditCard, investment, loan, other)
- `balanceInCents` - Balance in cents (avoids floating point issues)
- `currency` - Currency code (ISO 4217)
- `color` - Account color (hex code)
- `icon` - Account icon name
- `accountNumber` - Masked account number
- `bankName` - Bank name
- `isDefault` - Is default account
- `isActive` - Is account active
- `includeInTotal` - Include in total balance
- `notes` - Additional notes
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp
- `displayOrder` - Display order

### 3. Categories Table
Stores transaction categories.

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `name` - Category name
- `type` - Category type (income, expense)
- `parentId` - Parent category ID (for subcategories)
- `color` - Category color
- `icon` - Category icon
- `budgetLimitInCents` - Monthly budget limit
- `isSystem` - Is system category (cannot be deleted)
- `isActive` - Is category active
- `displayOrder` - Display order
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### 4. Transactions Table
Stores financial transactions.

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `accountId` - Foreign key to Accounts
- `categoryId` - Foreign key to Categories
- `type` - Transaction type (income, expense, transfer)
- `status` - Transaction status (pending, completed, cancelled)
- `amountInCents` - Amount in cents
- `currency` - Currency code
- `description` - Transaction description
- `notes` - Additional notes
- `transactionDate` - Transaction date
- `payee` - Payee/Payer name
- `location` - Transaction location
- `tags` - Tags (comma-separated)
- `attachmentUrl` - Receipt/attachment URL
- `toAccountId` - Destination account (for transfers)
- `isRecurring` - Is recurring transaction
- `recurringTransactionId` - Recurring transaction ID
- `externalId` - External transaction ID (from bank sync)
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### 5. Budgets Table
Stores budget information.

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `name` - Budget name
- `amountInCents` - Budget amount in cents
- `currency` - Currency code
- `period` - Budget period (daily, weekly, monthly, yearly, custom)
- `startDate` - Period start date
- `endDate` - Period end date
- `rollover` - Rollover unused budget
- `alertThreshold` - Alert threshold percentage (0-100)
- `alertsEnabled` - Alerts enabled
- `isActive` - Is budget active
- `color` - Budget color
- `icon` - Budget icon
- `notes` - Additional notes
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### 6. Budget Categories Table
Junction table for budget-category relationships (many-to-many).

**Fields:**
- `id` - Primary key
- `budgetId` - Foreign key to Budgets
- `categoryId` - Foreign key to Categories
- `allocatedAmountInCents` - Allocated amount for this category
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

### 7. Goals Table
Stores financial goals.

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `name` - Goal name
- `description` - Goal description
- `targetAmountInCents` - Target amount in cents
- `currentAmountInCents` - Current saved amount in cents
- `currency` - Currency code
- `targetDate` - Target date to achieve goal
- `status` - Goal status (active, completed, cancelled, paused)
- `accountId` - Linked account ID
- `monthlyContributionInCents` - Monthly contribution amount
- `autoSaveEnabled` - Auto-save enabled
- `autoSavePercentage` - Auto-save percentage (0-100)
- `priority` - Goal priority (1-5, 1 being highest)
- `color` - Goal color
- `icon` - Goal icon
- `imageUrl` - Goal image URL
- `notes` - Additional notes
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp
- `completedAt` - Completion timestamp

### 8. Recurring Transactions Table
Stores recurring transaction templates.

**Fields:**
- `id` - Primary key
- `userId` - Foreign key to Users
- `accountId` - Foreign key to Accounts
- `categoryId` - Foreign key to Categories
- `type` - Transaction type
- `amountInCents` - Amount in cents
- `currency` - Currency code
- `description` - Description
- `frequency` - Recurrence frequency (daily, weekly, biweekly, monthly, quarterly, yearly)
- `startDate` - Start date
- `endDate` - End date (null for indefinite)
- `nextOccurrence` - Next occurrence date
- `lastOccurrence` - Last occurrence date
- `isActive` - Is active
- `autoCreate` - Auto-create transactions
- `daysBeforeToCreate` - Days before to create transaction
- `payee` - Payee/Payer name
- `notes` - Additional notes
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp

## Data Access Objects (DAOs)

### UsersDao
Provides methods for user operations:
- `getUserById(int id)`
- `getUserByUid(String uid)`
- `getUserByEmail(String email)`
- `getAllUsers()`
- `createUser(UsersCompanion user)`
- `updateUser(UserEntity user)`
- `deleteUser(int id)`
- `updateLastSynced(int id, DateTime timestamp)`
- `watchUserById(int id)` - Reactive
- `watchUserByUid(String uid)` - Reactive

### AccountsDao
Provides methods for account operations:
- `getAccountById(int id)`
- `getAccountsByUserId(int userId)`
- `getActiveAccounts(int userId)`
- `getDefaultAccount(int userId)`
- `getTotalBalance(int userId)`
- `createAccount(AccountsCompanion account)`
- `updateAccount(AccountEntity account)`
- `updateBalance(int id, int balanceInCents)`
- `deleteAccount(int id)`
- `setDefaultAccount(int userId, int accountId)`
- `watchAccountsByUserId(int userId)` - Reactive
- `watchAccountById(int id)` - Reactive

### TransactionsDao
Provides methods for transaction operations:
- `getTransactionById(int id)`
- `getTransactionsByUserId(int userId)`
- `getTransactionsByAccountId(int accountId)`
- `getTransactionsByCategoryId(int categoryId)`
- `getTransactionsByDateRange(int userId, DateTime start, DateTime end)`
- `getTransactionsByType(int userId, TransactionType type)`
- `getRecentTransactions(int userId, {int limit = 10})`
- `createTransaction(TransactionsCompanion transaction)`
- `updateTransaction(TransactionEntity transaction)`
- `deleteTransaction(int id)`
- `getTotalIncome(int userId, DateTime start, DateTime end)`
- `getTotalExpenses(int userId, DateTime start, DateTime end)`
- `watchTransactionsByUserId(int userId)` - Reactive
- `watchTransactionById(int id)` - Reactive

## Usage Examples

### Accessing the Database

```dart
import 'package:get_it/get_it.dart';
import 'package:fin_nest/core/database/app_database.dart';

// Get database instance
final database = GetIt.instance<AppDatabase>();
```

### Using DAOs

```dart
// Get user by UID
final user = await database.usersDao.getUserByUid('user123');

// Get all accounts for a user
final accounts = await database.accountsDao.getAccountsByUserId(userId);

// Create a new transaction
await database.transactionsDao.createTransaction(
  TransactionsCompanion.insert(
    userId: userId,
    accountId: accountId,
    type: TransactionType.expense,
    amountInCents: 5000, // $50.00
    currency: 'USD',
    description: 'Grocery shopping',
    transactionDate: DateTime.now(),
  ),
);

// Watch transactions (reactive)
database.transactionsDao.watchTransactionsByUserId(userId).listen((transactions) {
  print('Transactions updated: ${transactions.length}');
});
```

### Direct Table Access

```dart
// Query users table directly
final users = await database.select(database.users).get();

// Insert into accounts table
await database.into(database.accounts).insert(
  AccountsCompanion.insert(
    userId: userId,
    name: 'Savings Account',
    type: AccountType.bank,
    currency: 'USD',
  ),
);
```

## Money Storage

**Important:** All monetary amounts are stored in **cents** (smallest currency unit) to avoid floating-point precision issues.

```dart
// Store $50.00 as 5000 cents
amountInCents: 5000

// Convert to display
final dollars = amountInCents / 100; // 50.00
```

## Migrations

FinNest has a comprehensive migration system for evolving the database schema over time.

### Quick Migration Steps

1. **Modify schema** - Update table definition
2. **Increment version** - Change `schemaVersion` in `AppDatabase`
3. **Generate code** - Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. **Write migration** - Add logic to `_runMigrations` method
5. **Test** - Write and run migration tests

### Example Migration

```dart
// 1. Add column to table
TextColumn get theme => text().withDefault(const Constant('light'))();

// 2. Increment schemaVersion to 2

// 3. Add migration logic
Future<void> _runMigrations(Migrator m, int from, int to) async {
  if (from < 2) {
    await m.addColumn(users, users.theme);
  }
}
```

### Migration Resources

- **Full Guide**: `docs/DATABASE_MIGRATIONS.md` - Complete migration guide with examples
- **Quick Reference**: `docs/DATABASE_MIGRATIONS_QUICK_REFERENCE.md` - Common operations
- **Helper Utilities**: `lib/core/database/migrations/migration_helpers.dart` - Reusable helpers
- **Examples**: `lib/core/database/migrations/migration_examples.dart` - Example migrations
- **Tests**: `test/core/database/migration_test.dart` - Migration test utilities

See the full migration documentation for detailed examples and best practices.

## Code Generation

After making changes to tables or DAOs, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or for watch mode:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Best Practices

1. **Always use DAOs** for database operations instead of direct table access
2. **Store money in cents** to avoid floating-point issues
3. **Use reactive streams** (`watch*` methods) for UI updates
4. **Use transactions** for operations that modify multiple tables
5. **Index frequently queried columns** for better performance
6. **Validate data** before inserting into database
7. **Handle errors** gracefully with try-catch blocks

## Testing

The database is automatically initialized in `bootstrap.dart` and registered with GetIt for dependency injection.

To test database operations:

```dart
import 'package:get_it/get_it.dart';
import 'package:fin_nest/core/database/app_database.dart';

void main() async {
  // Initialize database
  final database = AppDatabase();
  GetIt.instance.registerSingleton<AppDatabase>(database);
  
  // Run tests
  // ...
  
  // Clean up
  await database.closeDb();
}
```

## Related Files

- **Main Database**: `lib/core/database/app_database.dart`
- **Tables**: `lib/core/database/tables/*.dart`
- **DAOs**: `lib/core/database/daos/*.dart`
- **Bootstrap**: `lib/bootstrap.dart`

---

**Status**: ✅ Complete and Ready to Use

