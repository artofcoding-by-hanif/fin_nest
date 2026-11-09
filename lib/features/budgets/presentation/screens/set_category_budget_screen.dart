import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/budget_provider.dart';

/// Screen to set or edit budget for a category
class SetCategoryBudgetScreen extends ConsumerStatefulWidget {
  final int? categoryId;

  const SetCategoryBudgetScreen({super.key, this.categoryId});

  @override
  ConsumerState<SetCategoryBudgetScreen> createState() =>
      _SetCategoryBudgetScreenState();
}

class _SetCategoryBudgetScreenState
    extends ConsumerState<SetCategoryBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  int? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    if (widget.categoryId != null) {
      _loadCategoryBudget();
    }
  }

  Future<void> _loadCategoryBudget() async {
    final db = ref.read(databaseProvider);
    final category = await db.categoriesDao.getCategoryById(widget.categoryId!);
    if (category != null && category.budgetLimitInCents != null) {
      _amountController.text = (category.budgetLimitInCents! / 100)
          .toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final amountInCents = (amount * 100).round();

      final db = ref.read(databaseProvider);
      final category = await db.categoriesDao.getCategoryById(
        _selectedCategoryId!,
      );

      if (category != null) {
        final updatedCategory = category.copyWith(
          budgetLimitInCents: drift.Value(amountInCents),
        );
        await db.categoriesDao.updateCategory(updatedCategory);

        if (mounted) {
          // Refresh the budget providers
          ref.invalidate(allBudgetProgressProvider);
          ref.invalidate(budgetSummaryProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget saved successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving budget: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removeBudget() async {
    if (_selectedCategoryId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Budget'),
        content: const Text('Are you sure you want to remove this budget?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: context.glass.expense,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      final category = await db.categoriesDao.getCategoryById(
        _selectedCategoryId!,
      );

      if (category != null) {
        final updatedCategory = category.copyWith(
          budgetLimitInCents: const drift.Value(null),
        );
        await db.categoriesDao.updateCategory(updatedCategory);

        if (mounted) {
          // Refresh the budget providers
          ref.invalidate(allBudgetProgressProvider);
          ref.invalidate(budgetSummaryProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget removed successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error removing budget: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategoriesAsync = ref.watch(
      expenseCategoriesWithBudgetsProvider,
    );

    final theme = Theme.of(context);
    final isEditing = widget.categoryId != null;

    return GlassScaffold(
      appBar: AppBar(
        title: Text(widget.categoryId != null ? 'Edit Budget' : 'Set Budget'),
        actions: widget.categoryId != null
            ? [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.glass.expense,
                  ),
                  onPressed: _isLoading ? null : _removeBudget,
                  tooltip: 'Remove Budget',
                ),
              ]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            // Header
            Row(
              children: [
                const GlassIcon(
                  Icons.pie_chart_rounded,
                  color: AppColors.violet,
                  size: 52,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Adjust your limit' : 'Plan your spending',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Set a monthly cap for this category',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Selection
                  if (!isEditing)
                    expenseCategoriesAsync.when(
                      data: (categories) => _buildCategorySelector(categories),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(
                        'Error: $error',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.glass.expense,
                        ),
                      ),
                    ),

                  if (!isEditing) const SizedBox(height: 20),

                  // Amount Input
                  StyledTextFormField(
                    controller: _amountController,
                    labelText: 'Monthly Budget Amount',
                    prefixText:
                        '${ref.watch(currentCurrencyProvider).symbol} ',
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_rounded,
                    ),
                    hintText: 'Enter maximum monthly spending',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Save Button
            StyledElevatedButton(
              onPressed: _saveBudget,
              text: 'Save Budget',
              icon: Icons.check_rounded,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryEntity> categories) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _selectedCategoryId,
          decoration: const InputDecoration(hintText: 'Choose a category'),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          items: categories.map((category) {
            return DropdownMenuItem(
              value: category.id,
              child: Row(
                children: [
                  GlassIcon(
                    CategoryVisuals.icon(category.icon),
                    color: CategoryVisuals.vivid(category.color),
                    size: 28,
                    glow: false,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedCategoryId = value);
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }
}
