import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_transactions_table.dart';
import '../../../../core/database/tables/categories_table.dart';
import '../../../../core/database/tables/transactions_table.dart';
import 'savings_provider.dart';

/// Provider to watch all transactions for a specific savings account
final watchSavingsTransactionsProvider =
    StreamProvider.family<List<SavingsTransactionEntity>, int>((
      ref,
      savingsId,
    ) {
      final db = ref.watch(databaseProvider);
      return db.savingsTransactionsDao.watchTransactionsBySavingsId(savingsId);
    });

/// Provider to watch all savings transactions for a user
final watchAllSavingsTransactionsProvider =
    StreamProvider<List<SavingsTransactionEntity>>((ref) {
      final db = ref.watch(databaseProvider);
      return db.savingsTransactionsDao.watchTransactionsByUserId(
        1,
      ); // TODO: Replace with actual user ID
    });

/// Provider for total deposits for a savings account
final totalDepositsProvider = FutureProvider.family<int, int>((
  ref,
  savingsId,
) async {
  final db = ref.watch(databaseProvider);
  return db.savingsTransactionsDao.getTotalDeposits(savingsId);
});

/// Provider for total withdrawals for a savings account
final totalWithdrawalsProvider = FutureProvider.family<int, int>((
  ref,
  savingsId,
) async {
  final db = ref.watch(databaseProvider);
  return db.savingsTransactionsDao.getTotalWithdrawals(savingsId);
});

