import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

/// Data Access Object for Transactions table
@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  /// Constructor
  TransactionsDao(super.db);

  /// Get transaction by ID
  Future<TransactionEntity?> getTransactionById(int id) {
    return (select(
      transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get all transactions for a user
  Future<List<TransactionEntity>> getTransactionsByUserId(int userId) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get transactions for an account
  Future<List<TransactionEntity>> getTransactionsByAccountId(int accountId) {
    return (select(transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get transactions by category
  Future<List<TransactionEntity>> getTransactionsByCategoryId(int categoryId) {
    return (select(transactions)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get transactions by date range
  Future<List<TransactionEntity>> getTransactionsByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(transactions)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.transactionDate.isBiggerOrEqualValue(startDate) &
                t.transactionDate.isSmallerOrEqualValue(endDate),
          )
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get transactions by type
  Future<List<TransactionEntity>> getTransactionsByType(
    int userId,
    TransactionType type,
  ) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId) & t.type.equalsValue(type))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get recent transactions
  Future<List<TransactionEntity>> getRecentTransactions(
    int userId, {
    int limit = 10,
  }) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(limit))
        .get();
  }

  /// Create a new transaction
  Future<int> createTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  /// Update a transaction
  Future<bool> updateTransaction(TransactionEntity transaction) {
    return update(transactions).replace(transaction);
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Get total income for a period
  Future<int> getTotalIncome(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final incomeTransactions =
        await (select(transactions)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.type.equalsValue(TransactionType.income) &
                  t.status.equalsValue(TransactionStatus.completed) &
                  t.transactionDate.isBiggerOrEqualValue(startDate) &
                  t.transactionDate.isSmallerOrEqualValue(endDate),
            ))
            .get();

    return incomeTransactions.fold<int>(
      0,
      (sum, transaction) => sum + transaction.amountInCents,
    );
  }

  /// Get total expenses for a period
  Future<int> getTotalExpenses(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenseTransactions =
        await (select(transactions)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.type.equalsValue(TransactionType.expense) &
                  t.status.equalsValue(TransactionStatus.completed) &
                  t.transactionDate.isBiggerOrEqualValue(startDate) &
                  t.transactionDate.isSmallerOrEqualValue(endDate),
            ))
            .get();

    return expenseTransactions.fold<int>(
      0,
      (sum, transaction) => sum + transaction.amountInCents,
    );
  }

  /// Watch transactions for a user (reactive)
  Stream<List<TransactionEntity>> watchTransactionsByUserId(int userId) {
    return (select(transactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  /// Watch transaction by ID (reactive)
  Stream<TransactionEntity?> watchTransactionById(int id) {
    return (select(
      transactions,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Get total spending for a specific category in a date range
  Future<int> getTotalByCategory({
    required int categoryId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final categoryTransactions =
        await (select(transactions)..where(
              (t) =>
                  t.categoryId.equals(categoryId) &
                  t.type.equalsValue(TransactionType.expense) &
                  t.status.equalsValue(TransactionStatus.completed) &
                  t.transactionDate.isBiggerOrEqualValue(startDate) &
                  t.transactionDate.isSmallerOrEqualValue(endDate),
            ))
            .get();

    return categoryTransactions.fold<int>(
      0,
      (sum, transaction) => sum + transaction.amountInCents,
    );
  }

  /// Get expenses grouped by category for a period
  Future<Map<int, int>> getExpensesByCategory(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenseTransactions =
        await (select(transactions)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.type.equalsValue(TransactionType.expense) &
                  t.status.equalsValue(TransactionStatus.completed) &
                  t.transactionDate.isBiggerOrEqualValue(startDate) &
                  t.transactionDate.isSmallerOrEqualValue(endDate) &
                  t.categoryId.isNotNull(),
            ))
            .get();

    // Group by category and sum amounts
    final Map<int, int> categoryTotals = {};
    for (final transaction in expenseTransactions) {
      final categoryId = transaction.categoryId!;
      categoryTotals[categoryId] =
          (categoryTotals[categoryId] ?? 0) + transaction.amountInCents;
    }

    return categoryTotals;
  }

  /// Get monthly expenses for the last N months
  Future<List<MonthlyTotal>> getMonthlyExpenses(
    int userId,
    int numberOfMonths,
  ) async {
    final now = DateTime.now();
    final List<MonthlyTotal> monthlyTotals = [];

    for (int i = 0; i < numberOfMonths; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
      final endOfMonth = DateTime(
        monthDate.year,
        monthDate.month + 1,
        0,
        23,
        59,
        59,
      );

      final total = await getTotalExpenses(userId, startOfMonth, endOfMonth);
      monthlyTotals.add(
        MonthlyTotal(
          year: monthDate.year,
          month: monthDate.month,
          totalInCents: total,
        ),
      );
    }

    return monthlyTotals.reversed.toList();
  }

  /// Get monthly income for the last N months
  Future<List<MonthlyTotal>> getMonthlyIncome(
    int userId,
    int numberOfMonths,
  ) async {
    final now = DateTime.now();
    final List<MonthlyTotal> monthlyTotals = [];

    for (int i = 0; i < numberOfMonths; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
      final endOfMonth = DateTime(
        monthDate.year,
        monthDate.month + 1,
        0,
        23,
        59,
        59,
      );

      final total = await getTotalIncome(userId, startOfMonth, endOfMonth);
      monthlyTotals.add(
        MonthlyTotal(
          year: monthDate.year,
          month: monthDate.month,
          totalInCents: total,
        ),
      );
    }

    return monthlyTotals.reversed.toList();
  }

  /// Get top spending category for a period
  Future<CategorySpending?> getTopSpendingCategory(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final categoryExpenses = await getExpensesByCategory(
      userId,
      startDate,
      endDate,
    );

    if (categoryExpenses.isEmpty) {
      return null;
    }

    // Find category with highest spending
    int topCategoryId = 0;
    int maxAmount = 0;

    categoryExpenses.forEach((categoryId, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        topCategoryId = categoryId;
      }
    });

    return CategorySpending(categoryId: topCategoryId, totalInCents: maxAmount);
  }

  /// Get weekly summary (last 7 days)
  Future<WeeklySummary> getWeeklySummary(int userId) async {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - 6);
    final endOfWeek = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final totalIncome = await getTotalIncome(userId, startOfWeek, endOfWeek);
    final totalExpenses = await getTotalExpenses(
      userId,
      startOfWeek,
      endOfWeek,
    );

    // Get transaction count
    final transactions =
        await (select(this.transactions)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.status.equalsValue(TransactionStatus.completed) &
                  t.transactionDate.isBiggerOrEqualValue(startOfWeek) &
                  t.transactionDate.isSmallerOrEqualValue(endOfWeek),
            ))
            .get();

    return WeeklySummary(
      totalIncomeInCents: totalIncome,
      totalExpensesInCents: totalExpenses,
      transactionCount: transactions.length,
      startDate: startOfWeek,
      endDate: endOfWeek,
    );
  }

  /// Get average daily spending for a period
  Future<double> getAverageDailySpending(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final totalExpenses = await getTotalExpenses(userId, startDate, endDate);
    final days = endDate.difference(startDate).inDays + 1;
    return days > 0 ? totalExpenses / days : 0.0;
  }

  /// Get spending trend (compare current period with previous period)
  Future<SpendingTrend> getSpendingTrend(int userId) async {
    final now = DateTime.now();

    // Current month
    final currentMonthStart = DateTime(now.year, now.month, 1);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    final currentMonthExpenses = await getTotalExpenses(
      userId,
      currentMonthStart,
      currentMonthEnd,
    );

    // Previous month
    final previousMonthStart = DateTime(now.year, now.month - 1, 1);
    final previousMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
    final previousMonthExpenses = await getTotalExpenses(
      userId,
      previousMonthStart,
      previousMonthEnd,
    );

    final difference = currentMonthExpenses - previousMonthExpenses;
    final percentageChange = previousMonthExpenses > 0
        ? (difference / previousMonthExpenses) * 100
        : 0.0;

    return SpendingTrend(
      currentPeriodInCents: currentMonthExpenses,
      previousPeriodInCents: previousMonthExpenses,
      differenceInCents: difference,
      percentageChange: percentageChange,
    );
  }

  /// Get budget progress for categories with budget limits
  Future<List<BudgetProgress>> getBudgetProgress(int userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Get all categories with budget limits
    final categoriesWithBudget = await db.categoriesDao.getCategoriesByUserId(
      userId,
    );
    final budgetCategories = categoriesWithBudget
        .where((c) => c.budgetLimitInCents != null && c.budgetLimitInCents! > 0)
        .toList();

    final List<BudgetProgress> progressList = [];

    for (final category in budgetCategories) {
      // Get spending for this category this month
      final categoryExpenses = await getExpensesByCategory(
        userId,
        startOfMonth,
        endOfMonth,
      );

      final spent = categoryExpenses[category.id] ?? 0;
      final budget = category.budgetLimitInCents!;
      final percentage = (spent / budget) * 100;

      progressList.add(
        BudgetProgress(
          categoryId: category.id,
          categoryName: category.name,
          budgetLimitInCents: budget,
          spentInCents: spent,
          remainingInCents: budget - spent,
          percentageUsed: percentage,
        ),
      );
    }

    return progressList;
  }

  /// Get savings rate (income - expenses) / income * 100
  Future<SavingsRate> getSavingsRate(int userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final totalIncome = await getTotalIncome(userId, startOfMonth, endOfMonth);
    final totalExpenses = await getTotalExpenses(
      userId,
      startOfMonth,
      endOfMonth,
    );

    final savings = totalIncome - totalExpenses;
    final savingsRate = totalIncome > 0 ? (savings / totalIncome) * 100 : 0.0;

    return SavingsRate(
      totalIncomeInCents: totalIncome,
      totalExpensesInCents: totalExpenses,
      savingsInCents: savings,
      savingsRatePercentage: savingsRate,
    );
  }
}

/// Data class for monthly totals
class MonthlyTotal {
  final int year;
  final int month;
  final int totalInCents;

  MonthlyTotal({
    required this.year,
    required this.month,
    required this.totalInCents,
  });

  String get monthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

/// Data class for category spending
class CategorySpending {
  final int categoryId;
  final int totalInCents;

  CategorySpending({required this.categoryId, required this.totalInCents});
}

/// Data class for weekly summary
class WeeklySummary {
  final int totalIncomeInCents;
  final int totalExpensesInCents;
  final int transactionCount;
  final DateTime startDate;
  final DateTime endDate;

  WeeklySummary({
    required this.totalIncomeInCents,
    required this.totalExpensesInCents,
    required this.transactionCount,
    required this.startDate,
    required this.endDate,
  });

  int get netInCents => totalIncomeInCents - totalExpensesInCents;
}

/// Data class for spending trend
class SpendingTrend {
  final int currentPeriodInCents;
  final int previousPeriodInCents;
  final int differenceInCents;
  final double percentageChange;

  SpendingTrend({
    required this.currentPeriodInCents,
    required this.previousPeriodInCents,
    required this.differenceInCents,
    required this.percentageChange,
  });

  bool get isIncreasing => differenceInCents > 0;
  bool get isDecreasing => differenceInCents < 0;
  bool get isStable => differenceInCents == 0;
}

/// Data class for budget progress
class BudgetProgress {
  final int categoryId;
  final String categoryName;
  final int budgetLimitInCents;
  final int spentInCents;
  final int remainingInCents;
  final double percentageUsed;

  BudgetProgress({
    required this.categoryId,
    required this.categoryName,
    required this.budgetLimitInCents,
    required this.spentInCents,
    required this.remainingInCents,
    required this.percentageUsed,
  });

  bool get isOverBudget => spentInCents > budgetLimitInCents;
  bool get isNearLimit => percentageUsed >= 80 && percentageUsed < 100;
  bool get isOnTrack => percentageUsed < 80;
}

/// Data class for savings rate
class SavingsRate {
  final int totalIncomeInCents;
  final int totalExpensesInCents;
  final int savingsInCents;
  final double savingsRatePercentage;

  SavingsRate({
    required this.totalIncomeInCents,
    required this.totalExpensesInCents,
    required this.savingsInCents,
    required this.savingsRatePercentage,
  });

  bool get isSaving => savingsInCents > 0;
  bool get isBreakingEven => savingsInCents == 0;
  bool get isOverspending => savingsInCents < 0;
}
