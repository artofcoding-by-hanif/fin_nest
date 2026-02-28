import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_table.dart';
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
      _currentValueController.text = (widget.savings!.currentValueInCents / 100)
          .toStringAsFixed(2);
      _investedAmountController.text =
          (widget.savings!.investedAmountInCents / 100).toStringAsFixed(2);
      _selectedCategory = widget.savings!.category;
      _maturityDate = widget.savings!.maturityDate;
      if (widget.savings!.interestRate != null) {
        _interestRateController.text = (widget.savings!.interestRate! / 100)
            .toStringAsFixed(2);
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
        await ref
            .read(savingsProvider.notifier)
            .addSavings(
              category: _selectedCategory,
              name: _nameController.text,
              currentValueInCents: (currentValue * 100).round(),
              investedAmountInCents: (investedAmount * 100).round(),
              maturityDate: _maturityDate,
              interestRate: interestRate != null
                  ? (interestRate * 100).round()
                  : null,
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
        await ref
            .read(savingsProvider.notifier)
            .updateSavings(
              id: widget.savings!.id,
              category: _selectedCategory,
              name: _nameController.text,
              currentValueInCents: (currentValue * 100).round(),
              investedAmountInCents: (investedAmount * 100).round(),
              maturityDate: _maturityDate,
              interestRate: interestRate != null
                  ? (interestRate * 100).round()
                  : null,
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

  String _getCategoryLabel(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.nps:
        return 'NPS';
      case SavingsCategory.lic:
        return 'LIC';
      case SavingsCategory.mutualFund:
        return 'Mutual Fund';
      case SavingsCategory.ksfe:
        return 'KSFE';
      case SavingsCategory.gold:
        return 'Gold';
      case SavingsCategory.cash:
        return 'Cash';
      case SavingsCategory.stocks:
        return 'Stocks';
      case SavingsCategory.fixedDeposit:
        return 'Fixed Deposit';
      case SavingsCategory.ppf:
        return 'PPF';
      case SavingsCategory.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.savings == null ? 'Add Savings' : 'Edit Savings'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category Dropdown
            DropdownButtonFormField<SavingsCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: SavingsCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_getCategoryLabel(category)),
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
            InkWell(
              onTap: () => _selectMaturityDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Maturity Date (Optional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _maturityDate != null
                      ? DateFormat('MMM dd, yyyy').format(_maturityDate!)
                      : 'Select maturity date',
                  style: TextStyle(
                    color: _maturityDate != null ? null : Colors.grey,
                  ),
                ),
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
