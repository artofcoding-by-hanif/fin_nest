import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/tables/savings_table.dart';

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return GetIt.instance<AppDatabase>();
});

/// Provider for watching all savings (reactive)
final watchSavingsProvider = StreamProvider<List<SavingsEntity>>((ref) {
  final db = ref.watch(databaseProvider);
  // TODO: Replace with actual user ID from auth
  return db.savingsDao.watchActiveSavings(1);
});

/// Provider for watching savings by category (reactive)
final watchSavingsByCategoryProvider =
    StreamProvider.family<List<SavingsEntity>, SavingsCategory>((
      ref,
      category,
    ) {
      final db = ref.watch(databaseProvider);
      // TODO: Replace with actual user ID from auth
      return db.savingsDao.watchSavingsByCategory(1, category);
    });

/// Provider for total savings value (reactive)
final totalSavingsValueProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  // TODO: Replace with actual user ID from auth
  return db.savingsDao.watchTotalSavingsValue(1);
});

/// Provider for total invested amount (reactive)
final totalInvestedAmountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  // TODO: Replace with actual user ID from auth
  return db.savingsDao.watchTotalInvestedAmount(1);
});

/// Provider for savings by category totals
final savingsByCategoryTotalsProvider =
    FutureProvider<Map<SavingsCategory, int>>((ref) async {
      final db = ref.watch(databaseProvider);
      // TODO: Replace with actual user ID from auth
      return db.savingsDao.getSavingsByCategoryTotals(1);
    });

/// State notifier for adding/editing savings
class SavingsNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _database;

  SavingsNotifier(this._database) : super(const AsyncValue.data(null));

  Future<void> addSavings({
    required SavingsCategory category,
    required String name,
    required int currentValueInCents,
    required int investedAmountInCents,
    DateTime? maturityDate,
    int? interestRate,
    String? accountNumber,
    String? institutionName,
    String? notes,
    String? color,
    String? icon,
  }) async {
    state = const AsyncValue.loading();

    try {
      // TODO: Replace with actual user ID from auth
      const userId = 1;

      await _database.savingsDao.createSavings(
        SavingsCompanion.insert(
          userId: userId,
          category: category,
          name: name,
          currentValueInCents: currentValueInCents,
          investedAmountInCents: investedAmountInCents,
          currency: const drift.Value('INR'),
          maturityDate: drift.Value(maturityDate),
          interestRate: drift.Value(interestRate),
          accountNumber: drift.Value(accountNumber),
          institutionName: drift.Value(institutionName),
          notes: drift.Value(notes),
          color: drift.Value(color),
          icon: drift.Value(icon),
        ),
      );

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateSavings({
    required int id,
    required SavingsCategory category,
    required String name,
    required int currentValueInCents,
    required int investedAmountInCents,
    DateTime? maturityDate,
    int? interestRate,
    String? accountNumber,
    String? institutionName,
    String? notes,
    bool? isActive,
    String? color,
    String? icon,
  }) async {
    state = const AsyncValue.loading();

    try {
      final existing = await _database.savingsDao.getSavingsById(id);
      if (existing == null) {
        throw Exception('Savings not found');
      }

      await _database.savingsDao.updateSavings(
        existing.copyWith(
          category: category,
          name: name,
          currentValueInCents: currentValueInCents,
          investedAmountInCents: investedAmountInCents,
          maturityDate: drift.Value(maturityDate),
          interestRate: drift.Value(interestRate),
          accountNumber: drift.Value(accountNumber),
          institutionName: drift.Value(institutionName),
          notes: drift.Value(notes),
          isActive: isActive ?? existing.isActive,
          color: drift.Value(color),
          icon: drift.Value(icon),
          updatedAt: DateTime.now(),
        ),
      );

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteSavings(int id) async {
    state = const AsyncValue.loading();

    try {
      await _database.savingsDao.deactivateSavings(id);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

/// Provider for savings notifier
final savingsProvider =
    StateNotifierProvider<SavingsNotifier, AsyncValue<void>>((ref) {
      final database = ref.watch(databaseProvider);
      return SavingsNotifier(database);
    });
