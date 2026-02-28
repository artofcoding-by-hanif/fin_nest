import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/database/tables/categories_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/feature_flags_debug_screen.dart';
// TODO: v2 - Uncomment when Budget Overview is re-enabled
// import '../../../budgets/presentation/providers/budget_provider.dart'
//     as budget_providers;
// import '../../../budgets/presentation/screens/budget_list_screen.dart';
import '../../../savings/presentation/providers/savings_provider.dart';
import '../../../savings/presentation/screens/savings_list_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../transactions/presentation/screens/add_expense_screen.dart';
import '../../../transactions/presentation/screens/add_income_screen.dart';
import '../../../transactions/presentation/screens/recurring_transactions_list_screen.dart';
import '../../../transactions/presentation/screens/transaction_list_screen.dart';
import '../../../transactions/presentation/providers/recurring_transaction_provider.dart';
import '../widgets/category_pie_chart.dart';
// TODO: v2 - Uncomment when Enhanced Insights is re-enabled
// import '../widgets/enhanced_insights_card.dart';
import '../widgets/monthly_trends_chart.dart';

/// Date range filter options for dashboard
enum DateRangeFilter {
  currentMonth('Current Month'),
  lastMonth('Last Month'),
  last6Months('Last 6 Months'),
  last12Months('Last 12 Months'),
  allTime('All Time');

  final String label;
  const DateRangeFilter(this.label);

  /// Get the start date for this filter
  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case DateRangeFilter.currentMonth:
        return DateTime(now.year, now.month, 1);
      case DateRangeFilter.lastMonth:
        // Get first day of last month
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month, 1);
      case DateRangeFilter.last6Months:
        return DateTime(now.year, now.month - 6, 1);
      case DateRangeFilter.last12Months:
        return DateTime(now.year, now.month - 12, 1);
      case DateRangeFilter.allTime:
        return DateTime(2000, 1, 1); // Far past date
    }
  }

  /// Get the end date for this filter
  DateTime getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case DateRangeFilter.currentMonth:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case DateRangeFilter.lastMonth:
        // Get last day of last month (day 0 of current month)
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59);
      case DateRangeFilter.last6Months:
      case DateRangeFilter.last12Months:
      case DateRangeFilter.allTime:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }
}

/// Provider for selected date range filter
final selectedDateRangeProvider = StateProvider<DateRangeFilter>((ref) {
  return DateRangeFilter.currentMonth;
});

/// Provider for database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Provider for watching all accounts (reactive)
final watchAccountsProvider = StreamProvider<List<AccountEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.accountsDao.watchAccountsByUserId(
    1,
  ); // TODO: Replace with actual user ID
});

/// Provider for total balance (reactive) - calculated from all transactions
final totalBalanceProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(watchTransactionsProvider);
  return transactionsAsync.when(
    data: (transactions) {
      // Calculate balance from all completed transactions
      return transactions
          .where((t) => t.status == TransactionStatus.completed)
          .fold<int>(0, (sum, t) {
            if (t.type == TransactionType.income) {
              return sum + t.amountInCents;
            } else {
              return sum - t.amountInCents;
            }
          });
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for watching all transactions (reactive)
final watchTransactionsProvider = StreamProvider<List<TransactionEntity>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.watchTransactionsByUserId(
    1,
  ); // TODO: Replace with actual user ID
});

/// Provider for income based on selected date range (reactive)
final monthlyIncomeProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(watchTransactionsProvider);
  final dateRange = ref.watch(selectedDateRangeProvider);
  final startDate = dateRange.getStartDate();
  final endDate = dateRange.getEndDate();

  return transactionsAsync.when(
    data: (transactions) {
      return transactions
          .where(
            (t) =>
                t.type == TransactionType.income &&
                t.status == TransactionStatus.completed &&
                t.transactionDate.isAfter(
                  startDate.subtract(const Duration(seconds: 1)),
                ) &&
                t.transactionDate.isBefore(
                  endDate.add(const Duration(seconds: 1)),
                ),
          )
          .fold<int>(0, (sum, t) => sum + t.amountInCents);
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for expenses based on selected date range (reactive)
final monthlyExpensesProvider = Provider<int>((ref) {
  final transactionsAsync = ref.watch(watchTransactionsProvider);
  final dateRange = ref.watch(selectedDateRangeProvider);
  final startDate = dateRange.getStartDate();
  final endDate = dateRange.getEndDate();

  return transactionsAsync.when(
    data: (transactions) {
      return transactions
          .where(
            (t) =>
                t.type == TransactionType.expense &&
                t.status == TransactionStatus.completed &&
                t.transactionDate.isAfter(
                  startDate.subtract(const Duration(seconds: 1)),
                ) &&
                t.transactionDate.isBefore(
                  endDate.add(const Duration(seconds: 1)),
                ),
          )
          .fold<int>(0, (sum, t) => sum + t.amountInCents);
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider for category-wise expenses based on selected date range
final categoryExpensesProvider = FutureProvider<Map<int, int>>((ref) async {
  final db = ref.watch(databaseProvider);
  final dateRange = ref.watch(selectedDateRangeProvider);
  final startDate = dateRange.getStartDate();
  final endDate = dateRange.getEndDate();
  return db.transactionsDao.getExpensesByCategory(1, startDate, endDate);
});

/// Provider for expense categories
final expenseCategoriesProvider = FutureProvider<List<CategoryEntity>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  return db.categoriesDao.getCategoriesByType(1, CategoryType.expense);
});

/// Provider for monthly expense trends (last 6 months)
final monthlyExpenseTrendsProvider = FutureProvider<List<MonthlyTotal>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getMonthlyExpenses(1, 6);
});

/// Provider for monthly income trends (last 6 months)
final monthlyIncomeTrendsProvider = FutureProvider<List<MonthlyTotal>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getMonthlyIncome(1, 6);
});

