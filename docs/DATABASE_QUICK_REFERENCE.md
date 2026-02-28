# Database Quick Reference

## 🚀 Quick Start

### Get Database Instance

```dart
import 'package:get_it/get_it.dart';
import 'package:fin_nest/core/database/app_database.dart';

final db = GetIt.instance<AppDatabase>();
```

## 📊 Common Operations

### Users

```dart
// Get user by UID
final user = await db.usersDao.getUserByUid('user123');

// Create user
await db.usersDao.createUser(
  UsersCompanion.insert(
    uid: 'user123',
    email: 'user@example.com',
  ),
);

// Watch user (reactive)
db.usersDao.watchUserByUid('user123').listen((user) {
  print('User updated: ${user?.displayName}');
});
```

### Accounts

```dart
// Get all accounts for user
final accounts = await db.accountsDao.getAccountsByUserId(userId);

// Get total balance
final totalBalance = await db.accountsDao.getTotalBalance(userId);

// Create account
await db.accountsDao.createAccount(
  AccountsCompanion.insert(
    userId: userId,
    name: 'Savings',
    type: AccountType.bank,
    currency: 'USD',
  ),
);

// Update balance
await db.accountsDao.updateBalance(accountId, 10000); // $100.00

// Set as default
await db.accountsDao.setDefaultAccount(userId, accountId);

// Watch accounts (reactive)
db.accountsDao.watchAccountsByUserId(userId).listen((accounts) {
  print('Accounts updated: ${accounts.length}');
});
```

### Transactions

```dart
// Get recent transactions
final recent = await db.transactionsDao.getRecentTransactions(userId, limit: 10);

// Get transactions by date range
final transactions = await db.transactionsDao.getTransactionsByDateRange(
  userId,
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

// Create transaction
await db.transactionsDao.createTransaction(
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

// Get total income/expenses
final income = await db.transactionsDao.getTotalIncome(
  userId,
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

final expenses = await db.transactionsDao.getTotalExpenses(
  userId,
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

// Watch transactions (reactive)
db.transactionsDao.watchTransactionsByUserId(userId).listen((transactions) {
  print('Transactions updated: ${transactions.length}');
});
```

## 💰 Money Conversion

```dart
// Store money in cents
final amountInCents = (50.00 * 100).toInt(); // $50.00 = 5000 cents

// Display money
final dollars = amountInCents / 100; // 5000 cents = $50.00
final formatted = '\$${dollars.toStringAsFixed(2)}'; // "$50.00"
```

## 🔄 Reactive Streams

All `watch*` methods return streams that automatically update when data changes:

```dart
// In a ConsumerWidget
@override
Widget build(BuildContext context, WidgetRef ref) {
  return StreamBuilder<List<AccountEntity>>(
    stream: db.accountsDao.watchAccountsByUserId(userId),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      
      final accounts = snapshot.data!;
      return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return ListTile(
            title: Text(account.name),
            subtitle: Text('\$${(account.balanceInCents / 100).toStringAsFixed(2)}'),
          );
        },
      );
    },
  );
}
```

## 📋 Table Reference

| Table | Purpose | Key Fields |
|-------|---------|------------|
| **Users** | User profiles | uid, email, displayName |
| **Accounts** | Financial accounts | name, type, balanceInCents |
| **Categories** | Transaction categories | name, type, parentId |
| **Transactions** | Financial transactions | type, amountInCents, transactionDate |
| **Budgets** | Budget tracking | name, amountInCents, period |
| **BudgetCategories** | Budget-category links | budgetId, categoryId |
| **Goals** | Financial goals | name, targetAmountInCents, status |
| **RecurringTransactions** | Recurring templates | frequency, nextOccurrence |

## 🔧 Code Generation

After modifying tables or DAOs:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Related Documentation

- **Full Guide**: `docs/DATABASE_SETUP.md`
- **Main Database**: `lib/core/database/app_database.dart`
- **Tables**: `lib/core/database/tables/*.dart`
- **DAOs**: `lib/core/database/daos/*.dart`

---

**Tip**: Always use DAOs instead of direct table access for better maintainability!

