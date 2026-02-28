import 'package:drift/drift.dart';

/// Goal status
enum GoalStatus {
  active,
  completed,
  cancelled,
  paused,
}

/// Goals table for financial goals tracking
@DataClassName('GoalEntity')
class Goals extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// User ID (foreign key)
  IntColumn get userId => integer()();
  
  /// Goal name
  TextColumn get name => text()();
  
  /// Goal description
  TextColumn get description => text().nullable()();
  
  /// Target amount in cents
  IntColumn get targetAmountInCents => integer()();
  
  /// Current saved amount in cents
  IntColumn get currentAmountInCents => integer().withDefault(const Constant(0))();
  
  /// Currency code
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  
  /// Target date to achieve the goal
  DateTimeColumn get targetDate => dateTime()();
  
  /// Goal status
  IntColumn get status => intEnum<GoalStatus>().withDefault(const Constant(0))(); // active
  
  /// Linked account ID (where savings are stored)
  IntColumn get accountId => integer().nullable()();
  
  /// Monthly contribution amount in cents
  IntColumn get monthlyContributionInCents => integer().nullable()();
  
  /// Whether auto-save is enabled
  BoolColumn get autoSaveEnabled => boolean().withDefault(const Constant(false))();
  
  /// Auto-save percentage (0-100)
  IntColumn get autoSavePercentage => integer().nullable()();
  
  /// Goal priority (1-5, 1 being highest)
  IntColumn get priority => integer().withDefault(const Constant(3))();
  
  /// Goal color (hex code)
  TextColumn get color => text().nullable()();
  
  /// Goal icon name
  TextColumn get icon => text().nullable()();
  
  /// Goal image URL
  TextColumn get imageUrl => text().nullable()();
  
  /// Notes about the goal
  TextColumn get notes => text().nullable()();
  
  /// When the goal was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the goal was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// When the goal was completed
  DateTimeColumn get completedAt => dateTime().nullable()();
}

