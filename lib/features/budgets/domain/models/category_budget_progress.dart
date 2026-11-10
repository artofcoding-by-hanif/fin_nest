import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_budget_progress.freezed.dart';
part 'category_budget_progress.g.dart';

/// Budget status based on spending percentage
enum BudgetStatus {
  /// Spending is under 80% of budget
  onTrack,
  
  /// Spending is between 80% and 100% of budget
  nearLimit,
  
  /// Spending is over 100% of budget
  overBudget,
  
  /// No budget set for this category
  noBudget;

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case BudgetStatus.onTrack:
        return 'On Track';
      case BudgetStatus.nearLimit:
        return 'Near Limit';
      case BudgetStatus.overBudget:
        return 'Over Budget';
      case BudgetStatus.noBudget:
        return 'No Budget';
    }
  }

  /// Get color for status
  String get colorHex {
    switch (this) {
      case BudgetStatus.onTrack:
        return '#4CAF50'; // Green
      case BudgetStatus.nearLimit:
        return '#FF9800'; // Orange
      case BudgetStatus.overBudget:
        return '#F44336'; // Red
      case BudgetStatus.noBudget:
        return '#9E9E9E'; // Grey
    }
  }
}

/// Category budget progress model
@freezed
abstract class CategoryBudgetProgress with _$CategoryBudgetProgress {
  const factory CategoryBudgetProgress({
    /// Category ID
    required int categoryId,
    
    /// Category name
    required String categoryName,
    
    /// Category icon name
    String? categoryIcon,
    
    /// Category color (hex code)
    String? categoryColor,
    
    /// Budget limit in cents (null if no budget set)
    int? budgetLimitInCents,
    
    /// Amount spent in cents for current month
    required int spentInCents,
    
    /// Progress percentage (0-100+)
    required double progressPercentage,
    
    /// Budget status
    required BudgetStatus status,
    
    /// Remaining amount in cents (can be negative if over budget)
    required int remainingInCents,
  }) = _CategoryBudgetProgress;

  const CategoryBudgetProgress._();

  /// Create from JSON
  factory CategoryBudgetProgress.fromJson(Map<String, dynamic> json) =>
      _$CategoryBudgetProgressFromJson(json);

  /// Calculate budget status from percentage
  static BudgetStatus calculateStatus(double percentage, bool hasBudget) {
    if (!hasBudget) return BudgetStatus.noBudget;
    if (percentage >= 100) return BudgetStatus.overBudget;
    if (percentage >= 80) return BudgetStatus.nearLimit;
    return BudgetStatus.onTrack;
  }

  /// Calculate progress percentage
  static double calculatePercentage(int spent, int? budgetLimit) {
    if (budgetLimit == null || budgetLimit == 0) return 0.0;
    return (spent / budgetLimit) * 100;
  }

  /// Calculate remaining amount
  static int calculateRemaining(int spent, int? budgetLimit) {
    if (budgetLimit == null) return 0;
    return budgetLimit - spent;
  }

  /// Create budget progress from category and spending data
  factory CategoryBudgetProgress.fromCategoryAndSpending({
    required int categoryId,
    required String categoryName,
    String? categoryIcon,
    String? categoryColor,
    int? budgetLimitInCents,
    required int spentInCents,
  }) {
    final percentage = calculatePercentage(spentInCents, budgetLimitInCents);
    final status = calculateStatus(percentage, budgetLimitInCents != null);
    final remaining = calculateRemaining(spentInCents, budgetLimitInCents);

    return CategoryBudgetProgress(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      categoryColor: categoryColor,
      budgetLimitInCents: budgetLimitInCents,
      spentInCents: spentInCents,
      progressPercentage: percentage,
      status: status,
      remainingInCents: remaining,
    );
  }

  /// Check if category has a budget set
  bool get hasBudget => budgetLimitInCents != null && budgetLimitInCents! > 0;

  /// Check if over budget
  bool get isOverBudget => status == BudgetStatus.overBudget;

  /// Check if near limit
  bool get isNearLimit => status == BudgetStatus.nearLimit;

  /// Check if on track
  bool get isOnTrack => status == BudgetStatus.onTrack;
}