/// Provider for top spending category (current month)
final topSpendingCategoryProvider = FutureProvider<CategorySpending?>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return db.transactionsDao.getTopSpendingCategory(1, startOfMonth, endOfMonth);
});

/// Provider for weekly summary
final weeklySummaryProvider = FutureProvider<WeeklySummary>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getWeeklySummary(1);
});

/// Provider for average daily spending (current month)
final averageDailySpendingProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return db.transactionsDao.getAverageDailySpending(
    1,
    startOfMonth,
    endOfMonth,
  );
});

/// Provider for spending trend
final spendingTrendProvider = FutureProvider<SpendingTrend>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getSpendingTrend(1);
});

/// Provider for budget progress
final budgetProgressProvider = FutureProvider<List<BudgetProgress>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getBudgetProgress(1);
});

/// Provider for savings rate
final savingsRateProvider = FutureProvider<SavingsRate>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.transactionsDao.getSavingsRate(1);
});

/// Dashboard screen with balance overview
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final flavorConfig = FlavorConfig.instance;
    final totalBalance = ref.watch(totalBalanceProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpenses = ref.watch(monthlyExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Image.asset(
          'finnest_logo_tag.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
            tooltip: 'Settings',
          ),
          if (flavorConfig.flavor.isDevelopment)
            IconButton(
              icon: const Icon(Icons.flag_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FeatureFlagsDebugScreen(),
                  ),
                );
              },
              tooltip: 'Feature Flags',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Filter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Period:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: DateRangeFilter.values.map((filter) {
                          final selectedFilter = ref.watch(
                            selectedDateRangeProvider,
                          );
                          final isSelected = selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter.label),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                          .read(
                                            selectedDateRangeProvider.notifier,
                                          )
                                          .state =
                                      filter;
                                }
                              },
                              selectedColor: theme.colorScheme.primaryContainer,
                              checkmarkColor:
                                  theme.colorScheme.onPrimaryContainer,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimaryContainer
                                    : theme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Balance Summary Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CurrencyText(
                    amountInCents: totalBalance,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _BalanceSummaryItem(
                          icon: Icons.arrow_downward,
                          label: 'Income',
                          amount: monthlyIncome,
                          color: Colors.green,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _BalanceSummaryItem(
                          icon: Icons.arrow_upward,
                          label: 'Expenses',
                          amount: monthlyExpenses,
                          color: Colors.red,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Savings Summary Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total Savings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SavingsListScreen(),
                            ),
                          );
                        },
                        tooltip: 'View all savings',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, child) {
                      final totalValueAsync = ref.watch(
                        totalSavingsValueProvider,
                      );
                      final totalInvestedAsync = ref.watch(
                        totalInvestedAmountProvider,
                      );

                      return totalValueAsync.when(
                        data: (totalValue) {
                          return totalInvestedAsync.when(
                            data: (totalInvested) {
                              final returns = totalValue - totalInvested;
                              final returnsPercentage = totalInvested > 0
                                  ? (returns / totalInvested) * 100
                                  : 0.0;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Invested',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            CurrencyText(
                                              amountInCents: totalInvested,
                                              style: theme
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Current Value',
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            CurrencyText(
                                              amountInCents: totalValue,
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          (returns >= 0
                                                  ? Colors.green
                                                  : Colors.red)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          returns >= 0
                                              ? Icons.trending_up
                                              : Icons.trending_down,
                                          color: returns >= 0
                                              ? Colors.green
                                              : Colors.red,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        CurrencyText(
                                          amountInCents: returns,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: returns >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '(${returnsPercentage.toStringAsFixed(2)}%)',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: returns >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (_, __) =>
                                const Text('Error loading invested amount'),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Text('Error loading savings'),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Upcoming Recurring Transactions
            Consumer(
              builder: (context, ref, child) {
                final upcomingTransactions = ref.watch(
                  upcomingRecurringTransactionsProvider,
                );

                // Only show if there are upcoming transactions
                if (upcomingTransactions.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event_repeat,
                            color: Colors.purple,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Upcoming This Week',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RecurringTransactionsListScreen(),
                                ),
                              );
                            },
                            tooltip: 'View all recurring transactions',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...upcomingTransactions.take(3).map((transaction) {
                        // Type is stored as: 0 = expense, 1 = income
                        final isIncome = transaction.type == 1;
                        final daysUntil = transaction.nextOccurrence
                            .difference(DateTime.now())
                            .inDays;
                        final daysText = daysUntil == 0
                            ? 'Today'
                            : daysUntil == 1
                            ? 'Tomorrow'
                            : 'In $daysUntil days';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isIncome ? Colors.green : Colors.red)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: isIncome ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.description,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      daysText,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              CurrencyText(
                                amountInCents: transaction.amountInCents,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isIncome ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (upcomingTransactions.length > 3) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RecurringTransactionsListScreen(),
                                ),
                              );
                            },
                            child: Text(
                              '+${upcomingTransactions.length - 3} more',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Quick Actions
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _QuickActionButton(
                    icon: Icons.add_circle,
                    label: 'Income',
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddIncomeScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _QuickActionButton(
                    icon: Icons.remove_circle,
                    label: 'Expense',
                    color: Colors.red,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  // TODO: v2 - Uncomment when Budget feature is re-enabled
                  // _QuickActionButton(
                  //   icon: Icons.account_balance_wallet,
                  //   label: 'Budgets',
                  //   color: Colors.orange,
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (_) => const BudgetListScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const SizedBox(width: 16),
                  _QuickActionButton(
                    icon: Icons.receipt_long,
                    label: 'History',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransactionListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _QuickActionButton(
                    icon: Icons.repeat,
                    label: 'Recurring',
                    color: theme.colorScheme.tertiary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const RecurringTransactionsListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _QuickActionButton(
                    icon: Icons.savings_outlined,
                    label: 'Savings',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SavingsListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // TODO: v2 - Enhanced Insights Card (hidden for now)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Consumer(
            //     builder: (context, ref, child) {
            //       final avgDailySpending = ref.watch(
            //         averageDailySpendingProvider,
            //       );
            //       final spendingTrend = ref.watch(spendingTrendProvider);
            //       final budgetProgress = ref.watch(budgetProgressProvider);
            //       final savingsRate = ref.watch(savingsRateProvider);
            //
            //       return avgDailySpending.when(
            //         data: (avgSpending) => spendingTrend.when(
            //           data: (trend) => budgetProgress.when(
            //             data: (budgets) => savingsRate.when(
            //               data: (savings) => EnhancedInsightsCard(
            //                 averageDailySpending: avgSpending,
            //                 spendingTrend: trend,
            //                 budgetProgress: budgets,
            //                 savingsRate: savings,
            //               ),
            //               loading: () => const Center(
            //                 child: Padding(
            //                   padding: EdgeInsets.all(32),
            //                   child: CircularProgressIndicator(),
            //                 ),
            //               ),
            //               error: (_, __) => const SizedBox.shrink(),
            //             ),
            //             loading: () => const Center(
            //               child: Padding(
            //                 padding: EdgeInsets.all(32),
            //                 child: CircularProgressIndicator(),
            //               ),
            //             ),
            //             error: (_, __) => const SizedBox.shrink(),
            //           ),
            //           loading: () => const Center(
            //             child: Padding(
            //               padding: EdgeInsets.all(32),
            //               child: CircularProgressIndicator(),
            //             ),
            //           ),
            //           error: (_, __) => const SizedBox.shrink(),
            //         ),
            //         loading: () => const Center(
            //           child: Padding(
            //             padding: EdgeInsets.all(32),
            //             child: CircularProgressIndicator(),
            //           ),
            //         ),
            //         error: (_, __) => const SizedBox.shrink(),
            //       );
            //     },
            //   ),
            // ),
            // const SizedBox(height: 16),

            // TODO: v2 - Budget Overview Card (hidden for now)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Consumer(
            //     builder: (context, ref, child) {
            //       final budgetSummaryAsync = ref.watch(
            //         budget_providers.budgetSummaryProvider,
            //       );
            //
            //       return budgetSummaryAsync.when(
            //         data: (summary) {
            //           // Only show if there are budgets set
            //           if (summary.totalBudgetInCents == 0) {
            //             return const SizedBox.shrink();
            //           }
            //
            //           return Card(
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.of(context).push(
            //                   MaterialPageRoute(
            //                     builder: (_) => const BudgetListScreen(),
            //                   ),
            //                 );
            //               },
            //               borderRadius: BorderRadius.circular(12),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             Container(
            //                               padding: const EdgeInsets.all(8),
            //                               decoration: BoxDecoration(
            //                                 color: Colors.orange.withValues(
            //                                   alpha: 0.1,
            //                                 ),
            //                                 borderRadius: BorderRadius.circular(
            //                                   8,
            //                                 ),
            //                               ),
            //                               child: const Icon(
            //                                 Icons.account_balance_wallet,
            //                                 color: Colors.orange,
            //                                 size: 20,
            //                               ),
            //                             ),
            //                             const SizedBox(width: 12),
            //                             Text(
            //                               'Budget Overview',
            //                               style: theme.textTheme.titleMedium
            //                                   ?.copyWith(
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                             ),
            //                           ],
            //                         ),
            //                         const Icon(
            //                           Icons.arrow_forward_ios,
            //                           size: 16,
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 16),
            //                     Row(
            //                       children: [
            //                         Expanded(
            //                           child: _BudgetSummaryItem(
            //                             label: 'Total Budget',
            //                             amount: formatCurrency(
            //                               ref,
            //                               summary.totalBudgetInCents,
            //                             ),
            //                             color: Colors.blue,
            //                           ),
            //                         ),
            //                         const SizedBox(width: 12),
            //                         Expanded(
            //                           child: _BudgetSummaryItem(
            //                             label: 'Spent',
            //                             amount: formatCurrency(
            //                               ref,
            //                               summary.totalSpentInCents,
            //                             ),
            //                             color: Colors.orange,
            //                           ),
            //                         ),
            //                         const SizedBox(width: 12),
            //                         Expanded(
            //                           child: _BudgetSummaryItem(
            //                             label: 'Remaining',
            //                             amount: formatCurrency(
            //                               ref,
            //                               summary.totalRemainingInCents,
            //                             ),
            //                             color:
            //                                 summary.totalRemainingInCents >= 0
            //                                 ? Colors.green
            //                                 : Colors.red,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const SizedBox(height: 12),
            //                     ClipRRect(
            //                       borderRadius: BorderRadius.circular(4),
            //                       child: LinearProgressIndicator(
            //                         value: summary.totalBudgetInCents > 0
            //                             ? (summary.totalSpentInCents /
            //                                       summary.totalBudgetInCents)
            //                                   .clamp(0.0, 1.0)
            //                             : 0.0,
            //                         backgroundColor: Colors.grey[200],
            //                         valueColor: AlwaysStoppedAnimation<Color>(
            //                           summary.totalSpentInCents >=
            //                                   summary.totalBudgetInCents
            //                               ? Colors.red
            //                               : summary.totalSpentInCents >=
            //                                     summary.totalBudgetInCents * 0.8
            //                               ? Colors.orange
            //                               : Colors.green,
            //                         ),
            //                         minHeight: 8,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //         loading: () => const SizedBox.shrink(),
            //         error: (error, stack) => const SizedBox.shrink(),
            //       );
            //     },
            //   ),
            // ),
            // const SizedBox(height: 16),

            // Category-wise Spending Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending by Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final categoryExpenses = ref.watch(
                            categoryExpensesProvider,
                          );
                          final categories = ref.watch(
                            expenseCategoriesProvider,
                          );

                          return categoryExpenses.when(
                            data: (expenses) => categories.when(
                              data: (cats) => CategoryPieChart(
                                categoryTotals: expenses,
                                categories: cats,
                              ),
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (_, __) => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text('Error loading categories'),
                                ),
                              ),
                            ),
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (_, __) => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('Error loading expense data'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monthly Trends Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Trends',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final expenseTrends = ref.watch(
                            monthlyExpenseTrendsProvider,
                          );
                          final incomeTrends = ref.watch(
                            monthlyIncomeTrendsProvider,
                          );

                          return expenseTrends.when(
                            data: (expenses) => incomeTrends.when(
                              data: (income) => MonthlyTrendsChart(
                                monthlyExpenses: expenses,
                                monthlyIncome: income,
                              ),
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (_, __) => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text('Error loading income trends'),
                                ),
                              ),
                            ),
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (_, __) => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('Error loading expense trends'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // Floating Action Button for quick expense entry
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget for displaying income/expense summary item
class _BalanceSummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int amount;
  final Color color;
  final ThemeData theme;

  const _BalanceSummaryItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          CurrencyText(
            amountInCents: amount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for round quick action button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// Widget for displaying budget summary item
class _BudgetSummaryItem extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _BudgetSummaryItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
