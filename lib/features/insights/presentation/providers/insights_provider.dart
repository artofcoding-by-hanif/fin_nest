import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../transactions/presentation/providers/recurring_transaction_provider.dart'
    show activeRecurringTransactionsProvider;
import '../../domain/insights_engine.dart';

final _databaseProvider = Provider<AppDatabase>(
  (ref) => GetIt.instance<AppDatabase>(),
);

// TODO: Replace the hard-coded user id 1 when auth lands (as elsewhere)
final _transactionsProvider = StreamProvider<List<TransactionEntity>>(
  (ref) => ref.watch(_databaseProvider).transactionsDao.watchTransactionsByUserId(1),
);

final _categoriesProvider = StreamProvider<List<CategoryEntity>>(
  (ref) => ref.watch(_databaseProvider).categoriesDao.watchCategoriesByUserId(1),
);

/// Smart Insights for today, recomputed whenever transactions, categories
/// (budgets), recurring payments or the currency setting change.
final smartInsightsProvider = Provider<AsyncValue<List<Insight>>>((ref) {
  final transactions = ref.watch(_transactionsProvider);
  final categories = ref.watch(_categoriesProvider);
  final recurring = ref.watch(activeRecurringTransactionsProvider);
  final currency = ref.watch(currentCurrencyProvider);
  final format = ref.watch(currencyFormatProvider);

  final error = transactions.error ?? categories.error ?? recurring.error;
  if (error != null) {
    return AsyncValue.error(error, StackTrace.current);
  }
  if (!transactions.hasValue || !categories.hasValue || !recurring.hasValue) {
    return const AsyncValue.loading();
  }

  final engine = InsightsEngine(
    transactions: [
      for (final t in transactions.requireValue)
        if (t.status == TransactionStatus.completed)
          InsightTransaction(
            date: t.transactionDate,
            amountCents: t.amountInCents,
            isIncome: t.type == TransactionType.income,
            categoryId: t.categoryId,
            description: t.description,
          ),
    ],
    categories: [
      for (final c in categories.requireValue)
        InsightCategory(
          id: c.id,
          name: c.name,
          icon: c.icon,
          color: c.color,
          budgetCents: c.budgetLimitInCents,
        ),
    ],
    recurring: [
      for (final r in recurring.requireValue)
        InsightRecurring(
          description: r.description,
          amountCents: r.amountInCents,
          // Stored as 0 = expense, 1 = income
          isIncome: r.type == 1,
          nextOccurrence: r.nextOccurrence,
        ),
    ],
    money: (cents) => formatMoney(cents, currency, format, decimalDigits: 0),
  );

  return AsyncValue.data(engine.compute(DateTime.now()));
});

/// Category lookup for rendering insight icons and colors
final insightCategoriesProvider = Provider<Map<int, CategoryEntity>>((ref) {
  final list = ref.watch(_categoriesProvider).value ?? const [];
  return {for (final c in list) c.id: c};
});
