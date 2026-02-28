import 'package:drift/drift.dart';

/// Budget period types
enum BudgetPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

/// Budgets table for budget tracking
@DataClassName('BudgetEntity')
class Budgets extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Budget name
  TextColumn get name => text()();
  
  /// Budget amount in cents
  IntColumn get amountInCents => integer()();
  
  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  
  /// Budget period
  IntColumn get period => intEnum<BudgetPeriod>()();
  
  /// Period start date
  DateTimeColumn get startDate => dateTime()();
  
  /// Period end date
  DateTimeColumn get endDate => dateTime()();
  
  /// Whether to rollover unused budget
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();
  
  /// Alert threshold percentage (0-100)
  IntColumn get alertThreshold => integer().withDefault(const Constant(80))();
  
  /// Whether alerts are enabled
  BoolColumn get alertsEnabled => boolean().withDefault(const Constant(true))();
  
  /// Whether this budget is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  /// Budget color (hex code)
  TextColumn get color => text().nullable()();
  
  /// Budget icon name
  TextColumn get icon => text().nullable()();
  
  /// Notes about the budget
  TextColumn get notes => text().nullable()();
  
  /// When the budget was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the budget was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

