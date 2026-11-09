import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/recurring_transactions_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass/glass.dart';
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

    return GlassScaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded),
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
                      Icons.check_circle_rounded,
                      color: _showInactiveOnly
                          ? theme.colorScheme.onSurfaceVariant
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
                      Icons.cancel_rounded,
                      color: _showInactiveOnly
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
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
            return EmptyState(
              title: _showInactiveOnly
                  ? 'No inactive recurring transactions'
                  : 'No recurring transactions yet',
              message: 'Tap the + button to add one',
              icon: Icons.repeat_rounded,
              color: theme.colorScheme.primary,
            );
          }

          // Group by frequency
          final groupedTransactions = _groupByFrequency(filteredTransactions);

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: groupedTransactions.length,
            itemBuilder: (context, index) {
              final entry = groupedTransactions.entries.elementAt(index);
              final frequency = entry.key;
              final items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 10),
                    child: Text(
                      _getFrequencyGroupLabel(frequency),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: 1.4,
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
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error loading recurring transactions: $error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: GradientFab(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecurringTransactionScreen(),
            ),
          );
        },
        icon: Icons.add_rounded,
        tooltip: 'Add recurring transaction',
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

    final glass = context.glass;
    final typeColor = isExpense ? glass.expense : glass.income;
    final category = transaction.categoryId == null
        ? null
        : categoriesAsync.asData?.value.cast<CategoryEntity?>().firstWhere(
            (c) => c?.id == transaction.categoryId,
            orElse: () => null,
          );
    final muted = theme.colorScheme.onSurfaceVariant;

    return GlassCard(
      blur: false,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      radius: AppTheme.radiusM,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Category / transaction type icon
              GlassIcon(
                category != null
                    ? CategoryVisuals.icon(
                        category.icon,
                        fallback: isExpense
                            ? Icons.remove_circle_outline_rounded
                            : Icons.add_circle_outline_rounded,
                      )
                    : (isExpense
                          ? Icons.remove_circle_outline_rounded
                          : Icons.add_circle_outline_rounded),
                color: category != null
                    ? CategoryVisuals.vivid(category.color, fallback: typeColor)
                    : typeColor,
                size: 44,
              ),
              const SizedBox(width: 14),
              // Description and category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    categoriesAsync.when(
                      data: (categories) {
                        if (transaction.categoryId == null) {
                          return Text(
                            'No category',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: muted,
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
                            color: muted,
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount
              Text(
                formattedAmount,
                style: AppTypography.amount(18).copyWith(color: typeColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Next occurrence and status
          Row(
            children: [
              Icon(Icons.event_rounded, size: 16, color: muted),
              const SizedBox(width: 6),
              Text(
                'Next: ${DateFormat('MMM dd, yyyy').format(transaction.nextOccurrence)}',
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
              const Spacer(),
              if (!transaction.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: glass.expense.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: glass.expense.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'INACTIVE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: glass.expense,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
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

    final glass = context.glass;
    final typeColor = isExpense ? glass.expense : glass.income;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  GlassIcon(
                    isExpense
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded,
                    color: typeColor,
                    size: 56,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedAmount,
                          style: AppTypography.amount(
                            26,
                          ).copyWith(color: typeColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                children: [
                  GlassCard(
                    blur: false,
                    radius: AppTheme.radiusM,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.category_rounded,
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
                          icon: Icons.account_balance_wallet_rounded,
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
                          icon: Icons.repeat_rounded,
                          label: 'Frequency',
                          value: _getFrequencyLabel(transaction.frequency),
                        ),
                        _DetailRow(
                          icon: Icons.event_rounded,
                          label: 'Start Date',
                          value: DateFormat(
                            'MMM dd, yyyy',
                          ).format(transaction.startDate),
                        ),
                        _DetailRow(
                          icon: Icons.event_busy_rounded,
                          label: 'End Date',
                          value: transaction.endDate != null
                              ? DateFormat(
                                  'MMM dd, yyyy',
                                ).format(transaction.endDate!)
                              : 'No end date',
                        ),
                        _DetailRow(
                          icon: Icons.event_available_rounded,
                          label: 'Next Occurrence',
                          value: DateFormat(
                            'MMM dd, yyyy',
                          ).format(transaction.nextOccurrence),
                        ),
                        if (transaction.lastOccurrence != null)
                          _DetailRow(
                            icon: Icons.history_rounded,
                            label: 'Last Occurrence',
                            value: DateFormat(
                              'MMM dd, yyyy',
                            ).format(transaction.lastOccurrence!),
                          ),
                        if (transaction.payee != null)
                          _DetailRow(
                            icon: Icons.person_rounded,
                            label: 'Payee',
                            value: transaction.payee!,
                          ),
                        _DetailRow(
                          icon: Icons.auto_awesome_rounded,
                          label: 'Auto-create',
                          value: transaction.autoCreate ? 'Enabled' : 'Disabled',
                        ),
                        if (transaction.autoCreate)
                          _DetailRow(
                            icon: Icons.schedule_rounded,
                            label: 'Create before',
                            value: _getDaysBeforeLabel(
                              transaction.daysBeforeToCreate,
                            ),
                          ),
                        if (transaction.notes != null &&
                            transaction.notes!.isNotEmpty)
                          _DetailRow(
                            icon: Icons.notes_rounded,
                            label: 'Notes',
                            value: transaction.notes!,
                          ),
                        _DetailRow(
                          icon: Icons.info_rounded,
                          label: 'Status',
                          value: transaction.isActive ? 'Active' : 'Inactive',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    // Edit button
                    GradientButton(
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
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      height: 52,
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
                                  ? Icons.pause_circle_rounded
                                  : Icons.play_circle_rounded,
                            ),
                            label: Text(
                              transaction.isActive ? 'Deactivate' : 'Activate',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
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
                                        backgroundColor: glass.expense,
                                        foregroundColor: Colors.white,
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
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: glass.expense,
                              side: BorderSide(
                                color: glass.expense.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
          GlassIcon(
            icon,
            color: theme.colorScheme.primary,
            size: 36,
            glow: false,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
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
