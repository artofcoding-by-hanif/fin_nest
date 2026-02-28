#!/bin/bash

# Script to build Flutter app with different flavors
# Usage: ./scripts/build_flavor.sh [dev|staging|prod] [android|ios|apk|appbundle]

set -e

FLAVOR=${1:-prod}
PLATFORM=${2:-apk}

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔨 Building FinNest${NC}"
echo -e "${BLUE}Flavor: $FLAVOR${NC}"
echo -e "${BLUE}Platform: $PLATFORM${NC}"

# Determine target file and flavor name
case $FLAVOR in
  dev|development)
    TARGET="lib/main_development.dart"
    FLAVOR_NAME="development"
    ;;
  staging|stg)
    TARGET="lib/main_staging.dart"
    FLAVOR_NAME="staging"
    ;;
  prod|production)
    TARGET="lib/main.dart"
    FLAVOR_NAME="production"
    ;;
  *)
    echo -e "${RED}❌ Invalid flavor: $FLAVOR${NC}"
    echo "Usage: $0 [dev|staging|prod] [android|ios|apk|appbundle]"
    exit 1
    ;;
esac

# Build based on platform
case $PLATFORM in
  apk)
    echo -e "${YELLOW}📦 Building APK...${NC}"
    flutter build apk -t "$TARGET" --dart-define=FLAVOR="$FLAVOR_NAME" --release
    echo -e "${GREEN}✅ APK built successfully!${NC}"
    echo -e "${BLUE}Location: build/app/outputs/flutter-apk/app-release.apk${NC}"
    ;;
    
  appbundle|aab)
    echo -e "${YELLOW}📦 Building App Bundle...${NC}"
    flutter build appbundle -t "$TARGET" --dart-define=FLAVOR="$FLAVOR_NAME" --release
    echo -e "${GREEN}✅ App Bundle built successfully!${NC}"
    echo -e "${BLUE}Location: build/app/outputs/bundle/release/app-release.aab${NC}"
    ;;
    
  ios)
    echo -e "${YELLOW}📦 Building iOS...${NC}"
    flutter build ios -t "$TARGET" --dart-define=FLAVOR="$FLAVOR_NAME" --release
    echo -e "${GREEN}✅ iOS build completed!${NC}"
    ;;
    
  ipa)
    echo -e "${YELLOW}📦 Building IPA...${NC}"
    flutter build ipa -t "$TARGET" --dart-define=FLAVOR="$FLAVOR_NAME" --release
    echo -e "${GREEN}✅ IPA built successfully!${NC}"
    ;;
    
  *)
    echo -e "${RED}❌ Invalid platform: $PLATFORM${NC}"
    echo "Usage: $0 [dev|staging|prod] [android|ios|apk|appbundle|ipa]"
    exit 1
    ;;
esac

echo -e "${GREEN}🎉 Build complete!${NC}"

