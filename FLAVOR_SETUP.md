# Flavor Configuration Guide

This document explains how to run the FinNest app with different flavors (environments).

## Available Flavors

The app supports three flavors:

1. **Development** - For local development with debug features enabled
2. **Staging** - For testing in a staging environment
3. **Production** - For production release

## Flavor Configurations

Each flavor has its own configuration:

### Development
- API Base URL: `https://dev-api.finnest.com`
- Logging: Enabled
- Analytics: Disabled
- Debug Banner: Visible

### Staging
- API Base URL: `https://staging-api.finnest.com`
- Logging: Enabled
- Analytics: Enabled
- Debug Banner: Visible

### Production
- API Base URL: `https://api.finnest.com`
- Logging: Disabled
- Analytics: Enabled
- Debug Banner: Hidden

## Running the App

### Using VS Code

1. Open the Run and Debug panel (Cmd/Ctrl + Shift + D)
2. Select the desired flavor from the dropdown:
   - Development
   - Staging
   - Production
3. Press F5 or click the play button

### Using Command Line

#### Development
```bash
flutter run -t lib/main_development.dart --dart-define=FLAVOR=development
```

#### Staging
```bash
flutter run -t lib/main_staging.dart --dart-define=FLAVOR=staging
```

#### Production
```bash
flutter run -t lib/main.dart --dart-define=FLAVOR=production
```

### Building for Release

#### Android

**Development APK:**
```bash
flutter build apk -t lib/main_development.dart --dart-define=FLAVOR=development --flavor development
```

**Staging APK:**
```bash
flutter build apk -t lib/main_staging.dart --dart-define=FLAVOR=staging --flavor staging
```

**Production APK:**
```bash
flutter build apk -t lib/main.dart --dart-define=FLAVOR=production --flavor production
```

#### iOS

**Development:**
```bash
flutter build ios -t lib/main_development.dart --dart-define=FLAVOR=development --flavor development
```

**Staging:**
```bash
flutter build ios -t lib/main_staging.dart --dart-define=FLAVOR=staging --flavor staging
```

**Production:**
```bash
flutter build ios -t lib/main.dart --dart-define=FLAVOR=production --flavor production
```

## Android Configuration

To properly configure flavors for Android, update `android/app/build.gradle`:

```gradle
android {
    // ... other configurations

    flavorDimensions "environment"
    
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "FinNest Dev"
        }
        
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "FinNest Staging"
        }
        
        production {
            dimension "environment"
            resValue "string", "app_name", "FinNest"
        }
    }
}
```

## iOS Configuration

For iOS, you'll need to create separate schemes in Xcode:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Go to Product > Scheme > Manage Schemes
3. Duplicate the Runner scheme for each flavor
4. Name them: Runner-Development, Runner-Staging, Runner-Production
5. For each scheme, set the appropriate build configuration

## Environment Variables

You can pass environment variables using `--dart-define`:

```bash
flutter run -t lib/main_development.dart \
  --dart-define=FLAVOR=development \
  --dart-define=API_KEY=your_api_key \
  --dart-define=API_SECRET=your_api_secret
```

These can be accessed in code via:
```dart
const apiKey = String.fromEnvironment('API_KEY');
```

## Using .env Files (Optional)

For better secret management, consider using the `flutter_dotenv` package:

1. Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

2. Create `.env` files:
   - `.env.development`
   - `.env.staging`
   - `.env.production`

3. Load in bootstrap:
```dart
await dotenv.load(fileName: ".env.${flavor.name}");
```

## Best Practices

1. **Never commit secrets** - Use `.gitignore` for `.env` files
2. **Use different bundle IDs** - Allows installing multiple flavors simultaneously
3. **Different app icons** - Visual distinction between environments
4. **Separate Firebase projects** - One for each environment
5. **Feature flags** - Control features per environment

## Troubleshooting

### Issue: Flavor not initialized
**Solution:** Ensure `FlavorConfig.initialize()` is called in bootstrap before accessing `FlavorConfig.instance`

### Issue: Wrong API being called
**Solution:** Check that you're running the correct entry point (`main_development.dart`, etc.)

### Issue: Can't install multiple flavors on same device
**Solution:** Ensure different `applicationIdSuffix` in Android and different bundle IDs in iOS

## Additional Resources

- [Flutter Flavors Documentation](https://flutter.dev/docs/deployment/flavors)
- [Environment Variables in Flutter](https://dart.dev/guides/environment-declarations)

