# Flutter Flavors 使用指南

本项目使用 Flavors 来区分开发（dev）、测试（staging）和生产（prod）环境。

## 环境说明

| Flavor | 说明 | Application ID | 应用名称 |
|--------|------|----------------|----------|
| dev | 开发环境 | com.example.flutter_demo.dev | Flutter Demo Dev |
| staging | 测试环境 | com.example.flutter_demo.staging | Flutter Demo Staging |
| prod | 生产环境 | com.example.flutter_demo | Flutter Demo |

## 快速开始

### 使用 VS Code

在 VS Code 中，按 `F5` 或点击调试面板，选择对应的配置：

- **Dev (Debug)** - 开发环境调试模式
- **Dev (Profile)** - 开发环境性能分析模式
- **Dev (Release)** - 开发环境发布模式
- **Staging (Debug/Profile/Release)** - 测试环境
- **Prod (Debug/Profile/Release)** - 生产环境

### 使用命令行

#### 运行应用

```bash
# 开发环境
flutter run --flavor dev -t lib/main_dev.dart

# 测试环境
flutter run --flavor staging -t lib/main_staging.dart

# 生产环境
flutter run --flavor prod -t lib/main_prod.dart
```

#### 使用脚本运行

```bash
# 给脚本添加执行权限（首次使用）
chmod +x scripts/*.sh

# 运行开发环境
./scripts/run_dev.sh

# 运行测试环境
./scripts/run_staging.sh

# 运行生产环境
./scripts/run_prod.sh
```

### 构建应用

#### Android APK

```bash
# 构建开发版 APK
flutter build apk --flavor dev -t lib/main_dev.dart

# 构建测试版 APK
flutter build apk --flavor staging -t lib/main_staging.dart

# 构建生产版 APK (Release)
flutter build apk --flavor prod -t lib/main_prod.dart --release

# 使用脚本构建
./scripts/build_apk.sh dev      # 开发版
./scripts/build_apk.sh staging  # 测试版
./scripts/build_apk.sh prod     # 生产版
./scripts/build_apk.sh all      # 全部版本
```

APK 输出位置：`build/app/outputs/flutter-apk/`

#### Android App Bundle

```bash
# 构建生产版 AAB (用于 Google Play)
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
```

#### iOS

```bash
# 构建开发版 (无签名)
flutter build ios --flavor dev -t lib/main_dev.dart --no-codesign

# 构建生产版 (无签名)
flutter build ios --flavor prod -t lib/main_prod.dart --release --no-codesign

# 使用脚本构建
./scripts/build_ios.sh dev
./scripts/build_ios.sh prod
```

## 配置说明

### 文件结构

```
lib/
├── main.dart           # 默认入口（开发环境）
├── main_dev.dart       # 开发环境入口
├── main_staging.dart   # 测试环境入口
├── main_prod.dart      # 生产环境入口
├── main_common.dart    # 通用启动逻辑
└── app/
    └── config/
        ├── flavor_config.dart  # Flavor 配置类
        └── app_config.dart     # 应用配置
```

### Flavor 配置

在 `lib/app/config/flavor_config.dart` 中定义了各环境的配置：

```dart
// 开发环境配置
FlavorValues.dev()
  apiBaseUrl: 'https://www.wanandroid.com'
  enableLogging: true
  enableDebugMode: true
  showDebugBanner: true
  connectTimeout: 60000ms
  enableCrashReporting: false

// 测试环境配置
FlavorValues.staging()
  apiBaseUrl: 'https://www.wanandroid.com'
  enableLogging: true
  enableDebugMode: false
  showDebugBanner: true
  connectTimeout: 30000ms
  enableCrashReporting: true

// 生产环境配置
FlavorValues.prod()
  apiBaseUrl: 'https://www.wanandroid.com'
  enableLogging: false
  enableDebugMode: false
  showDebugBanner: false
  connectTimeout: 30000ms
  enableCrashReporting: true
  enableAnalytics: true
```

### 在代码中使用

```dart
import 'package:flutter_demo/app/config/flavor_config.dart';

// 判断当前环境
if (FlavorConfig.isDev) {
  // 开发环境特有逻辑
}

if (FlavorConfig.isProd) {
  // 生产环境特有逻辑
}

// 获取配置值
final apiUrl = FlavorConfig.values.apiBaseUrl;
final enableLog = FlavorConfig.values.enableLogging;

// 获取环境名称
print('Current: ${FlavorConfig.name}');      // "Development"
print('Short: ${FlavorConfig.shortName}');   // "DEV"
```

## Android 配置

Android Flavors 配置在 `android/app/build.gradle.kts`：

```kotlin
productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix = ".dev"
        resValue("string", "app_name", "Flutter Demo Dev")
    }
    create("staging") {
        dimension = "environment"
        applicationIdSuffix = ".staging"
        resValue("string", "app_name", "Flutter Demo Staging")
    }
    create("prod") {
        dimension = "environment"
        resValue("string", "app_name", "Flutter Demo")
    }
}
```

## iOS 配置

iOS 使用 xcconfig 文件配置，位于 `ios/Flutter/`：

- `Dev.xcconfig` - 开发环境配置
- `Staging.xcconfig` - 测试环境配置
- `Prod.xcconfig` - 生产环境配置

### 创建 Xcode Schemes

1. 在 Xcode 中打开 `ios/Runner.xcworkspace`
2. 选择 **Product > Scheme > Manage Schemes**
3. 复制 Runner scheme 三份，分别命名为：
   - Runner-dev
   - Runner-staging
   - Runner-prod
4. 编辑每个 scheme，在 **Build > Pre-actions** 中添加脚本设置环境变量

或者使用 `flutter run` 时指定 flavor，Flutter 会自动处理。

## 同时安装多个版本

由于每个 flavor 有不同的 Application ID，你可以在同一设备上同时安装：

- Flutter Demo Dev (dev)
- Flutter Demo Staging (staging)
- Flutter Demo (prod)

这在测试不同版本时非常有用。

## 环境标识

非生产环境会在应用右上角显示环境标识横幅：

- 开发环境：绿色 "DEV" 标识
- 测试环境：橙色 "STG" 标识
- 生产环境：无标识

## 自定义配置

如需添加自定义配置项，修改 `FlavorValues` 类：

```dart
class FlavorValues {
  // 添加新的配置项
  final String customApiKey;
  final bool enableNewFeature;
  
  const FlavorValues({
    // ...
    this.customApiKey = '',
    this.enableNewFeature = false,
  });
  
  factory FlavorValues.dev() {
    return const FlavorValues(
      // ...
      customApiKey: 'dev_key_xxx',
      enableNewFeature: true,
    );
  }
}
```

## 常见问题

### Q: 直接运行 `flutter run` 会使用哪个环境？
A: 默认使用开发环境（dev）。`main.dart` 作为默认入口会初始化 dev 配置。

### Q: 如何在 CI/CD 中使用？
A: 在构建命令中指定 `--flavor` 和 `-t` 参数即可：
```bash
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

### Q: 如何添加新的环境？
1. 在 `Flavor` 枚举中添加新值
2. 在 `FlavorValues` 中添加对应的工厂方法
3. 创建新的 `main_xxx.dart` 入口文件
4. 在 Android `build.gradle.kts` 中添加新的 productFlavor
5. 为 iOS 创建新的 xcconfig 文件
6. 更新 VS Code launch.json

### Q: 热重载在 Flavor 模式下正常工作吗？
A: 是的，热重载完全正常工作。

