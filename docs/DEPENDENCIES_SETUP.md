# Core Dependencies Setup

This document outlines all the core dependencies added to the FinNest application.

## ✅ Installed Dependencies

### State Management & Dependency Injection

#### **GetIt** (v9.2.0)
- **Purpose**: Service locator for dependency injection
- **Usage**: Register and retrieve services/repositories throughout the app
- **Documentation**: https://pub.dev/packages/get_it

#### **Flutter Riverpod** (v2.6.1)
- **Purpose**: State management solution
- **Usage**: Manage app state, providers, and reactive programming
- **Documentation**: https://riverpod.dev

#### **Riverpod Annotation** (v2.6.1)
- **Purpose**: Annotations for code generation with Riverpod
- **Usage**: Use `@riverpod` annotations for automatic provider generation
- **Documentation**: https://riverpod.dev/docs/concepts/about_code_generation

### Networking

#### **Dio** (v5.9.1)
- **Purpose**: HTTP client for API requests
- **Features**:
  - Interceptors for request/response handling
  - Global configuration
  - FormData, File upload, Timeout
  - HTTP2 support
- **Documentation**: https://pub.dev/packages/dio

### Database

#### **Drift** (v2.28.2)
- **Purpose**: Reactive persistence library (formerly Moor)
- **Features**:
  - Type-safe SQL queries
  - Reactive streams
  - Migrations support
  - Cross-platform (SQLite)
- **Documentation**: https://drift.simonbinder.eu

#### **Drift Flutter** (v0.2.7)
- **Purpose**: Flutter-specific utilities for Drift
- **Features**: Native SQLite integration for Flutter
- **Documentation**: https://drift.simonbinder.eu/docs/platforms/

### Serialization

#### **Freezed Annotation** (v2.4.4)
- **Purpose**: Annotations for immutable classes and unions
- **Usage**: Create immutable data classes with copyWith, equality, toString
- **Documentation**: https://pub.dev/packages/freezed

#### **JSON Annotation** (v4.9.0)
- **Purpose**: Annotations for JSON serialization
- **Usage**: Define how classes should be serialized to/from JSON
- **Documentation**: https://pub.dev/packages/json_annotation

### Notifications

#### **Flutter Local Notifications** (v20.0.0)
- **Purpose**: Display local notifications
- **Features**:
  - Scheduled notifications
  - Custom sounds and icons
  - Action buttons
  - Platform-specific features
- **Documentation**: https://pub.dev/packages/flutter_local_notifications

## 🛠️ Dev Dependencies (Code Generation)

### **Build Runner** (v2.5.4)
- **Purpose**: Code generation tool
- **Usage**: Run code generators for Freezed, JSON Serializable, Riverpod, Drift
- **Command**: `flutter pub run build_runner build`

### **Freezed** (v2.5.8)
- **Purpose**: Code generator for immutable classes
- **Usage**: Generates copyWith, equality, toString, and union types
- **Documentation**: https://pub.dev/packages/freezed

### **JSON Serializable** (v6.9.5)
- **Purpose**: Code generator for JSON serialization
- **Usage**: Generates toJson/fromJson methods
- **Documentation**: https://pub.dev/packages/json_serializable

### **Riverpod Generator** (v2.6.4)
- **Purpose**: Code generator for Riverpod providers
- **Usage**: Generates providers from annotated functions/classes
- **Documentation**: https://riverpod.dev/docs/concepts/about_code_generation

### **Drift Dev** (v2.28.0)
- **Purpose**: Code generator for Drift database
- **Usage**: Generates type-safe database code from table definitions
- **Documentation**: https://drift.simonbinder.eu/docs/getting-started/

## 📝 Code Generation Commands

### Generate code once:
```bash
flutter pub run build_runner build
```

### Generate code and delete conflicting outputs:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch for changes and regenerate automatically:
```bash
flutter pub run build_runner watch
```

### Clean generated files:
```bash
flutter pub run build_runner clean
```

## 🎯 Usage Examples

### GetIt - Dependency Injection
```dart
// Register services
final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}

// Use services
final apiClient = getIt<ApiClient>();
```

### Riverpod - State Management
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}

// In widget
final count = ref.watch(counterProvider);
```

### Dio - HTTP Requests
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 5),
));

final response = await dio.get('/users');
```

### Drift - Database
```dart
@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
}
```

### Freezed - Immutable Classes
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## 🔄 Next Steps

1. **Initialize GetIt** in `lib/bootstrap.dart`
2. **Set up Dio** with interceptors in `lib/core/network/api_client.dart`
3. **Create Drift database** in `lib/core/database/app_database.dart`
4. **Define data models** using Freezed and JSON Serializable
5. **Create Riverpod providers** for state management
6. **Configure notifications** in platform-specific code

## 📚 Additional Resources

- [Flutter Riverpod Documentation](https://riverpod.dev)
- [Drift Documentation](https://drift.simonbinder.eu)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Dio Documentation](https://pub.dev/packages/dio)

