import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/add_income_provider.dart';

/// Screen for adding income transactions
class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
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
    final picked = await showDatePicker(
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
    final categories = await ref.read(incomeCategoriesProvider.future);

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

  Future<void> _saveIncome() async {
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
      // Convert amount to cents
      final amount = double.parse(_amountController.text);
      final amountInCents = (amount * 100).round();

      await ref
          .read(addIncomeProvider.notifier)
          .addIncome(
            accountId: _selectedAccount!.id,
            categoryId: _selectedCategory!.id,
            amountInCents: amountInCents,
            description: _descriptionController.text,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
            transactionDate: _selectedDate,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding income: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income'), elevation: 0),
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
            StyledSelectorField(
              labelText: 'Category',
              displayText: _selectedCategory?.name ?? 'Select category',
              icon: Icons.category,
              hasValue: _selectedCategory != null,
              onTap: () => _selectCategory(context),
            ),
            const SizedBox(height: 20),

            // Account field
            StyledSelectorField(
              labelText: 'Account',
              displayText: _selectedAccount?.name ?? 'Select account',
              icon: Icons.account_balance_wallet,
              hasValue: _selectedAccount != null,
              onTap: () => _selectAccount(context),
            ),
            const SizedBox(height: 20),

            // Date field
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
              hintText: 'e.g., Monthly salary, Freelance project',
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
              onPressed: _saveIncome,
              text: 'Save Income',
              icon: Icons.check,
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Category picker modal bottom sheet
class _CategoryPicker extends StatelessWidget {
  final List<CategoryEntity> categories;

  const _CategoryPicker({required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Category', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No income categories available'),
            )
          else
            ...categories.map((category) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.color != null
                      ? Color(
                          int.parse(category.color!.replaceFirst('#', '0xFF')),
                        )
                      : theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.category,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(category.name),
                onTap: () => Navigator.of(context).pop(category),
              );
            }),
        ],
      ),
    );
  }
}

/// Account picker modal bottom sheet
class _AccountPicker extends StatelessWidget {
  final List<AccountEntity> accounts;

  const _AccountPicker({required this.accounts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Account', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          if (accounts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No accounts available'),
            )
          else
            ...accounts.map((account) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: account.color != null
                      ? Color(
                          int.parse(account.color!.replaceFirst('#', '0xFF')),
                        )
                      : theme.colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(account.name),
                subtitle: Text(account.type.name.toUpperCase()),
                onTap: () => Navigator.of(context).pop(account),
              );
            }),
        ],
      ),
    );
  }
}
