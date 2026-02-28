import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app.dart';
import 'core/config/flavor_config.dart';
import 'core/config/feature_flag_manager.dart';
import 'core/database/app_database.dart';
import 'core/services/notification_service.dart';
import 'core/services/background_task_service.dart';
import 'core/services/settings_service.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/biometric_auth_service.dart';
import 'core/background/background_task_types.dart';

/// Bootstrap the application with necessary initializations
Future<void> bootstrap(Flavor flavor) async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize flavor configuration
  FlavorConfig.initialize(flavor);

  // Initialize feature flags
  await FeatureFlagManager.instance.initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Setup error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      // In debug mode, print the error
      debugPrint('Flutter Error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    } else {
      // In release mode, log to crash reporting service
      // TODO: Send to crash reporting service (e.g., Sentry, Firebase Crashlytics)
    }
  };

  // Handle errors outside of Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('Platform Error: $error');
      debugPrint('Stack trace: $stack');
    } else {
      // TODO: Send to crash reporting service
    }
    return true;
  };

  // Initialize dependency injection
  await _initializeDependencies();

  // Initialize settings service
  await _initializeSettings();

  // Initialize secure storage service
  await _initializeSecureStorage();

  // Initialize biometric authentication service
  await _initializeBiometricAuth();

  // Initialize local database
  await _initializeDatabase();

  // Initialize timezone database for scheduled notifications
  await _initializeTimezone();

  // Initialize notification service
  await _initializeNotifications();

  // Initialize background task service
  await _initializeBackgroundTasks();

  // TODO: Initialize Firebase (if using)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Run the app
  runApp(const ProviderScope(child: App()));
}

/// Initialize dependency injection
Future<void> _initializeDependencies() async {
  final getIt = GetIt.instance;

  // Register database as singleton
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // TODO: Register other services
  // getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  // getIt.registerLazySingleton<AuthService>(() => AuthService());
}

/// Initialize settings service
Future<void> _initializeSettings() async {
  await SettingsService.instance.initialize();
  if (kDebugMode) {
    debugPrint('Settings service initialized successfully');
  }
}

/// Initialize secure storage service
Future<void> _initializeSecureStorage() async {
  await SecureStorageService.instance.initialize();
  if (kDebugMode) {
    debugPrint('Secure storage service initialized successfully');
  }
}

/// Initialize biometric authentication service
Future<void> _initializeBiometricAuth() async {
  await BiometricAuthService.instance.initialize();
  if (kDebugMode) {
    debugPrint('Biometric authentication service initialized successfully');
  }
}

/// Initialize local database
Future<void> _initializeDatabase() async {
  // Database is initialized lazily when first accessed
  // You can optionally run migrations or seed data here
  if (kDebugMode) {
    debugPrint('Database initialized successfully');
  }
}

/// Initialize timezone database for scheduled notifications
Future<void> _initializeTimezone() async {
  tz.initializeTimeZones();
  // Set local timezone (you may want to use flutter_timezone package to get device timezone)
  tz.setLocalLocation(tz.getLocation('UTC'));
  if (kDebugMode) {
    debugPrint('Timezone initialized successfully');
  }
}

/// Initialize notification service
Future<void> _initializeNotifications() async {
  await NotificationService.instance.initialize(
    onNotificationTap: (payload) {
      // TODO: Handle notification tap and navigate to appropriate screen
      if (kDebugMode) {
        debugPrint('Notification tapped: ${payload.type.name}');
        debugPrint('Route: ${payload.route}');
        debugPrint('Data: ${payload.data}');
      }
    },
  );

  // Request notification permissions
  await NotificationService.instance.requestPermissions();

  if (kDebugMode) {
    debugPrint('Notification service initialized successfully');
  }
}

/// Initialize background task service
Future<void> _initializeBackgroundTasks() async {
  await BackgroundTaskService.instance.initialize();

  // Schedule default periodic tasks
  await _scheduleDefaultBackgroundTasks();

  if (kDebugMode) {
    debugPrint('Background task service initialized successfully');
  }
}

/// Schedule default background tasks
Future<void> _scheduleDefaultBackgroundTasks() async {
  try {
    // Schedule data sync every 6 hours
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.dataSync,
      frequency: const Duration(hours: 6),
    );

    // Schedule budget alert check every hour
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.budgetAlertCheck,
      frequency: const Duration(hours: 1),
    );

    // Schedule bill reminder check every 12 hours
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.billReminderCheck,
      frequency: const Duration(hours: 12),
    );

    // Schedule recurring transaction processing daily
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.recurringTransactionProcessing,
      frequency: const Duration(hours: 24),
    );

    // Schedule data cleanup weekly
    await BackgroundTaskService.instance.schedulePeriodicTask(
      BackgroundTaskType.dataCleanup,
      frequency: const Duration(days: 7),
    );

    if (kDebugMode) {
      debugPrint('Default background tasks scheduled successfully');
    }
  } catch (e) {
    debugPrint('Failed to schedule default background tasks: $e');
  }
}
