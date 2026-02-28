import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/categories_table.dart';
import '../../../../core/widgets/currency_text.dart';

/// Widget for displaying category-wise spending as a pie chart
class CategoryPieChart extends ConsumerWidget {
  final Map<int, int> categoryTotals;
  final List<CategoryEntity> categories;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (categoryTotals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No expense data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    // Calculate total for percentages
    final total = categoryTotals.values.fold<int>(
      0,
      (sum, amount) => sum + amount,
    );

    // Create pie chart sections
    final sections = categoryTotals.entries.map((entry) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => CategoryEntity(
          id: entry.key,
          userId: 1,
          name: 'Unknown',
          type: CategoryType.expense,
          icon: 'help_outline',
          color: '#9E9E9E',
          isSystem: false,
          isActive: true,
          displayOrder: 999,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final percentage = (entry.value / total) * 100;
      final color = _parseColor(category.color ?? '#9E9E9E');

      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        color: color,
        radius: 100,
        titleStyle: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Column(
      children: [
        // Pie Chart
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: categoryTotals.entries.map((entry) {
            final category = categories.firstWhere(
              (c) => c.id == entry.key,
              orElse: () => CategoryEntity(
                id: entry.key,
                userId: 1,
                name: 'Unknown',
                type: CategoryType.expense,
                icon: 'help_outline',
                color: '#9E9E9E',
                isSystem: false,
                isActive: true,
                displayOrder: 999,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );

            final color = _parseColor(category.color ?? '#9E9E9E');
            final amount = formatCurrency(ref, entry.value);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${category.name}: $amount',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
