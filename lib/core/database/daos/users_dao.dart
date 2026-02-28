import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

/// Data Access Object for Users table
@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  /// Constructor
  UsersDao(super.db);

  /// Get user by ID
  Future<UserEntity?> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Get user by UID (from auth provider)
  Future<UserEntity?> getUserByUid(String uid) {
    return (select(users)..where((u) => u.uid.equals(uid))).getSingleOrNull();
  }

  /// Get user by email
  Future<UserEntity?> getUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  /// Get all users
  Future<List<UserEntity>> getAllUsers() {
    return select(users).get();
  }

  /// Create a new user
  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  /// Update a user
  Future<bool> updateUser(UserEntity user) {
    return update(users).replace(user);
  }

  /// Delete a user
  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  /// Update last synced timestamp
  Future<void> updateLastSynced(int id, DateTime timestamp) {
    return (update(users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(lastSyncedAt: Value(timestamp)));
  }

  /// Watch user by ID (reactive)
  Stream<UserEntity?> watchUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).watchSingleOrNull();
  }

  /// Watch user by UID (reactive)
  Stream<UserEntity?> watchUserByUid(String uid) {
    return (select(users)..where((u) => u.uid.equals(uid))).watchSingleOrNull();
  }
}

