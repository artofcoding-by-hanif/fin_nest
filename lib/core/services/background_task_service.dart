import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../background/background_task_types.dart';
import '../background/handlers/recurring_transaction_handler.dart';
import '../database/app_database.dart';

/// Service for managing background tasks using WorkManager
///
/// This service provides a centralized way to schedule and manage
/// background tasks in the FinNest application.
class BackgroundTaskService {
  BackgroundTaskService._();

  /// Singleton instance
  static final BackgroundTaskService instance = BackgroundTaskService._();

  /// WorkManager instance
  final Workmanager _workmanager = Workmanager();

  /// Whether the service has been initialized
  bool _isInitialized = false;

  /// Initialize the background task service
  ///
  /// This should be called once during app startup in bootstrap.dart
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('BackgroundTaskService already initialized');
      return;
    }

    try {
      await _workmanager.initialize(callbackDispatcher);

      _isInitialized = true;
      debugPrint('BackgroundTaskService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize BackgroundTaskService: $e');
      rethrow;
    }
  }

  /// Schedule a one-time background task
  ///
  /// [type] - The type of background task to schedule
  /// [delay] - Optional delay before the task runs (default: immediate)
  /// [constraints] - Optional constraints for when the task can run
  /// [inputData] - Optional data to pass to the task
  Future<void> scheduleOneTimeTask(
    BackgroundTaskType type, {
    Duration? delay,
    Constraints? constraints,
    Map<String, dynamic>? inputData,
  }) async {
    _ensureInitialized();

    try {
      await _workmanager.registerOneOffTask(
        type.taskId,
        type.taskId,
        initialDelay: delay,
        constraints:
            constraints ??
            Constraints(
              networkType: type.requiresNetwork
                  ? NetworkType.connected
                  : NetworkType.notRequired,
              requiresCharging: type.requiresCharging,
            ),
        inputData: inputData,
      );

      if (kDebugMode) {
        debugPrint('Scheduled one-time task: ${type.displayName}');
      }
    } catch (e) {
      debugPrint('Failed to schedule one-time task ${type.displayName}: $e');
      rethrow;
    }
  }

  /// Schedule a periodic background task
  ///
  /// [type] - The type of background task to schedule
  /// [frequency] - How often the task should run (minimum 15 minutes)
  /// [constraints] - Optional constraints for when the task can run
  /// [inputData] - Optional data to pass to the task
  Future<void> schedulePeriodicTask(
    BackgroundTaskType type, {
    required Duration frequency,
    Constraints? constraints,
    Map<String, dynamic>? inputData,
  }) async {
    _ensureInitialized();

    // WorkManager requires minimum 15 minutes for periodic tasks
    if (frequency.inMinutes < 15) {
      throw ArgumentError(
        'Periodic tasks must have a frequency of at least 15 minutes',
      );
    }

    try {
      await _workmanager.registerPeriodicTask(
        type.taskId,
        type.taskId,
        frequency: frequency,
        constraints:
            constraints ??
            Constraints(
              networkType: type.requiresNetwork
                  ? NetworkType.connected
                  : NetworkType.notRequired,
              requiresCharging: type.requiresCharging,
            ),
        inputData: inputData,
      );

      if (kDebugMode) {
        debugPrint(
          'Scheduled periodic task: ${type.displayName} (every ${frequency.inMinutes} minutes)',
        );
      }
    } catch (e) {
      debugPrint('Failed to schedule periodic task ${type.displayName}: $e');
      rethrow;
    }
  }

  /// Cancel a specific background task
  Future<void> cancelTask(BackgroundTaskType type) async {
    _ensureInitialized();

    try {
      await _workmanager.cancelByUniqueName(type.taskId);

      if (kDebugMode) {
        debugPrint('Cancelled task: ${type.displayName}');
      }
    } catch (e) {
      debugPrint('Failed to cancel task ${type.displayName}: $e');
      rethrow;
    }
  }

  /// Cancel all background tasks
  Future<void> cancelAllTasks() async {
    _ensureInitialized();

    try {
      await _workmanager.cancelAll();

      if (kDebugMode) {
        debugPrint('Cancelled all background tasks');
      }
    } catch (e) {
      debugPrint('Failed to cancel all tasks: $e');
      rethrow;
    }
  }

  /// Ensure the service is initialized before use
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'BackgroundTaskService must be initialized before use. '
        'Call initialize() first.',
      );
    }
  }
}

/// Top-level callback dispatcher for background tasks
///
/// This function is called by WorkManager when a background task needs to run.
/// It must be a top-level function (not a class method).
///
/// Note: Background tasks run in a separate isolate, so we create a new
/// database instance here instead of using the service locator.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      debugPrint('Background task started: $task');
      debugPrint('Input data: $inputData');
    }

    // Create database instance for background task
    // Background tasks run in a separate isolate, so we can't use GetIt
    final db = AppDatabase();

    try {
      // Handle different task types
      switch (task) {
        case 'com.finnest.task.recurring_transaction_processing':
          final handler = RecurringTransactionHandler(db);
          await handler.processDueRecurringTransactions();
          break;

        // Add other task handlers here as needed
        default:
          if (kDebugMode) {
            debugPrint('Unknown task type: $task');
          }
      }

      if (kDebugMode) {
        debugPrint('Background task completed successfully: $task');
      }

      // Close database connection
      await db.close();

      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('Background task failed: $task');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Ensure database is closed even on error
      await db.close();

      return Future.value(false);
    }
  });
}
