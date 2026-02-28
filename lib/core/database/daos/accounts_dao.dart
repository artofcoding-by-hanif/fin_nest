import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

/// Data Access Object for Accounts table
@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  /// Constructor
  AccountsDao(super.db);

  /// Get account by ID
  Future<AccountEntity?> getAccountById(int id) {
    return (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  /// Get all accounts for a user
  Future<List<AccountEntity>> getAccountsByUserId(int userId) {
    return (select(accounts)
          ..where((a) => a.userId.equals(userId))
          ..orderBy([(a) => OrderingTerm(expression: a.displayOrder)]))
        .get();
  }

  /// Get active accounts for a user
  Future<List<AccountEntity>> getActiveAccounts(int userId) {
    return (select(accounts)
          ..where((a) => a.userId.equals(userId) & a.isActive.equals(true))
          ..orderBy([(a) => OrderingTerm(expression: a.displayOrder)]))
        .get();
  }

  /// Get default account for a user
  Future<AccountEntity?> getDefaultAccount(int userId) {
    return (select(accounts)
          ..where((a) => a.userId.equals(userId) & a.isDefault.equals(true)))
        .getSingleOrNull();
  }

  /// Get total balance for a user (in cents)
  Future<int> getTotalBalance(int userId) async {
    final accountsList = await (select(accounts)
          ..where((a) =>
              a.userId.equals(userId) &
              a.isActive.equals(true) &
              a.includeInTotal.equals(true)))
        .get();

    return accountsList.fold<int>(
      0,
      (sum, account) => sum + account.balanceInCents,
    );
  }

  /// Create a new account
  Future<int> createAccount(AccountsCompanion account) {
    return into(accounts).insert(account);
  }

  /// Update an account
  Future<bool> updateAccount(AccountEntity account) {
    return update(accounts).replace(account);
  }

  /// Update account balance
  Future<void> updateBalance(int id, int balanceInCents) {
    return (update(accounts)..where((a) => a.id.equals(id)))
        .write(AccountsCompanion(balanceInCents: Value(balanceInCents)));
  }

  /// Delete an account
  Future<int> deleteAccount(int id) {
    return (delete(accounts)..where((a) => a.id.equals(id))).go();
  }

  /// Set account as default
  Future<void> setDefaultAccount(int userId, int accountId) async {
    // First, unset all default accounts for the user
    await (update(accounts)..where((a) => a.userId.equals(userId)))
        .write(const AccountsCompanion(isDefault: Value(false)));

    // Then set the specified account as default
    await (update(accounts)..where((a) => a.id.equals(accountId)))
        .write(const AccountsCompanion(isDefault: Value(true)));
  }

  /// Watch accounts for a user (reactive)
  Stream<List<AccountEntity>> watchAccountsByUserId(int userId) {
    return (select(accounts)
          ..where((a) => a.userId.equals(userId))
          ..orderBy([(a) => OrderingTerm(expression: a.displayOrder)]))
        .watch();
  }

  /// Watch account by ID (reactive)
  Stream<AccountEntity?> watchAccountById(int id) {
    return (select(accounts)..where((a) => a.id.equals(id))).watchSingleOrNull();
  }
}

