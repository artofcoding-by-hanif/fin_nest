# Background Tasks Setup Guide

This guide explains how to set up and use the background task system in FinNest using WorkManager.

## Overview

The background task system is built on top of `workmanager` and provides:
- **12 background task types** for different operations
- **Periodic tasks** that run at regular intervals
- **One-time tasks** for immediate or delayed execution
- **Network and charging constraints** for efficient battery usage
- **Persistent scheduling** that survives app restarts and device reboots

## Architecture

```
lib/core/
├── background/
│   └── background_task_types.dart    # Task type definitions
└── services/
    └── background_task_service.dart  # Main background task service
```

## Background Task Types

The system supports 12 background task types:

| Type | Requires Network | Requires Charging | Use Case |
|------|-----------------|-------------------|----------|
| `dataSync` | ✅ | ❌ | Sync data with remote server |
| `transactionProcessing` | ❌ | ❌ | Process pending transactions |
| `budgetAlertCheck` | ❌ | ❌ | Check budget limits and send alerts |
| `billReminderCheck` | ❌ | ❌ | Check upcoming bills and send reminders |
| `recurringTransactionProcessing` | ❌ | ❌ | Process recurring transactions |
| `goalProgressUpdate` | ❌ | ❌ | Update goal progress |
| `dataCleanup` | ❌ | ❌ | Clean up old data |
| `databaseBackup` | ❌ | ✅ | Backup local database |
| `notificationSync` | ✅ | ❌ | Sync notification settings |
| `exchangeRateUpdate` | ✅ | ❌ | Update currency exchange rates |
| `reportGeneration` | ❌ | ✅ | Generate financial reports |
| `accountBalanceCheck` | ❌ | ❌ | Check account balances |

## Setup

### 1. Dependencies

The following package is already installed:
```yaml
dependencies:
  workmanager: ^0.9.0+3
```

### 2. Platform Configuration

#### Android (android/app/src/main/AndroidManifest.xml)

Required permissions:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

These permissions allow:
- **RECEIVE_BOOT_COMPLETED**: Reschedule tasks after device reboot
- **WAKE_LOCK**: Wake up device to run tasks
- **FOREGROUND_SERVICE**: Run long-running tasks

#### iOS

WorkManager uses iOS Background Fetch and Background Processing. No additional configuration needed.

### 3. Initialization

The background task service is automatically initialized in `bootstrap.dart`:

```dart
await BackgroundTaskService.instance.initialize();

// Schedule default periodic tasks
await _scheduleDefaultBackgroundTasks();
```

### 4. Default Scheduled Tasks

The following tasks are scheduled by default:

- **Data Sync**: Every 6 hours
- **Budget Alert Check**: Every 1 hour
- **Bill Reminder Check**: Every 12 hours
- **Recurring Transaction Processing**: Every 24 hours
- **Data Cleanup**: Every 7 days

## Usage

### Schedule a One-Time Task

```dart
import 'package:fin_nest/core/services/background_task_service.dart';
import 'package:fin_nest/core/background/background_task_types.dart';

// Schedule immediate task
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.transactionProcessing,
);

// Schedule delayed task
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.databaseBackup,
  delay: const Duration(hours: 2),
);

// Schedule with custom constraints
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.reportGeneration,
  delay: const Duration(hours: 1),
  constraints: Constraints(
    networkType: NetworkType.connected,
    requiresCharging: true,
    requiresBatteryNotLow: true,
  ),
);
```

### Schedule a Periodic Task

```dart
// Schedule periodic task (minimum 15 minutes)
await BackgroundTaskService.instance.schedulePeriodicTask(
  BackgroundTaskType.budgetAlertCheck,
  frequency: const Duration(hours: 1),
);

// Schedule with custom constraints
await BackgroundTaskService.instance.schedulePeriodicTask(
  BackgroundTaskType.dataSync,
  frequency: const Duration(hours: 6),
  constraints: Constraints(
    networkType: NetworkType.connected,
    requiresBatteryNotLow: true,
  ),
);
```

### Pass Data to Background Task

```dart
await BackgroundTaskService.instance.scheduleOneTimeTask(
  BackgroundTaskType.transactionProcessing,
  inputData: {
    'transactionId': 123,
    'userId': 456,
    'action': 'process',
  },
);
```

### Cancel Tasks

```dart
// Cancel specific task
await BackgroundTaskService.instance.cancelTask(
  BackgroundTaskType.budgetAlertCheck,
);

// Cancel all tasks
await BackgroundTaskService.instance.cancelAllTasks();
```

## Implementing Task Logic

The task execution logic is defined in the `callbackDispatcher` function in `background_task_service.dart`.

To implement task logic, update the `callbackDispatcher` function:

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task started: $task');
    
    try {
      // Handle each task type
      switch (task) {
        case 'com.finnest.task.data_sync':
          await _handleDataSync(inputData);
          break;
        case 'com.finnest.task.budget_alert_check':
          await _handleBudgetAlertCheck(inputData);
          break;
        // Add more cases...
        default:
          debugPrint('Unknown task: $task');
      }
      
      return Future.value(true); // Success
    } catch (e) {
      debugPrint('Task failed: $e');
      return Future.value(false); // Failure
    }
  });
}
```

## Best Practices

1. **Minimum Frequency**: Periodic tasks must have a frequency of at least 15 minutes
2. **Battery Optimization**: Use `requiresCharging` for heavy tasks like backups and reports
3. **Network Constraints**: Use `NetworkType.connected` for tasks that need internet
4. **Task Duration**: Keep tasks short (< 10 minutes) to avoid being killed by the OS
5. **Error Handling**: Always handle errors and return true/false to indicate success/failure
6. **Unique Task IDs**: Each task type has a unique ID to prevent conflicts
7. **Testing**: Test background tasks on real devices, not emulators
8. **Battery Saver**: Background tasks may not run when battery saver is enabled

## Next Steps

1. **Implement task execution logic** in `callbackDispatcher`
2. **Add more task types** as needed for your app
3. **Test on real devices** to ensure tasks run as expected
4. **Monitor task execution** using WorkManager logs
5. **Handle task failures** with retry logic

## Troubleshooting

See [BACKGROUND_TASKS_QUICK_REFERENCE.md](./BACKGROUND_TASKS_QUICK_REFERENCE.md) for common issues and solutions.

