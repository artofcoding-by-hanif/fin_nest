import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/transactions_table.dart';

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Enum for transaction filter type
enum TransactionFilter {
  all,
  income,
  expense,
}

/// State class for transaction list filters
class TransactionListState {
  final TransactionFilter filter;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionListState({
    this.filter = TransactionFilter.all,
    this.startDate,
    this.endDate,
  });

  TransactionListState copyWith({
    TransactionFilter? filter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionListState(
      filter: filter ?? this.filter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

/// State notifier for transaction list filters
class TransactionListNotifier extends StateNotifier<TransactionListState> {
  TransactionListNotifier() : super(const TransactionListState());

  void setFilter(TransactionFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  void clearFilters() {
    state = const TransactionListState();
  }
}

/// Provider for transaction list filters
final transactionListFilterProvider =
    StateNotifierProvider<TransactionListNotifier, TransactionListState>((ref) {
  return TransactionListNotifier();
});

/// Provider for all transactions (reactive stream)
final allTransactionsProvider = StreamProvider<List<TransactionEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.transactionsDao.watchTransactionsByUserId(1);
});

/// Provider for filtered transactions
final filteredTransactionsProvider = Provider<AsyncValue<List<TransactionEntity>>>((ref) {
  final allTransactions = ref.watch(allTransactionsProvider);
  final filterState = ref.watch(transactionListFilterProvider);

  return allTransactions.whenData((transactions) {
    var filtered = transactions;

    // Filter by type
    if (filterState.filter == TransactionFilter.income) {
      filtered = filtered.where((t) => t.type == TransactionType.income).toList();
    } else if (filterState.filter == TransactionFilter.expense) {
      filtered = filtered.where((t) => t.type == TransactionType.expense).toList();
    }

    // Filter by date range
    if (filterState.startDate != null && filterState.endDate != null) {
      filtered = filtered.where((t) {
        return t.transactionDate.isAfter(filterState.startDate!) &&
            t.transactionDate.isBefore(filterState.endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  });
});

/// Provider for grouped transactions by date
final groupedTransactionsProvider = Provider<AsyncValue<Map<DateTime, List<TransactionEntity>>>>((ref) {
  final filteredTransactions = ref.watch(filteredTransactionsProvider);

  return filteredTransactions.whenData((transactions) {
    final Map<DateTime, List<TransactionEntity>> grouped = {};

    for (final transaction in transactions) {
      // Group by date (without time)
      final date = DateTime(
        transaction.transactionDate.year,
        transaction.transactionDate.month,
        transaction.transactionDate.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  });
});

/// Provider for deleting a transaction
final deleteTransactionProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return (int transactionId) async {
    await db.transactionsDao.deleteTransaction(transactionId);
    // Refresh the transaction list
    ref.invalidate(allTransactionsProvider);
  };
});

/// Provider for getting transaction with category and account details
final transactionDetailsProvider = FutureProvider.family<TransactionDetails?, int>((ref, transactionId) async {
  final db = ref.watch(databaseProvider);
  
  final transaction = await db.transactionsDao.getTransactionById(transactionId);
  if (transaction == null) return null;

  final category = transaction.categoryId != null
      ? await db.categoriesDao.getCategoryById(transaction.categoryId!)
      : null;
  
  final account = await db.accountsDao.getAccountById(transaction.accountId);

  return TransactionDetails(
    transaction: transaction,
    category: category,
    account: account,
  );
});

/// Class to hold transaction with related details
class TransactionDetails {
  final TransactionEntity transaction;
  final CategoryEntity? category;
  final AccountEntity? account;

  TransactionDetails({
    required this.transaction,
    this.category,
    this.account,
  });
}

