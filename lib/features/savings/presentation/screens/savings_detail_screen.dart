import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../providers/savings_transactions_provider.dart';
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

  String _getTransactionTypeLabel(SavingsTransactionType type) {
    switch (type) {
      case SavingsTransactionType.deposit:
        return 'Deposit';
      case SavingsTransactionType.withdrawal:
        return 'Withdrawal';
      case SavingsTransactionType.interest:
        return 'Interest';
      case SavingsTransactionType.dividend:
        return 'Dividend';
      case SavingsTransactionType.appreciation:
        return 'Appreciation';
      case SavingsTransactionType.depreciation:
        return 'Depreciation';
    }
  }

  IconData _getTransactionTypeIcon(SavingsTransactionType type) {
    switch (type) {
      case SavingsTransactionType.deposit:
        return Icons.add_circle_outline;
      case SavingsTransactionType.withdrawal:
        return Icons.remove_circle_outline;
      case SavingsTransactionType.interest:
        return Icons.trending_up;
      case SavingsTransactionType.dividend:
        return Icons.payments;
      case SavingsTransactionType.appreciation:
        return Icons.arrow_upward;
      case SavingsTransactionType.depreciation:
        return Icons.arrow_downward;
    }
  }

  Color _getTransactionColor(SavingsTransactionType type) {
    switch (type) {
      case SavingsTransactionType.deposit:
      case SavingsTransactionType.interest:
      case SavingsTransactionType.dividend:
      case SavingsTransactionType.appreciation:
        return Colors.green;
      case SavingsTransactionType.withdrawal:
      case SavingsTransactionType.depreciation:
        return Colors.red;
    }
  }

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

    return Scaffold(
      appBar: AppBar(
        title: Text(savings.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Current Value',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                CurrencyText(
                  amountInCents: savings.currentValueInCents,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Invested',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        CurrencyText(
                          amountInCents: savings.investedAmountInCents,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Returns',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            CurrencyText(
                              amountInCents: returns,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: returns >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${returnsPercentage.toStringAsFixed(2)}%)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: returns >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                      children: SavingsDateRangeFilter.values.map((filter) {
                        final selectedFilter = ref.watch(
                          selectedSavingsDateRangeProvider,
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
                                          selectedSavingsDateRangeProvider
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

          // Transaction History Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
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
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first transaction to get started',
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions in this period',
                          style: theme.textTheme.titleMedium,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: transactionsWithBalance.length,
                  itemBuilder: (context, index) {
                    final item = transactionsWithBalance[index];
                    final transaction =
                        item['transaction'] as SavingsTransactionEntity;
                    final balance = item['balance'] as int;
                    final color = _getTransactionColor(transaction.type);

                    return Dismissible(
                      key: Key('transaction_${transaction.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
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
                                  foregroundColor: Colors.red,
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
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withValues(alpha: 0.1),
                            child: Icon(
                              _getTransactionTypeIcon(transaction.type),
                              color: color,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            _getTransactionTypeLabel(transaction.type),
                          ),
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
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
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
                                        Icons.link,
                                        size: 12,
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
                              Text(
                                'Balance: ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              CurrencyText(
                                amountInCents: balance,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddSavingsTransactionScreen(
                                      savingsId: savings.id,
                                      savingsName: savings.name,
                                      transaction: transaction,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
