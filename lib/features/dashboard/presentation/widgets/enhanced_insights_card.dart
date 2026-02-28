import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/widgets/currency_text.dart';

/// Enhanced insights card showing multiple financial insights
class EnhancedInsightsCard extends ConsumerWidget {
  final double? averageDailySpending;
  final SpendingTrend? spendingTrend;
  final List<BudgetProgress>? budgetProgress;
  final SavingsRate? savingsRate;

  const EnhancedInsightsCard({
    super.key,
    this.averageDailySpending,
    this.spendingTrend,
    this.budgetProgress,
    this.savingsRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.insights,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Financial Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Average Daily Spending
            if (averageDailySpending != null) ...[
              _InsightRow(
                icon: Icons.calendar_today,
                iconColor: Colors.blue,
                label: 'Avg. Daily Spending',
                value: formatCurrencyFromDouble(
                  ref,
                  averageDailySpending! / 100,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Spending Trend
            if (spendingTrend != null) ...[
              _InsightRow(
                icon: spendingTrend!.isIncreasing
                    ? Icons.trending_up
                    : spendingTrend!.isDecreasing
                    ? Icons.trending_down
                    : Icons.trending_flat,
                iconColor: spendingTrend!.isIncreasing
                    ? Colors.red
                    : spendingTrend!.isDecreasing
                    ? Colors.green
                    : Colors.grey,
                label: 'Spending Trend',
                value:
                    '${spendingTrend!.percentageChange.abs().toStringAsFixed(1)}% '
                    '${spendingTrend!.isIncreasing
                        ? 'up'
                        : spendingTrend!.isDecreasing
                        ? 'down'
                        : 'stable'}',
              ),
              const SizedBox(height: 12),
            ],

            // Savings Rate
            if (savingsRate != null) ...[
              _InsightRow(
                icon: savingsRate!.isSaving
                    ? Icons.savings
                    : savingsRate!.isOverspending
                    ? Icons.warning
                    : Icons.balance,
                iconColor: savingsRate!.isSaving
                    ? Colors.green
                    : savingsRate!.isOverspending
                    ? Colors.red
                    : Colors.orange,
                label: 'Savings Rate',
                value:
                    '${savingsRate!.savingsRatePercentage.toStringAsFixed(1)}%',
              ),
              const SizedBox(height: 12),
            ],

            // Budget Progress
            if (budgetProgress != null && budgetProgress!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Budget Progress',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...budgetProgress!.map(
                (progress) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BudgetProgressItem(progress: progress),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Insight row widget
class _InsightRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InsightRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Budget progress item widget
class _BudgetProgressItem extends ConsumerWidget {
  final BudgetProgress progress;

  const _BudgetProgressItem({required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Color getProgressColor() {
      if (progress.isOverBudget) return Colors.red;
      if (progress.isNearLimit) return Colors.orange;
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              progress.categoryName,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${formatCurrency(ref, progress.spentInCents, compact: true)} / '
              '${formatCurrency(ref, progress.budgetLimitInCents, compact: true)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: getProgressColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (progress.percentageUsed / 100).clamp(0.0, 1.0),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(getProgressColor()),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
