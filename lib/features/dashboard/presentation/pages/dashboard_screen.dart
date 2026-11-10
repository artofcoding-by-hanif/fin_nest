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
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../savings/presentation/providers/savings_provider.dart';
import '../../../savings/presentation/screens/savings_list_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../transactions/presentation/screens/add_expense_screen.dart';
import '../../../transactions/presentation/screens/add_income_screen.dart';
import '../../../transactions/presentation/screens/recurring_transactions_list_screen.dart';
import '../../../transactions/presentation/screens/transaction_list_screen.dart';
import '../../../transactions/presentation/providers/recurring_transaction_provider.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_trends_chart.dart';
import '../../../insights/presentation/widgets/insights_section.dart';

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
    error: (_, _) => 0,
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
    error: (_, _) => 0,
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
    error: (_, _) => 0,
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
// The v2 Enhanced Insights and Budget Overview sections that used to be
// commented out here were removed in the Aurora Glass redesign; recover
// them from git history (commit 832ff04) when re-enabling those features.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final flavorConfig = FlavorConfig.instance;

    return GlassScaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            const FinNestLogo(size: 34),
            const SizedBox(width: 10),
            Text('FinNest', style: theme.textTheme.titleLarge),
          ],
        ),
        actions: [
          if (flavorConfig.flavor.isDevelopment)
            _GlassIconButton(
              icon: Icons.flag_rounded,
              tooltip: 'Feature Flags',
              onTap: () => _open(context, const FeatureFlagsDebugScreen()),
            ),
          _GlassIconButton(
            icon: Icons.settings_rounded,
            tooltip: 'Settings',
            onTap: () => _open(context, const SettingsScreen()),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          const _PeriodSelector(),
          const SizedBox(height: 16),
          const _BalanceHero(),
          const SizedBox(height: 24),
          _QuickActions(onOpen: (page) => _open(context, page)),
          const SizedBox(height: 24),
          const InsightsSection(),
          const SizedBox(height: 24),
          _SavingsCard(onOpen: () => _open(context, const SavingsListScreen())),
          const _UpcomingSection(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Spending by Category'),
          GlassCard(
            child: Consumer(
              builder: (context, ref, _) {
                final expenses = ref.watch(categoryExpensesProvider);
                final categories = ref.watch(expenseCategoriesProvider);
                return expenses.when(
                  data: (e) => categories.when(
                    data: (c) =>
                        CategoryPieChart(categoryTotals: e, categories: c),
                    loading: () => const _CardLoading(),
                    error: (_, _) =>
                        const _CardError('Couldn\'t load categories'),
                  ),
                  loading: () => const _CardLoading(),
                  error: (_, _) =>
                      const _CardError('Couldn\'t load expense data'),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Monthly Trends'),
          GlassCard(
            child: Consumer(
              builder: (context, ref, _) {
                final expenses = ref.watch(monthlyExpenseTrendsProvider);
                final income = ref.watch(monthlyIncomeTrendsProvider);
                return expenses.when(
                  data: (e) => income.when(
                    data: (i) => MonthlyTrendsChart(
                      monthlyExpenses: e,
                      monthlyIncome: i,
                    ),
                    loading: () => const _CardLoading(),
                    error: (_, _) =>
                        const _CardError('Couldn\'t load income trends'),
                  ),
                  loading: () => const _CardLoading(),
                  error: (_, _) =>
                      const _CardError('Couldn\'t load expense trends'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFab(
        tooltip: 'Add expense',
        onPressed: () => _open(context, const AddExpenseScreen()),
      ),
    );
  }
}

/// Round frosted icon button for the app bar.
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: tooltip,
        child: GlassCard(
          width: 42,
          height: 42,
          radius: 21,
          padding: EdgeInsets.zero,
          onTap: onTap,
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

/// Horizontal period chips that drive the income/expense figures.
class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateRangeProvider);
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: DateRangeFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final filter = DateRangeFilter.values[i];
          final isSelected = filter == selected;
          return GlassChips(
            child: ChoiceChip(
              label: Text(filter.label),
              selected: isSelected,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              side: isSelected
                  ? BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    )
                  : null,
              onSelected: (_) =>
                  ref.read(selectedDateRangeProvider.notifier).state = filter,
            ),
          );
        },
      ),
    );
  }
}

/// The vivid hero card: total balance with income/expense for the period.
class _BalanceHero extends ConsumerWidget {
  const _BalanceHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalBalance = ref.watch(totalBalanceProvider);
    final income = ref.watch(monthlyIncomeProvider);
    final expenses = ref.watch(monthlyExpensesProvider);
    final period = ref.watch(selectedDateRangeProvider);

    return GlassCard(
      padding: EdgeInsets.zero,
      radius: AppTheme.radiusXL,
      gradient: const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFDB2777)],
        stops: [0, 0.55, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Stack(
        children: [
          // Light orbs for depth.
          Positioned(
            right: -40,
            top: -50,
            child: _Orb(size: 180, color: const Color(0xFF22D3EE), alpha: 0.55),
          ),
          Positioned(
            left: -60,
            bottom: -70,
            child: _Orb(size: 200, color: const Color(0xFFF472B6), alpha: 0.45),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total Balance',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.blur_on_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CurrencyText(
                    amountInCents: totalBalance,
                    style: AppTypography.amount(
                      38,
                    ).copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  period.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _HeroStat(
                        icon: Icons.south_west_rounded,
                        label: 'Income',
                        amount: income,
                        accent: const Color(0xFF6EE7B7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HeroStat(
                        icon: Icons.north_east_rounded,
                        label: 'Expenses',
                        amount: expenses,
                        accent: const Color(0xFFFDA4AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double alpha;

  const _Orb({required this.size, required this.color, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

/// Frosted stat pill inside the hero card (always on a vivid background).
class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final int amount;
  final Color accent;

  const _HeroStat({
    required this.icon,
    required this.label,
    required this.amount,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: CurrencyText(
                    amountInCents: amount,
                    style: AppTypography.amount(
                      15,
                      weight: FontWeight.w600,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of glass shortcut tiles.
class _QuickActions extends StatelessWidget {
  final void Function(Widget page) onOpen;

  const _QuickActions({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;
    final actions = [
      (Icons.add_card_rounded, 'Income', glass.income, const AddIncomeScreen()),
      (
        Icons.shopping_bag_rounded,
        'Expense',
        glass.expense,
        const AddExpenseScreen(),
      ),
      (
        Icons.receipt_long_rounded,
        'History',
        AppColors.violet,
        const TransactionListScreen(),
      ),
      (
        Icons.autorenew_rounded,
        'Recurring',
        AppColors.cyan,
        const RecurringTransactionsListScreen(),
      ),
      (
        Icons.savings_rounded,
        'Savings',
        AppColors.savings,
        const SavingsListScreen(),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (icon, label, color, page) in actions)
          _QuickAction(
            icon: icon,
            label: label,
            color: color,
            onTap: () => onOpen(page),
          ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassIcon(icon, color: color, size: 56),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

/// Savings summary: invested, current value and returns.
class _SavingsCard extends ConsumerWidget {
  final VoidCallback onOpen;

  const _SavingsCard({required this.onOpen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final glass = context.glass;
    final totalValue = ref.watch(totalSavingsValueProvider);
    final totalInvested = ref.watch(totalInvestedAmountProvider);

    return GlassCard(
      onTap: onOpen,
      tint: AppColors.savings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const GlassIcon(
                Icons.savings_rounded,
                color: AppColors.savings,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Total Savings',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 18),
          totalValue.when(
            data: (value) => totalInvested.when(
              data: (invested) {
                final returns = value - invested;
                final pct = invested > 0 ? returns / invested * 100 : 0.0;
                final up = returns >= 0;
                final color = up ? glass.income : glass.expense;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _Figure(
                            label: 'Current value',
                            amount: value,
                            style: AppTypography.amount(
                              24,
                            ).copyWith(color: theme.colorScheme.onSurface),
                          ),
                        ),
                        _Figure(
                          label: 'Invested',
                          amount: invested,
                          alignEnd: true,
                          style: AppTypography.amount(
                            16,
                            weight: FontWeight.w600,
                          ).copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: color.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            up
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: color,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          CurrencyText(
                            amountInCents: returns,
                            prefix: up ? '+' : '',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: color,
                              fontFeatures: AppTypography.tabular,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${up ? '+' : ''}${pct.toStringAsFixed(2)}%',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const _CardLoading(),
              error: (_, _) =>
                  const _CardError('Couldn\'t load invested amount'),
            ),
            loading: () => const _CardLoading(),
            error: (_, _) => const _CardError('Couldn\'t load savings'),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final String label;
  final int amount;
  final TextStyle style;
  final bool alignEnd;

  const _Figure({
    required this.label,
    required this.amount,
    required this.style,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        CurrencyText(amountInCents: amount, style: style),
      ],
    );
  }
}

/// Recurring transactions due in the next week (hidden when none).
class _UpcomingSection extends ConsumerWidget {
  const _UpcomingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingRecurringTransactionsProvider);
    if (upcoming.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final glass = context.glass;
    void openAll() => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RecurringTransactionsListScreen(),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Upcoming This Week',
            actionLabel: upcoming.length > 3
                ? '${upcoming.length - 3} more'
                : 'See all',
            onAction: openAll,
          ),
          for (final t in upcoming.take(3))
            Builder(
              builder: (context) {
                // Type is stored as: 0 = expense, 1 = income
                final isIncome = t.type == 1;
                final days = t.nextOccurrence.difference(DateTime.now()).inDays;
                final when = days <= 0
                    ? 'Today'
                    : days == 1
                    ? 'Tomorrow'
                    : 'In $days days';
                final color = isIncome ? glass.income : glass.expense;
                return GlassTile(
                  onTap: openAll,
                  leading: GlassIcon(
                    isIncome
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    color: color,
                    size: 42,
                  ),
                  title: Text(t.description),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(when),
                    ],
                  ),
                  trailing: CurrencyText(
                    amountInCents: t.amountInCents,
                    prefix: isIncome ? '+' : '−',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: color,
                      fontFeatures: AppTypography.tabular,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CardLoading extends StatelessWidget {
  const _CardLoading();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(32),
    child: LoadingIndicator(size: 32),
  );
}

class _CardError extends StatelessWidget {
  final String message;

  const _CardError(this.message);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    ),
  );
}
