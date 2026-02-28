import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../domain/models/category_budget_progress.dart';

/// Budget progress card widget
class BudgetProgressCard extends ConsumerWidget {
  final CategoryBudgetProgress progress;
  final VoidCallback? onTap;

  const BudgetProgressCard({super.key, required this.progress, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Parse color from hex string
    Color categoryColor = Colors.blue;
    if (progress.categoryColor != null) {
      try {
        categoryColor = Color(
          int.parse(progress.categoryColor!.replaceFirst('#', '0xFF')),
        );
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    // Get status color
    final statusColor = _getStatusColor(progress.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category name and icon
              Row(
                children: [
                  // Category icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(progress.categoryIcon),
                      color: categoryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Category name
                  Expanded(
                    child: Text(
                      progress.categoryName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      progress.status.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Budget amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spent',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(ref, progress.spentInCents),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(ref, progress.budgetLimitInCents ?? 0),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (progress.progressPercentage / 100).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 8),

              // Progress percentage and remaining
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progress.progressPercentage.toStringAsFixed(1)}% used',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    progress.remainingInCents >= 0
                        ? '${formatCurrency(ref, progress.remainingInCents)} left'
                        : '${formatCurrency(ref, progress.remainingInCents.abs())} over',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: progress.remainingInCents >= 0
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.onTrack:
        return Colors.green;
      case BudgetStatus.nearLimit:
        return Colors.orange;
      case BudgetStatus.overBudget:
        return Colors.red;
      case BudgetStatus.noBudget:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? iconName) {
    if (iconName == null) return Icons.category;

    // Map icon names to IconData
    final iconMap = {
      'shopping_cart': Icons.shopping_cart,
      'restaurant': Icons.restaurant,
      'local_gas_station': Icons.local_gas_station,
      'home': Icons.home,
      'phone_android': Icons.phone_android,
      'medical_services': Icons.medical_services,
      'school': Icons.school,
      'sports_esports': Icons.sports_esports,
      'flight': Icons.flight,
      'shopping_bag': Icons.shopping_bag,
      'fastfood': Icons.fastfood,
      'directions_car': Icons.directions_car,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
