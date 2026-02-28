import 'package:drift/drift.dart';

/// Savings transaction types
enum SavingsTransactionType {
  deposit, // Money added to savings
  withdrawal, // Money withdrawn from savings
  interest, // Interest earned
  dividend, // Dividend received
  appreciation, // Value appreciation (for stocks, mutual funds, gold)
  depreciation, // Value depreciation
}

/// Savings transactions table for tracking deposits, withdrawals, and other changes to savings
@DataClassName('SavingsTransactionEntity')
class SavingsTransactions extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// User ID (foreign key)
  IntColumn get userId => integer()();

  /// Savings ID (foreign key to Savings table)
  IntColumn get savingsId => integer()();

  /// Transaction type
  IntColumn get type => intEnum<SavingsTransactionType>()();

  /// Amount in cents
  IntColumn get amountInCents => integer()();

  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('INR'))();

  /// Transaction date
  DateTimeColumn get transactionDate => dateTime()();

  /// Additional notes
  TextColumn get notes => text().nullable()();

  /// Units (for mutual funds, stocks - optional)
  RealColumn get units => real().nullable()();

  /// NAV/Price per unit (for mutual funds, stocks - optional, stored in cents)
  IntColumn get pricePerUnitInCents => integer().nullable()();

  /// Whether this is from a recurring transaction
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();

  /// Recurring transaction ID (if this is part of a recurring series)
  IntColumn get recurringTransactionId => integer().nullable()();

  /// Linked expense transaction ID (for deposits that create expense transactions)
  IntColumn get linkedTransactionId => integer().nullable()();

  /// When the transaction was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the transaction was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
