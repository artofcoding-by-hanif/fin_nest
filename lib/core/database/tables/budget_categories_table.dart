import 'package:drift/drift.dart';

/// Budget categories junction table (many-to-many relationship)
@DataClassName('BudgetCategoryEntity')
class BudgetCategories extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// Budget ID (foreign key)
  IntColumn get budgetId => integer()();
  
  /// Category ID (foreign key)
  IntColumn get categoryId => integer()();
  
  /// Allocated amount in cents for this category
  IntColumn get allocatedAmountInCents => integer()();
  
  /// When the allocation was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the allocation was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

