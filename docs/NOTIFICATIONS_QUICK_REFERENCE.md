# Notification System - Quick Reference

## Quick Start

### 1. Show Instant Notification

```dart
import 'package:fin_nest/core/services/notification_service.dart';
import 'package:fin_nest/core/notifications/notification_types.dart';
import 'package:fin_nest/core/notifications/notification_payload.dart';

await NotificationService.instance.showNotification(
  id: 1,
  title: 'Transaction Complete',
  body: 'Your payment of \$50.00 was successful',
  type: NotificationType.transaction,
  payload: NotificationPayload.transaction(
    transactionId: 789,
    route: '/transactions/789',
  ),
);
```

### 2. Schedule Notification

```dart
await NotificationService.instance.scheduleNotification(
  id: 2,
  title: 'Bill Reminder',
  body: 'Your rent is due in 3 days',
  scheduledDate: DateTime.now().add(const Duration(days: 3)),
  type: NotificationType.billReminder,
  payload: NotificationPayload.billReminder(
    transactionId: 456,
    route: '/bills/456',
  ),
);
```

### 3. Cancel Notification

```dart
// Cancel specific notification
await NotificationService.instance.cancelNotification(1);

// Cancel all notifications
await NotificationService.instance.cancelAllNotifications();
```

## Notification Types Reference

| Type | Use Case | Example |
|------|----------|---------|
| `budgetAlert` | Budget warnings | "You've spent 90% of your grocery budget" |
| `billReminder` | Bill due dates | "Electric bill due tomorrow" |
| `goalUpdate` | Goal progress | "You're 50% towards your vacation goal!" |
| `transaction` | Transaction confirmations | "Payment of $25.00 received" |
| `recurringTransaction` | Recurring alerts | "Monthly subscription charged" |
| `accountUpdate` | Account changes | "Your account balance is low" |
| `savingsSuggestion` | Savings tips | "Save $50 this week to reach your goal" |
| `investmentUpdate` | Investment news | "Your portfolio is up 5% this month" |
| `general` | General messages | "Welcome to FinNest!" |

## Payload Factory Methods

Each notification type has a factory method for creating payloads:

```dart
// Budget Alert
NotificationPayload.budgetAlert(budgetId: 123, route: '/budgets/123')

// Bill Reminder
NotificationPayload.billReminder(transactionId: 456, route: '/bills/456')

// Goal Update
NotificationPayload.goalUpdate(goalId: 789, route: '/goals/789')

// Transaction
NotificationPayload.transaction(transactionId: 101, route: '/transactions/101')

// Recurring Transaction
NotificationPayload.recurringTransaction(recurringId: 202, route: '/recurring/202')

// Account Update
NotificationPayload.accountUpdate(accountId: 303, route: '/accounts/303')

// Savings Suggestion
NotificationPayload.savingsSuggestion(suggestionId: 404, route: '/savings/404')

// Investment Update
NotificationPayload.investmentUpdate(investmentId: 505, route: '/investments/505')

// General
NotificationPayload.general(route: '/home')
```

## Common Operations

### Check if Notifications are Enabled

```dart
final enabled = await NotificationService.instance.areNotificationsEnabled();
if (!enabled) {
  // Show dialog to request permissions
  await NotificationService.instance.requestPermissions();
}
```

### Get Pending Notifications

```dart
final pending = await NotificationService.instance.getPendingNotifications();
debugPrint('You have ${pending.length} pending notifications');
```

### Handle Notification Tap

Configure in `bootstrap.dart`:

```dart
await NotificationService.instance.initialize(
  onNotificationTap: (payload) {
    // Navigate to the appropriate screen
    if (payload.route != null) {
      navigatorKey.currentState?.pushNamed(payload.route!);
    }
    
    // Access payload data
    final id = payload.data?['id'];
    debugPrint('Notification tapped: ${payload.type.name}, ID: $id');
  },
);
```

## Common Issues & Solutions

### Issue: Notifications not showing on Android 13+

**Solution**: Request POST_NOTIFICATIONS permission at runtime:

```dart
await NotificationService.instance.requestPermissions();
```

### Issue: Scheduled notifications not firing

**Solution**: Ensure SCHEDULE_EXACT_ALARM permission is granted and battery optimization is disabled for the app.

### Issue: Notifications disappear after device restart

**Solution**: The RECEIVE_BOOT_COMPLETED permission is already configured. Notifications will be rescheduled automatically.

### Issue: Notification channels not updating

**Solution**: Uninstall and reinstall the app. Notification channels cannot be modified after creation.

### Issue: Timezone issues with scheduled notifications

**Solution**: Use the timezone package to convert to local timezone:

```dart
import 'package:timezone/timezone.dart' as tz;

final scheduledDate = tz.TZDateTime.from(
  DateTime.now().add(const Duration(hours: 1)),
  tz.local,
);
```

## Best Practices

1. **Use unique IDs**: Each notification should have a unique ID to avoid conflicts
2. **Include payload**: Always include payload for navigation and context
3. **Choose appropriate type**: Use the correct NotificationType for proper channel routing
4. **Request permissions early**: Request notification permissions during onboarding
5. **Cancel old notifications**: Cancel notifications that are no longer relevant
6. **Test on real devices**: Notification behavior varies across devices and OS versions
7. **Handle notification taps**: Always implement onNotificationTap callback
8. **Use meaningful titles**: Keep titles short and descriptive
9. **Provide context in body**: Include relevant details in the notification body
10. **Respect user preferences**: Allow users to disable specific notification types

## Testing

### Test Instant Notification

```dart
// In your debug screen or test
ElevatedButton(
  onPressed: () async {
    await NotificationService.instance.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Test Notification',
      body: 'This is a test notification',
      type: NotificationType.general,
    );
  },
  child: const Text('Test Notification'),
)
```

### Test Scheduled Notification

```dart
ElevatedButton(
  onPressed: () async {
    await NotificationService.instance.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Scheduled Test',
      body: 'This notification was scheduled 10 seconds ago',
      scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
      type: NotificationType.general,
    );
  },
  child: const Text('Test Scheduled Notification'),
)
```

## See Also

- [NOTIFICATIONS_SETUP.md](./NOTIFICATIONS_SETUP.md) - Complete setup guide
- [NOTIFICATIONS_SUMMARY.md](./NOTIFICATIONS_SUMMARY.md) - Implementation summary

