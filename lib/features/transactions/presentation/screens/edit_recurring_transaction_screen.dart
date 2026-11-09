import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/accounts_table.dart';
import '../../../../core/database/tables/recurring_transactions_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/recurring_transaction_provider.dart';

/// Screen for editing recurring transactions
class EditRecurringTransactionScreen extends ConsumerStatefulWidget {
  final RecurringTransactionEntity recurringTransaction;

  const EditRecurringTransactionScreen({
    super.key,
    required this.recurringTransaction,
  });

  @override
  ConsumerState<EditRecurringTransactionScreen> createState() =>
      _EditRecurringTransactionScreenState();
}

class _EditRecurringTransactionScreenState
    extends ConsumerState<EditRecurringTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _payeeController = TextEditingController();
  final _notesController = TextEditingController();

  late TransactionType _transactionType;
  CategoryEntity? _selectedCategory;
  AccountEntity? _selectedAccount;
  late RecurrenceFrequency _frequency;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _autoCreate;
  late int _daysBeforeToCreate;
  late DateTime _nextOccurrence;
  late bool _enableNotifications;
  late int _notificationMinutesBefore;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final recurring = widget.recurringTransaction;

    // Initialize controllers with existing values
    _amountController.text = (recurring.amountInCents / 100).toStringAsFixed(2);
    _descriptionController.text = recurring.description;
    _payeeController.text = recurring.payee ?? '';
    _notesController.text = recurring.notes ?? '';

    // Initialize state variables
    // Type is stored as: 0 = expense, 1 = income
    _transactionType = recurring.type == 0
        ? TransactionType.expense
        : TransactionType.income;
    _frequency = recurring.frequency;
    _startDate = recurring.startDate;
    _endDate = recurring.endDate;
    _autoCreate = recurring.autoCreate;
    _daysBeforeToCreate = recurring.daysBeforeToCreate;
    _nextOccurrence = recurring.nextOccurrence;
    _enableNotifications = recurring.enableNotifications;
    _notificationMinutesBefore = recurring.notificationMinutesBefore;

    // Load category and account
    _loadCategoryAndAccount();
  }

  Future<void> _loadCategoryAndAccount() async {
    final db = ref.read(databaseProvider);

    // Load category
    if (widget.recurringTransaction.categoryId != null) {
      final category = await db.categoriesDao.getCategoryById(
        widget.recurringTransaction.categoryId!,
      );
      if (mounted) {
        setState(() {
          _selectedCategory = category;
        });
      }
    }

    // Load account
    final account = await db.accountsDao.getAccountById(
      widget.recurringTransaction.accountId,
    );
    if (mounted) {
      setState(() {
        _selectedAccount = account;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _payeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _transactionType == TransactionType.income
        ? ref.watch(incomeCategoriesProvider)
        : ref.watch(expenseCategoriesProvider);
    final accounts = ref.watch(userAccountsProvider);

    final glass = context.glass;
    final isIncome = _transactionType == TransactionType.income;

    return GlassScaffold(
      appBar: AppBar(title: const Text('Edit Recurring Transaction')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            // Transaction Type
            GlassCard(
              padding: const EdgeInsets.all(16),
              tint: isIncome ? glass.income : glass.expense,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaction Type', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                          icon: Icon(Icons.remove_circle_outline_rounded),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Income'),
                          icon: Icon(Icons.add_circle_outline_rounded),
                        ),
                      ],
                      selected: {_transactionType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          _transactionType = newSelection.first;
                          _selectedCategory = null; // Reset category
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Amount
            StyledTextFormField(
              controller: _amountController,
              labelText: 'Amount',
              prefixText: '${ref.watch(currentCurrencyProvider).symbol} ',
              prefixIcon: const Icon(Icons.payments_rounded),
              hintText: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            StyledTextFormField(
              controller: _descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description_rounded),
              hintText: 'e.g., Monthly rent, Netflix subscription',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            categories.when(
              data: (categoryList) {
                // Check if selected category is in the current list
                final isSelectedCategoryValid =
                    _selectedCategory != null &&
                    categoryList.any((c) => c.id == _selectedCategory!.id);

                return DropdownButtonFormField<CategoryEntity>(
                  value: isSelectedCategoryValid ? _selectedCategory : null,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categoryList.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          GlassIcon(
                            CategoryVisuals.icon(category.icon),
                            color: CategoryVisuals.vivid(category.color),
                            size: 28,
                            glow: false,
                          ),
                          const SizedBox(width: 12),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                'Error: $error',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account
            accounts.when(
              data: (accountList) {
                return DropdownButtonFormField<AccountEntity>(
                  value: _selectedAccount,
                  decoration: const InputDecoration(labelText: 'Account'),
                  items: accountList.map((account) {
                    return DropdownMenuItem(
                      value: account,
                      child: Row(
                        children: [
                          GlassIcon(
                            _getAccountIcon(account.type),
                            color: CategoryVisuals.vivid(
                              account.color,
                              fallback: theme.colorScheme.primary,
                            ),
                            size: 28,
                            glow: false,
                          ),
                          const SizedBox(width: 12),
                          Text(account.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccount = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an account';
                    }
                    return null;
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                'Error: $error',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Frequency
            DropdownButtonFormField<RecurrenceFrequency>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                prefixIcon: Icon(Icons.repeat_rounded),
              ),
              items: RecurrenceFrequency.values.map((freq) {
                return DropdownMenuItem(
                  value: freq,
                  child: Text(_getFrequencyLabel(freq)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _frequency = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Dates
            GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text('Dates', style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),

                  // Start Date
                  _DateRow(
                    icon: Icons.calendar_today_rounded,
                    color: theme.colorScheme.primary,
                    title: 'Start Date',
                    value: DateFormat.yMMMd().format(_startDate),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                  ),

                  // Next Occurrence
                  _DateRow(
                    icon: Icons.event_available_rounded,
                    color: theme.colorScheme.secondary,
                    title: 'Next Occurrence',
                    value: DateFormat.yMMMd().format(_nextOccurrence),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _nextOccurrence,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _nextOccurrence = date;
                        });
                      }
                    },
                  ),

                  // End Date
                  _DateRow(
                    icon: Icons.event_busy_rounded,
                    color: theme.colorScheme.tertiary,
                    title: 'End Date (Optional)',
                    value: _endDate != null
                        ? DateFormat.yMMMd().format(_endDate!)
                        : 'No end date',
                    trailing: _endDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              setState(() {
                                _endDate = null;
                              });
                            },
                          )
                        : null,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            _endDate ??
                            DateTime.now().add(const Duration(days: 365)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auto-create settings
            GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-create Settings',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: GlassIcon(
                      Icons.auto_awesome_rounded,
                      color: theme.colorScheme.primary,
                      size: 40,
                    ),
                    title: const Text('Auto-create transactions'),
                    subtitle: const Text(
                      'Automatically create transactions on schedule',
                    ),
                    value: _autoCreate,
                    onChanged: (value) {
                      setState(() {
                        _autoCreate = value;
                      });
                    },
                  ),
                  if (_autoCreate) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _daysBeforeToCreate.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Days before to create',
                        helperText: 'Create transaction X days before due date',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        final days = int.tryParse(value);
                        if (days != null) {
                          _daysBeforeToCreate = days;
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notification settings
            GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notifications', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const GlassIcon(
                      Icons.notifications_active_rounded,
                      color: AppColors.warning,
                      size: 40,
                    ),
                    title: const Text('Enable Notifications'),
                    subtitle: const Text(
                      'Get notified before the transaction is due',
                    ),
                    value: _enableNotifications,
                    onChanged: (value) {
                      setState(() {
                        _enableNotifications = value;
                      });
                    },
                  ),
                  if (_enableNotifications) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _notificationMinutesBefore,
                      decoration: const InputDecoration(
                        labelText: 'Notify me',
                        helperText: 'When to show the notification?',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('On the due date'),
                        ),
                        DropdownMenuItem(
                          value: 1440,
                          child: Text('1 day before'),
                        ),
                        DropdownMenuItem(
                          value: 2880,
                          child: Text('2 days before'),
                        ),
                        DropdownMenuItem(
                          value: 4320,
                          child: Text('3 days before'),
                        ),
                        DropdownMenuItem(
                          value: 10080,
                          child: Text('1 week before'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _notificationMinutesBefore = value;
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payee field (optional)
            StyledTextFormField(
              controller: _payeeController,
              labelText: 'Payee (Optional)',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              hintText: 'Who receives/sends this payment?',
            ),
            const SizedBox(height: 16),

            // Notes field (optional)
            StyledTextFormField(
              controller: _notesController,
              labelText: 'Notes (Optional)',
              prefixIcon: const Icon(Icons.notes_rounded),
              hintText: 'Additional information',
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save button
            GradientButton(
              onPressed: _saveRecurringTransaction,
              label: 'Save Changes',
              icon: Icons.check_rounded,
              gradient: isIncome
                  ? AppColors.incomeGradient
                  : AppColors.expenseGradient,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return Icons.payments_rounded;
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.creditCard:
        return Icons.credit_card_rounded;
      case AccountType.investment:
        return Icons.trending_up_rounded;
      case AccountType.loan:
        return Icons.account_balance_wallet_rounded;
      case AccountType.other:
        return Icons.account_balance_wallet_rounded;
    }
  }

  String _getFrequencyLabel(RecurrenceFrequency frequency) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return 'Daily';
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Bi-weekly';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.quarterly:
        return 'Quarterly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }

  Future<void> _saveRecurringTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null || _selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select category and account'),
          backgroundColor: context.glass.expense,
        ),
      );
      return;
    }

    try {
      final amountInCents = (double.parse(_amountController.text) * 100)
          .round();

      // Create updated entity
      // Type is stored as: 0 = expense, 1 = income
      final updatedTransaction = RecurringTransactionEntity(
        id: widget.recurringTransaction.id,
        userId: widget.recurringTransaction.userId,
        accountId: _selectedAccount!.id,
        categoryId: _selectedCategory?.id,
        type: _transactionType == TransactionType.income ? 1 : 0,
        amountInCents: amountInCents,
        currency: widget.recurringTransaction.currency,
        description: _descriptionController.text,
        frequency: _frequency,
        startDate: _startDate,
        endDate: _endDate,
        nextOccurrence: _nextOccurrence,
        isActive: widget.recurringTransaction.isActive,
        autoCreate: _autoCreate,
        daysBeforeToCreate: _daysBeforeToCreate,
        payee: _payeeController.text.isEmpty ? null : _payeeController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        enableNotifications: _enableNotifications,
        notificationMinutesBefore: _notificationMinutesBefore,
        createdAt: widget.recurringTransaction.createdAt,
        updatedAt: DateTime.now(),
      );

      final updateRecurring = ref.read(updateRecurringTransactionProvider);
      await updateRecurring(updatedTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Recurring transaction updated successfully'),
            backgroundColor: context.glass.income,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: context.glass.expense),
        );
      }
    }
  }
}

/// Tappable date row inside the Dates glass card.
class _DateRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final Widget? trailing;
  final VoidCallback onTap;

  const _DateRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 8),
      leading: GlassIcon(icon, color: color, size: 40),
      title: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: trailing,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      onTap: onTap,
    );
  }
}
