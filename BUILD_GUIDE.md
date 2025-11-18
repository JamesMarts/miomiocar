# 🏗️ 构建指南

本文档提供详细的项目构建和运行指南。

## 📋 前置要求

- Flutter SDK >= 3.3.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Xcode（用于iOS开发，仅macOS）

## 🚀 初始化项目

### 1. 克隆项目并安装依赖

```bash
# 进入项目目录
cd flutter_demo

# 安装依赖
flutter pub get
```

### 2. 生成必要的代码文件

```bash
# 生成国际化文件
flutter gen-l10n

# 生成JSON序列化代码
flutter pub run build_runner build --delete-conflicting-outputs
```

**注意：** 必须先生成这些文件，否则会出现编译错误！

## 🔨 构建命令

### 开发环境运行

```bash
# 默认使用开发环境
flutter run

# 或显式指定开发环境
flutter run --dart-define=ENVIRONMENT=dev
```

### 测试环境运行

```bash
flutter run --dart-define=ENVIRONMENT=staging
```

### 生产环境运行

```bash
flutter run --dart-define=ENVIRONMENT=production
```

## 📦 打包发布

### Android APK

```bash
# Debug版本
flutter build apk --debug --dart-define=ENVIRONMENT=dev

# Release版本（生产环境）
flutter build apk --release --dart-define=ENVIRONMENT=production

# 生成分包APK（减小单个APK大小）
flutter build apk --split-per-abi --dart-define=ENVIRONMENT=production
```

生成的APK位于：`build/app/outputs/flutter-apk/`

### Android App Bundle (AAB)

```bash
# 用于Google Play上传
flutter build appbundle --release --dart-define=ENVIRONMENT=production
```

生成的AAB位于：`build/app/outputs/bundle/release/`

### iOS

```bash
# 确保在macOS上运行
flutter build ios --release --dart-define=ENVIRONMENT=production

# 或使用Xcode打开项目手动构建
open ios/Runner.xcworkspace
```

## 🧪 测试

### 运行单元测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/user_repository_test.dart

# 生成覆盖率报告
flutter test --coverage
```

### 运行集成测试

```bash
flutter test integration_test
```

## 🔍 代码质量检查

### Lint检查

```bash
# 分析代码
flutter analyze

# 格式化代码
flutter format lib/ test/
```

## 🛠️ 常见问题

### 1. 编译错误：找不到 `app_localizations.dart`

**解决方案：**

```bash
flutter gen-l10n
```

### 2. 编译错误：找不到 `.g.dart` 文件

**解决方案：**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 依赖冲突

**解决方案：**

```bash
# 清除缓存
flutter clean
flutter pub get
```

### 4. iOS构建失败

**解决方案：**

```bash
# 更新Pods
cd ios
pod install --repo-update
cd ..
```

### 5. Gradle构建缓慢

**解决方案：**

在 `android/gradle.properties` 中添加：

```properties
org.gradle.jvmargs=-Xmx2048m
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
```

## 📊 性能优化

### 构建大小优化

```bash
# 移除未使用的资源
flutter build apk --release --split-debug-info=./debug-info --obfuscate

# 查看应用大小分析
flutter build apk --analyze-size
```

### 启动时间优化

1. 使用延迟加载
2. 减少首屏依赖
3. 使用Splash Screen

## 🔄 持续集成

### GitHub Actions示例

创建 `.github/workflows/main.yml`：

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.0'
    
    - run: flutter pub get
    - run: flutter gen-l10n
    - run: flutter pub run build_runner build --delete-conflicting-outputs
    - run: flutter analyze
    - run: flutter test
    - run: flutter build apk --release --dart-define=ENVIRONMENT=production
```

## 📱 设备调试

### 查看连接的设备

```bash
flutter devices
```

### 指定设备运行

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Chrome
flutter run -d chrome
```

### 热重载

- 按 `r` - 热重载
- 按 `R` - 热重启
- 按 `q` - 退出

## 🎯 发布检查清单

在发布前确保：

- [ ] 已更新版本号（pubspec.yaml）
- [ ] 已测试所有环境（dev/staging/production）
- [ ] 已运行所有测试并通过
- [ ] 已进行代码分析（flutter analyze）
- [ ] 已测试不同屏幕尺寸
- [ ] 已测试明暗主题
- [ ] 已测试所有支持的语言
- [ ] 已测试网络异常情况
- [ ] 已移除调试代码和日志
- [ ] 已更新CHANGELOG.md

## 📚 更多资源

- [Flutter官方文档](https://docs.flutter.dev/)
- [Dart官方文档](https://dart.dev/guides)
- [Flutter中文网](https://flutter.cn/)

---

如有任何问题，请查看项目README或提交Issue。

