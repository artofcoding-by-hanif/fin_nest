import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../database/app_database.dart';
import '../../database/tables/recurring_transactions_table.dart';
import '../../database/tables/transactions_table.dart';

/// Handler for processing recurring transactions in background
class RecurringTransactionHandler {
  final AppDatabase _db;

  RecurringTransactionHandler(this._db);

  /// Process all due recurring transactions
  ///
  /// This method:
  /// 1. Fetches all active recurring transactions
  /// 2. Checks which ones are due (based on nextOccurrence and daysBeforeToCreate)
  /// 3. Creates actual transactions from the recurring templates
  /// 4. Updates the nextOccurrence date
  /// 5. Deactivates recurring transactions that have passed their end date
  Future<void> processDueRecurringTransactions() async {
    try {
      final now = DateTime.now();

      if (kDebugMode) {
        debugPrint('Processing recurring transactions at: $now');
      }

      // Get all users (for now we'll process for all users)
      final users = await _db.usersDao.getAllUsers();

      int totalProcessed = 0;
      int totalCreated = 0;
      int totalDeactivated = 0;

      for (final user in users) {
        final result = await _processUserRecurringTransactions(user.id, now);
        totalProcessed += result.processed;
        totalCreated += result.created;
        totalDeactivated += result.deactivated;
      }

      if (kDebugMode) {
        debugPrint('Recurring transaction processing complete:');
        debugPrint('  - Processed: $totalProcessed');
        debugPrint('  - Created: $totalCreated');
        debugPrint('  - Deactivated: $totalDeactivated');
      }
    } catch (e, stackTrace) {
      debugPrint('Error processing recurring transactions: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Process recurring transactions for a specific user
  Future<_ProcessingResult> _processUserRecurringTransactions(
    int userId,
    DateTime now,
  ) async {
    int processed = 0;
    int created = 0;
    int deactivated = 0;

    // Get all active recurring transactions for this user
    final activeRecurring = await _db.recurringTransactionsDao
        .getActiveRecurringTransactions(userId);

    if (kDebugMode) {
      debugPrint(
        'Processing ${activeRecurring.length} active recurring transactions for user $userId',
      );
    }

    for (final recurring in activeRecurring) {
      processed++;

      // Check if past end date
      if (recurring.endDate != null && now.isAfter(recurring.endDate!)) {
        await _db.recurringTransactionsDao.deactivateRecurringTransaction(
          recurring.id,
        );
        deactivated++;

        if (kDebugMode) {
          debugPrint(
            'Deactivated recurring transaction ${recurring.id} (past end date)',
          );
        }
        continue;
      }

      // Check if due (considering daysBeforeToCreate)
      final dueDate = recurring.nextOccurrence.subtract(
        Duration(days: recurring.daysBeforeToCreate),
      );

      if (now.isAfter(dueDate) || now.isAtSameMomentAs(dueDate)) {
        // Create the transaction
        await _createTransactionFromRecurring(recurring);
        created++;

        // Calculate next occurrence
        final nextOccurrence = _calculateNextOccurrence(
          recurring.nextOccurrence,
          recurring.frequency,
        );

        // Update the recurring transaction
        await _db.recurringTransactionsDao.updateNextOccurrence(
          recurring.id,
          nextOccurrence,
        );

        if (kDebugMode) {
          debugPrint('Created transaction from recurring ${recurring.id}');
          debugPrint('  Next occurrence: $nextOccurrence');
        }
      }
    }

    return _ProcessingResult(
      processed: processed,
      created: created,
      deactivated: deactivated,
    );
  }

  /// Create an actual transaction from a recurring transaction template
  Future<void> _createTransactionFromRecurring(
    RecurringTransactionEntity recurring,
  ) async {
    await _db.transactionsDao.createTransaction(
      TransactionsCompanion.insert(
        userId: recurring.userId,
        accountId: recurring.accountId,
        categoryId: Value(recurring.categoryId),
        type: TransactionType.values[recurring.type],
        amountInCents: recurring.amountInCents,
        currency: Value(recurring.currency),
        description: recurring.description,
        transactionDate: recurring.nextOccurrence,
        payee: Value(recurring.payee),
        notes: Value(recurring.notes),
        isRecurring: const Value(true),
        recurringTransactionId: Value(recurring.id),
        status: const Value(TransactionStatus.completed),
      ),
    );
  }

  /// Calculate the next occurrence date based on frequency
  DateTime _calculateNextOccurrence(
    DateTime currentOccurrence,
    RecurrenceFrequency frequency,
  ) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return currentOccurrence.add(const Duration(days: 1));

      case RecurrenceFrequency.weekly:
        return currentOccurrence.add(const Duration(days: 7));

      case RecurrenceFrequency.biweekly:
        return currentOccurrence.add(const Duration(days: 14));

      case RecurrenceFrequency.monthly:
        return DateTime(
          currentOccurrence.year,
          currentOccurrence.month + 1,
          currentOccurrence.day,
        );

      case RecurrenceFrequency.quarterly:
        return DateTime(
          currentOccurrence.year,
          currentOccurrence.month + 3,
          currentOccurrence.day,
        );

      case RecurrenceFrequency.yearly:
        return DateTime(
          currentOccurrence.year + 1,
          currentOccurrence.month,
          currentOccurrence.day,
        );
    }
  }
}

/// Result of processing recurring transactions
class _ProcessingResult {
  final int processed;
  final int created;
  final int deactivated;

  _ProcessingResult({
    required this.processed,
    required this.created,
    required this.deactivated,
  });
}
