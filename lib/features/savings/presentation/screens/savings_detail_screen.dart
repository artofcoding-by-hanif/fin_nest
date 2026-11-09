import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/savings_transactions_provider.dart';
import 'add_edit_savings_screen.dart';
import 'add_savings_transaction_screen.dart';

/// Date range filter options for savings transaction history
enum SavingsDateRangeFilter {
  currentMonth('Current Month'),
  lastMonth('Last Month'),
  last6Months('Last 6 Months'),
  last12Months('Last 12 Months'),
  allTime('All Time');

  final String label;
  const SavingsDateRangeFilter(this.label);

  /// Get the start date for this filter
  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case SavingsDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month, 1);
      case SavingsDateRangeFilter.lastMonth:
        // Get first day of last month
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month, 1);
      case SavingsDateRangeFilter.last6Months:
        return DateTime(now.year, now.month - 6, 1);
      case SavingsDateRangeFilter.last12Months:
        return DateTime(now.year, now.month - 12, 1);
      case SavingsDateRangeFilter.allTime:
        return DateTime(2000, 1, 1); // Far past date
    }
  }

  /// Get the end date for this filter
  DateTime getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case SavingsDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case SavingsDateRangeFilter.lastMonth:
        // Get last day of last month (day 0 of current month)
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59);
      case SavingsDateRangeFilter.last6Months:
      case SavingsDateRangeFilter.last12Months:
      case SavingsDateRangeFilter.allTime:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }
}

/// Provider for selected date range filter for savings transactions
final selectedSavingsDateRangeProvider = StateProvider<SavingsDateRangeFilter>((
  ref,
) {
  return SavingsDateRangeFilter.allTime;
});

/// Screen for viewing savings details and transaction history
class SavingsDetailScreen extends ConsumerWidget {
  final SavingsEntity savings;

