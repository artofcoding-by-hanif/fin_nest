import 'package:drift/drift.dart';

/// Savings category types
enum SavingsCategory {
  nps,
  lic,
  mutualFund,
  ksfe,
  gold,
  cash,
  stocks,
  fixedDeposit,
  ppf,
  other,
}

/// Savings table for tracking various savings and investments
@DataClassName('SavingsEntity')
class Savings extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Savings category
  IntColumn get category => intEnum<SavingsCategory>()();
  
  /// Savings name/description
  TextColumn get name => text()();
  
  /// Current value in cents
  IntColumn get currentValueInCents => integer()();
  
  /// Invested/Principal amount in cents
  IntColumn get investedAmountInCents => integer()();
  
  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  
  /// Maturity date (optional)
  DateTimeColumn get maturityDate => dateTime().nullable()();
  
  /// Interest rate (optional, stored as percentage * 100, e.g., 7.5% = 750)
  IntColumn get interestRate => integer().nullable()();
  
  /// Account/Policy/Folio number
  TextColumn get accountNumber => text().nullable()();
  
  /// Institution/Company name (e.g., SBI, HDFC, LIC)
  TextColumn get institutionName => text().nullable()();
  
  /// Additional notes
  TextColumn get notes => text().nullable()();
  
  /// Whether this savings is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  /// Color for UI display (hex code)
  TextColumn get color => text().nullable()();
  
  /// Icon name for UI display
  TextColumn get icon => text().nullable()();
  
  /// When the savings entry was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the savings entry was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

