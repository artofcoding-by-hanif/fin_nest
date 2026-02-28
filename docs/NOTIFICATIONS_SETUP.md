# Notification System Setup Guide

This guide explains how to set up and use the local notification system in FinNest.

## Overview

The notification system is built on top of `flutter_local_notifications` and provides:
- **9 notification types** for different financial events
- **Scheduled notifications** with timezone support
- **Instant notifications** for immediate alerts
- **Platform-specific configuration** for Android and iOS
- **Type-safe notification handling** with payload support

## Architecture

```
lib/core/
├── notifications/
│   ├── notification_types.dart      # Notification type definitions
│   └── notification_payload.dart    # Payload handling for navigation
└── services/
    └── notification_service.dart    # Main notification service
```

## Notification Types

The system supports 9 notification types:

| Type | Channel ID | Importance | Use Case |
|------|-----------|-----------|----------|
| `budgetAlert` | `budget_alerts` | High | Budget limit warnings |
| `billReminder` | `bill_reminders` | High | Upcoming bill payments |
| `goalUpdate` | `goal_updates` | Default | Goal progress updates |
| `transaction` | `transactions` | Default | Transaction confirmations |
| `recurringTransaction` | `recurring_transactions` | Default | Recurring transaction alerts |
| `accountUpdate` | `account_updates` | Low | Account balance changes |
| `savingsSuggestion` | `savings_suggestions` | Low | Savings recommendations |
| `investmentUpdate` | `investment_updates` | Default | Investment performance |
| `general` | `general` | Default | General notifications |

## Setup

### 1. Dependencies

The following packages are already installed:
```yaml
dependencies:
  flutter_local_notifications: ^20.0.0
  timezone: ^0.10.1
```

### 2. Platform Configuration

#### Android (android/app/src/main/AndroidManifest.xml)

Required permissions:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

Required receivers:
```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
    </intent-filter>
</receiver>
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver" />
```

#### iOS (ios/Runner/AppDelegate.swift)

Configure notification delegate:
```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
}
```

### 3. Initialization

The notification service is automatically initialized in `bootstrap.dart`:

```dart
await NotificationService.instance.initialize(
  onNotificationTap: (payload) {
    // Handle notification tap and navigate
    debugPrint('Notification tapped: ${payload.type.name}');
    debugPrint('Route: ${payload.route}');
    debugPrint('Data: ${payload.data}');
  },
);

// Request permissions
await NotificationService.instance.requestPermissions();
```

## Usage

### Show Instant Notification

```dart
import 'package:fin_nest/core/services/notification_service.dart';
import 'package:fin_nest/core/notifications/notification_types.dart';
import 'package:fin_nest/core/notifications/notification_payload.dart';

await NotificationService.instance.showNotification(
  id: 1,
  title: 'Budget Alert',
  body: 'You have exceeded 80% of your monthly budget',
  type: NotificationType.budgetAlert,
  payload: NotificationPayload.budgetAlert(
    budgetId: 123,
    route: '/budgets/123',
  ),
);
```

### Schedule Notification

```dart
await NotificationService.instance.scheduleNotification(
  id: 2,
  title: 'Bill Reminder',
  body: 'Your electricity bill is due tomorrow',
  scheduledDate: DateTime.now().add(const Duration(days: 1)),
  type: NotificationType.billReminder,
  payload: NotificationPayload.billReminder(
    transactionId: 456,
    route: '/transactions/456',
  ),
);
```

### Cancel Notification

```dart
// Cancel specific notification
await NotificationService.instance.cancelNotification(1);

// Cancel all notifications
await NotificationService.instance.cancelAllNotifications();
```

### Get Pending Notifications

```dart
final pending = await NotificationService.instance.getPendingNotifications();
for (final notification in pending) {
  debugPrint('Pending: ${notification.id} - ${notification.title}');
}
```

### Check Notification Permissions

```dart
final enabled = await NotificationService.instance.areNotificationsEnabled();
if (!enabled) {
  // Show dialog to enable notifications
}
```

## Next Steps

1. **Implement navigation handling** in `bootstrap.dart` `onNotificationTap` callback
2. **Create notification scheduling logic** for budgets, bills, and goals
3. **Add notification preferences** to allow users to customize notification types
4. **Implement notification history** to track sent notifications
5. **Add notification actions** for quick actions from notifications

## Troubleshooting

See [NOTIFICATIONS_QUICK_REFERENCE.md](./NOTIFICATIONS_QUICK_REFERENCE.md) for common issues and solutions.

