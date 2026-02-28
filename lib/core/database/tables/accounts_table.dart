import 'package:drift/drift.dart';

/// Account types
enum AccountType {
  cash,
  bank,
  creditCard,
  investment,
  loan,
  other,
}

/// Accounts table for storing financial accounts
@DataClassName('AccountEntity')
class Accounts extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Account name
  TextColumn get name => text()();
  
  /// Account type
  IntColumn get type => intEnum<AccountType>()();
  
  /// Account balance in cents (to avoid floating point issues)
  IntColumn get balanceInCents => integer().withDefault(const Constant(0))();
  
  /// Currency code (ISO 4217)
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  
  /// Account color (hex code)
  TextColumn get color => text().nullable()();
  
  /// Account icon name
  TextColumn get icon => text().nullable()();
  
  /// Account number (masked)
  TextColumn get accountNumber => text().nullable()();
  
  /// Bank name
  TextColumn get bankName => text().nullable()();
  
  /// Whether this is the default account
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  
  /// Whether this account is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  /// Whether to include in total balance
  BoolColumn get includeInTotal => boolean().withDefault(const Constant(true))();
  
  /// Notes about the account
  TextColumn get notes => text().nullable()();
  
  /// When the account was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the account was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// Display order
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}

