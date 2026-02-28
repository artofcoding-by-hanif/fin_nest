/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'FinNest';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const int apiTimeout = 30000; // 30 seconds
  static const int apiRetryAttempts = 3;
  static const Duration apiRetryDelay = Duration(seconds: 2);

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50 MB

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Database
  static const String databaseName = 'finnest.db';
  static const int databaseVersion = 1;

  // Secure Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyBiometricEnabled = 'biometric_enabled';

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyLastSyncTime = 'last_sync_time';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Currency
  static const String defaultCurrency = 'INR';
  static const String currencySymbol = '₹';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Background Sync
  static const Duration syncInterval = Duration(hours: 6);
  static const String syncTaskName = 'finnest_sync';

  // Notifications
  static const String notificationChannelId = 'finnest_notifications';
  static const String notificationChannelName = 'FinNest Notifications';
  static const String notificationChannelDescription =
      'Notifications for FinNest app';

  // Deep Links
  static const String deepLinkScheme = 'finnest';
  static const String deepLinkHost = 'app';

  // Support
  static const String supportEmail = 'support@finnest.com';
  static const String privacyPolicyUrl = 'https://finnest.com/privacy';
  static const String termsOfServiceUrl = 'https://finnest.com/terms';

  // Prevent instantiation
  AppConstants._();
}
