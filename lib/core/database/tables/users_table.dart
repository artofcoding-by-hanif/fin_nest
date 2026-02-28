import 'package:drift/drift.dart';

/// Users table for storing user profile information
@DataClassName('UserEntity')
class Users extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User's unique identifier (from auth provider)
  TextColumn get uid => text().unique()();
  
  /// User's email address
  TextColumn get email => text()();
  
  /// User's display name
  TextColumn get displayName => text().nullable()();
  
  /// User's phone number
  TextColumn get phoneNumber => text().nullable()();
  
  /// User's profile photo URL
  TextColumn get photoUrl => text().nullable()();
  
  /// User's preferred currency
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  
  /// User's preferred language
  TextColumn get language => text().withDefault(const Constant('en'))();
  
  /// Whether biometric authentication is enabled
  BoolColumn get biometricEnabled => boolean().withDefault(const Constant(false))();
  
  /// Whether notifications are enabled
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  
  /// User's timezone
  TextColumn get timezone => text().nullable()();
  
  /// When the user was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the user was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the user last synced
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

