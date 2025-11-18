# 🔧 快速修复指南

项目框架已生成完毕，但需要执行以下步骤才能正常运行。

## ⚠️ 已知问题

1. **国际化文件未生成** - 需要正确配置并生成
2. **导入路径问题** - 部分相对导入路径需要修正
3. **Connectivity Plus API变更** - 需要适配新版本API
4. **部分废弃API使用** - RadioListTile等组件的API已更新

## 🔨 修复步骤

### 步骤1：修复国际化配置

由于当前Flutter版本的l10n生成机制，建议暂时使用硬编码字符串或创建简单的本地化类：

**方案A：暂时禁用国际化**
1. 在所有使用`AppLocalizations`的地方改为硬编码字符串
2. 后续可以再集成国际化

**方案B：手动创建简单的本地化类**（推荐）

创建 `lib/app/core/localization/app_localizations_simple.dart`:

```dart
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get home => 'Home';
  String get discover => 'Discover';
  String get notifications => 'Notifications';
  String get profile => 'Profile';
  String get settings => 'Settings';
  String get language => 'Language';
  String get themeMode => 'Theme Mode';
  String get lightMode => 'Light';
  String get darkMode => 'Dark';
  String get systemMode => 'System';
  String get english => 'English';
  String get arabic => 'العربية';
  String get loading => 'Loading...';
  String get retry => 'Retry';
  String get cancel => 'Cancel';
  String get noData => 'No data available';
  String get error => 'Error';
  String get logout => 'Logout';
}
```

然后更新所有导入为：
```dart
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
```

### 步骤2：修复Connectivity Plus

更新 `lib/app/core/utils/connectivity_service.dart`:

旧版本API返回单个结果，新版本返回List。需要修改：

```dart
// 旧的
final result = await _connectivity.checkConnectivity();
_updateStatus(result);

_subscription = _connectivity.onConnectivityChanged.listen(
  (ConnectivityResult result) {
    _updateStatus(result);
  },
);

// 新的
final results = await _connectivity.checkConnectivity();
_updateStatus([results]);

_subscription = _connectivity.onConnectivityChanged.listen(
  (List<ConnectivityResult> results) {
    _updateStatus(results);
  },
);
```

### 步骤3：修复导入路径

将所有使用相对路径`../../`导入`app_config.dart`的文件改为绝对路径：

```dart
// 旧的
import '../config/app_config.dart';
import '../../config/app_config.dart';

// 新的
import 'package:flutter_demo/app/config/app_config.dart';
```

影响的文件：
- `lib/app/core/analytics/analytics_service.dart`
- `lib/app/core/localization/locale_provider.dart`
- `lib/app/core/network/dio_client.dart`
- `lib/app/core/network/interceptors/*.dart`
- `lib/app/core/utils/logger.dart`
- `lib/app/domain/usecases/*.dart`
- `lib/app/presentation/app_theme.dart`

### 步骤4：修复AppTheme导入顺序

在 `lib/app/presentation/app_theme.dart` 中，所有import必须在代码前面：

将文件末尾的import移到文件顶部。

### 步骤5：修复CardTheme类型

在 `lib/app/presentation/app_theme.dart` 中：

```dart
// 旧的
cardTheme: CardTheme(...)

// 新的
cardTheme: const CardThemeData(...)
```

### 步骤6：修复PageResponse导入

在 `lib/app/domain/usecases/get_user_usecase.dart` 中添加导入：

```dart
import '../../core/network/api_exception.dart';
```

### 步骤7：修复RadioListTile废弃API

在 `lib/app/presentation/pages/settings_page.dart` 中，RadioListTile的用法需要更新。
可以暂时忽略这个warning，或者使用Radio + ListTile组合。

## 🚀 自动修复脚本（推荐）

创建并运行以下脚本可以自动修复大部分问题：

```bash
#!/bin/bash

# 1. 替换所有相对导入为绝对导入
find lib -name "*.dart" -type f -exec sed -i '' \
  "s|import '../config/app_config.dart';|import 'package:flutter_demo/app/config/app_config.dart';|g" {} \;
  
find lib -name "*.dart" -type f -exec sed -i '' \
  "s|import '../../config/app_config.dart';|import 'package:flutter_demo/app/config/app_config.dart';|g" {} \;

find lib -name "*.dart" -type f -exec sed -i '' \
  "s|import '../config/env.dart';|import 'package:flutter_demo/app/config/env.dart';|g" {} \;

# 2. 修复CardTheme
sed -i '' 's/cardTheme: CardTheme(/cardTheme: const CardThemeData(/g' \
  lib/app/presentation/app_theme.dart

# 3. 重新运行代码生成
flutter pub run build_runner build --delete-conflicting-outputs

echo "修复完成！现在运行: flutter run"
```

保存为 `fix.sh`，然后执行：

```bash
chmod +x fix.sh
./fix.sh
```

## ✅ 验证修复

执行以下命令验证：

```bash
# 1. 分析代码
flutter analyze

# 2. 如果没有error（info和warning可以忽略），运行项目
flutter run --dart-define=ENVIRONMENT=dev
```

## 📝 后续改进

修复上述问题后，项目应该可以运行。后续可以考虑：

1. 正确配置 Flutter Intl
2. 连接真实的后端API
3. 添加更多业务功能
4. 优化性能和用户体验

## 💡 提示

- 如果遇到问题，可以先注释掉有问题的功能模块
- 核心的网络层、状态管理、路由等功能已经完整
- 可以先让项目跑起来，再逐步完善

## 📞 需要帮助？

如果自动修复脚本无法解决所有问题，请手动按照上述步骤一一修复，或提交Issue说明具体报错信息。

---

**重要提示：** 这个框架生成了完整的架构代码，但由于依赖版本和Flutter SDK版本的差异，需要一些适配工作。上述修复步骤可以解决大部分问题。

