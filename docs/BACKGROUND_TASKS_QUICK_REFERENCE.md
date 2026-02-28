# Background Tasks - Quick Reference

## Quick Start

### 1. Schedule One-Time Task

```dart
import 'package:fin_nest/core/services/background_task_service.dart';
import 'package:fin_nest/core/background/background_task_types.dart';

// Immediate execution
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.transactionProcessing,
);

// Delayed execution
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.databaseBackup,
  delay: const Duration(hours: 2),
);
```

### 2. Schedule Periodic Task

```dart
// Minimum 15 minutes frequency
await BackgroundTaskService.instance.schedulePeriodicTask(
  BackgroundTaskType.budgetAlertCheck,
  frequency: const Duration(hours: 1),
);
```

### 3. Cancel Tasks

```dart
// Cancel specific task
await BackgroundTaskService.instance.cancelTask(
  BackgroundTaskType.budgetAlertCheck,
);

// Cancel all tasks
await BackgroundTaskService.instance.cancelAllTasks();
```

## Task Types Reference

| Task Type | Network | Charging | Frequency | Use Case |
|-----------|---------|----------|-----------|----------|
| `dataSync` | ✅ | ❌ | 6 hours | Sync with server |
| `transactionProcessing` | ❌ | ❌ | On-demand | Process transactions |
| `budgetAlertCheck` | ❌ | ❌ | 1 hour | Check budget limits |
| `billReminderCheck` | ❌ | ❌ | 12 hours | Check bill due dates |
| `recurringTransactionProcessing` | ❌ | ❌ | 24 hours | Process recurring |
| `goalProgressUpdate` | ❌ | ❌ | On-demand | Update goals |
| `dataCleanup` | ❌ | ❌ | 7 days | Clean old data |
| `databaseBackup` | ❌ | ✅ | On-demand | Backup database |
| `notificationSync` | ✅ | ❌ | On-demand | Sync notifications |
| `exchangeRateUpdate` | ✅ | ❌ | On-demand | Update rates |
| `reportGeneration` | ❌ | ✅ | On-demand | Generate reports |
| `accountBalanceCheck` | ❌ | ❌ | On-demand | Check balances |

## Constraints

### Network Constraints

```dart
// Require any network connection
constraints: Constraints(
  networkType: NetworkType.connected,
)

// Require unmetered network (WiFi)
constraints: Constraints(
  networkType: NetworkType.unmetered,
)

// No network required
constraints: Constraints(
  networkType: NetworkType.notRequired,
)
```

### Battery Constraints

```dart
// Require device to be charging
constraints: Constraints(
  requiresCharging: true,
)

// Require battery not low
constraints: Constraints(
  requiresBatteryNotLow: true,
)

// Require device idle (Android only)
constraints: Constraints(
  requiresDeviceIdle: true,
)
```

### Combined Constraints

```dart
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.databaseBackup,
  constraints: Constraints(
    networkType: NetworkType.unmetered,
    requiresCharging: true,
    requiresBatteryNotLow: true,
  ),
);
```

## Passing Data to Tasks

```dart
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.transactionProcessing,
  inputData: {
    'transactionId': 123,
    'userId': 456,
    'action': 'process',
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

## Implementing Task Logic

Update `callbackDispatcher` in `background_task_service.dart`:

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Task started: $task');
    
    try {
      switch (task) {
        case 'com.finnest.task.budget_alert_check':
          // Get database instance
          final db = GetIt.instance<AppDatabase>();
          
          // Check budgets
          final budgets = await db.select(db.budgets).get();
          for (final budget in budgets) {
            // Check if budget exceeded
            // Send notification if needed
          }
          break;
          
        case 'com.finnest.task.data_sync':
          // Sync data with server
          final apiClient = GetIt.instance<ApiClient>();
          await apiClient.syncData();
          break;
          
        default:
          debugPrint('Unknown task: $task');
      }
      
      return Future.value(true);
    } catch (e) {
      debugPrint('Task failed: $e');
      return Future.value(false);
    }
  });
}
```

## Common Issues & Solutions

### Issue: Tasks not running

**Solutions**:
1. Check battery optimization settings - disable for your app
2. Verify minimum frequency (15 minutes for periodic tasks)
3. Check device battery saver mode
4. Ensure app has necessary permissions

### Issue: Tasks running too frequently

**Solution**: WorkManager may run tasks more frequently than requested. This is normal behavior to batch tasks for battery efficiency.

### Issue: Tasks not running after device reboot

**Solution**: Ensure `RECEIVE_BOOT_COMPLETED` permission is in AndroidManifest.xml.

### Issue: Tasks failing silently

**Solution**: Add proper error handling and logging in `callbackDispatcher`.

### Issue: Cannot access database in background task

**Solution**: Use GetIt to access database instance:
```dart
final db = GetIt.instance<AppDatabase>();
```

## Best Practices

1. **Keep tasks short**: Aim for < 10 minutes execution time
2. **Handle errors gracefully**: Always return true/false to indicate success/failure
3. **Use constraints wisely**: Don't over-constrain tasks or they may never run
4. **Test on real devices**: Emulators don't accurately simulate background task behavior
5. **Monitor battery usage**: Use Android Battery Historian to analyze impact
6. **Respect user preferences**: Allow users to disable background tasks
7. **Use unique task IDs**: Each task type has a unique ID automatically
8. **Cancel old tasks**: Cancel tasks before rescheduling to avoid duplicates
9. **Log task execution**: Use debugPrint to track task execution
10. **Return proper status**: Return true for success, false for failure (will retry)

## Testing

### Test One-Time Task

```dart
// In your debug screen or test
ElevatedButton(
  onPressed: () async {
    await BackgroundTaskService.instance.scheduleOneTimeTask(
      BackgroundTaskType.budgetAlertCheck,
      delay: const Duration(seconds: 30),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task scheduled in 30 seconds')),
    );
  },
  child: const Text('Test Background Task'),
)
```

### Test Periodic Task

```dart
ElevatedButton(
  onPressed: () async {
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.budgetAlertCheck,
      frequency: const Duration(minutes: 15), // Minimum
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Periodic task scheduled')),
    );
  },
  child: const Text('Test Periodic Task'),
)
```

## See Also

- [BACKGROUND_TASKS_SETUP.md](./BACKGROUND_TASKS_SETUP.md) - Complete setup guide
- [BACKGROUND_TASKS_SUMMARY.md](./BACKGROUND_TASKS_SUMMARY.md) - Implementation summary

