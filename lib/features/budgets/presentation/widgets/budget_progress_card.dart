import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../domain/models/category_budget_progress.dart';

/// Budget progress card widget
class BudgetProgressCard extends ConsumerWidget {
  final CategoryBudgetProgress progress;
  final VoidCallback? onTap;

  const BudgetProgressCard({super.key, required this.progress, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final categoryColor = CategoryVisuals.vivid(progress.categoryColor);
    final statusColor = budgetStatusColor(context, progress.status);
    final remainingColor = progress.remainingInCents >= 0
        ? context.glass.income
        : context.glass.expense;

    return GlassCard(
      blur: false,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      radius: AppTheme.radiusL,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category name and icon
          Row(
            children: [
              GlassIcon(
                CategoryVisuals.icon(progress.categoryIcon),
                color: categoryColor,
                size: 44,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  progress.categoryName,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  progress.status.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Budget amounts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency(ref, progress.spentInCents),
                    style: AppTypography.amount(20).copyWith(
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency(ref, progress.budgetLimitInCents ?? 0),
                    style: AppTypography.amount(
                      16,
                      weight: FontWeight.w600,
                    ).copyWith(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar
          BudgetGradientBar(
            value: progress.progressPercentage / 100,
            gradient: budgetStatusGradient(progress.status),
          ),

          const SizedBox(height: 10),

          // Progress percentage and remaining
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.progressPercentage.toStringAsFixed(1)}% used',
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
              Text(
                progress.remainingInCents >= 0
                    ? '${formatCurrency(ref, progress.remainingInCents)} left'
                    : '${formatCurrency(ref, progress.remainingInCents.abs())} over',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: remainingColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Text/accent color for a budget status, tuned for the current brightness.
Color budgetStatusColor(BuildContext context, BudgetStatus status) {
  switch (status) {
    case BudgetStatus.onTrack:
      return context.glass.income;
    case BudgetStatus.nearLimit:
      return budgetWarningColor(context);
    case BudgetStatus.overBudget:
      return context.glass.expense;
    case BudgetStatus.noBudget:
      return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

/// Gradient fill for a budget status.
Gradient budgetStatusGradient(BudgetStatus status) {
  switch (status) {
    case BudgetStatus.onTrack:
      return AppColors.incomeGradient;
    case BudgetStatus.nearLimit:
      return AppColors.warningGradient;
    case BudgetStatus.overBudget:
      return AppColors.expenseGradient;
    case BudgetStatus.noBudget:
      return AppColors.savingsGradient;
  }
}

/// [AppColors.warning] deepened on light backgrounds so text stays legible.
Color budgetWarningColor(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return AppColors.warning;
  }
  final hsl = HSLColor.fromColor(AppColors.warning);
  return hsl.withLightness(0.40).toColor();
}

/// Rounded progress track (theme colors) with a gradient fill.
class BudgetGradientBar extends StatelessWidget {
  /// Fraction filled; clamped to 0..1.
  final double value;
  final Gradient gradient;
  final double height;

  const BudgetGradientBar({
    super.key,
    required this.value,
    required this.gradient,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackColor = theme.progressIndicatorTheme.linearTrackColor ??
        theme.colorScheme.surfaceContainerHighest;
    final fraction = value.isNaN ? 0.0 : value.clamp(0.0, 1.0);
    final radius = BorderRadius.circular(height);
    final glowColor = gradient.colors.first;

    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(color: trackColor, borderRadius: radius),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction,
            heightFactor: 1,
            child: fraction == 0
                ? const SizedBox.shrink()
                : DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: radius,
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withValues(alpha: 0.45),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
