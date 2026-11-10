import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/transactions_table.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/currency_text.dart';
import '../../insights/domain/insights_engine.dart';
import '../domain/finance_context.dart';

/// Reads the user's data from the local database and builds the AI context.
///
/// Built fresh for every request so the assistant always sees current
/// numbers. Runs entirely on the device; only the resulting summary is sent.
class FinanceContextLoader {
  FinanceContextLoader(this._db, this._ref);

  final AppDatabase _db;
  final Ref _ref;

  // TODO: Replace the hard-coded user id 1 when auth lands (as elsewhere)
  static const _userId = 1;

  Future<Map<String, Object?>> load({required bool shareDescriptions}) async {
    final currency = _ref.read(currentCurrencyProvider);
    final format = _ref.read(currencyFormatProvider);

    final rows = await _db.transactionsDao.getTransactionsByUserId(_userId);
    final categories = await _db.categoriesDao.getCategoriesByUserId(_userId);
    final recurring = await _db.recurringTransactionsDao
        .getActiveRecurringTransactions(_userId);
    final savings = await _db.savingsDao.getActiveSavings(_userId);

    final transactions = [
      for (final t in rows)
        if (t.status == TransactionStatus.completed)
          InsightTransaction(
            date: t.transactionDate,
            amountCents: t.amountInCents,
            isIncome: t.type == TransactionType.income,
            categoryId: t.categoryId,
            description: t.description,
          ),
    ];
    final insightCategories = [
      for (final c in categories)
        InsightCategory(
          id: c.id,
          name: c.name,
          budgetCents: c.budgetLimitInCents,
        ),
    ];
    final insightRecurring = [
      for (final r in recurring)
        InsightRecurring(
          description: r.description,
          amountCents: r.amountInCents,
          isIncome: r.type == 1, // 0 = expense, 1 = income
          nextOccurrence: r.nextOccurrence,
        ),
    ];

    final now = DateTime.now();
    final signals = InsightsEngine(
      transactions: transactions,
      categories: insightCategories,
      recurring: insightRecurring,
      money: (cents) => formatMoney(cents, currency, format, decimalDigits: 0),
    ).compute(now).map((i) => i.signal).toList();

    return FinanceContextBuilder.build(
      FinanceSnapshot(
        currency: currency.code,
        transactions: transactions,
        categories: insightCategories,
        recurring: [
          for (final r in recurring)
            ContextRecurring(
              description: r.description,
              amountCents: r.amountInCents,
              isIncome: r.type == 1,
              frequency: r.frequency.name,
              nextOccurrence: r.nextOccurrence,
            ),
        ],
        savings: [
          for (final v in savings)
            ContextSaving(
              category: v.category.name,
              investedCents: v.investedAmountInCents,
              currentCents: v.currentValueInCents,
            ),
        ],
        signals: signals,
      ),
      now: now,
      shareDescriptions: shareDescriptions,
    );
  }
}

final financeContextLoaderProvider = Provider<FinanceContextLoader>(
  (ref) => FinanceContextLoader(GetIt.instance<AppDatabase>(), ref),
);
