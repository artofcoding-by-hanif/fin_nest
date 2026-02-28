/// Notification types for FinNest
enum NotificationType {
  /// Budget alerts (overspending, approaching limit)
  budgetAlert,
  
  /// Bill reminders (upcoming bills, overdue bills)
  billReminder,
  
  /// Goal updates (milestone reached, goal completed)
  goalUpdate,
  
  /// Transaction notifications (large transaction, unusual activity)
  transaction,
  
  /// Recurring transaction reminders
  recurringTransaction,
  
  /// Account updates (low balance, negative balance)
  accountUpdate,
  
  /// Savings suggestions
  savingsSuggestion,
  
  /// Investment updates
  investmentUpdate,
  
  /// General app notifications
  general,
}

/// Extension to get notification type properties
extension NotificationTypeExtension on NotificationType {
  /// Get the notification channel ID for this type
  String get channelId {
    switch (this) {
      case NotificationType.budgetAlert:
        return 'budget_alerts';
      case NotificationType.billReminder:
        return 'bill_reminders';
      case NotificationType.goalUpdate:
        return 'goal_updates';
      case NotificationType.transaction:
        return 'transactions';
      case NotificationType.recurringTransaction:
        return 'recurring_transactions';
      case NotificationType.accountUpdate:
        return 'account_updates';
      case NotificationType.savingsSuggestion:
        return 'savings_suggestions';
      case NotificationType.investmentUpdate:
        return 'investment_updates';
      case NotificationType.general:
        return 'general';
    }
  }

  /// Get the notification channel name for this type
  String get channelName {
    switch (this) {
      case NotificationType.budgetAlert:
        return 'Budget Alerts';
      case NotificationType.billReminder:
        return 'Bill Reminders';
      case NotificationType.goalUpdate:
        return 'Goal Updates';
      case NotificationType.transaction:
        return 'Transactions';
      case NotificationType.recurringTransaction:
        return 'Recurring Transactions';
      case NotificationType.accountUpdate:
        return 'Account Updates';
      case NotificationType.savingsSuggestion:
        return 'Savings Suggestions';
      case NotificationType.investmentUpdate:
        return 'Investment Updates';
      case NotificationType.general:
        return 'General';
    }
  }

  /// Get the notification channel description for this type
  String get channelDescription {
    switch (this) {
      case NotificationType.budgetAlert:
        return 'Notifications about budget limits and overspending';
      case NotificationType.billReminder:
        return 'Reminders for upcoming and overdue bills';
      case NotificationType.goalUpdate:
        return 'Updates on your financial goals progress';
      case NotificationType.transaction:
        return 'Notifications about your transactions';
      case NotificationType.recurringTransaction:
        return 'Reminders for recurring transactions';
      case NotificationType.accountUpdate:
        return 'Updates about your account balances';
      case NotificationType.savingsSuggestion:
        return 'Suggestions to help you save money';
      case NotificationType.investmentUpdate:
        return 'Updates about your investments';
      case NotificationType.general:
        return 'General app notifications';
    }
  }

  /// Get the importance level for this notification type
  /// High importance: Makes sound and appears as heads-up notification
  /// Default importance: Makes sound
  /// Low importance: No sound
  NotificationImportance get importance {
    switch (this) {
      case NotificationType.budgetAlert:
      case NotificationType.billReminder:
      case NotificationType.accountUpdate:
        return NotificationImportance.high;
      case NotificationType.goalUpdate:
      case NotificationType.transaction:
      case NotificationType.recurringTransaction:
        return NotificationImportance.defaultImportance;
      case NotificationType.savingsSuggestion:
      case NotificationType.investmentUpdate:
      case NotificationType.general:
        return NotificationImportance.low;
    }
  }
}

/// Notification importance levels
enum NotificationImportance {
  /// No sound, does not appear in status bar
  min,
  
  /// No sound
  low,
  
  /// Makes sound
  defaultImportance,
  
  /// Makes sound and appears as heads-up notification
  high,
  
  /// Makes sound and appears as heads-up notification, may use full screen
  max,
}

/// Notification priority (for Android < 8.0)
enum NotificationPriority {
  min,
  low,
  defaultPriority,
  high,
  max,
}

