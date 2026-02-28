import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../notifications/notification_types.dart';
import '../notifications/notification_payload.dart';

/// Notification service for local notifications
///
/// This service handles:
/// - Initialization of notification channels
/// - Showing instant notifications
/// - Scheduling notifications
/// - Handling notification taps
/// - Managing notification permissions
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Callback for when a notification is tapped
  Function(NotificationPayload)? onNotificationTap;

  /// Initialize the notification service
  ///
  /// This should be called during app startup in bootstrap.dart
  ///
  /// Example:
  /// ```dart
  /// await NotificationService.instance.initialize(
  ///   onNotificationTap: (payload) {
  ///     // Navigate to the route specified in the payload
  ///     navigatorKey.currentState?.pushNamed(payload.route ?? '/');
  ///   },
  /// );
  /// ```
  Future<void> initialize({
    Function(NotificationPayload)? onNotificationTap,
  }) async {
    this.onNotificationTap = onNotificationTap;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // macOS initialization settings
    const macOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOSSettings,
    );

    // Initialize with settings
    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    debugPrint('Notification service initialized successfully');
  }

  /// Handle notification tap
  void _onNotificationResponse(NotificationResponse response) {
    final payloadString = response.payload;
    if (payloadString != null && onNotificationTap != null) {
      try {
        final payload = NotificationPayload.fromJson(payloadString);
        onNotificationTap!(payload);
        debugPrint('Notification tapped: $payload');
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    // Create a channel for each notification type
    for (final type in NotificationType.values) {
      final channel = AndroidNotificationChannel(
        type.channelId,
        type.channelName,
        description: type.channelDescription,
        importance: _mapImportance(type.importance),
        enableVibration: type.importance != NotificationImportance.low,
        playSound: type.importance != NotificationImportance.low,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    debugPrint(
      'Created ${NotificationType.values.length} notification channels',
    );
  }

  /// Map our importance enum to Android importance
  Importance _mapImportance(NotificationImportance importance) {
    switch (importance) {
      case NotificationImportance.min:
        return Importance.min;
      case NotificationImportance.low:
        return Importance.low;
      case NotificationImportance.defaultImportance:
        return Importance.defaultImportance;
      case NotificationImportance.high:
        return Importance.high;
      case NotificationImportance.max:
        return Importance.max;
    }
  }

  /// Map our priority enum to Android priority
  Priority _mapPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.min:
        return Priority.min;
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.defaultPriority:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.max:
        return Priority.max;
    }
  }

  /// Show an instant notification
  ///
  /// Example:
  /// ```dart
  /// await NotificationService.instance.showNotification(
  ///   id: 1,
  ///   title: 'Budget Alert',
  ///   body: 'You have exceeded your monthly budget',
  ///   type: NotificationType.budgetAlert,
  ///   payload: NotificationPayload.budgetAlert(budgetId: 123),
  /// );
  /// ```
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationType type,
    NotificationPayload? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      type.channelId,
      type.channelName,
      channelDescription: type.channelDescription,
      importance: _mapImportance(type.importance),
      priority: _mapPriority(NotificationPriority.defaultPriority),
      enableVibration: type.importance != NotificationImportance.low,
      playSound: type.importance != NotificationImportance.low,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload?.toJson(),
    );

    debugPrint('Showed notification: $title');
  }

  /// Schedule a notification for a specific date and time
  ///
  /// Example:
  /// ```dart
  /// await NotificationService.instance.scheduleNotification(
  ///   id: 2,
  ///   title: 'Bill Reminder',
  ///   body: 'Your electricity bill is due tomorrow',
  ///   scheduledDate: DateTime.now().add(Duration(days: 1)),
  ///   type: NotificationType.billReminder,
  ///   payload: NotificationPayload.billReminder(transactionId: 456),
  /// );
  /// ```
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required NotificationType type,
    NotificationPayload? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      type.channelId,
      type.channelName,
      channelDescription: type.channelDescription,
      importance: _mapImportance(type.importance),
      priority: _mapPriority(NotificationPriority.defaultPriority),
      enableVibration: type.importance != NotificationImportance.low,
      playSound: type.importance != NotificationImportance.low,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload?.toJson(),
    );

    debugPrint('Scheduled notification: $title for $scheduledDate');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
    debugPrint('Cancelled notification with id: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('Cancelled all notifications');
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Request notification permissions (iOS/macOS)
  ///
  /// Returns true if permissions were granted
  Future<bool> requestPermissions() async {
    final iosImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final macOSImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('iOS notification permissions granted: $granted');
      return granted ?? false;
    }

    if (macOSImplementation != null) {
      final granted = await macOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('macOS notification permissions granted: $granted');
      return granted ?? false;
    }

    // Android doesn't require runtime permissions for notifications (before Android 13)
    return true;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled();
      return enabled ?? false;
    }

    // For iOS/macOS, we assume they're enabled if permissions were granted
    return true;
  }
}
