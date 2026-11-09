import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/daos/transactions_dao.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass/glass.dart';

/// Monthly income vs expense as paired gradient bars.
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
    final glass = context.glass;

    if (monthlyExpenses.isEmpty && monthlyIncome.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: EmptyState(
          icon: Icons.bar_chart_rounded,
          message: 'Add a few transactions to see your trends',
        ),
      );
    }

    int maxOf(List<MonthlyTotal> l) => l.isEmpty
        ? 0
        : l.map((e) => e.totalInCents).reduce((a, b) => a > b ? a : b);
    final rawMax = [maxOf(monthlyExpenses), maxOf(monthlyIncome)]
        .reduce((a, b) => a > b ? a : b);
    final maxY = rawMax == 0 ? 100.0 : rawMax * 1.15;

    final incomeGradient = LinearGradient(
      colors: [glass.income, AppColors.cyan],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
    final expenseGradient = LinearGradient(
      colors: [const Color(0xFFF97316), glass.expense],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    final groups = <BarChartGroupData>[
      for (var i = 0; i < monthlyExpenses.length; i++)
        BarChartGroupData(
          x: i,
          barsSpace: 5,
          barRods: [
            BarChartRodData(
              toY: i < monthlyIncome.length
                  ? monthlyIncome[i].totalInCents.toDouble()
                  : 0,
              gradient: incomeGradient,
              width: 10,
              borderRadius: BorderRadius.circular(6),
            ),
            BarChartRodData(
              toY: monthlyExpenses[i].totalInCents.toDouble(),
              gradient: expenseGradient,
              width: 10,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
    ];

    final axisStyle = theme.textTheme.labelSmall;

    return Column(
      children: [
        Row(
          children: [
            _Legend(gradient: incomeGradient, label: 'Income'),
            const SizedBox(width: 20),
            _Legend(gradient: expenseGradient, label: 'Expenses'),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barGroups: groups,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: glass.border,
                  strokeWidth: 1,
                  dashArray: const [4, 6],
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: maxY / 4,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max) return const SizedBox.shrink();
                      return Text(
                        NumberFormat.compact().format(value / 100),
                        style: axisStyle,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= monthlyExpenses.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(monthlyExpenses[i].monthName, style: axisStyle),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xF2151C3E),
                  tooltipBorderRadius: BorderRadius.circular(12),
                  tooltipPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = rodIndex == 0 ? 'Income' : 'Expense';
                    return BarTooltipItem(
                      '$label\n',
                      theme.textTheme.labelSmall!.copyWith(
                        color: Colors.white70,
                      ),
                      children: [
                        TextSpan(
                          text: formatCurrency(ref, rod.toY.toInt()),
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Gradient gradient;
  final String label;

  const _Legend({required this.gradient, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(gradient: gradient, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
