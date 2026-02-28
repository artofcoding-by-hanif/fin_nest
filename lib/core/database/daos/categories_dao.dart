import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

/// Data Access Object for Categories table
@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  /// Constructor
  CategoriesDao(super.db);

  /// Get category by ID
  Future<CategoryEntity?> getCategoryById(int id) {
    return (select(categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get all categories for a user
  Future<List<CategoryEntity>> getCategoriesByUserId(int userId) {
    return (select(categories)
          ..where((c) => c.userId.equals(userId))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }

  /// Get active categories for a user
  Future<List<CategoryEntity>> getActiveCategories(int userId) {
    return (select(categories)
          ..where((c) => c.userId.equals(userId) & c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }

  /// Get categories by type (income or expense)
  Future<List<CategoryEntity>> getCategoriesByType(
    int userId,
    CategoryType type,
  ) {
    return (select(categories)
          ..where((c) =>
              c.userId.equals(userId) &
              c.type.equalsValue(type) &
              c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }

  /// Get parent categories (top-level categories)
  Future<List<CategoryEntity>> getParentCategories(
    int userId,
    CategoryType type,
  ) {
    return (select(categories)
          ..where((c) =>
              c.userId.equals(userId) &
              c.type.equalsValue(type) &
              c.parentId.isNull() &
              c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }

  /// Get subcategories for a parent category
  Future<List<CategoryEntity>> getSubcategories(int parentId) {
    return (select(categories)
          ..where((c) => c.parentId.equals(parentId) & c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }

  /// Create a new category
  Future<int> createCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  /// Update a category
  Future<bool> updateCategory(CategoryEntity category) {
    return update(categories).replace(category);
  }

  /// Delete a category
  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  /// Deactivate a category (soft delete)
  Future<void> deactivateCategory(int id) {
    return (update(categories)..where((c) => c.id.equals(id)))
        .write(const CategoriesCompanion(isActive: Value(false)));
  }

  /// Watch categories for a user (reactive)
  Stream<List<CategoryEntity>> watchCategoriesByUserId(int userId) {
    return (select(categories)
          ..where((c) => c.userId.equals(userId))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .watch();
  }

  /// Watch categories by type (reactive)
  Stream<List<CategoryEntity>> watchCategoriesByType(
    int userId,
    CategoryType type,
  ) {
    return (select(categories)
          ..where((c) =>
              c.userId.equals(userId) &
              c.type.equalsValue(type) &
              c.isActive.equals(true))
          ..orderBy([
            (c) => OrderingTerm(expression: c.displayOrder),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .watch();
  }

  /// Watch category by ID (reactive)
  Stream<CategoryEntity?> watchCategoryById(int id) {
    return (select(categories)..where((c) => c.id.equals(id)))
        .watchSingleOrNull();
  }
}

