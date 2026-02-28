#!/bin/bash

# Script to run Flutter app with different flavors
# Usage: ./scripts/run_flavor.sh [dev|staging|prod] [device_id]

set -e

FLAVOR=${1:-dev}
DEVICE=${2:-}

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Running FinNest with flavor: $FLAVOR${NC}"

case $FLAVOR in
  dev|development)
    echo -e "${YELLOW}📱 Starting Development flavor...${NC}"
    if [ -z "$DEVICE" ]; then
      flutter run -t lib/main_development.dart --dart-define=FLAVOR=development
    else
      flutter run -t lib/main_development.dart --dart-define=FLAVOR=development -d "$DEVICE"
    fi
    ;;
    
  staging|stg)
    echo -e "${YELLOW}📱 Starting Staging flavor...${NC}"
    if [ -z "$DEVICE" ]; then
      flutter run -t lib/main_staging.dart --dart-define=FLAVOR=staging
    else
      flutter run -t lib/main_staging.dart --dart-define=FLAVOR=staging -d "$DEVICE"
    fi
    ;;
    
  prod|production)
    echo -e "${YELLOW}📱 Starting Production flavor...${NC}"
    if [ -z "$DEVICE" ]; then
      flutter run -t lib/main.dart --dart-define=FLAVOR=production
    else
      flutter run -t lib/main.dart --dart-define=FLAVOR=production -d "$DEVICE"
    fi
    ;;
    
  *)
    echo -e "${RED}❌ Invalid flavor: $FLAVOR${NC}"
    echo "Usage: $0 [dev|staging|prod] [device_id]"
    echo "Example: $0 dev"
    echo "Example: $0 staging emulator-5554"
    exit 1
    ;;
esac

echo -e "${GREEN}✅ Done!${NC}"

