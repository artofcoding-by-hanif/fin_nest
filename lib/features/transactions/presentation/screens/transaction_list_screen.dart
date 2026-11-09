import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../providers/transaction_list_provider.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';

/// Date range filter options for transactions
enum TransactionDateRangeFilter {
  currentMonth('Current Month'),
  lastMonth('Last Month'),
  last6Months('Last 6 Months'),
  last12Months('Last 12 Months'),
  allTime('All Time');

  final String label;
  const TransactionDateRangeFilter(this.label);

  /// Get the start date for this filter
  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case TransactionDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month, 1);
      case TransactionDateRangeFilter.lastMonth:
        // Get first day of last month
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month, 1);
      case TransactionDateRangeFilter.last6Months:
        return DateTime(now.year, now.month - 6, 1);
      case TransactionDateRangeFilter.last12Months:
        return DateTime(now.year, now.month - 12, 1);
      case TransactionDateRangeFilter.allTime:
        return DateTime(2000, 1, 1); // Far past date
    }
  }

  /// Get the end date for this filter
  DateTime getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case TransactionDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case TransactionDateRangeFilter.lastMonth:
        // Get last day of last month (day 0 of current month)
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59);
      case TransactionDateRangeFilter.last6Months:
      case TransactionDateRangeFilter.last12Months:
      case TransactionDateRangeFilter.allTime:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }
}

/// Provider for selected date range filter for transactions
final selectedTransactionDateRangeProvider =
    StateProvider<TransactionDateRangeFilter>((ref) {
      return TransactionDateRangeFilter.allTime;
    });

/// Screen for viewing and managing transactions
class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final groupedTransactions = ref.watch(groupedTransactionsProvider);

    return GlassScaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          // Filter button
          PopupMenuButton<TransactionFilter>(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filter',
            onSelected: (filter) {
              ref
                  .read(transactionListFilterProvider.notifier)
                  .setFilter(filter);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TransactionFilter.all,
                child: Text('All Transactions'),
              ),
              const PopupMenuItem(
                value: TransactionFilter.income,
                child: Text('Income Only'),
              ),
              const PopupMenuItem(
                value: TransactionFilter.expense,
                child: Text('Expenses Only'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
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
                      children: TransactionDateRangeFilter.values.map((filter) {
                        final selectedFilter = ref.watch(
                          selectedTransactionDateRangeProvider,
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
                                            selectedTransactionDateRangeProvider
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
          // Transaction List
          Expanded(
            child: groupedTransactions.when(
              data: (grouped) {
                // Get selected date range filter
                final selectedFilter = ref.watch(
                  selectedTransactionDateRangeProvider,
                );
                final startDate = selectedFilter.getStartDate();
                final endDate = selectedFilter.getEndDate();

                // Filter grouped transactions by date range
                final filteredGrouped = <DateTime, List<TransactionEntity>>{};
                grouped.forEach((date, transactions) {
                  if (date.isAfter(
                        startDate.subtract(const Duration(days: 1)),
                      ) &&
                      date.isBefore(endDate.add(const Duration(days: 1)))) {
                    filteredGrouped[date] = transactions;
                  }
                });

                if (filteredGrouped.isEmpty) {
                  return const EmptyState(
                    title: 'No transactions in this period',
                    message: 'Try selecting a different date range',
                    icon: Icons.receipt_long_rounded,
                  );
                }

                // Sort dates in descending order
                final sortedDates = filteredGrouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final transactions = filteredGrouped[date]!;

                    return _DateGroup(date: date, transactions: transactions);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => EmptyState(
                title: 'Something went wrong',
                message: 'Error loading transactions: $error',
                icon: Icons.error_outline_rounded,
                color: context.glass.expense,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFab(
        onPressed: () => _showAddTransactionMenu(context),
        icon: Icons.add_rounded,
        tooltip: 'Add transaction',
      ),
    );
  }

  void _showAddTransactionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassTile(
                leading: GlassIcon(
                  Icons.south_west_rounded,
                  gradient: AppColors.incomeGradient,
                  color: context.glass.income,
                  size: 44,
                ),
                title: const Text('Add Income'),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
                  );
                },
              ),
              GlassTile(
                margin: EdgeInsets.zero,
                leading: GlassIcon(
                  Icons.north_east_rounded,
                  gradient: AppColors.expenseGradient,
                  color: context.glass.expense,
                  size: 44,
                ),
                title: const Text('Add Expense'),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying a group of transactions by date
class _DateGroup extends ConsumerWidget {
  final DateTime date;
  final List<TransactionEntity> transactions;

  const _DateGroup({required this.date, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final glass = context.glass;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateLabel;
    if (date == today) {
      dateLabel = 'Today';
    } else if (date == yesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = DateFormat('EEEE, MMM dd, yyyy').format(date);
    }

    // Calculate total for the day
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<int>(0, (sum, t) => sum + t.amountInCents);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<int>(0, (sum, t) => sum + t.amountInCents);

    final totalStyle = theme.textTheme.labelMedium?.copyWith(
      fontFeatures: AppTypography.tabular,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  if (totalIncome > 0) ...[
                    Text(
                      '+${formatCurrency(ref, totalIncome)}',
                      style: totalStyle?.copyWith(color: glass.income),
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (totalExpense > 0)
                    Text(
                      '-${formatCurrency(ref, totalExpense)}',
                      style: totalStyle?.copyWith(color: glass.expense),
                    ),
                ],
              ),
            ],
          ),
        ),
        // Transaction items
        ...transactions.map(
          (transaction) => _TransactionItem(transaction: transaction),
        ),
      ],
    );
  }
}

/// Widget for displaying a single transaction item
class _TransactionItem extends ConsumerWidget {
  final TransactionEntity transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final glass = context.glass;
    final transactionDetails = ref.watch(
      transactionDetailsProvider(transaction.id),
    );

    return transactionDetails.when(
      data: (details) {
        if (details == null) return const SizedBox.shrink();

        final isIncome = transaction.type == TransactionType.income;
        final typeColor = isIncome ? glass.income : glass.expense;
        final subtitleParts = [
          if (details.category != null) details.category!.name,
          if (details.account != null) details.account!.name,
        ];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: Key('transaction_${transaction.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                gradient: AppColors.expenseGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => const _DeleteDialog(),
              );
            },
            onDismissed: (direction) async {
              await ref.read(deleteTransactionProvider)(transaction.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transaction deleted')),
                );
              }
            },
            child: GlassTile(
              margin: EdgeInsets.zero,
              leading: GlassIcon(
                details.category != null
                    ? CategoryVisuals.icon(details.category!.icon)
                    : (isIncome
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded),
                color: details.category != null
                    ? CategoryVisuals.vivid(
                        details.category!.color,
                        fallback: typeColor,
                      )
                    : typeColor,
                size: 42,
              ),
              title: Text(transaction.description),
              subtitle: subtitleParts.isEmpty
                  ? null
                  : Text(subtitleParts.join(' · ')),
              trailing: Text(
                '${isIncome ? '+' : '-'}${formatCurrency(ref, transaction.amountInCents)}',
                style: AppTypography.amount(
                  15,
                  weight: FontWeight.w600,
                ).copyWith(color: typeColor),
              ),
              onTap: () => _showTransactionDetails(context, ref, transaction),
            ),
          ),
        );
      },
      loading: () => GlassTile(
        leading: const SizedBox(
          width: 42,
          height: 42,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        title: Text(
          'Loading...',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
      error: (error, stack) => GlassTile(
        leading: GlassIcon(
          Icons.error_outline_rounded,
          color: glass.expense,
          size: 42,
        ),
        title: Text('Error: $error'),
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    WidgetRef ref,
    TransactionEntity transaction,
  ) {
    // TODO: Navigate to edit screen
    showModalBottomSheet(
      context: context,
      builder: (context) => _TransactionDetailsSheet(transaction: transaction),
    );
  }
}

/// Confirmation dialog for deleting a transaction.
class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Transaction'),
      content: const Text('Are you sure you want to delete this transaction?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: context.glass.expense),
          child: const Text('DELETE'),
        ),
      ],
    );
  }
}

