import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_table.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/savings_provider.dart';

/// Screen for adding or editing a savings entry
class AddEditSavingsScreen extends ConsumerStatefulWidget {
  final SavingsEntity? savings;

  const AddEditSavingsScreen({super.key, this.savings});

  @override
  ConsumerState<AddEditSavingsScreen> createState() =>
      _AddEditSavingsScreenState();
}

class _AddEditSavingsScreenState extends ConsumerState<AddEditSavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentValueController = TextEditingController();
  final _investedAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _institutionNameController = TextEditingController();
  final _notesController = TextEditingController();

  SavingsCategory _selectedCategory = SavingsCategory.mutualFund;
  DateTime? _maturityDate;

  @override
  void initState() {
    super.initState();
    if (widget.savings != null) {
      _nameController.text = widget.savings!.name;
      _currentValueController.text =
          (widget.savings!.currentValueInCents / 100).toStringAsFixed(2);
      _investedAmountController.text =
          (widget.savings!.investedAmountInCents / 100).toStringAsFixed(2);
      _selectedCategory = widget.savings!.category;
      _maturityDate = widget.savings!.maturityDate;
      if (widget.savings!.interestRate != null) {
        _interestRateController.text =
            (widget.savings!.interestRate! / 100).toStringAsFixed(2);
      }
      _accountNumberController.text = widget.savings!.accountNumber ?? '';
      _institutionNameController.text = widget.savings!.institutionName ?? '';
      _notesController.text = widget.savings!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentValueController.dispose();
    _investedAmountController.dispose();
    _interestRateController.dispose();
    _accountNumberController.dispose();
    _institutionNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectMaturityDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _maturityDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _maturityDate = picked;
      });
    }
  }

  Future<void> _saveSavings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentValue = double.tryParse(_currentValueController.text) ?? 0;
    final investedAmount = double.tryParse(_investedAmountController.text) ?? 0;
    final interestRate = _interestRateController.text.isNotEmpty
        ? double.tryParse(_interestRateController.text)
        : null;

    try {
      if (widget.savings == null) {
        // Add new savings
        await ref.read(savingsProvider.notifier).addSavings(
              category: _selectedCategory,
              name: _nameController.text,
              currentValueInCents: (currentValue * 100).round(),
              investedAmountInCents: (investedAmount * 100).round(),
              maturityDate: _maturityDate,
              interestRate:
                  interestRate != null ? (interestRate * 100).round() : null,
              accountNumber: _accountNumberController.text.isNotEmpty
                  ? _accountNumberController.text
                  : null,
              institutionName: _institutionNameController.text.isNotEmpty
                  ? _institutionNameController.text
                  : null,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
            );
      } else {
        // Update existing savings
        await ref.read(savingsProvider.notifier).updateSavings(
              id: widget.savings!.id,
              category: _selectedCategory,
              name: _nameController.text,
              currentValueInCents: (currentValue * 100).round(),
              investedAmountInCents: (investedAmount * 100).round(),
              maturityDate: _maturityDate,
              interestRate:
                  interestRate != null ? (interestRate * 100).round() : null,
              accountNumber: _accountNumberController.text.isNotEmpty
                  ? _accountNumberController.text
                  : null,
              institutionName: _institutionNameController.text.isNotEmpty
                  ? _institutionNameController.text
                  : null,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.savings == null
                  ? 'Savings added successfully'
                  : 'Savings updated successfully',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = SavingsCategoryStyle.of(_selectedCategory);

    return GlassScaffold(
      appBar: AppBar(
        title: Text(widget.savings == null ? 'Add Savings' : 'Edit Savings'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // Category preview
            GlassCard(
              tint: style.color,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GlassIcon(style.icon, color: style.color, size: 52),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.savings == null
                              ? 'New savings'
                              : 'Editing savings',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          style.label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            DropdownButtonFormField<SavingsCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              items: SavingsCategory.values.map((category) {
                final itemStyle = SavingsCategoryStyle.of(category);
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      GlassIcon(
                        itemStyle.icon,
                        color: itemStyle.color,
                        size: 28,
                        glow: false,
                      ),
                      const SizedBox(width: 12),
                      Text(itemStyle.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Name Field
            StyledTextFormField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'e.g., HDFC Mutual Fund',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Current Value Field
            StyledTextFormField(
              controller: _currentValueController,
              labelText: 'Current Value',
              hintText: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current value';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount < 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Invested Amount Field
            StyledTextFormField(
              controller: _investedAmountController,
              labelText: 'Invested Amount',
              hintText: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter invested amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount < 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Interest Rate Field (Optional)
            StyledTextFormField(
              controller: _interestRateController,
              labelText: 'Interest Rate (%) - Optional',
              hintText: 'e.g., 7.5',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),

            // Maturity Date Picker
            StyledSelectorField(
              labelText: 'Maturity Date (Optional)',
              displayText: _maturityDate != null
                  ? DateFormat('MMM dd, yyyy').format(_maturityDate!)
                  : 'Select maturity date',
              icon: Icons.calendar_today_rounded,
              hasValue: _maturityDate != null,
              onTap: () => _selectMaturityDate(context),
            ),
            const SizedBox(height: 16),

            // Account Number Field (Optional)
            StyledTextFormField(
              controller: _accountNumberController,
              labelText: 'Account Number - Optional',
              hintText: 'e.g., 1234567890',
            ),
            const SizedBox(height: 16),

            // Institution Name Field (Optional)
            StyledTextFormField(
              controller: _institutionNameController,
              labelText: 'Institution Name - Optional',
              hintText: 'e.g., HDFC Bank',
            ),
            const SizedBox(height: 16),

            // Notes Field (Optional)
            StyledTextFormField(
              controller: _notesController,
              labelText: 'Notes - Optional',
              hintText: 'Additional notes',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save Button
            StyledElevatedButton(
              onPressed: _saveSavings,
              text: widget.savings == null ? 'Add Savings' : 'Update Savings',
              icon: widget.savings == null
                  ? Icons.add_rounded
                  : Icons.check_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

/// Label, glass icon and vivid tint for each [SavingsCategory].
/// Shared by all savings screens so a category looks the same everywhere.
class SavingsCategoryStyle {
  final String label;
  final IconData icon;
  final Color color;

  const SavingsCategoryStyle._(this.label, this.icon, this.color);

  static SavingsCategoryStyle of(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.nps:
        return const SavingsCategoryStyle._(
          'NPS',
          Icons.account_balance_rounded,
          AppColors.indigo,
        );
      case SavingsCategory.lic:
        return const SavingsCategoryStyle._(
          'LIC',
          Icons.health_and_safety_rounded,
          Color(0xFF14B8A6), // teal
        );
      case SavingsCategory.mutualFund:
        return const SavingsCategoryStyle._(
          'Mutual Fund',
          Icons.pie_chart_rounded,
          AppColors.violet,
        );
      case SavingsCategory.ksfe:
        return const SavingsCategoryStyle._(
          'KSFE',
          Icons.groups_rounded,
          AppColors.pink,
        );
      case SavingsCategory.gold:
        return const SavingsCategoryStyle._(
          'Gold',
          Icons.diamond_rounded,
          Color(0xFFF59E0B), // amber
        );
      case SavingsCategory.cash:
        return const SavingsCategoryStyle._(
          'Cash',
          Icons.payments_rounded,
          AppColors.income,
        );
      case SavingsCategory.stocks:
        return const SavingsCategoryStyle._(
          'Stocks',
          Icons.candlestick_chart_rounded,
          AppColors.cyan,
        );
      case SavingsCategory.fixedDeposit:
        return const SavingsCategoryStyle._(
          'Fixed Deposit',
          Icons.lock_clock_rounded,
          AppColors.blue,
        );
      case SavingsCategory.ppf:
        return const SavingsCategoryStyle._(
          'PPF',
          Icons.savings_rounded,
          Color(0xFFF97316), // orange
        );
      case SavingsCategory.other:
        return const SavingsCategoryStyle._(
          'Other',
          Icons.category_rounded,
          Color(0xFFD946EF), // fuchsia
        );
    }
  }
}

/// Small pill showing gain/loss percentage with a trend arrow.
class SavingsReturnBadge extends StatelessWidget {
  final int returnsInCents;
  final double percentage;

  const SavingsReturnBadge({
    super.key,
    required this.returnsInCents,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isGain = returnsInCents >= 0;
    final color = isGain ? context.glass.income : context.glass.expense;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGain ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${percentage.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
