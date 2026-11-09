import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/tables/savings_table.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/loading_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final savingsAsync = _selectedCategory == null
        ? ref.watch(watchSavingsProvider)
        : ref.watch(watchSavingsByCategoryProvider(_selectedCategory!));

    return GlassScaffold(
      appBar: AppBar(title: const Text('Savings')),
      body: Column(
        children: [
          // Date Range Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Text(
                  'Period',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
                          child: GlassChips(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GlassChips(
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
                ),
                ...SavingsCategory.values.map((category) {
                  final style = SavingsCategoryStyle.of(category);
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GlassChips(
                      child: FilterChip(
                        avatar: isSelected
                            ? null
                            : Icon(style.icon, size: 16, color: style.color),
                        label: Text(style.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

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
                  return EmptyState(
                    icon: Icons.savings_rounded,
                    color: AppColors.savings,
                    title: savings.isEmpty
                        ? 'No savings yet'
                        : 'No savings in this period',
                    message: savings.isEmpty
                        ? 'Add your first savings entry to get started'
                        : 'Try selecting a different date range or category',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                  itemCount: filteredSavings.length,
                  itemBuilder: (context, index) {
                    final saving = filteredSavings[index];
                    final returns =
                        saving.currentValueInCents -
                        saving.investedAmountInCents;
                    final returnsPercentage = saving.investedAmountInCents > 0
                        ? (returns / saving.investedAmountInCents) * 100
                        : 0.0;
                    final style = SavingsCategoryStyle.of(saving.category);
                    final returnsColor = returns >= 0
                        ? context.glass.income
                        : context.glass.expense;
                    final mutedSmall = theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    );

                    return GlassCard(
                      blur: false,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditSavingsScreen(savings: saving),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: icon, name, category, returns badge
                          Row(
                            children: [
                              GlassIcon(
                                style.icon,
                                color: style.color,
                                size: 46,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      saving.name,
                                      style: theme.textTheme.titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(style.label, style: mutedSmall),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SavingsReturnBadge(
                                returnsInCents: returns,
                                percentage: returnsPercentage,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Figures
                          _Figure(
                            label: 'Current Value',
                            child: CurrencyText(
                              amountInCents: saving.currentValueInCents,
                              style: AppTypography.amount(24).copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _Figure(
                                  label: 'Invested',
                                  child: CurrencyText(
                                    amountInCents: saving.investedAmountInCents,
                                    style: AppTypography.amount(
                                      15,
                                      weight: FontWeight.w600,
                                    ).copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _Figure(
                                  label: 'Returns',
                                  child: CurrencyText(
                                    amountInCents: returns,
                                    prefix: returns > 0 ? '+' : null,
                                    style: AppTypography.amount(
                                      15,
                                      weight: FontWeight.w600,
                                    ).copyWith(color: returnsColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (saving.maturityDate != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.event_rounded,
                                  size: 14,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Matures: ${DateFormat('MMM dd, yyyy').format(saving.maturityDate!)}',
                                  style: mutedSmall,
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),

                          // Action buttons
                          Row(
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
                                  icon: const Icon(Icons.add_rounded, size: 18),
                                  label: const Text('Add'),
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                  icon: const Icon(
                                    Icons.history_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('History'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => ErrorView(message: 'Error: $error'),
            ),
          ),
        ],
      ),
      floatingActionButton: GradientFab(
        tooltip: 'Add Savings',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditSavingsScreen(),
            ),
          );
        },
      ),
    );
  }
}

/// Small label + figure used on savings cards.
class _Figure extends StatelessWidget {
  final String label;
  final Widget child;

  const _Figure({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ],
    );
  }
}
