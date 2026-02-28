import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/accounts_table.dart';
import '../../../../core/database/tables/recurring_transactions_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/recurring_transaction_provider.dart';

/// Screen for adding recurring transactions
class AddRecurringTransactionScreen extends ConsumerStatefulWidget {
  const AddRecurringTransactionScreen({super.key});

  @override
  ConsumerState<AddRecurringTransactionScreen> createState() =>
      _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState
    extends ConsumerState<AddRecurringTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _payeeController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _transactionType = TransactionType.expense;
  CategoryEntity? _selectedCategory;
  AccountEntity? _selectedAccount;
  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _autoCreate = true;
  int _daysBeforeToCreate = 0;
  bool _enableNotifications = false;
  int _notificationMinutesBefore = 0;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recurring Transaction'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Transaction Type Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Type', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 12),
                    SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Income'),
                          icon: Icon(Icons.add_circle_outline),
                        ),
                      ],
                      selected: {_transactionType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          _transactionType = newSelection.first;
                          _selectedCategory =
                              null; // Reset category when type changes
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Amount field
            StyledTextFormField(
              controller: _amountController,
              labelText: 'Amount',
              prefixText: '${ref.watch(currentCurrencyProvider).symbol} ',
              prefixIcon: const Icon(Icons.attach_money),
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
            const SizedBox(height: 20),

            // Category field
            categories.when(
              data: (categoryList) => StyledSelectorField(
                labelText: 'Category',
                displayText: _selectedCategory?.name ?? 'Select category',
                icon: Icons.category,
                hasValue: _selectedCategory != null,
                onTap: () => _showCategoryPicker(context, categoryList),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading categories: $error'),
            ),
            const SizedBox(height: 20),

            // Account field
            accounts.when(
              data: (accountList) => StyledSelectorField(
                labelText: 'Account',
                displayText: _selectedAccount?.name ?? 'Select account',
                icon: Icons.account_balance_wallet,
                hasValue: _selectedAccount != null,
                onTap: () => _showAccountPicker(context, accountList),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading accounts: $error'),
            ),
            const SizedBox(height: 20),

            // Frequency field
            DropdownButtonFormField<RecurrenceFrequency>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
                helperText: 'How often should this repeat?',
              ),
              items: RecurrenceFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(_getFrequencyLabel(frequency)),
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

            // Start Date field
            StyledSelectorField(
              labelText: 'Start Date',
              displayText: DateFormat('MMM dd, yyyy').format(_startDate),
              icon: Icons.calendar_today,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: 20),

            // End Date field (optional)
            InkWell(
              onTap: () => _selectEndDate(context),
              borderRadius: BorderRadius.circular(16),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'End Date (Optional)',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: _endDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _endDate = null;
                            });
                          },
                        )
                      : const Icon(Icons.calendar_today),
                ),
                child: Text(
                  _endDate != null
                      ? DateFormat('MMM dd, yyyy').format(_endDate!)
                      : 'No end date',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _endDate == null
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description field
            StyledTextFormField(
              controller: _descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description),
              hintText: 'e.g., Monthly rent, Netflix subscription',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Payee field (optional)
            StyledTextFormField(
              controller: _payeeController,
              labelText: 'Payee (Optional)',
              prefixIcon: const Icon(Icons.person_outline),
              hintText: 'Who receives/sends this payment?',
            ),
            const SizedBox(height: 20),

            // Auto-create switch
            SwitchListTile(
              title: const Text('Auto-create transactions'),
              subtitle: const Text(
                'Automatically create transactions when due',
              ),
              value: _autoCreate,
              onChanged: (value) {
                setState(() {
                  _autoCreate = value;
                });
              },
            ),
            const SizedBox(height: 8),

            // Days before to create (only if auto-create is enabled)
            if (_autoCreate)
              DropdownButtonFormField<int>(
                initialValue: _daysBeforeToCreate,
                decoration: const InputDecoration(
                  labelText: 'Create transaction',
                  border: OutlineInputBorder(),
                  helperText: 'How many days before the due date?',
                ),
                items: [
                  const DropdownMenuItem(
                    value: 0,
                    child: Text('On the due date'),
                  ),
                  const DropdownMenuItem(value: 1, child: Text('1 day before')),
                  const DropdownMenuItem(
                    value: 2,
                    child: Text('2 days before'),
                  ),
                  const DropdownMenuItem(
                    value: 3,
                    child: Text('3 days before'),
                  ),
                  const DropdownMenuItem(
                    value: 7,
                    child: Text('1 week before'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _daysBeforeToCreate = value;
                    });
                  }
                },
              ),
            if (_autoCreate) const SizedBox(height: 20),

            // Notification settings
            SwitchListTile(
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
            const SizedBox(height: 8),

            // Notification timing (only if notifications are enabled)
            if (_enableNotifications)
              DropdownButtonFormField<int>(
                initialValue: _notificationMinutesBefore,
                decoration: const InputDecoration(
                  labelText: 'Notify me',
                  border: OutlineInputBorder(),
                  helperText: 'When to show the notification?',
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('On the due date')),
                  DropdownMenuItem(value: 1440, child: Text('1 day before')),
                  DropdownMenuItem(value: 2880, child: Text('2 days before')),
                  DropdownMenuItem(value: 4320, child: Text('3 days before')),
                  DropdownMenuItem(value: 10080, child: Text('1 week before')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _notificationMinutesBefore = value;
                    });
                  }
                },
              ),
            if (_enableNotifications) const SizedBox(height: 20),

            // Notes field (optional)
            StyledTextFormField(
              controller: _notesController,
              labelText: 'Notes (Optional)',
              prefixIcon: const Icon(Icons.note),
              hintText: 'Additional information',
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save button
            StyledElevatedButton(
              onPressed: _saveRecurringTransaction,
              text: 'Save Recurring Transaction',
              icon: Icons.check,
              backgroundColor: _transactionType == TransactionType.income
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, clear it
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 365)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _showCategoryPicker(
    BuildContext context,
    List<CategoryEntity> categories,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CategoryPicker(
        categories: categories,
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategory = category;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAccountPicker(BuildContext context, List<AccountEntity> accounts) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _AccountPicker(
        accounts: accounts,
        selectedAccount: _selectedAccount,
        onAccountSelected: (account) {
          setState(() {
            _selectedAccount = account;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _saveRecurringTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an account')));
      return;
    }

    final amount = double.parse(_amountController.text);
    final amountInCents = (amount * 100).round();

    await ref
        .read(addRecurringTransactionProvider.notifier)
        .addRecurringTransaction(
          accountId: _selectedAccount!.id,
          categoryId: _selectedCategory!.id,
          type: _transactionType,
          amountInCents: amountInCents,
          description: _descriptionController.text,
          frequency: _frequency,
          startDate: _startDate,
          endDate: _endDate,
          autoCreate: _autoCreate,
          daysBeforeToCreate: _daysBeforeToCreate,
          payee: _payeeController.text.isEmpty ? null : _payeeController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          enableNotifications: _enableNotifications,
          notificationMinutesBefore: _notificationMinutesBefore,
        );

    final state = ref.read(addRecurringTransactionProvider);

    state.when(
      data: (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recurring transaction saved successfully'),
            ),
          );
          Navigator.pop(context);
        }
      },
      loading: () {},
      error: (error, stack) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $error')));
        }
      },
    );
  }
}

