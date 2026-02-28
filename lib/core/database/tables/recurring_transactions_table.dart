import 'package:drift/drift.dart';

/// Recurrence frequency
enum RecurrenceFrequency { daily, weekly, biweekly, monthly, quarterly, yearly }

/// Recurring transactions table
@DataClassName('RecurringTransactionEntity')
class RecurringTransactions extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// User ID (foreign key)
  IntColumn get userId => integer()();

  /// Account ID (foreign key)
  IntColumn get accountId => integer()();

  /// Category ID (foreign key)
  IntColumn get categoryId => integer().nullable()();

  /// Transaction type (income/expense/transfer)
  IntColumn get type => integer()();

  /// Amount in cents
  IntColumn get amountInCents => integer()();

  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  /// Description
  TextColumn get description => text()();

  /// Recurrence frequency
  IntColumn get frequency => intEnum<RecurrenceFrequency>()();

  /// Start date
  DateTimeColumn get startDate => dateTime()();

  /// End date (null for indefinite)
  DateTimeColumn get endDate => dateTime().nullable()();

  /// Next occurrence date
  DateTimeColumn get nextOccurrence => dateTime()();

  /// Last occurrence date
  DateTimeColumn get lastOccurrence => dateTime().nullable()();

  /// Whether this recurring transaction is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Whether to auto-create transactions
  BoolColumn get autoCreate => boolean().withDefault(const Constant(true))();

  /// Days before to create transaction
  IntColumn get daysBeforeToCreate =>
      integer().withDefault(const Constant(0))();

  /// Payee/Payer name
  TextColumn get payee => text().nullable()();

  /// Notes
  TextColumn get notes => text().nullable()();

  /// Whether to show notifications for this recurring transaction
  BoolColumn get enableNotifications =>
      boolean().withDefault(const Constant(false))();

  /// Minutes before the transaction to show notification (0 = on due date)
  IntColumn get notificationMinutesBefore =>
      integer().withDefault(const Constant(0))();

  /// When the recurring transaction was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// When the recurring transaction was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
