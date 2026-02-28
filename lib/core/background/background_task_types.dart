/// Background task types for FinNest
///
/// This file defines all background task types that can be scheduled
/// using the WorkManager plugin.

/// Enum representing different types of background tasks
enum BackgroundTaskType {
  /// Sync data with remote server
  dataSync,

  /// Process pending transactions
  transactionProcessing,

  /// Check and send budget alerts
  budgetAlertCheck,

  /// Check and send bill reminders
  billReminderCheck,

  /// Process recurring transactions
  recurringTransactionProcessing,

  /// Update goal progress
  goalProgressUpdate,

  /// Clean up old data
  dataCleanup,

  /// Backup local database
  databaseBackup,

  /// Sync notifications
  notificationSync,

  /// Update exchange rates
  exchangeRateUpdate,

  /// Generate financial reports
  reportGeneration,

  /// Check account balances
  accountBalanceCheck,
}

/// Extension on BackgroundTaskType to provide additional properties
extension BackgroundTaskTypeExtension on BackgroundTaskType {
  /// Unique identifier for the task
  String get taskId {
    switch (this) {
      case BackgroundTaskType.dataSync:
        return 'com.finnest.task.data_sync';
      case BackgroundTaskType.transactionProcessing:
        return 'com.finnest.task.transaction_processing';
      case BackgroundTaskType.budgetAlertCheck:
        return 'com.finnest.task.budget_alert_check';
      case BackgroundTaskType.billReminderCheck:
        return 'com.finnest.task.bill_reminder_check';
      case BackgroundTaskType.recurringTransactionProcessing:
        return 'com.finnest.task.recurring_transaction_processing';
      case BackgroundTaskType.goalProgressUpdate:
        return 'com.finnest.task.goal_progress_update';
      case BackgroundTaskType.dataCleanup:
        return 'com.finnest.task.data_cleanup';
      case BackgroundTaskType.databaseBackup:
        return 'com.finnest.task.database_backup';
      case BackgroundTaskType.notificationSync:
        return 'com.finnest.task.notification_sync';
      case BackgroundTaskType.exchangeRateUpdate:
        return 'com.finnest.task.exchange_rate_update';
      case BackgroundTaskType.reportGeneration:
        return 'com.finnest.task.report_generation';
      case BackgroundTaskType.accountBalanceCheck:
        return 'com.finnest.task.account_balance_check';
    }
  }

  /// Human-readable name for the task
  String get displayName {
    switch (this) {
      case BackgroundTaskType.dataSync:
        return 'Data Sync';
      case BackgroundTaskType.transactionProcessing:
        return 'Transaction Processing';
      case BackgroundTaskType.budgetAlertCheck:
        return 'Budget Alert Check';
      case BackgroundTaskType.billReminderCheck:
        return 'Bill Reminder Check';
      case BackgroundTaskType.recurringTransactionProcessing:
        return 'Recurring Transaction Processing';
      case BackgroundTaskType.goalProgressUpdate:
        return 'Goal Progress Update';
      case BackgroundTaskType.dataCleanup:
        return 'Data Cleanup';
      case BackgroundTaskType.databaseBackup:
        return 'Database Backup';
      case BackgroundTaskType.notificationSync:
        return 'Notification Sync';
      case BackgroundTaskType.exchangeRateUpdate:
        return 'Exchange Rate Update';
      case BackgroundTaskType.reportGeneration:
        return 'Report Generation';
      case BackgroundTaskType.accountBalanceCheck:
        return 'Account Balance Check';
    }
  }

  /// Description of what the task does
  String get description {
    switch (this) {
      case BackgroundTaskType.dataSync:
        return 'Synchronizes local data with remote server';
      case BackgroundTaskType.transactionProcessing:
        return 'Processes pending transactions and updates balances';
      case BackgroundTaskType.budgetAlertCheck:
        return 'Checks budget limits and sends alerts if exceeded';
      case BackgroundTaskType.billReminderCheck:
        return 'Checks upcoming bills and sends reminders';
      case BackgroundTaskType.recurringTransactionProcessing:
        return 'Processes recurring transactions that are due';
      case BackgroundTaskType.goalProgressUpdate:
        return 'Updates progress towards financial goals';
      case BackgroundTaskType.dataCleanup:
        return 'Cleans up old data and temporary files';
      case BackgroundTaskType.databaseBackup:
        return 'Creates a backup of the local database';
      case BackgroundTaskType.notificationSync:
        return 'Synchronizes notification settings and history';
      case BackgroundTaskType.exchangeRateUpdate:
        return 'Updates currency exchange rates';
      case BackgroundTaskType.reportGeneration:
        return 'Generates financial reports and insights';
      case BackgroundTaskType.accountBalanceCheck:
        return 'Checks account balances and sends low balance alerts';
    }
  }

  /// Whether this task requires network connectivity
  bool get requiresNetwork {
    switch (this) {
      case BackgroundTaskType.dataSync:
      case BackgroundTaskType.notificationSync:
      case BackgroundTaskType.exchangeRateUpdate:
        return true;
      case BackgroundTaskType.transactionProcessing:
      case BackgroundTaskType.budgetAlertCheck:
      case BackgroundTaskType.billReminderCheck:
      case BackgroundTaskType.recurringTransactionProcessing:
      case BackgroundTaskType.goalProgressUpdate:
      case BackgroundTaskType.dataCleanup:
      case BackgroundTaskType.databaseBackup:
      case BackgroundTaskType.reportGeneration:
      case BackgroundTaskType.accountBalanceCheck:
        return false;
    }
  }

  /// Whether this task requires the device to be charging
  bool get requiresCharging {
    switch (this) {
      case BackgroundTaskType.databaseBackup:
      case BackgroundTaskType.reportGeneration:
        return true;
      default:
        return false;
    }
  }
}

