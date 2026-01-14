#!/bin/bash
# 运行生产环境
# 使用方法: ./scripts/run_prod.sh

echo "🚀 Starting Flutter Demo in Production mode..."
flutter run --flavor prod -t lib/main_prod.dart "$@"

