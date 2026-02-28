import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/recurring_transactions_table.dart';

part 'recurring_transactions_dao.g.dart';

/// Data Access Object for RecurringTransactions table
@DriftAccessor(tables: [RecurringTransactions])
class RecurringTransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$RecurringTransactionsDaoMixin {
  /// Constructor
  RecurringTransactionsDao(super.db);

  /// Get recurring transaction by ID
  Future<RecurringTransactionEntity?> getRecurringTransactionById(int id) {
    return (select(recurringTransactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get all recurring transactions for a user
  Future<List<RecurringTransactionEntity>> getRecurringTransactionsByUserId(
    int userId,
  ) {
    return (select(recurringTransactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextOccurrence, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Get active recurring transactions for a user
  Future<List<RecurringTransactionEntity>> getActiveRecurringTransactions(
    int userId,
  ) {
    return (select(recurringTransactions)
          ..where((t) => t.userId.equals(userId) & t.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextOccurrence, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Get recurring transactions by type
  Future<List<RecurringTransactionEntity>> getRecurringTransactionsByType(
    int userId,
    int type,
  ) {
    return (select(recurringTransactions)
          ..where((t) => t.userId.equals(userId) & t.type.equals(type))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextOccurrence, mode: OrderingMode.asc)
          ]))
        .get();
  }

  /// Get recurring transactions due for processing
  /// Returns transactions where nextOccurrence <= currentDate + daysBeforeToCreate
  Future<List<RecurringTransactionEntity>> getDueRecurringTransactions(
    int userId,
    DateTime currentDate,
  ) async {
    final allActive = await getActiveRecurringTransactions(userId);
    
    return allActive.where((rt) {
      final dueDate = currentDate.add(Duration(days: rt.daysBeforeToCreate));
      return rt.nextOccurrence.isBefore(dueDate) || 
             rt.nextOccurrence.isAtSameMomentAs(dueDate);
    }).toList();
  }

  /// Create a new recurring transaction
  Future<int> createRecurringTransaction(
    RecurringTransactionsCompanion recurringTransaction,
  ) {
    return into(recurringTransactions).insert(recurringTransaction);
  }

  /// Update a recurring transaction
  Future<bool> updateRecurringTransaction(
    RecurringTransactionEntity recurringTransaction,
  ) {
    return update(recurringTransactions).replace(recurringTransaction);
  }

  /// Delete a recurring transaction
  Future<int> deleteRecurringTransaction(int id) {
    return (delete(recurringTransactions)..where((t) => t.id.equals(id))).go();
  }

  /// Deactivate a recurring transaction
  Future<int> deactivateRecurringTransaction(int id) async {
    return (update(recurringTransactions)..where((t) => t.id.equals(id)))
        .write(const RecurringTransactionsCompanion(isActive: Value(false)));
  }

  /// Activate a recurring transaction
  Future<int> activateRecurringTransaction(int id) async {
    return (update(recurringTransactions)..where((t) => t.id.equals(id)))
        .write(const RecurringTransactionsCompanion(isActive: Value(true)));
  }

  /// Update next occurrence date
  Future<int> updateNextOccurrence(int id, DateTime nextOccurrence) async {
    return (update(recurringTransactions)..where((t) => t.id.equals(id)))
        .write(RecurringTransactionsCompanion(
          nextOccurrence: Value(nextOccurrence),
          lastOccurrence: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Watch recurring transactions for a user (reactive)
  Stream<List<RecurringTransactionEntity>> watchRecurringTransactionsByUserId(
    int userId,
  ) {
    return (select(recurringTransactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextOccurrence, mode: OrderingMode.asc)
          ]))
        .watch();
  }

  /// Watch active recurring transactions (reactive)
  Stream<List<RecurringTransactionEntity>> watchActiveRecurringTransactions(
    int userId,
  ) {
    return (select(recurringTransactions)
          ..where((t) => t.userId.equals(userId) & t.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm(expression: t.nextOccurrence, mode: OrderingMode.asc)
          ]))
        .watch();
  }

  /// Watch recurring transaction by ID (reactive)
  Stream<RecurringTransactionEntity?> watchRecurringTransactionById(int id) {
    return (select(recurringTransactions)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }
}

