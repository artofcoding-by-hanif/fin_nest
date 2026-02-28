import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/database/tables/categories_table.dart';

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Provider for expense categories
final expenseCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.categoriesDao.getCategoriesByType(1, CategoryType.expense);
});

/// Provider for user accounts
final userAccountsProvider = FutureProvider<List<AccountEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.accountsDao.getActiveAccounts(1);
});

/// State notifier for adding expenses
class AddExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _database;

  AddExpenseNotifier(this._database) : super(const AsyncValue.data(null));

  Future<void> addExpense({
    required int accountId,
    required int categoryId,
    required int amountInCents,
    required String description,
    String? notes,
    required DateTime transactionDate,
  }) async {
    state = const AsyncValue.loading();

    try {
      // For now, use a hardcoded user ID of 1
      // TODO: Replace with actual user ID from auth
      const userId = 1;

      await _database.transactionsDao.createTransaction(
        TransactionsCompanion.insert(
          userId: userId,
          accountId: accountId,
          categoryId: drift.Value(categoryId),
          type: TransactionType.expense,
          status: drift.Value(TransactionStatus.completed),
          amountInCents: amountInCents,
          currency: const drift.Value('USD'),
          description: description,
          notes: drift.Value(notes),
          transactionDate: transactionDate,
        ),
      );

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

/// Provider for add expense notifier
final addExpenseProvider =
    StateNotifierProvider<AddExpenseNotifier, AsyncValue<void>>((ref) {
  final database = ref.watch(databaseProvider);
  return AddExpenseNotifier(database);
});

