import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/categories_table.dart';
import '../../domain/models/category_budget_progress.dart';

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Provider for expense categories with budgets
final expenseCategoriesWithBudgetsProvider =
    StreamProvider<List<CategoryEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  // For now, use a hardcoded user ID of 1
  // TODO: Replace with actual user ID from auth
  return db.categoriesDao.watchCategoriesByType(1, CategoryType.expense);
});

/// Provider for a single category budget progress
final categoryBudgetProgressProvider =
    FutureProvider.family<CategoryBudgetProgress, int>((ref, categoryId) async {
  final db = ref.watch(databaseProvider);
  
  // Get category details
  final category = await db.categoriesDao.getCategoryById(categoryId);
  if (category == null) {
    throw Exception('Category not found');
  }

  // Get current month's spending for this category
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  final spending = await db.transactionsDao.getTotalByCategory(
    categoryId: categoryId,
    startDate: startOfMonth,
    endDate: endOfMonth,
  );

  // Create budget progress
  return CategoryBudgetProgress.fromCategoryAndSpending(
    categoryId: category.id,
    categoryName: category.name,
    categoryIcon: category.icon,
    categoryColor: category.color,
    budgetLimitInCents: category.budgetLimitInCents,
    spentInCents: spending,
  );
});

/// Provider for all budget progress (only categories with budgets)
final allBudgetProgressProvider =
    FutureProvider<List<CategoryBudgetProgress>>((ref) async {
  final db = ref.watch(databaseProvider);
  
  // Get all expense categories
  final categories = await db.categoriesDao.getCategoriesByType(
    1, // TODO: Replace with actual user ID
    CategoryType.expense,
  );

  // Filter categories with budgets
  final categoriesWithBudgets = categories
      .where((c) => c.budgetLimitInCents != null && c.budgetLimitInCents! > 0)
      .toList();

  if (categoriesWithBudgets.isEmpty) {
    return [];
  }

  // Get current month's date range
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  // Calculate progress for each category
  final progressList = <CategoryBudgetProgress>[];
  
  for (final category in categoriesWithBudgets) {
    final spending = await db.transactionsDao.getTotalByCategory(
      categoryId: category.id,
      startDate: startOfMonth,
      endDate: endOfMonth,
    );

    final progress = CategoryBudgetProgress.fromCategoryAndSpending(
      categoryId: category.id,
      categoryName: category.name,
      categoryIcon: category.icon,
      categoryColor: category.color,
      budgetLimitInCents: category.budgetLimitInCents,
      spentInCents: spending,
    );

    progressList.add(progress);
  }

  // Sort by progress percentage (highest first)
  progressList.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));

  return progressList;
});

/// Provider for budget summary statistics
final budgetSummaryProvider = FutureProvider<BudgetSummary>((ref) async {
  final budgetProgress = await ref.watch(allBudgetProgressProvider.future);

  if (budgetProgress.isEmpty) {
    return const BudgetSummary(
      totalBudgetInCents: 0,
      totalSpentInCents: 0,
      totalRemainingInCents: 0,
      categoriesOnTrack: 0,
      categoriesNearLimit: 0,
      categoriesOverBudget: 0,
    );
  }

  final totalBudget = budgetProgress.fold<int>(
    0,
    (sum, p) => sum + (p.budgetLimitInCents ?? 0),
  );

  final totalSpent = budgetProgress.fold<int>(
    0,
    (sum, p) => sum + p.spentInCents,
  );

  final totalRemaining = totalBudget - totalSpent;

  final onTrack = budgetProgress.where((p) => p.isOnTrack).length;
  final nearLimit = budgetProgress.where((p) => p.isNearLimit).length;
  final overBudget = budgetProgress.where((p) => p.isOverBudget).length;

  return BudgetSummary(
    totalBudgetInCents: totalBudget,
    totalSpentInCents: totalSpent,
    totalRemainingInCents: totalRemaining,
    categoriesOnTrack: onTrack,
    categoriesNearLimit: nearLimit,
    categoriesOverBudget: overBudget,
  );
});

/// Budget summary model
class BudgetSummary {
  final int totalBudgetInCents;
  final int totalSpentInCents;
  final int totalRemainingInCents;
  final int categoriesOnTrack;
  final int categoriesNearLimit;
  final int categoriesOverBudget;

  const BudgetSummary({
    required this.totalBudgetInCents,
    required this.totalSpentInCents,
    required this.totalRemainingInCents,
    required this.categoriesOnTrack,
    required this.categoriesNearLimit,
    required this.categoriesOverBudget,
  });
}

