# Flutter Demo - 全栈基础框架

一个完整的、工程化的Flutter项目框架，包含国际化、网络请求、状态管理、埋点、依赖注入等完整功能。

## ✨ 特性

- ✅ **国际化支持** - 内置英语和阿拉伯语，可轻松扩展
- ✅ **多环境配置** - 支持开发、测试、生产环境切换
- ✅ **网络层封装** - 基于Dio的完整网络请求封装，包含拦截器
- ✅ **状态管理** - 使用Riverpod进行状态管理
- ✅ **依赖注入** - 使用GetIt进行依赖注入
- ✅ **路由管理** - 使用GoRouter进行声明式路由
- ✅ **主题支持** - Material 3主题，支持明暗模式切换
- ✅ **埋点分析** - 可扩展的埋点服务接口
- ✅ **网络监听** - 实时监听网络状态变化
- ✅ **完整示例** - 包含用户管理的完整CRUD示例

## 📁 项目结构

```
lib/
├── app/
│   ├── config/                  # 配置文件
│   │   ├── env.dart            # 环境管理
│   │   └── app_config.dart     # 应用配置
│   ├── core/                    # 核心模块
│   │   ├── network/            # 网络层
│   │   │   ├── dio_client.dart
│   │   │   ├── api_exception.dart
│   │   │   └── interceptors/   # 拦截器
│   │   ├── localization/       # 国际化
│   │   │   ├── arb/           # 语言文件
│   │   │   └── locale_provider.dart
│   │   ├── analytics/          # 埋点服务
│   │   ├── di/                 # 依赖注入
│   │   └── utils/              # 工具类
│   ├── data/                    # 数据层
│   │   ├── models/             # 数据模型
│   │   └── repositories/       # 仓库层
│   ├── domain/                  # 领域层
│   │   ├── entities/           # 领域实体
│   │   └── usecases/           # 业务用例
│   └── presentation/            # 表现层
│       ├── pages/              # 页面
│       ├── widgets/            # 组件
│       ├── states/             # 状态管理
│       ├── app_router.dart     # 路由配置
│       └── app_theme.dart      # 主题配置
└── main.dart                    # 入口文件
```

## 🚀 快速开始

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 生成代码

```bash
# 生成国际化文件
flutter gen-l10n

# 生成JSON序列化代码和Mock类
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 运行项目

```bash
# 开发环境
flutter run --dart-define=ENVIRONMENT=dev

# 测试环境
flutter run --dart-define=ENVIRONMENT=staging

# 生产环境
flutter run --dart-define=ENVIRONMENT=production
```

## 🌐 多环境配置

项目支持三种环境：

- **dev** - 开发环境
- **staging** - 测试环境
- **production** - 生产环境

通过 `--dart-define` 参数指定环境：

```bash
flutter run --dart-define=ENVIRONMENT=production
flutter build apk --dart-define=ENVIRONMENT=production
```

环境配置文件位于 `lib/app/config/env.dart`，可以配置不同环境的API地址等。

## 🌍 国际化

项目内置英语和阿拉伯语支持，可以通过设置页面切换语言。

### 添加新语言

1. 在 `lib/app/core/localization/arb/` 目录下创建新的 `.arb` 文件，例如 `app_zh.arb`
2. 在 `lib/app/core/localization/locale_provider.dart` 中添加新的 Locale
3. 运行 `flutter gen-l10n` 生成代码

## 📡 网络请求

### API端点管理

所有API地址统一在 `lib/app/core/network/api_endpoints.dart` 中管理：

```dart
class ApiEndpoints {
  // 静态端点
  static const String login = '/auth/login';
  static const String userList = '/users';
  
  // 动态端点（带参数）
  static String userDetail(int userId) => '/users/$userId';
}
```

### 基本使用

```dart
import 'package:flutter_demo/app/core/network/api_endpoints.dart';

// 注入DioClient
final dioClient = getIt<DioClient>();

// GET请求 - 使用统一管理的端点
final data = await dioClient.get<Map<String, dynamic>>(
  ApiEndpoints.userList,
  fromJson: (json) => json as Map<String, dynamic>,
);

// POST请求 - 使用统一管理的端点
final data = await dioClient.post<Map<String, dynamic>>(
  ApiEndpoints.login,
  data: {'username': 'user', 'password': 'pass'},
  fromJson: (json) => json as Map<String, dynamic>,
);

// 带参数的端点
final data = await dioClient.get<Map<String, dynamic>>(
  ApiEndpoints.userDetail(123),
  fromJson: (json) => json as Map<String, dynamic>,
);
```

### 添加新的API端点

1. 在 `api_endpoints.dart` 中添加端点定义
2. 在 Repository 中使用 `ApiEndpoints.xxx`

### 标准响应格式

后端API应返回以下格式：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

其中 `code` 为 0 表示成功，其他值表示业务错误。

## 🎨 主题

项目使用Material 3设计，支持明暗主题自动切换。

在 `lib/app/presentation/app_theme.dart` 中可以自定义主题配置。

## 🧪 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/user_repository_test.dart

# 生成测试覆盖率
flutter test --coverage
```

## 📦 主要依赖

| 依赖 | 版本 | 用途 |
|------|------|------|
| dio | ^5.4.0 | 网络请求 |
| flutter_riverpod | ^2.4.9 | 状态管理 |
| get_it | ^7.6.4 | 依赖注入 |
| go_router | ^13.0.0 | 路由管理 |
| shared_preferences | ^2.2.2 | 本地存储 |
| connectivity_plus | ^5.0.2 | 网络状态监听 |
| json_annotation | ^4.8.1 | JSON序列化 |
| logger | ^2.0.2 | 日志工具 |

## 📝 代码生成

项目使用以下代码生成工具：

- **json_serializable** - JSON序列化
- **build_runner** - 代码生成
- **flutter_gen** - 国际化文件生成

生成命令：

```bash
# 一次性生成
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式（开发时推荐）
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 🔧 自定义配置

### 修改API地址

编辑 `lib/app/config/env.dart`，修改不同环境的 `apiBaseUrl`：

```dart
static String get apiBaseUrl {
  switch (_currentEnvironment) {
    case Environment.dev:
      return 'https://your-dev-api.com';
    case Environment.staging:
      return 'https://your-staging-api.com';
    case Environment.production:
      return 'https://your-api.com';
  }
}
```

### 添加新的Repository

1. 在 `lib/app/data/repositories/` 创建新的Repository类
2. 在 `lib/app/core/di/injector.dart` 中注册
3. 通过 `getIt<YourRepository>()` 使用

### 添加新的页面

1. 在 `lib/app/presentation/pages/` 创建页面
2. 在 `lib/app/presentation/app_router.dart` 中添加路由
3. 使用 `context.go('/your-route')` 导航

## 📱 应用截图

主页面包含4个Tab：

- **Home** - 用户列表，支持下拉刷新和无限滚动
- **Discover** - 探索页面（示例）
- **Notifications** - 通知页面（示例）
- **Profile** - 个人中心，包含设置入口

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License

## 📮 联系方式

如有问题，请提交Issue或联系维护者。

---

**注意事项：**

1. 首次运行前请确保执行 `flutter pub get` 和代码生成命令
2. 如果遇到编译错误，请检查是否已生成必要的代码文件（.g.dart）
3. 网络请求需要配置真实的API地址才能正常使用
4. 示例数据仅供参考，实际使用时请替换为真实业务逻辑
