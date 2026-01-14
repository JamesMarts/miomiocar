#!/bin/bash
# 构建 iOS
# 使用方法: ./scripts/build_ios.sh [dev|staging|prod]

FLAVOR=${1:-prod}

echo "📦 Building iOS for $FLAVOR..."

case $FLAVOR in
  dev)
    flutter build ios --flavor dev -t lib/main_dev.dart --no-codesign
    ;;
  staging)
    flutter build ios --flavor staging -t lib/main_staging.dart --no-codesign
    ;;
  prod)
    flutter build ios --flavor prod -t lib/main_prod.dart --release --no-codesign
    ;;
  *)
    echo "Unknown flavor: $FLAVOR"
    echo "Usage: ./scripts/build_ios.sh [dev|staging|prod]"
    exit 1
    ;;
esac

echo "✅ Build complete!"

