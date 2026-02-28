import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/categories_table.dart';
import '../../../../core/database/tables/recurring_transactions_table.dart';
import '../../../../core/database/tables/transactions_table.dart';

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Provider for all recurring transactions (reactive stream)
final allRecurringTransactionsProvider =
    StreamProvider<List<RecurringTransactionEntity>>((ref) {
      final db = ref.watch(databaseProvider);
      // For now, use a hardcoded user ID of 1
      // TODO: Replace with actual user ID from auth
      return db.recurringTransactionsDao.watchRecurringTransactionsByUserId(1);
    });

/// Provider for active recurring transactions (reactive stream)
final activeRecurringTransactionsProvider =
    StreamProvider<List<RecurringTransactionEntity>>((ref) {
      final db = ref.watch(databaseProvider);
      // For now, use a hardcoded user ID of 1
      // TODO: Replace with actual user ID from auth
      return db.recurringTransactionsDao.watchActiveRecurringTransactions(1);
    });

/// Provider for upcoming recurring transactions (next 7 days)
final upcomingRecurringTransactionsProvider =
    Provider<List<RecurringTransactionEntity>>((ref) {
      final activeTransactionsAsync = ref.watch(
        activeRecurringTransactionsProvider,
      );

      return activeTransactionsAsync.when(
        data: (transactions) {
          final now = DateTime.now();
          final nextWeek = now.add(const Duration(days: 7));

          // Filter transactions that are due within the next 7 days
          final upcoming = transactions.where((transaction) {
            final dueDate = transaction.nextOccurrence;
            return dueDate.isAfter(now) && dueDate.isBefore(nextWeek);
          }).toList();

          // Sort by next occurrence date (earliest first)
          upcoming.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));

          return upcoming;
        },
        loading: () => <RecurringTransactionEntity>[],
        error: (_, __) => <RecurringTransactionEntity>[],
      );
    });

/// Provider for expense categories
final expenseCategoriesProvider = FutureProvider<List<CategoryEntity>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.categoriesDao.getCategoriesByType(1, CategoryType.expense);
});

/// Provider for income categories
final incomeCategoriesProvider = FutureProvider<List<CategoryEntity>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.categoriesDao.getCategoriesByType(1, CategoryType.income);
});

/// Provider for user accounts
final userAccountsProvider = FutureProvider<List<AccountEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.accountsDao.getActiveAccounts(1);
});

/// State notifier for adding recurring transactions
class AddRecurringTransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  AddRecurringTransactionNotifier(this._db)
    : super(const AsyncValue.data(null));

  Future<void> addRecurringTransaction({
    required int accountId,
    required int categoryId,
    required TransactionType type,
    required int amountInCents,
    required String description,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    bool autoCreate = true,
    int daysBeforeToCreate = 0,
    String? payee,
    String? notes,
    bool enableNotifications = false,
    int notificationMinutesBefore = 0,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Calculate next occurrence based on frequency
      final nextOccurrence = _calculateNextOccurrence(startDate, frequency);

      final recurringTransaction = RecurringTransactionsCompanion.insert(
        userId: 1, // TODO: Replace with actual user ID from auth
        accountId: accountId,
        categoryId: Value(categoryId),
        type: type == TransactionType.income ? 1 : 0,
        amountInCents: amountInCents,
        currency: const Value('USD'), // TODO: Get from user settings
        description: description,
        frequency: frequency,
        startDate: startDate,
        endDate: Value(endDate),
        nextOccurrence: nextOccurrence,
        isActive: const Value(true),
        autoCreate: Value(autoCreate),
        daysBeforeToCreate: Value(daysBeforeToCreate),
        payee: Value(payee),
        notes: Value(notes),
        enableNotifications: Value(enableNotifications),
        notificationMinutesBefore: Value(notificationMinutesBefore),
      );

      await _db.recurringTransactionsDao.createRecurringTransaction(
        recurringTransaction,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  DateTime _calculateNextOccurrence(
    DateTime startDate,
    RecurrenceFrequency frequency,
  ) {
    final now = DateTime.now();
    if (startDate.isAfter(now)) {
      return startDate;
    }

    switch (frequency) {
      case RecurrenceFrequency.daily:
        return now.add(const Duration(days: 1));
      case RecurrenceFrequency.weekly:
        return now.add(const Duration(days: 7));
      case RecurrenceFrequency.biweekly:
        return now.add(const Duration(days: 14));
      case RecurrenceFrequency.monthly:
        return DateTime(now.year, now.month + 1, startDate.day);
      case RecurrenceFrequency.quarterly:
        return DateTime(now.year, now.month + 3, startDate.day);
      case RecurrenceFrequency.yearly:
        return DateTime(now.year + 1, startDate.month, startDate.day);
    }
  }
}

/// Provider for adding recurring transactions
final addRecurringTransactionProvider =
    StateNotifierProvider<AddRecurringTransactionNotifier, AsyncValue<void>>((
      ref,
    ) {
      final db = ref.watch(databaseProvider);
      return AddRecurringTransactionNotifier(db);
    });

/// Provider for deleting a recurring transaction
final deleteRecurringTransactionProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return (int recurringTransactionId) async {
    await db.recurringTransactionsDao.deleteRecurringTransaction(
      recurringTransactionId,
    );
    // Refresh the recurring transaction list
    ref.invalidate(allRecurringTransactionsProvider);
  };
});

/// Provider for toggling recurring transaction active status
final toggleRecurringTransactionProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return (int recurringTransactionId, bool isActive) async {
    if (isActive) {
      await db.recurringTransactionsDao.activateRecurringTransaction(
        recurringTransactionId,
      );
    } else {
      await db.recurringTransactionsDao.deactivateRecurringTransaction(
        recurringTransactionId,
      );
    }
    // Refresh the recurring transaction list
    ref.invalidate(allRecurringTransactionsProvider);
  };
});

/// Provider for updating a recurring transaction
final updateRecurringTransactionProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return (RecurringTransactionEntity recurringTransaction) async {
    await db.recurringTransactionsDao.updateRecurringTransaction(
      recurringTransaction,
    );
    // Refresh the recurring transaction list
    ref.invalidate(allRecurringTransactionsProvider);
  };
});
