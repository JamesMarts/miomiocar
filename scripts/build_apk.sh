#!/bin/bash
# 构建 APK
# 使用方法: ./scripts/build_apk.sh [dev|staging|prod]

FLAVOR=${1:-prod}

echo "📦 Building APK for $FLAVOR..."

case $FLAVOR in
  dev)
    flutter build apk --flavor dev -t lib/main_dev.dart
    ;;
  staging)
    flutter build apk --flavor staging -t lib/main_staging.dart
    ;;
  prod)
    flutter build apk --flavor prod -t lib/main_prod.dart --release
    ;;
  all)
    echo "Building all flavors..."
    flutter build apk --flavor dev -t lib/main_dev.dart
    flutter build apk --flavor staging -t lib/main_staging.dart
    flutter build apk --flavor prod -t lib/main_prod.dart --release
    ;;
  *)
    echo "Unknown flavor: $FLAVOR"
    echo "Usage: ./scripts/build_apk.sh [dev|staging|prod|all]"
    exit 1
    ;;
esac

echo "✅ Build complete!"
echo "📍 APK location: build/app/outputs/flutter-apk/"

