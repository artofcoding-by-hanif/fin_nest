import 'package:drift/drift.dart';

/// Transaction types
enum TransactionType {
  income,
  expense,
  transfer,
}

/// Transaction status
enum TransactionStatus {
  pending,
  completed,
  cancelled,
}

/// Transactions table for storing financial transactions
@DataClassName('TransactionEntity')
class Transactions extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Account ID (foreign key)
  IntColumn get accountId => integer()();
  
  /// Category ID (foreign key)
  IntColumn get categoryId => integer().nullable()();
  
  /// Transaction type
  IntColumn get type => intEnum<TransactionType>()();
  
  /// Transaction status
  IntColumn get status => intEnum<TransactionStatus>().withDefault(const Constant(1))(); // completed
  
  /// Amount in cents
  IntColumn get amountInCents => integer()();
  
  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  
  /// Transaction description
  TextColumn get description => text()();
  
  /// Additional notes
  TextColumn get notes => text().nullable()();
  
  /// Transaction date
  DateTimeColumn get transactionDate => dateTime()();
  
  /// Payee/Payer name
  TextColumn get payee => text().nullable()();
  
  /// Location where transaction occurred
  TextColumn get location => text().nullable()();
  
  /// Tags (comma-separated)
  TextColumn get tags => text().nullable()();
  
  /// Receipt/attachment URL
  TextColumn get attachmentUrl => text().nullable()();
  
  /// For transfers: destination account ID
  IntColumn get toAccountId => integer().nullable()();
  
  /// Whether this is a recurring transaction
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  
  /// Recurring transaction ID (if this is part of a recurring series)
  IntColumn get recurringTransactionId => integer().nullable()();
  
  /// External transaction ID (from bank sync)
  TextColumn get externalId => text().nullable()();
  
  /// When the transaction was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the transaction was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

