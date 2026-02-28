import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/widgets/currency_text.dart';

/// Widget for displaying monthly income and expense trends as a bar chart
class MonthlyTrendsChart extends ConsumerWidget {
  final List<MonthlyTotal> monthlyExpenses;
  final List<MonthlyTotal> monthlyIncome;

  const MonthlyTrendsChart({
    super.key,
    required this.monthlyExpenses,
    required this.monthlyIncome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (monthlyExpenses.isEmpty && monthlyIncome.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No transaction data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    // Find max value for scaling
    final maxExpense = monthlyExpenses.isEmpty
        ? 0
        : monthlyExpenses
              .map((e) => e.totalInCents)
              .reduce((a, b) => a > b ? a : b);
    final maxIncome = monthlyIncome.isEmpty
        ? 0
        : monthlyIncome
              .map((e) => e.totalInCents)
              .reduce((a, b) => a > b ? a : b);
    final maxValue = maxExpense > maxIncome ? maxExpense : maxIncome;

    // Create bar groups
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < monthlyExpenses.length; i++) {
      final expense = monthlyExpenses[i].totalInCents.toDouble();
      final income = i < monthlyIncome.length
          ? monthlyIncome[i].totalInCents.toDouble()
          : 0.0;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: income,
              color: Colors.green,
              width: 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: expense,
              color: Colors.red,
              width: 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return Column(
      children: [
        // Bar Chart
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: BarChart(
              BarChartData(
                maxY: maxValue.toDouble(),
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          NumberFormat.compact().format(value / 100),
                          style: theme.textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < monthlyExpenses.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyExpenses[value.toInt()].monthName,
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final isIncome = rodIndex == 0;
                      final label = isIncome ? 'Income' : 'Expense';
                      final amount = formatCurrency(ref, (rod.toY).toInt());
                      return BarTooltipItem(
                        '$label\n$amount',
                        theme.textTheme.labelSmall!.copyWith(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: Colors.green, label: 'Income'),
            const SizedBox(width: 24),
            _LegendItem(color: Colors.red, label: 'Expenses'),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
