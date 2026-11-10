// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_transactions_dao.dart';

// ignore_for_file: type=lint
mixin _$SavingsTransactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SavingsTransactionsTable get savingsTransactions =>
      attachedDatabase.savingsTransactions;
  SavingsTransactionsDaoManager get managers =>
      SavingsTransactionsDaoManager(this);
}

class SavingsTransactionsDaoManager {
  final _$SavingsTransactionsDaoMixin _db;
  SavingsTransactionsDaoManager(this._db);
  $$SavingsTransactionsTableTableManager get savingsTransactions =>
      $$SavingsTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.savingsTransactions,
      );
}
