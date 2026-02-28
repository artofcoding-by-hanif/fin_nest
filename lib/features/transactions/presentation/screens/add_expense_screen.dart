import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/accounts_table.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/add_expense_provider.dart';

/// Screen for adding a new expense transaction
class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CategoryEntity? _selectedCategory;
  AccountEntity? _selectedAccount;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectCategory(BuildContext context) async {
    final categories = await ref.read(expenseCategoriesProvider.future);

    if (!context.mounted) return;

    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      builder: (context) => _CategoryPicker(categories: categories),
    );

    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  Future<void> _selectAccount(BuildContext context) async {
    final accounts = await ref.read(userAccountsProvider.future);

    if (!context.mounted) return;

    final selected = await showModalBottomSheet<AccountEntity>(
      context: context,
      builder: (context) => _AccountPicker(accounts: accounts),
    );

    if (selected != null) {
      setState(() {
        _selectedAccount = selected;
      });
    }
  }

  Future<void> _saveExpense() async {
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

    try {
      final amount = double.parse(_amountController.text);
      final amountInCents = (amount * 100).round();

      await ref
          .read(addExpenseProvider.notifier)
          .addExpense(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amountInCents: amountInCents,
            description: _descriptionController.text,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
            transactionDate: _selectedDate,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding expense: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense'), elevation: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Amount field
            StyledTextFormField(
              controller: _amountController,
              labelText: 'Amount',
              prefixText: '${ref.watch(currentCurrencyProvider).symbol} ',
              prefixIcon: const Icon(Icons.attach_money),
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

            // Category selector
            StyledSelectorField(
              labelText: 'Category',
              displayText: _selectedCategory?.name ?? 'Select category',
              icon: Icons.category,
              hasValue: _selectedCategory != null,
              onTap: () => _selectCategory(context),
            ),
            const SizedBox(height: 20),

            // Account selector (Payment method)
            StyledSelectorField(
              labelText: 'Payment Method',
              displayText: _selectedAccount?.name ?? 'Select account',
              icon: Icons.account_balance_wallet,
              hasValue: _selectedAccount != null,
              onTap: () => _selectAccount(context),
            ),
            const SizedBox(height: 20),

            // Date selector
            StyledSelectorField(
              labelText: 'Date',
              displayText: DateFormat('MMM dd, yyyy').format(_selectedDate),
              icon: Icons.calendar_today,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),

            // Description field
            StyledTextFormField(
              controller: _descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description),
              hintText: 'e.g., Grocery shopping, Dinner',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Notes field
            StyledTextFormField(
              controller: _notesController,
              labelText: 'Notes (optional)',
              prefixIcon: const Icon(Icons.note),
              hintText: 'Add any additional notes',
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save button
            StyledElevatedButton(
              onPressed: _saveExpense,
              text: 'Save Expense',
              icon: Icons.check,
              backgroundColor: Colors.red,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Category picker widget
class _CategoryPicker extends StatelessWidget {
  final List<CategoryEntity> categories;

  const _CategoryPicker({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: Icon(
                    Icons.category,
                    color: category.color != null
                        ? Color(
                            int.parse(
                              category.color!.replaceFirst('#', '0xFF'),
                            ),
                          )
                        : null,
                  ),
                  title: Text(category.name),
                  onTap: () => Navigator.of(context).pop(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Account picker widget
class _AccountPicker extends StatelessWidget {
  final List<AccountEntity> accounts;

  const _AccountPicker({required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Account', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  leading: Icon(
                    _getAccountIcon(account.type),
                    color: account.color != null
                        ? Color(
                            int.parse(account.color!.replaceFirst('#', '0xFF')),
                          )
                        : null,
                  ),
                  title: Text(account.name),
                  subtitle: Text(account.type.name.toUpperCase()),
                  onTap: () => Navigator.of(context).pop(account),
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