/// Category picker modal bottom sheet
class _CategoryPicker extends StatelessWidget {
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final Function(CategoryEntity) onCategorySelected;

  const _CategoryPicker({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Select Category', style: theme.textTheme.titleLarge),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory?.id == category.id;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.color != null
                        ? Color(
                            int.parse(
                              category.color!.replaceFirst('#', '0xFF'),
                            ),
                          )
                        : theme.colorScheme.primary.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.category,
                      color: category.color != null
                          ? Colors.white
                          : theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(category.name),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  selected: isSelected,
                  onTap: () => onCategorySelected(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Account picker modal bottom sheet
class _AccountPicker extends StatelessWidget {
  final List<AccountEntity> accounts;
  final AccountEntity? selectedAccount;
  final Function(AccountEntity) onAccountSelected;

  const _AccountPicker({
    required this.accounts,
    required this.selectedAccount,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Select Account', style: theme.textTheme.titleLarge),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isSelected = selectedAccount?.id == account.id;

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(_getAccountIcon(account.type)),
                  ),
                  title: Text(account.name),
                  subtitle: Text(account.type.name.toUpperCase()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  selected: isSelected,
                  onTap: () => onAccountSelected(account),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return Icons.money;
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.investment:
        return Icons.trending_up;
      case AccountType.loan:
        return Icons.account_balance_wallet;
      case AccountType.other:
        return Icons.account_balance_wallet;
    }
  }
}
