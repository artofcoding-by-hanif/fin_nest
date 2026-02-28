/// Environment configuration
/// This class holds environment-specific variables
/// You can use flutter_dotenv or similar packages to load from .env files
class Env {
  // API Configuration
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  static const String apiSecret = String.fromEnvironment(
    'API_SECRET',
    defaultValue: '',
  );

  // Firebase Configuration (if using Firebase)
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  // Analytics
  static const String mixpanelToken = String.fromEnvironment(
    'MIXPANEL_TOKEN',
    defaultValue: '',
  );

  // Feature Flags
  static const bool enableBiometrics = bool.fromEnvironment(
    'ENABLE_BIOMETRICS',
    defaultValue: true,
  );

  static const bool enableNotifications = bool.fromEnvironment(
    'ENABLE_NOTIFICATIONS',
    defaultValue: true,
  );

  // Prevent instantiation
  Env._();
}
