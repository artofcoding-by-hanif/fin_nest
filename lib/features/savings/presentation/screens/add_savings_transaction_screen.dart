import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_transactions_table.dart';
import '../../../../core/widgets/styled_button.dart';
import '../../../../core/widgets/styled_form_field.dart';
import '../providers/savings_transactions_provider.dart';

/// Screen for adding or editing a savings transaction
class AddSavingsTransactionScreen extends ConsumerStatefulWidget {
  final int savingsId;
  final String savingsName;
  final SavingsTransactionEntity?
  transaction; // null for add, non-null for edit

  const AddSavingsTransactionScreen({
    super.key,
    required this.savingsId,
    required this.savingsName,
    this.transaction,
  });

  @override
  ConsumerState<AddSavingsTransactionScreen> createState() =>
      _AddSavingsTransactionScreenState();
}

class _AddSavingsTransactionScreenState
    extends ConsumerState<AddSavingsTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _unitsController = TextEditingController();
  final _pricePerUnitController = TextEditingController();

  SavingsTransactionType _selectedType = SavingsTransactionType.deposit;
  DateTime _selectedDate = DateTime.now();
  bool _showAdvancedFields = false;

  @override
  void initState() {
    super.initState();
    // If editing, populate fields with existing transaction data
    if (widget.transaction != null) {
      final transaction = widget.transaction!;
      _selectedType = transaction.type;
      _selectedDate = transaction.transactionDate;
      _amountController.text = (transaction.amountInCents / 100)
          .toStringAsFixed(2);
      _notesController.text = transaction.notes ?? '';

      if (transaction.units != null ||
          transaction.pricePerUnitInCents != null) {
        _showAdvancedFields = true;
        if (transaction.units != null) {
          _unitsController.text = transaction.units!.toString();
        }
        if (transaction.pricePerUnitInCents != null) {
          _pricePerUnitController.text =
              (transaction.pricePerUnitInCents! / 100).toStringAsFixed(2);
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _unitsController.dispose();
    _pricePerUnitController.dispose();
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

  String _getTransactionTypeLabel(SavingsTransactionType type) {
    switch (type) {
      case SavingsTransactionType.deposit:
        return 'Deposit';
      case SavingsTransactionType.withdrawal:
        return 'Withdrawal';
      case SavingsTransactionType.interest:
        return 'Interest';
      case SavingsTransactionType.dividend:
        return 'Dividend';
      case SavingsTransactionType.appreciation:
        return 'Appreciation';
      case SavingsTransactionType.depreciation:
        return 'Depreciation';
    }
  }

  IconData _getTransactionTypeIcon(SavingsTransactionType type) {
    switch (type) {
      case SavingsTransactionType.deposit:
        return Icons.add_circle_outline;
      case SavingsTransactionType.withdrawal:
        return Icons.remove_circle_outline;
      case SavingsTransactionType.interest:
        return Icons.trending_up;
      case SavingsTransactionType.dividend:
        return Icons.payments;
      case SavingsTransactionType.appreciation:
        return Icons.arrow_upward;
      case SavingsTransactionType.depreciation:
        return Icons.arrow_downward;
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    final amountInCents = (amount * 100).round();

    double? units;
    int? pricePerUnitInCents;

    if (_showAdvancedFields) {
      units = _unitsController.text.isNotEmpty
          ? double.tryParse(_unitsController.text)
          : null;
      final pricePerUnit = _pricePerUnitController.text.isNotEmpty
          ? double.tryParse(_pricePerUnitController.text)
          : null;
      pricePerUnitInCents = pricePerUnit != null
          ? (pricePerUnit * 100).round()
          : null;
    }

    try {
      final isEditing = widget.transaction != null;

      if (isEditing) {
        // Update existing transaction
        await ref
            .read(savingsTransactionProvider.notifier)
            .updateTransaction(
              id: widget.transaction!.id,
              userId: widget.transaction!.userId,
              savingsId: widget.savingsId,
              type: _selectedType,
              amountInCents: amountInCents,
              transactionDate: _selectedDate,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
              units: units,
              pricePerUnitInCents: pricePerUnitInCents,
              createdAt: widget.transaction!.createdAt,
            );
      } else {
        // Add new transaction
        await ref
            .read(savingsTransactionProvider.notifier)
            .addTransaction(
              userId: 1, // TODO: Replace with actual user ID
              savingsId: widget.savingsId,
              type: _selectedType,
              amountInCents: amountInCents,
              transactionDate: _selectedDate,
              notes: _notesController.text.isNotEmpty
                  ? _notesController.text
                  : null,
              units: units,
              pricePerUnitInCents: pricePerUnitInCents,
            );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Transaction updated successfully'
                : 'Transaction added successfully',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving transaction: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savingsTransactionProvider);
    final isEditing = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${isEditing ? 'Edit' : 'Add'} Transaction - ${widget.savingsName}',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Transaction Type Selector
            const Text(
              'Transaction Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SavingsTransactionType>(
              value: _selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: SavingsTransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getTransactionTypeIcon(type), size: 20),
                      const SizedBox(width: 8),
                      Text(_getTransactionTypeLabel(type)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Amount Field
            StyledTextFormField(
              controller: _amountController,
              labelText: 'Amount',
              hintText: 'Enter amount',
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
              prefixIcon: const Icon(Icons.currency_rupee),
            ),
            const SizedBox(height: 16),

            // Date Selector
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Transaction Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  DateFormat('dd MMM yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes Field
            StyledTextFormField(
              controller: _notesController,
              labelText: 'Notes (Optional)',
              hintText: 'Add notes about this transaction',
              maxLines: 3,
              prefixIcon: const Icon(Icons.note),
            ),
            const SizedBox(height: 16),

            // Advanced Fields Toggle
            CheckboxListTile(
              title: const Text('Show advanced fields (Units & Price)'),
              subtitle: const Text('For mutual funds, stocks, etc.'),
              value: _showAdvancedFields,
              onChanged: (value) {
                setState(() {
                  _showAdvancedFields = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Advanced Fields
            if (_showAdvancedFields) ...[
              const SizedBox(height: 8),
              StyledTextFormField(
                controller: _unitsController,
                labelText: 'Units (Optional)',
                hintText: 'Number of units',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                ],
                prefixIcon: const Icon(Icons.numbers),
              ),
              const SizedBox(height: 16),
              StyledTextFormField(
                controller: _pricePerUnitController,
                labelText: 'Price per Unit (Optional)',
                hintText: 'NAV or price per unit',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                prefixIcon: const Icon(Icons.price_change),
              ),
            ],

            const SizedBox(height: 24),

            // Save Button
            StyledElevatedButton(
              text: 'Add Transaction',
              onPressed: state.isLoading ? null : _saveTransaction,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
