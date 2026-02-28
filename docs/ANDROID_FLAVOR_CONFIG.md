# Android Flavor Configuration

This guide explains how to configure Android flavors for the FinNest app.

## Step 1: Update android/app/build.gradle

Add the following configuration to your `android/app/build.gradle` file:

```gradle
android {
    namespace = "com.finnest.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId = "com.finnest.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode.toInteger()
        versionName = flutterVersionName
    }

    // Add flavor dimensions
    flavorDimensions = ["environment"]
    
    // Define product flavors
    productFlavors {
        development {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue "string", "app_name", "FinNest Dev"
            
            // Optional: Different app icon
            // manifestPlaceholders = [appIcon: "@mipmap/ic_launcher_dev"]
        }
        
        staging {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue "string", "app_name", "FinNest Staging"
            
            // Optional: Different app icon
            // manifestPlaceholders = [appIcon: "@mipmap/ic_launcher_staging"]
        }
        
        production {
            dimension = "environment"
            resValue "string", "app_name", "FinNest"
            
            // Optional: Different app icon
            // manifestPlaceholders = [appIcon: "@mipmap/ic_launcher"]
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.debug
            // TODO: Add your release signing config
            // signingConfig = signingConfigs.release
        }
    }
}
```

## Step 2: Update AndroidManifest.xml

Update `android/app/src/main/AndroidManifest.xml` to use the dynamic app name:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="@string/app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... rest of your manifest -->
    </application>
</manifest>
```

## Step 3: Create Flavor-Specific Resources (Optional)

You can create flavor-specific resources by creating these directories:

```
android/app/src/
├── development/
│   └── res/
│       ├── mipmap-hdpi/
│       ├── mipmap-mdpi/
│       ├── mipmap-xhdpi/
│       ├── mipmap-xxhdpi/
│       └── mipmap-xxxhdpi/
├── staging/
│   └── res/
│       └── ... (same structure)
└── production/
    └── res/
        └── ... (same structure)
```

## Step 4: Build Commands

### Build APK
```bash
# Development
flutter build apk -t lib/main_development.dart --flavor development

# Staging
flutter build apk -t lib/main_staging.dart --flavor staging

# Production
flutter build apk -t lib/main.dart --flavor production
```

### Build App Bundle
```bash
# Development
flutter build appbundle -t lib/main_development.dart --flavor development

# Staging
flutter build appbundle -t lib/main_staging.dart --flavor staging

# Production
flutter build appbundle -t lib/main.dart --flavor production
```

## Step 5: Run Commands

```bash
# Development
flutter run -t lib/main_development.dart --flavor development

# Staging
flutter run -t lib/main_staging.dart --flavor staging

# Production
flutter run -t lib/main.dart --flavor production
```

## Signing Configuration (Production)

For production builds, create a `android/key.properties` file:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

Then update `build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... other config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## Troubleshooting

### Issue: Multiple APKs installed
This is expected! Each flavor has a different `applicationId`, allowing multiple versions to coexist.

### Issue: Build fails with flavor not found
Make sure you're using both `-t` (target) and `--flavor` flags together.

### Issue: Wrong app name showing
Check that `android:label="@string/app_name"` is set in AndroidManifest.xml

