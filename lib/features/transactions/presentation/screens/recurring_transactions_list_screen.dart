import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/recurring_transactions_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../providers/recurring_transaction_provider.dart';
import 'add_recurring_transaction_screen.dart';
import 'edit_recurring_transaction_screen.dart';

/// Screen for viewing and managing recurring transactions
class RecurringTransactionsListScreen extends ConsumerStatefulWidget {
  const RecurringTransactionsListScreen({super.key});

  @override
  ConsumerState<RecurringTransactionsListScreen> createState() =>
      _RecurringTransactionsListScreenState();
}

class _RecurringTransactionsListScreenState
    extends ConsumerState<RecurringTransactionsListScreen> {
  bool _showInactiveOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recurringTransactionsAsync = ref.watch(
      allRecurringTransactionsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                if (value == 'active') {
                  _showInactiveOnly = false;
                } else if (value == 'inactive') {
                  _showInactiveOnly = true;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'active',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _showInactiveOnly
                          ? null
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Active Only'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'inactive',
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel,
                      color: _showInactiveOnly
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Inactive Only'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: recurringTransactionsAsync.when(
        data: (transactions) {
          // Filter transactions based on active/inactive toggle
          final filteredTransactions = _showInactiveOnly
              ? transactions.where((t) => !t.isActive).toList()
              : transactions.where((t) => t.isActive).toList();

          if (filteredTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.repeat,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showInactiveOnly
                        ? 'No inactive recurring transactions'
                        : 'No recurring transactions yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add one',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          // Group by frequency
          final groupedTransactions = _groupByFrequency(filteredTransactions);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedTransactions.length,
            itemBuilder: (context, index) {
              final entry = groupedTransactions.entries.elementAt(index);
              final frequency = entry.key;
              final items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      _getFrequencyGroupLabel(frequency),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...items.map(
                    (transaction) => _RecurringTransactionCard(
                      transaction: transaction,
                      onTap: () =>
                          _showTransactionDetails(context, transaction),
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading recurring transactions: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecurringTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Map<RecurrenceFrequency, List<RecurringTransactionEntity>> _groupByFrequency(
    List<RecurringTransactionEntity> transactions,
  ) {
    final grouped = <RecurrenceFrequency, List<RecurringTransactionEntity>>{};

    for (final transaction in transactions) {
      if (!grouped.containsKey(transaction.frequency)) {
        grouped[transaction.frequency] = [];
      }
      grouped[transaction.frequency]!.add(transaction);
    }

    // Sort each group by next occurrence
    for (final key in grouped.keys) {
      grouped[key]!.sort(
        (a, b) => a.nextOccurrence.compareTo(b.nextOccurrence),
      );
    }

    return grouped;
  }

  String _getFrequencyGroupLabel(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return 'DAILY';
      case RecurrenceFrequency.weekly:
        return 'WEEKLY';
      case RecurrenceFrequency.biweekly:
        return 'BI-WEEKLY';
      case RecurrenceFrequency.monthly:
        return 'MONTHLY';
      case RecurrenceFrequency.quarterly:
        return 'QUARTERLY';
      case RecurrenceFrequency.yearly:
        return 'YEARLY';
    }
  }

  void _showTransactionDetails(
    BuildContext context,
    RecurringTransactionEntity transaction,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _RecurringTransactionDetailsSheet(transaction: transaction),
    );
  }
}

/// Card widget for displaying a recurring transaction
class _RecurringTransactionCard extends ConsumerWidget {
  final RecurringTransactionEntity transaction;
  final VoidCallback onTap;

  const _RecurringTransactionCard({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Type is stored as: 0 = expense, 1 = income
    final transactionType = transaction.type == 0
        ? TransactionType.expense
        : TransactionType.income;
    final isExpense = transactionType == TransactionType.expense;
    final formattedAmount = formatCurrency(ref, transaction.amountInCents);

    // Get category name
    final categoriesAsync = isExpense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Transaction type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isExpense
                          ? theme.colorScheme.errorContainer
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isExpense
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      color: isExpense
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Description and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        categoriesAsync.when(
                          data: (categories) {
                            if (transaction.categoryId == null) {
                              return Text(
                                'No category',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              );
                            }

                            final category = categories
                                .cast<CategoryEntity?>()
                                .firstWhere(
                                  (c) => c?.id == transaction.categoryId,
                                  orElse: () => null,
                                );

                            return Text(
                              category?.name ?? 'Unknown category',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (error, stack) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Text(
                    formattedAmount,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isExpense
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Next occurrence and status
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Next: ${DateFormat('MMM dd, yyyy').format(transaction.nextOccurrence)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  if (!transaction.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'INACTIVE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Details sheet for a recurring transaction
class _RecurringTransactionDetailsSheet extends ConsumerWidget {
  final RecurringTransactionEntity transaction;

  const _RecurringTransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Type is stored as: 0 = expense, 1 = income
    final transactionType = transaction.type == 0
        ? TransactionType.expense
        : TransactionType.income;
    final isExpense = transactionType == TransactionType.expense;
    final formattedAmount = formatCurrency(ref, transaction.amountInCents);

    // Get category and account
    final categoriesAsync = isExpense
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);
    final accountsAsync = ref.watch(userAccountsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isExpense
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isExpense ? Icons.remove_circle : Icons.add_circle,
                        color: isExpense
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.description,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedAmount,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: isExpense
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _DetailRow(
                      icon: Icons.category,
                      label: 'Category',
                      value: categoriesAsync.when(
                        data: (categories) {
                          if (transaction.categoryId == null) {
                            return 'No category';
                          }

                          final category = categories
                              .cast<CategoryEntity?>()
                              .firstWhere(
                                (c) => c?.id == transaction.categoryId,
                                orElse: () => null,
                              );
                          return category?.name ?? 'Unknown category';
                        },
                        loading: () => 'Loading...',
                        error: (error, stack) => 'Unknown',
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.account_balance_wallet,
                      label: 'Account',
                      value: accountsAsync.when(
                        data: (accounts) {
                          final account = accounts.firstWhere(
                            (a) => a.id == transaction.accountId,
                            orElse: () => accounts.first,
                          );
                          return account.name;
                        },
                        loading: () => 'Loading...',
                        error: (error, stack) => 'Unknown',
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.repeat,
                      label: 'Frequency',
                      value: _getFrequencyLabel(transaction.frequency),
                    ),
                    _DetailRow(
                      icon: Icons.event,
                      label: 'Start Date',
                      value: DateFormat(
                        'MMM dd, yyyy',
                      ).format(transaction.startDate),
                    ),
                    _DetailRow(
                      icon: Icons.event_busy,
                      label: 'End Date',
                      value: transaction.endDate != null
                          ? DateFormat(
                              'MMM dd, yyyy',
                            ).format(transaction.endDate!)
                          : 'No end date',
                    ),
                    _DetailRow(
                      icon: Icons.event_available,
                      label: 'Next Occurrence',
                      value: DateFormat(
                        'MMM dd, yyyy',
                      ).format(transaction.nextOccurrence),
                    ),
                    if (transaction.lastOccurrence != null)
                      _DetailRow(
                        icon: Icons.history,
                        label: 'Last Occurrence',
                        value: DateFormat(
                          'MMM dd, yyyy',
                        ).format(transaction.lastOccurrence!),
                      ),
                    if (transaction.payee != null)
                      _DetailRow(
                        icon: Icons.person,
                        label: 'Payee',
                        value: transaction.payee!,
                      ),
                    _DetailRow(
                      icon: Icons.auto_awesome,
                      label: 'Auto-create',
                      value: transaction.autoCreate ? 'Enabled' : 'Disabled',
                    ),
                    if (transaction.autoCreate)
                      _DetailRow(
                        icon: Icons.schedule,
                        label: 'Create before',
                        value: _getDaysBeforeLabel(
                          transaction.daysBeforeToCreate,
                        ),
                      ),
                    if (transaction.notes != null &&
                        transaction.notes!.isNotEmpty)
                      _DetailRow(
                        icon: Icons.notes,
                        label: 'Notes',
                        value: transaction.notes!,
                      ),
                    _DetailRow(
                      icon: Icons.info,
                      label: 'Status',
                      value: transaction.isActive ? 'Active' : 'Inactive',
                    ),
                  ],
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Edit button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditRecurringTransactionScreen(
                                recurringTransaction: transaction,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Activate/Deactivate and Delete buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              Navigator.pop(context);
                              final toggleFn = ref.read(
                                toggleRecurringTransactionProvider,
                              );
                              await toggleFn(
                                transaction.id,
                                !transaction.isActive,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      transaction.isActive
                                          ? 'Recurring transaction deactivated'
                                          : 'Recurring transaction activated',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              transaction.isActive
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                            ),
                            label: Text(
                              transaction.isActive ? 'Deactivate' : 'Activate',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Delete Recurring Transaction',
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete this recurring transaction? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('CANCEL'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.error,
                                      ),
                                      child: const Text('DELETE'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true && context.mounted) {
                                final deleteFn = ref.read(
                                  deleteRecurringTransactionProvider,
                                );
                                await deleteFn(transaction.id);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Recurring transaction deleted',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
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
      },
    );
  }

  String _getFrequencyLabel(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Bi-weekly (Every 2 weeks)';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.quarterly:
        return 'Quarterly (Every 3 months)';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }

  String _getDaysBeforeLabel(int days) {
    if (days == 0) return 'On the due date';
    if (days == 1) return '1 day before';
    if (days == 7) return '1 week before';
    return '$days days before';
  }
}

/// Detail row widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
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
