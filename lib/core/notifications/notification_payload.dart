import 'dart:convert';
import 'notification_types.dart';

/// Notification payload for handling notification taps
class NotificationPayload {
  const NotificationPayload({
    required this.type,
    this.route,
    this.data,
  });

  /// Type of notification
  final NotificationType type;

  /// Route to navigate to when notification is tapped
  final String? route;

  /// Additional data for the notification
  final Map<String, dynamic>? data;

  /// Convert to JSON string for storage
  String toJson() {
    return jsonEncode({
      'type': type.name,
      'route': route,
      'data': data,
    });
  }

  /// Create from JSON string
  factory NotificationPayload.fromJson(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return NotificationPayload(
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.general,
      ),
      route: map['route'] as String?,
      data: map['data'] as Map<String, dynamic>?,
    );
  }

  /// Create a budget alert payload
  factory NotificationPayload.budgetAlert({
    required int budgetId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.budgetAlert,
      route: route ?? '/budgets/$budgetId',
      data: {'budgetId': budgetId},
    );
  }

  /// Create a bill reminder payload
  factory NotificationPayload.billReminder({
    required int transactionId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.billReminder,
      route: route ?? '/transactions/$transactionId',
      data: {'transactionId': transactionId},
    );
  }

  /// Create a goal update payload
  factory NotificationPayload.goalUpdate({
    required int goalId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.goalUpdate,
      route: route ?? '/goals/$goalId',
      data: {'goalId': goalId},
    );
  }

  /// Create a transaction notification payload
  factory NotificationPayload.transaction({
    required int transactionId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.transaction,
      route: route ?? '/transactions/$transactionId',
      data: {'transactionId': transactionId},
    );
  }

  /// Create a recurring transaction reminder payload
  factory NotificationPayload.recurringTransaction({
    required int recurringTransactionId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.recurringTransaction,
      route: route ?? '/recurring-transactions/$recurringTransactionId',
      data: {'recurringTransactionId': recurringTransactionId},
    );
  }

  /// Create an account update payload
  factory NotificationPayload.accountUpdate({
    required int accountId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.accountUpdate,
      route: route ?? '/accounts/$accountId',
      data: {'accountId': accountId},
    );
  }

  /// Create a savings suggestion payload
  factory NotificationPayload.savingsSuggestion({
    String? route,
    Map<String, dynamic>? data,
  }) {
    return NotificationPayload(
      type: NotificationType.savingsSuggestion,
      route: route ?? '/insights/savings',
      data: data,
    );
  }

  /// Create an investment update payload
  factory NotificationPayload.investmentUpdate({
    required int accountId,
    String? route,
  }) {
    return NotificationPayload(
      type: NotificationType.investmentUpdate,
      route: route ?? '/accounts/$accountId',
      data: {'accountId': accountId},
    );
  }

  /// Create a general notification payload
  factory NotificationPayload.general({
    String? route,
    Map<String, dynamic>? data,
  }) {
    return NotificationPayload(
      type: NotificationType.general,
      route: route,
      data: data,
    );
  }

  @override
  String toString() {
    return 'NotificationPayload(type: $type, route: $route, data: $data)';
  }
}

