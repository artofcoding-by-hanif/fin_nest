import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/savings_table.dart';

part 'savings_dao.g.dart';

/// Data Access Object for Savings table
@DriftAccessor(tables: [Savings])
class SavingsDao extends DatabaseAccessor<AppDatabase> with _$SavingsDaoMixin {
  /// Constructor
  SavingsDao(super.db);

  /// Get savings by ID
  Future<SavingsEntity?> getSavingsById(int id) {
    return (select(savings)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Get all savings for a user
  Future<List<SavingsEntity>> getSavingsByUserId(int userId) {
    return (select(savings)
          ..where((s) => s.userId.equals(userId))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get active savings for a user
  Future<List<SavingsEntity>> getActiveSavings(int userId) {
    return (select(savings)
          ..where((s) => s.userId.equals(userId) & s.isActive.equals(true))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get savings by category
  Future<List<SavingsEntity>> getSavingsByCategory(
    int userId,
    SavingsCategory category,
  ) {
    return (select(savings)
          ..where(
            (s) =>
                s.userId.equals(userId) &
                s.category.equalsValue(category) &
                s.isActive.equals(true),
          )
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get total savings value for a user
  Future<int> getTotalSavingsValue(int userId) async {
    final query = selectOnly(savings)
      ..addColumns([savings.currentValueInCents.sum()])
      ..where(savings.userId.equals(userId) & savings.isActive.equals(true));

    final result = await query.getSingleOrNull();
    return result?.read(savings.currentValueInCents.sum()) ?? 0;
  }

  /// Get total invested amount for a user
  Future<int> getTotalInvestedAmount(int userId) async {
    final query = selectOnly(savings)
      ..addColumns([savings.investedAmountInCents.sum()])
      ..where(savings.userId.equals(userId) & savings.isActive.equals(true));

    final result = await query.getSingleOrNull();
    return result?.read(savings.investedAmountInCents.sum()) ?? 0;
  }

  /// Get savings grouped by category with totals
  Future<Map<SavingsCategory, int>> getSavingsByCategoryTotals(
    int userId,
  ) async {
    final allSavings = await getActiveSavings(userId);
    final Map<SavingsCategory, int> categoryTotals = {};

    for (final saving in allSavings) {
      categoryTotals[saving.category] =
          (categoryTotals[saving.category] ?? 0) + saving.currentValueInCents;
    }

    return categoryTotals;
  }

  /// Create a new savings entry
  Future<int> createSavings(SavingsCompanion savings) {
    return into(this.savings).insert(savings);
  }

  /// Update a savings entry
  Future<bool> updateSavings(SavingsEntity savings) {
    return update(this.savings).replace(savings);
  }

  /// Delete a savings entry
  Future<int> deleteSavings(int id) {
    return (delete(this.savings)..where((s) => s.id.equals(id))).go();
  }

  /// Deactivate a savings entry (soft delete)
  Future<void> deactivateSavings(int id) {
    return (update(savings)..where((s) => s.id.equals(id))).write(
      const SavingsCompanion(isActive: Value(false)),
    );
  }

  /// Watch all savings for a user (reactive)
  Stream<List<SavingsEntity>> watchSavingsByUserId(int userId) {
    return (select(savings)
          ..where((s) => s.userId.equals(userId))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Watch active savings for a user (reactive)
  Stream<List<SavingsEntity>> watchActiveSavings(int userId) {
    return (select(savings)
          ..where((s) => s.userId.equals(userId) & s.isActive.equals(true))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Watch savings by category (reactive)
  Stream<List<SavingsEntity>> watchSavingsByCategory(
    int userId,
    SavingsCategory category,
  ) {
    return (select(savings)
          ..where(
            (s) =>
                s.userId.equals(userId) &
                s.category.equalsValue(category) &
                s.isActive.equals(true),
          )
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Watch savings by ID (reactive)
  Stream<SavingsEntity?> watchSavingsById(int id) {
    return (select(savings)..where((s) => s.id.equals(id))).watchSingleOrNull();
  }

  /// Watch total savings value for a user (reactive)
  Stream<int> watchTotalSavingsValue(int userId) {
    final query = selectOnly(savings)
      ..addColumns([savings.currentValueInCents.sum()])
      ..where(savings.userId.equals(userId) & savings.isActive.equals(true));

    return query.watch().map((rows) {
      final result = rows.firstOrNull;
      return result?.read(savings.currentValueInCents.sum()) ?? 0;
    });
  }

  /// Watch total invested amount for a user (reactive)
  Stream<int> watchTotalInvestedAmount(int userId) {
    final query = selectOnly(savings)
      ..addColumns([savings.investedAmountInCents.sum()])
      ..where(savings.userId.equals(userId) & savings.isActive.equals(true));

    return query.watch().map((rows) {
      final result = rows.firstOrNull;
      return result?.read(savings.investedAmountInCents.sum()) ?? 0;
    });
  }
}
