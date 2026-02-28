import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../providers/savings_provider.dart';
import 'add_edit_savings_screen.dart';
import 'add_savings_transaction_screen.dart';
import 'savings_detail_screen.dart';

/// Date range filter options for savings list
enum SavingsListDateRangeFilter {
  currentMonth('Current Month'),
  lastMonth('Last Month'),
  last6Months('Last 6 Months'),
  last12Months('Last 12 Months'),
  allTime('All Time');

  final String label;
  const SavingsListDateRangeFilter(this.label);

  /// Get the start date for this filter
  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case SavingsListDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month, 1);
      case SavingsListDateRangeFilter.lastMonth:
        // Get first day of last month
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month, 1);
      case SavingsListDateRangeFilter.last6Months:
        return DateTime(now.year, now.month - 6, 1);
      case SavingsListDateRangeFilter.last12Months:
        return DateTime(now.year, now.month - 12, 1);
      case SavingsListDateRangeFilter.allTime:
        return DateTime(2000, 1, 1); // Far past date
    }
  }

  /// Get the end date for this filter
  DateTime getEndDate() {
    final now = DateTime.now();
    switch (this) {
      case SavingsListDateRangeFilter.currentMonth:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case SavingsListDateRangeFilter.lastMonth:
        // Get last day of last month (day 0 of current month)
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        return DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59);
      case SavingsListDateRangeFilter.last6Months:
      case SavingsListDateRangeFilter.last12Months:
      case SavingsListDateRangeFilter.allTime:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }
  }
}

/// Screen for viewing and managing savings
class SavingsListScreen extends ConsumerStatefulWidget {
  const SavingsListScreen({super.key});

  @override
  ConsumerState<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends ConsumerState<SavingsListScreen> {
  SavingsCategory? _selectedCategory;
  SavingsListDateRangeFilter _selectedDateRange =
      SavingsListDateRangeFilter.allTime;

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
    final theme = Theme.of(context);
    final savingsAsync = _selectedCategory == null
        ? ref.watch(watchSavingsProvider)
        : ref.watch(watchSavingsByCategoryProvider(_selectedCategory!));

    return Scaffold(
      appBar: AppBar(title: const Text('Savings'), elevation: 0),
      body: Column(
        children: [
          // Date Range Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Period:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: SavingsListDateRangeFilter.values.map((filter) {
                        final isSelected = _selectedDateRange == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter.label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedDateRange = filter;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Filter Chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ),
                ...SavingsCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_getCategoryLabel(category)),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),

          // Savings List
          Expanded(
            child: savingsAsync.when(
              data: (savings) {
                // Apply date range filter
                final startDate = _selectedDateRange.getStartDate();
                final endDate = _selectedDateRange.getEndDate();
                final filteredSavings = savings.where((saving) {
                  return saving.createdAt.isAfter(
                        startDate.subtract(const Duration(seconds: 1)),
                      ) &&
                      saving.createdAt.isBefore(
                        endDate.add(const Duration(seconds: 1)),
                      );
                }).toList();

                if (filteredSavings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.savings_outlined,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          savings.isEmpty
                              ? 'No savings yet'
                              : 'No savings in this period',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          savings.isEmpty
                              ? 'Add your first savings entry to get started'
                              : 'Try selecting a different date range or category',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSavings.length,
                  itemBuilder: (context, index) {
                    final saving = filteredSavings[index];
                    final returns =
                        saving.currentValueInCents -
                        saving.investedAmountInCents;
                    final returnsPercentage = saving.investedAmountInCents > 0
                        ? (returns / saving.investedAmountInCents) * 100
                        : 0.0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              saving.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(_getCategoryLabel(saving.category)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Current Value',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                          ),
                                          CurrencyText(
                                            amountInCents:
                                                saving.currentValueInCents,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Invested',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                          ),
                                          CurrencyText(
                                            amountInCents:
                                                saving.investedAmountInCents,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      returns >= 0
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      size: 16,
                                      color: returns >= 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    CurrencyText(
                                      amountInCents: returns,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: returns >= 0
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${returnsPercentage.toStringAsFixed(2)}%)',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: returns >= 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                    ),
                                  ],
                                ),
                                if (saving.maturityDate != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Matures: ${DateFormat('MMM dd, yyyy').format(saving.maturityDate!)}',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditSavingsScreen(savings: saving),
                                ),
                              );
                            },
                          ),
                          // Action buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddSavingsTransactionScreen(
                                                savingsId: saving.id,
                                                savingsName: saving.name,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add Transaction'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SavingsDetailScreen(
                                                savings: saving,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.history, size: 18),
                                    label: const Text('View History'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditSavingsScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
