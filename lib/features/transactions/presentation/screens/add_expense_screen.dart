import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/accounts_table.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/glass/glass.dart';
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

      await ref.read(addExpenseProvider.notifier).addExpense(
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
    return GlassScaffold(
      appBar: AppBar(title: const Text('Add Expense')),
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
              prefixIcon: const Icon(Icons.payments_rounded),
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
              icon: Icons.category_rounded,
              hasValue: _selectedCategory != null,
              onTap: () => _selectCategory(context),
            ),
            const SizedBox(height: 20),

            // Account selector (Payment method)
            StyledSelectorField(
              labelText: 'Payment Method',
              displayText: _selectedAccount?.name ?? 'Select account',
              icon: Icons.account_balance_wallet_rounded,
              hasValue: _selectedAccount != null,
              onTap: () => _selectAccount(context),
            ),
            const SizedBox(height: 20),

            // Date selector
            StyledSelectorField(
              labelText: 'Date',
              displayText: DateFormat('MMM dd, yyyy').format(_selectedDate),
              icon: Icons.calendar_today_rounded,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),

            // Description field
            StyledTextFormField(
              controller: _descriptionController,
              labelText: 'Description',
              prefixIcon: const Icon(Icons.description_rounded),
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
              prefixIcon: const Icon(Icons.sticky_note_2_rounded),
              hintText: 'Add any additional notes',
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save button
            GradientButton(
              onPressed: _saveExpense,
              label: 'Save Expense',
              icon: Icons.check_rounded,
              gradient: AppColors.expenseGradient,
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetTitle('Select Category'),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    _CategoryRow(category: categories[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryEntity category;

  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return GlassTile(
      leading: GlassIcon(
        CategoryVisuals.icon(category.icon),
        color: CategoryVisuals.vivid(
          category.color,
          fallback: AppColors.expense,
        ),
        size: 40,
      ),
      title: Text(category.name),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => Navigator.of(context).pop(category),
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetTitle('Select Account'),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return GlassTile(
                    leading: GlassIcon(
                      _accountIcon(account),
                      color: CategoryVisuals.vivid(
                        account.color,
                        fallback: theme.colorScheme.secondary,
                      ),
                      size: 40,
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
      ),
    );
  }
}

/// Glass-styled header for the picker sheets.
class _SheetTitle extends StatelessWidget {
  final String title;

  const _SheetTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

IconData _accountIcon(AccountEntity account) {
  switch (account.type) {
    case AccountType.cash:
      return Icons.payments_rounded;
    case AccountType.bank:
      return Icons.account_balance_rounded;
    case AccountType.creditCard:
      return Icons.credit_card_rounded;
    case AccountType.investment:
      return Icons.trending_up_rounded;
    case AccountType.loan:
    case AccountType.other:
      return Icons.account_balance_wallet_rounded;
  }
}
