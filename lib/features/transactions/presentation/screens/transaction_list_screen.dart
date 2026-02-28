import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
        actions: [
          // Filter button
          PopupMenuButton<TransactionFilter>(
            icon: const Icon(Icons.filter_list),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                      children: TransactionDateRangeFilter.values.map((filter) {
                        final selectedFilter = ref.watch(
                          selectedTransactionDateRangeProvider,
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
                                          selectedTransactionDateRangeProvider
                                              .notifier,
                                        )
                                        .state =
                                    filter;
                              }
                            },
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions in this period',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try selecting a different date range',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Sort dates in descending order
                final sortedDates = filteredGrouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final transactions = filteredGrouped[date]!;

                    return _DateGroup(date: date, transactions: transactions);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error loading transactions: $error'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTransactionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: const Text('Add Income'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle, color: Colors.red),
              title: const Text('Add Expense'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: theme.colorScheme.surfaceContainerHighest,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (totalIncome > 0) ...[
                    Text(
                      '+${formatCurrency(ref, totalIncome)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (totalExpense > 0)
                    Text(
                      '-${formatCurrency(ref, totalExpense)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
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
    final transactionDetails = ref.watch(
      transactionDetailsProvider(transaction.id),
    );

    return transactionDetails.when(
      data: (details) {
        if (details == null) return const SizedBox.shrink();

        final isIncome = transaction.type == TransactionType.income;
        final amount = transaction.amountInCents / 100;

        return Dismissible(
          key: Key('transaction_${transaction.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Transaction'),
                content: const Text(
                  'Are you sure you want to delete this transaction?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
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
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: details.category?.color != null
                  ? Color(
                      int.parse(
                        details.category!.color!.replaceFirst('#', '0xFF'),
                      ),
                    )
                  : (isIncome ? Colors.green : Colors.red).withValues(
                      alpha: 0.2,
                    ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              transaction.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.category != null) Text(details.category!.name),
                if (details.account != null)
                  Text(
                    details.account!.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
            trailing: Text(
              '${isIncome ? '+' : '-'}${formatCurrency(ref, transaction.amountInCents)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => _showTransactionDetails(context, ref, transaction),
          ),
        );
      },
      loading: () => const ListTile(
        leading: CircularProgressIndicator(),
        title: Text('Loading...'),
      ),
      error: (error, stack) => ListTile(
        leading: const Icon(Icons.error, color: Colors.red),
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

/// Bottom sheet for transaction details
class _TransactionDetailsSheet extends ConsumerWidget {
  final TransactionEntity transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionDetails = ref.watch(
      transactionDetailsProvider(transaction.id),
    );

    return transactionDetails.when(
      data: (details) {
        if (details == null) return const SizedBox.shrink();

        final isIncome = transaction.type == TransactionType.income;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _DetailRow(
                  label: 'Amount',
                  value:
                      '${isIncome ? '+' : '-'}${formatCurrency(ref, transaction.amountInCents)}',
                  valueColor: isIncome ? Colors.green : Colors.red,
                ),
                _DetailRow(
                  label: 'Type',
                  value: isIncome ? 'Income' : 'Expense',
                ),
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Transaction'),
                              content: const Text(
                                'Are you sure you want to delete this transaction?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
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
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: Navigate to edit screen
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit feature coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

/// Widget for displaying a detail row
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