/// State notifier for managing savings transactions
class SavingsTransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _database;

  SavingsTransactionNotifier(this._database)
    : super(const AsyncValue.data(null));

  /// Add a new savings transaction
  Future<void> addTransaction({
    required int userId,
    required int savingsId,
    required SavingsTransactionType type,
    required int amountInCents,
    required DateTime transactionDate,
    String? notes,
    double? units,
    int? pricePerUnitInCents,
    bool isRecurring = false,
    int? recurringTransactionId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int? linkedTransactionId;

      // If this is a deposit, create a linked expense transaction
      if (type == SavingsTransactionType.deposit) {
        linkedTransactionId = await _createLinkedExpenseTransaction(
          userId: userId,
          savingsId: savingsId,
          amountInCents: amountInCents,
          transactionDate: transactionDate,
          notes: notes,
        );
      }

      // Create the savings transaction
      await _database.savingsTransactionsDao.createTransaction(
        SavingsTransactionsCompanion(
          userId: drift.Value(userId),
          savingsId: drift.Value(savingsId),
          type: drift.Value(type),
          amountInCents: drift.Value(amountInCents),
          transactionDate: drift.Value(transactionDate),
          notes: drift.Value(notes),
          units: drift.Value(units),
          pricePerUnitInCents: drift.Value(pricePerUnitInCents),
          isRecurring: drift.Value(isRecurring),
          recurringTransactionId: drift.Value(recurringTransactionId),
          linkedTransactionId: drift.Value(linkedTransactionId),
        ),
      );

      // Update the savings account's current value
      await _updateSavingsValue(savingsId, type, amountInCents);
    });
  }

  /// Update an existing savings transaction
  Future<void> updateTransaction({
    required int id,
    required int userId,
    required int savingsId,
    required SavingsTransactionType type,
    required int amountInCents,
    required DateTime transactionDate,
    String? notes,
    double? units,
    int? pricePerUnitInCents,
    bool isRecurring = false,
    int? recurringTransactionId,
    required DateTime createdAt,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Get the old transaction to calculate the difference
      final oldTransaction = await _database.savingsTransactionsDao
          .getTransactionById(id);

      int? linkedTransactionId;

      // Handle linked expense transaction scenarios
      if (oldTransaction != null) {
        final wasDeposit =
            oldTransaction.type == SavingsTransactionType.deposit;
        final isDeposit = type == SavingsTransactionType.deposit;

        if (wasDeposit && isDeposit) {
          // Both old and new are deposits - update the linked expense
          if (oldTransaction.linkedTransactionId != null) {
            await _updateLinkedExpenseTransaction(
              transactionId: oldTransaction.linkedTransactionId!,
              userId: userId,
              savingsId: savingsId,
              amountInCents: amountInCents,
              transactionDate: transactionDate,
              notes: notes,
            );
            linkedTransactionId = oldTransaction.linkedTransactionId;
          }
        } else if (wasDeposit && !isDeposit) {
          // Changed from deposit to non-deposit - delete the linked expense
          if (oldTransaction.linkedTransactionId != null) {
            await _database.transactionsDao.deleteTransaction(
              oldTransaction.linkedTransactionId!,
            );
          }
        } else if (!wasDeposit && isDeposit) {
          // Changed from non-deposit to deposit - create a new linked expense
          linkedTransactionId = await _createLinkedExpenseTransaction(
            userId: userId,
            savingsId: savingsId,
            amountInCents: amountInCents,
            transactionDate: transactionDate,
            notes: notes,
          );
        }
      }

      // Update the transaction
      await _database.savingsTransactionsDao.updateTransaction(
        SavingsTransactionEntity(
          id: id,
          userId: userId,
          savingsId: savingsId,
          type: type,
          amountInCents: amountInCents,
          currency: 'INR',
          transactionDate: transactionDate,
          notes: notes,
          units: units,
          pricePerUnitInCents: pricePerUnitInCents,
          isRecurring: isRecurring,
          recurringTransactionId: recurringTransactionId,
          linkedTransactionId: linkedTransactionId,
          createdAt: createdAt,
          updatedAt: DateTime.now(),
        ),
      );

      // Reverse the old transaction's effect and apply the new one
      if (oldTransaction != null) {
        await _reverseTransactionEffect(
          savingsId,
          oldTransaction.type,
          oldTransaction.amountInCents,
        );
        await _updateSavingsValue(savingsId, type, amountInCents);
      }
    });
  }

  /// Delete a savings transaction
  Future<void> deleteTransaction(int id, int savingsId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Get the transaction to reverse its effect
      final transaction = await _database.savingsTransactionsDao
          .getTransactionById(id);

      // If this transaction has a linked expense, delete it first
      if (transaction != null && transaction.linkedTransactionId != null) {
        await _database.transactionsDao.deleteTransaction(
          transaction.linkedTransactionId!,
        );
      }

      // Delete the savings transaction
      await _database.savingsTransactionsDao.deleteTransaction(id);

      // Reverse the transaction's effect on savings value
      if (transaction != null) {
        await _reverseTransactionEffect(
          savingsId,
          transaction.type,
          transaction.amountInCents,
        );
      }
    });
  }

  /// Update the savings account's invested amount based on transaction type
  /// Only deposits and withdrawals affect invested amount
  /// Current value is manually editable by the user
  Future<void> _updateSavingsValue(
    int savingsId,
    SavingsTransactionType type,
    int amountInCents,
  ) async {
    final savings = await _database.savingsDao.getSavingsById(savingsId);
    if (savings == null) return;

    // Only deposits and withdrawals affect invested amount
    // Interest, dividends, appreciation, depreciation do NOT affect invested amount
    if (type != SavingsTransactionType.deposit &&
        type != SavingsTransactionType.withdrawal) {
      return;
    }

    int newInvestedAmount = savings.investedAmountInCents;

    // Update based on transaction type
    switch (type) {
      case SavingsTransactionType.deposit:
        newInvestedAmount += amountInCents;
        break;
      case SavingsTransactionType.withdrawal:
        newInvestedAmount -= amountInCents;
        break;
      default:
        return; // Should not reach here due to early return above
    }

    // Update the savings account's invested amount
    await _database.savingsDao.updateSavings(
      savings.copyWith(
        investedAmountInCents: newInvestedAmount,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Reverse the effect of a transaction on savings invested amount
  /// Only deposits and withdrawals affect invested amount
  Future<void> _reverseTransactionEffect(
    int savingsId,
    SavingsTransactionType type,
    int amountInCents,
  ) async {
    final savings = await _database.savingsDao.getSavingsById(savingsId);
    if (savings == null) return;

    // Only deposits and withdrawals affect invested amount
    // Interest, dividends, appreciation, depreciation do NOT affect invested amount
    if (type != SavingsTransactionType.deposit &&
        type != SavingsTransactionType.withdrawal) {
      return;
    }

    int newInvestedAmount = savings.investedAmountInCents;

    // Reverse the effect based on transaction type
    switch (type) {
      case SavingsTransactionType.deposit:
        newInvestedAmount -= amountInCents;
        break;
      case SavingsTransactionType.withdrawal:
        newInvestedAmount += amountInCents;
        break;
      default:
        return; // Should not reach here due to early return above
    }

    // Update the savings account's invested amount
    await _database.savingsDao.updateSavings(
      savings.copyWith(
        investedAmountInCents: newInvestedAmount,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Create a linked expense transaction for a savings deposit
  Future<int> _createLinkedExpenseTransaction({
    required int userId,
    required int savingsId,
    required int amountInCents,
    required DateTime transactionDate,
    String? notes,
  }) async {
    // Get the Savings category
    final categories = await _database.categoriesDao.getCategoriesByType(
      userId,
      CategoryType.expense,
    );
    final savingsCategory = categories.firstWhere(
      (cat) => cat.name == 'Savings',
      orElse: () => throw Exception('Savings category not found'),
    );

    // Get the default account
    final defaultAccount = await _database.accountsDao.getDefaultAccount(
      userId,
    );
    if (defaultAccount == null) {
      throw Exception('No default account found');
    }

    // Get the savings account name for the description
    final savings = await _database.savingsDao.getSavingsById(savingsId);
    final description = savings != null
        ? 'Savings deposit to ${savings.name}'
        : 'Savings deposit';

    // Create the expense transaction
    final transactionId = await _database.transactionsDao.createTransaction(
      TransactionsCompanion.insert(
        userId: userId,
        accountId: defaultAccount.id,
        categoryId: drift.Value(savingsCategory.id),
        type: TransactionType.expense,
        status: drift.Value(TransactionStatus.completed),
        amountInCents: amountInCents,
        currency: const drift.Value('USD'),
        description: description,
        notes: drift.Value(notes),
        transactionDate: transactionDate,
      ),
    );

    return transactionId;
  }

  /// Update a linked expense transaction
  Future<void> _updateLinkedExpenseTransaction({
    required int transactionId,
    required int userId,
    required int savingsId,
    required int amountInCents,
    required DateTime transactionDate,
    String? notes,
  }) async {
    // Get the existing transaction
    final existingTransaction = await _database.transactionsDao
        .getTransactionById(transactionId);
    if (existingTransaction == null) {
      throw Exception('Linked transaction not found');
    }

    // Get the savings account name for the description
    final savings = await _database.savingsDao.getSavingsById(savingsId);
    final description = savings != null
        ? 'Savings deposit to ${savings.name}'
        : 'Savings deposit';

    // Update the expense transaction
    await _database.transactionsDao.updateTransaction(
      existingTransaction.copyWith(
        amountInCents: amountInCents,
        description: description,
        notes: drift.Value(notes),
        transactionDate: transactionDate,
        updatedAt: DateTime.now(),
      ),
    );
  }
}

/// Provider for savings transaction notifier
final savingsTransactionProvider =
    StateNotifierProvider<SavingsTransactionNotifier, AsyncValue<void>>((ref) {
      final database = ref.watch(databaseProvider);
      return SavingsTransactionNotifier(database);
    });
