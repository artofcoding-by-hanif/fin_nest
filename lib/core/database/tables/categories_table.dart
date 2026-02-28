import 'package:drift/drift.dart';

/// Category types
enum CategoryType {
  income,
  expense,
}

/// Categories table for transaction categorization
@DataClassName('CategoryEntity')
class Categories extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Category name
  TextColumn get name => text()();
  
  /// Category type (income or expense)
  IntColumn get type => intEnum<CategoryType>()();
  
  /// Parent category ID (for subcategories)
  IntColumn get parentId => integer().nullable()();
  
  /// Category color (hex code)
  TextColumn get color => text().nullable()();
  
  /// Category icon name
  TextColumn get icon => text().nullable()();
  
  /// Monthly budget limit in cents
  IntColumn get budgetLimitInCents => integer().nullable()();
  
  /// Whether this is a system category (cannot be deleted)
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  
  /// Whether this category is active
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  /// Display order
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  
  /// When the category was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the category was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

