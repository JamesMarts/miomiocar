#!/bin/bash
# 运行测试环境
# 使用方法: ./scripts/run_staging.sh

echo "🚀 Starting Flutter Demo in Staging mode..."
flutter run --flavor staging -t lib/main_staging.dart "$@"

