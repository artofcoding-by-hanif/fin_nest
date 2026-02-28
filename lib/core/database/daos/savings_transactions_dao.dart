import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/savings_transactions_table.dart';

part 'savings_transactions_dao.g.dart';

/// Data Access Object for SavingsTransactions table
@DriftAccessor(tables: [SavingsTransactions])
class SavingsTransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsTransactionsDaoMixin {
  /// Constructor
  SavingsTransactionsDao(super.db);

  /// Get transaction by ID
  Future<SavingsTransactionEntity?> getTransactionById(int id) {
    return (select(
      savingsTransactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get all transactions for a savings account
  Future<List<SavingsTransactionEntity>> getTransactionsBySavingsId(
    int savingsId,
  ) {
    return (select(savingsTransactions)
          ..where((t) => t.savingsId.equals(savingsId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get all transactions for a user
  Future<List<SavingsTransactionEntity>> getTransactionsByUserId(int userId) {
    return (select(savingsTransactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get transactions by type for a savings account
  Future<List<SavingsTransactionEntity>> getTransactionsByType(
    int savingsId,
    SavingsTransactionType type,
  ) {
    return (select(savingsTransactions)
          ..where(
            (t) => t.savingsId.equals(savingsId) & t.type.equalsValue(type),
          )
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Get total deposits for a savings account
  Future<int> getTotalDeposits(int savingsId) async {
    final query = selectOnly(savingsTransactions)
      ..where(
        savingsTransactions.savingsId.equals(savingsId) &
            savingsTransactions.type.equalsValue(
              SavingsTransactionType.deposit,
            ),
      )
      ..addColumns([savingsTransactions.amountInCents.sum()]);

    final result = await query.getSingleOrNull();
    return result?.read(savingsTransactions.amountInCents.sum()) ?? 0;
  }

  /// Get total withdrawals for a savings account
  Future<int> getTotalWithdrawals(int savingsId) async {
    final query = selectOnly(savingsTransactions)
      ..where(
        savingsTransactions.savingsId.equals(savingsId) &
            savingsTransactions.type.equalsValue(
              SavingsTransactionType.withdrawal,
            ),
      )
      ..addColumns([savingsTransactions.amountInCents.sum()]);

    final result = await query.getSingleOrNull();
    return result?.read(savingsTransactions.amountInCents.sum()) ?? 0;
  }

  /// Create a new transaction
  Future<int> createTransaction(SavingsTransactionsCompanion transaction) {
    return into(savingsTransactions).insert(transaction);
  }

  /// Update a transaction
  Future<bool> updateTransaction(SavingsTransactionEntity transaction) {
    return update(savingsTransactions).replace(transaction);
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id) {
    return (delete(savingsTransactions)..where((t) => t.id.equals(id))).go();
  }

  /// Watch all transactions for a savings account (reactive)
  Stream<List<SavingsTransactionEntity>> watchTransactionsBySavingsId(
    int savingsId,
  ) {
    return (select(savingsTransactions)
          ..where((t) => t.savingsId.equals(savingsId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  /// Watch transaction by ID (reactive)
  Stream<SavingsTransactionEntity?> watchTransactionById(int id) {
    return (select(
      savingsTransactions,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Watch all transactions for a user (reactive)
  Stream<List<SavingsTransactionEntity>> watchTransactionsByUserId(int userId) {
    return (select(savingsTransactions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.transactionDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }
}