  const SavingsDetailScreen({super.key, required this.savings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionsAsync = ref.watch(
      watchSavingsTransactionsProvider(savings.id),
    );
    final returns = savings.currentValueInCents - savings.investedAmountInCents;
    final returnsPercentage = savings.investedAmountInCents > 0
        ? (returns / savings.investedAmountInCents) * 100
        : 0.0;
    final categoryStyle = SavingsCategoryStyle.of(savings.category);
    final returnsColor = returns >= 0
        ? context.glass.income
        : context.glass.expense;

    return GlassScaffold(
      appBar: AppBar(
        title: Text(savings.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: GlassCard(
              tint: AppColors.savings,
              radius: AppTheme.radiusXL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GlassIcon(
                        categoryStyle.icon,
                        color: categoryStyle.color,
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Value',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              categoryStyle.label,
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      SavingsReturnBadge(
                        returnsInCents: returns,
                        percentage: returnsPercentage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _GradientMask(
                    gradient: AppColors.savingsGradient,
                    child: CurrencyText(
                      amountInCents: savings.currentValueInCents,
                      style: AppTypography.amount(
                        36,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroStat(
                          label: 'Invested',
                          child: CurrencyText(
                            amountInCents: savings.investedAmountInCents,
                            style: AppTypography.amount(
                              18,
                            ).copyWith(color: theme.colorScheme.onSurface),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroStat(
                          label: 'Returns',
                          child: CurrencyText(
                            amountInCents: returns,
                            style: AppTypography.amount(
                              18,
                            ).copyWith(color: returnsColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Date Range Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text(
                  'Period',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: SavingsDateRangeFilter.values.map((filter) {
                        final selectedFilter = ref.watch(
                          selectedSavingsDateRangeProvider,
                        );
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GlassChips(
                            child: FilterChip(
                              label: Text(filter.label),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  ref
                                          .read(
                                            selectedSavingsDateRangeProvider
                                                .notifier,
                                          )
                                          .state =
                                      filter;
                                }
                              },
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

          // Transaction History Header
          SectionHeader(
            title: 'Transaction History',
            actionLabel: 'Add',
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            onAction: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddSavingsTransactionScreen(
                    savingsId: savings.id,
                    savingsName: savings.name,
                  ),
                ),
              );
            },
          ),

          // Transaction List
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const EmptyState(
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.savings,
                    title: 'No transactions yet',
                    message: 'Add your first transaction to get started',
                  );
                }

                // Get selected date range filter
                final selectedFilter = ref.watch(
                  selectedSavingsDateRangeProvider,
                );
                final startDate = selectedFilter.getStartDate();
                final endDate = selectedFilter.getEndDate();

                // Filter transactions by date range
                final filteredTransactions = transactions.where((transaction) {
                  return transaction.transactionDate.isAfter(
                        startDate.subtract(const Duration(days: 1)),
                      ) &&
                      transaction.transactionDate.isBefore(
                        endDate.add(const Duration(days: 1)),
                      );
                }).toList();

                // Check if filtered list is empty
                if (filteredTransactions.isEmpty) {
                  return const EmptyState(
                    icon: Icons.event_busy_rounded,
                    color: AppColors.savings,
                    title: 'No transactions in this period',
                    message: 'Try selecting a different date range',
                  );
                }

                // Sort transactions by date (newest first)
                final sortedTransactions =
                    List<SavingsTransactionEntity>.from(filteredTransactions)
                      ..sort(
                        (a, b) =>
                            b.transactionDate.compareTo(a.transactionDate),
                      );

                // Calculate running balance
                int runningBalance = 0;
                final transactionsWithBalance = <Map<String, dynamic>>[];

                // Process in reverse order to calculate running balance
                for (var i = sortedTransactions.length - 1; i >= 0; i--) {
                  final transaction = sortedTransactions[i];

                  // Update running balance based on transaction type
                  switch (transaction.type) {
                    case SavingsTransactionType.deposit:
                    case SavingsTransactionType.interest:
                    case SavingsTransactionType.dividend:
                    case SavingsTransactionType.appreciation:
                      runningBalance += transaction.amountInCents;
                      break;
                    case SavingsTransactionType.withdrawal:
                    case SavingsTransactionType.depreciation:
                      runningBalance -= transaction.amountInCents;
                      break;
                  }

                  transactionsWithBalance.insert(0, {
                    'transaction': transaction,
                    'balance': runningBalance,
                  });
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                  itemCount: transactionsWithBalance.length,
                  itemBuilder: (context, index) {
                    final item = transactionsWithBalance[index];
                    final transaction =
                        item['transaction'] as SavingsTransactionEntity;
                    final balance = item['balance'] as int;
                    final typeStyle = SavingsTransactionTypeStyle.of(
                      context,
                      transaction.type,
                    );
                    final color = typeStyle.color;

                    return Dismissible(
                      key: Key('transaction_${transaction.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          gradient: AppColors.expenseGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Transaction'),
                            content: const Text(
                              'Are you sure you want to delete this transaction? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                  foregroundColor: context.glass.expense,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        try {
                          await ref
                              .read(savingsTransactionProvider.notifier)
                              .deleteTransaction(transaction.id, savings.id);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction deleted successfully'),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error deleting transaction: $e'),
                              backgroundColor: AppColors.expenseDeep,
                            ),
                          );
                        }
                      },
                      child: GlassTile(
                        leading: GlassIcon(
                          typeStyle.icon,
                          color: color,
                          size: 42,
                        ),
                        title: Text(typeStyle.label),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(transaction.transactionDate),
                            ),
                            if (transaction.notes != null &&
                                transaction.notes!.isNotEmpty)
                              Text(
                                transaction.notes!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            // Show linkage indicator for deposits linked to expenses
                            if (transaction.linkedTransactionId != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.link_rounded,
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Linked to Expense',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Balance: ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Flexible(
                                  child: CurrencyText(
                                    amountInCents: balance,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: CurrencyText(
                          amountInCents: transaction.amountInCents,
                          prefix:
                              (transaction.type ==
                                      SavingsTransactionType.deposit ||
                                  transaction.type ==
                                      SavingsTransactionType.interest ||
                                  transaction.type ==
                                      SavingsTransactionType.dividend ||
                                  transaction.type ==
                                      SavingsTransactionType.appreciation)
                              ? '+'
                              : '-',
                          style: AppTypography.amount(
                            16,
                          ).copyWith(color: color),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddSavingsTransactionScreen(
                                savingsId: savings.id,
                                savingsName: savings.name,
                                transaction: transaction,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) =>
                  ErrorView(message: 'Error loading transactions: $error'),
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFab(
        tooltip: 'Add Transaction',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSavingsTransactionScreen(
                savingsId: savings.id,
                savingsName: savings.name,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small labelled figure inside the hero card.
class _HeroStat extends StatelessWidget {
  final String label;
  final Widget child;

  const _HeroStat({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: context.glass.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Paints its child (e.g. a [CurrencyText]) with a gradient.
class _GradientMask extends StatelessWidget {
  final Gradient gradient;
  final Widget child;

  const _GradientMask({required this.gradient, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}
