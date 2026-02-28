# iOS Flavor Configuration

This guide explains how to configure iOS flavors (schemes) for the FinNest app.

## Step 1: Open Xcode

```bash
open ios/Runner.xcworkspace
```

## Step 2: Create Schemes

1. In Xcode, go to **Product > Scheme > Manage Schemes**
2. Select the **Runner** scheme and click the **gear icon** at the bottom
3. Click **Duplicate** to create a copy
4. Rename it to **Runner-Development**
5. Repeat for **Runner-Staging** and **Runner-Production**

## Step 3: Configure Build Configurations

1. Select your project in the Project Navigator
2. Select the **Runner** project (not target)
3. Go to the **Info** tab
4. Under **Configurations**, duplicate Debug and Release for each flavor:
   - Debug-Development
   - Debug-Staging
   - Debug-Production
   - Release-Development
   - Release-Staging
   - Release-Production

## Step 4: Update Scheme Settings

For each scheme (Development, Staging, Production):

1. Go to **Product > Scheme > Edit Scheme**
2. For each action (Run, Test, Profile, Analyze, Archive):
   - Set the appropriate Build Configuration
   - Example: For Development scheme's Run action, use Debug-Development

## Step 5: Configure Bundle Identifiers

### Option 1: Using User-Defined Settings

1. Select the **Runner** target
2. Go to **Build Settings**
3. Click **+** and select **Add User-Defined Setting**
4. Name it `PRODUCT_BUNDLE_IDENTIFIER_SUFFIX`
5. Set values for each configuration:
   - Development: `.dev`
   - Staging: `.staging`
   - Production: (empty)

6. Update the Bundle Identifier to:
   ```
   com.finnest.app$(PRODUCT_BUNDLE_IDENTIFIER_SUFFIX)
   ```

### Option 2: Using xcconfig Files

Create configuration files in `ios/Flutter/`:

**Development.xcconfig:**
```
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.finnest.app.dev
DISPLAY_NAME = FinNest Dev
```

**Staging.xcconfig:**
```
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.finnest.app.staging
DISPLAY_NAME = FinNest Staging
```

**Production.xcconfig:**
```
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.finnest.app
DISPLAY_NAME = FinNest
```

Then assign these to the appropriate configurations in Project Settings.

## Step 6: Update Info.plist

Update `ios/Runner/Info.plist` to use the dynamic display name:

```xml
<key>CFBundleDisplayName</key>
<string>$(DISPLAY_NAME)</string>
```

## Step 7: Different App Icons (Optional)

1. Create separate asset catalogs for each flavor:
   - `AppIcon-Development`
   - `AppIcon-Staging`
   - `AppIcon-Production`

2. In Build Settings, set `ASSETCATALOG_COMPILER_APPICON_NAME` for each configuration

## Step 8: Build Commands

### Using Flutter CLI

```bash
# Development
flutter build ios -t lib/main_development.dart --flavor development

# Staging
flutter build ios -t lib/main_staging.dart --flavor staging

# Production
flutter build ios -t lib/main.dart --flavor production
```

### Using Xcode

1. Select the appropriate scheme (Runner-Development, etc.)
2. Select your target device or simulator
3. Click **Product > Build** or **Product > Run**

## Step 9: Archive for App Store

```bash
# Production
flutter build ipa -t lib/main.dart --flavor production --release
```

Or in Xcode:
1. Select **Runner-Production** scheme
2. Select **Any iOS Device (arm64)**
3. Click **Product > Archive**
4. Once complete, click **Distribute App**

## Provisioning Profiles

You'll need separate provisioning profiles for each bundle identifier:
- `com.finnest.app.dev`
- `com.finnest.app.staging`
- `com.finnest.app`

Create these in the Apple Developer Portal and download them to Xcode.

## Troubleshooting

### Issue: Scheme not found
Make sure you've created the schemes in Xcode and they match the flavor names.

### Issue: Wrong bundle identifier
Check that the bundle identifier is correctly set in Build Settings for each configuration.

### Issue: Provisioning profile error
Ensure you have provisioning profiles for all bundle identifiers and they're properly installed.

### Issue: Can't install multiple versions
This is expected! Each flavor has a different bundle ID, allowing multiple versions to coexist.

## Quick Reference

| Flavor | Bundle ID | Display Name | Scheme |
|--------|-----------|--------------|--------|
| Development | com.finnest.app.dev | FinNest Dev | Runner-Development |
| Staging | com.finnest.app.staging | FinNest Staging | Runner-Staging |
| Production | com.finnest.app | FinNest | Runner-Production |

