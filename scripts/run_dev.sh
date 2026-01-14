#!/bin/bash
# 运行开发环境
# 使用方法: ./scripts/run_dev.sh

echo "🚀 Starting Flutter Demo in Development mode..."
flutter run --flavor dev -t lib/main_dev.dart "$@"

