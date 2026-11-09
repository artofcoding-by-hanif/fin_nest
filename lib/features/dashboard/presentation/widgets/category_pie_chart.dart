import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass/glass.dart';

/// Category spending as a glowing donut with a ranked legend.
class CategoryPieChart extends ConsumerStatefulWidget {
  final Map<int, int> categoryTotals;
  final List<CategoryEntity> categories;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.categories,
  });

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.categoryTotals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: EmptyState(
          icon: Icons.donut_large_rounded,
          message: 'No spending in this period yet',
        ),
      );
    }

    final total = widget.categoryTotals.values.fold<int>(0, (a, b) => a + b);
    final entries = widget.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final slices = entries.map((e) {
      final cat = widget.categories.where((c) => c.id == e.key).firstOrNull;
      return (
        name: cat?.name ?? 'Unknown',
        icon: CategoryVisuals.icon(cat?.icon),
        color: CategoryVisuals.vivid(cat?.color),
        amount: e.value,
        pct: total == 0 ? 0.0 : e.value / total * 100,
      );
    }).toList();

    final focused = _touched != null && _touched! < slices.length
        ? slices[_touched!]
        : null;

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 68,
                  startDegreeOffset: -90,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      final i = response?.touchedSection?.touchedSectionIndex;
                      if (!event.isInterestedForInteractions || i == null || i < 0) {
                        if (_touched != null) setState(() => _touched = null);
                        return;
                      }
                      if (i != _touched) setState(() => _touched = i);
                    },
                  ),
                  sections: [
                    for (var i = 0; i < slices.length; i++)
                      PieChartSectionData(
                        value: slices[i].amount.toDouble(),
                        showTitle: false,
                        radius: i == _touched ? 34 : 26,
                        gradient: AppColors.tintGradient(slices[i].color),
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    focused?.name ?? 'Total spent',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CurrencyText(
                    amountInCents: focused?.amount ?? total,
                    compact: true,
                    style: AppTypography.amount(22).copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (focused != null)
                    Text(
                      '${focused.pct.toStringAsFixed(1)}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: focused.color,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (final s in slices.take(6))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                GlassIcon(s.icon, color: s.color, size: 34, glow: false),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatCurrency(ref, s.amount),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFeatures: AppTypography.tabular,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _GradientBar(fraction: s.pct / 100, color: s.color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (slices.length > 6)
          Text(
            '+${slices.length - 6} more categories',
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _GradientBar extends StatelessWidget {
  final double fraction;
  final Color color;

  const _GradientBar({required this.fraction, required this.color});

  @override
  Widget build(BuildContext context) {
    final track = Theme.of(context).progressIndicatorTheme.linearTrackColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 5,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: track ?? Colors.transparent)),
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.02, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.tintGradient(color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
