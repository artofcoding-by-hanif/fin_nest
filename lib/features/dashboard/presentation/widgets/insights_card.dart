import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/widgets/currency_text.dart';

/// Widget for displaying quick insights (top spending category and weekly summary)
class InsightsCard extends ConsumerWidget {
  final CategorySpending? topCategory;
  final CategoryEntity? categoryEntity;
  final WeeklySummary weeklySummary;

  const InsightsCard({
    super.key,
    required this.topCategory,
    required this.categoryEntity,
    required this.weeklySummary,
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
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Top Spending Category
            _InsightItem(
              icon: Icons.trending_up,
              iconColor: Colors.red,
              title: 'Top Spending',
              subtitle: topCategory != null && categoryEntity != null
                  ? categoryEntity!.name
                  : 'No expenses yet',
              value: topCategory != null
                  ? formatCurrency(ref, topCategory!.totalInCents)
                  : null,
            ),
            const SizedBox(height: 12),

            // Weekly Summary
            _InsightItem(
              icon: Icons.calendar_today,
              iconColor: Colors.blue,
              title: 'This Week',
              subtitle: '${weeklySummary.transactionCount} transactions',
              value: formatCurrency(ref, weeklySummary.netInCents.abs()),
              valueColor: weeklySummary.netInCents >= 0
                  ? Colors.green
                  : Colors.red,
              valuePrefix: weeklySummary.netInCents >= 0 ? '+' : '-',
            ),
            const SizedBox(height: 12),

            // Weekly Income/Expense Breakdown
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Income',
                    value: NumberFormat.compact().format(
                      weeklySummary.totalIncomeInCents / 100,
                    ),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    label: 'Expenses',
                    value: NumberFormat.compact().format(
                      weeklySummary.totalExpensesInCents / 100,
                    ),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual insight item
class _InsightItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? value;
  final Color? valueColor;
  final String? valuePrefix;

  const _InsightItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.value,
    this.valueColor,
    this.valuePrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (value != null)
          Text(
            '${valuePrefix ?? ''}\$${value!.replaceAll('\$', '')}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

/// Mini stat widget for income/expense breakdown
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            '\$$value',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