/// Bottom sheet for transaction details
class _TransactionDetailsSheet extends ConsumerWidget {
  final TransactionEntity transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final glass = context.glass;
    final transactionDetails = ref.watch(
      transactionDetailsProvider(transaction.id),
    );

    return transactionDetails.when(
      data: (details) {
        if (details == null) return const SizedBox.shrink();

        final isIncome = transaction.type == TransactionType.income;
        final typeColor = isIncome ? glass.income : glass.expense;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction Details',
                      style: theme.textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Amount hero
                GlassCard(
                  blur: false,
                  tint: typeColor,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      GlassIcon(
                        details.category != null
                            ? CategoryVisuals.icon(details.category!.icon)
                            : (isIncome
                                  ? Icons.south_west_rounded
                                  : Icons.north_east_rounded),
                        color: details.category != null
                            ? CategoryVisuals.vivid(
                                details.category!.color,
                                fallback: typeColor,
                              )
                            : typeColor,
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isIncome ? 'Income' : 'Expense',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: GradientText(
                                '${isIncome ? '+' : '-'}${formatCurrency(ref, transaction.amountInCents)}',
                                style: AppTypography.amount(30),
                                gradient: isIncome
                                    ? AppColors.incomeGradient
                                    : AppColors.expenseGradient,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (details.category != null)
                  _DetailRow(label: 'Category', value: details.category!.name),
                if (details.account != null)
                  _DetailRow(label: 'Account', value: details.account!.name),
                _DetailRow(
                  label: 'Date',
                  value: DateFormat(
                    'MMM dd, yyyy',
                  ).format(transaction.transactionDate),
                ),
                _DetailRow(
                  label: 'Description',
                  value: transaction.description,
                ),
                if (transaction.notes != null)
                  _DetailRow(label: 'Notes', value: transaction.notes!),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: glass.expense,
                            side: BorderSide(
                              color: glass.expense.withValues(alpha: 0.5),
                            ),
                          ),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => const _DeleteDialog(),
                            );

                            if (confirmed == true && context.mounted) {
                              await ref.read(deleteTransactionProvider)(
                                transaction.id,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Transaction deleted'),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Delete'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        height: 52,
                        onPressed: () {
                          // TODO: Navigate to edit screen
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit feature coming soon'),
                            ),
                          );
                        },
                        icon: Icons.edit_rounded,
                        label: 'Edit',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text('Error: $error')),
      ),
    );
  }
}

/// Widget for displaying a detail row
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
