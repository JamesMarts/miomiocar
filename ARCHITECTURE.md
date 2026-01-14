# 项目架构说明

## 📁 最终目录结构（Feature-based 架构）

```
lib/
├── app/
│   ├── config/                    # 配置层
│   │   ├── app_config.dart        # 应用配置
│   │   └── env.dart               # 环境配置
│   │
│   ├── core/                      # 核心层（公共基础设施）
│   │   ├── analytics/             # 埋点服务
│   │   ├── constants/             # 常量定义
│   │   ├── di/                    # 依赖注入
│   │   │   └── injector.dart
│   │   ├── error/                 # 错误处理模块
│   │   │   ├── app_exception.dart # 统一异常类
│   │   │   ├── result.dart        # Result类型
│   │   │   ├── error_handler.dart # 错误处理器
│   │   │   └── index.dart         # 模块导出
│   │   ├── localization/          # 国际化
│   │   ├── network/               # 网络层
│   │   ├── storage/               # 本地存储
│   │   ├── utils/                 # 工具类
│   │   └── widgets/               # 公共组件库
│   │       ├── buttons/           # 按钮组件
│   │       ├── dialogs/           # 对话框组件
│   │       ├── empty/             # 空状态组件
│   │       ├── error/             # 错误组件
│   │       ├── forms/             # 表单组件
│   │       ├── loading/           # 加载组件
│   │       └── index.dart         # 组件导出
│   │
│   ├── features/                  # 功能模块（按业务拆分）
│   │   ├── article/               # 文章模块
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── presentation/
│   │   │   │   ├── providers/
│   │   │   │   └── widgets/
│   │   │   └── article.dart       # 模块导出
│   │   │
│   │   ├── home/                  # 首页模块
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   └── tabs/
│   │   │   └── home.dart          # 模块导出
│   │   │
│   │   ├── settings/              # 设置模块
│   │   │   ├── presentation/
│   │   │   │   └── pages/
│   │   │   └── settings.dart      # 模块导出
│   │   │
│   │   └── user/                  # 用户模块
│   │       ├── data/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   └── usecases/
│   │       ├── presentation/
│   │       │   ├── pages/
│   │       │   ├── providers/
│   │       │   └── widgets/
│   │       └── user.dart          # 模块导出
│   │
│   ├── router/                    # 路由层（独立）
│   │   ├── app_router.dart        # 路由配置
│   │   ├── routes.dart            # 路由常量
│   │   ├── route_guards.dart      # 路由守卫
│   │   └── index.dart             # 路由导出
│   │
│   ├── shared/                    # 共享层
│   │   ├── models/                # 共享模型
│   │   │   └── page_response.dart # 分页响应
│   │   └── index.dart             # 共享导出
│   │
│   └── theme/                     # 主题层（独立）
│       ├── app_theme.dart         # 主题配置
│       └── index.dart             # 主题导出
│
└── main.dart
```

## 🎯 核心优化内容

### 1. Result 类型（统一结果处理）

```dart
import 'package:flutter_demo/app/core/error/index.dart';

// 使用 Result 类型处理异步操作
Future<Result<UserModel>> getUser() async {
  return Result.fromAsync(() async {
    final data = await _client.get(...);
    return UserModel.fromJson(data);
  });
}

// 处理结果
final result = await getUser();
result.when(
  success: (user) => print('用户: ${user.name}'),
  failure: (error) => print('错误: ${error.message}'),
);

// 链式操作
final name = result
    .map((user) => user.name)
    .getOrElse('未知用户');
```

### 2. 统一异常类型

```dart
// 网络异常
NetworkException.noInternet()
NetworkException.connectTimeout()
NetworkException.response(statusCode: 404)

// 业务异常
BusinessException.fromResponse(code: -1001, message: 'Token过期')

// 验证异常
ValidationException.required('email')
ValidationException.invalidFormat('email', 'example@domain.com')

// 缓存异常
CacheException.notFound('user_key')
CacheException.expired('token')
```

### 3. Feature 模块化

每个功能模块独立包含完整的分层结构：

```dart
// 导入整个模块
import 'package:flutter_demo/app/features/user/user.dart';

// 或单独导入
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';
import 'package:flutter_demo/app/features/user/presentation/providers/user_providers.dart';
```

### 4. 路由守卫

```dart
// 认证守卫 - 自动检查登录状态
class AuthGuard extends RouteGuard {
  @override
  String? check(BuildContext context, GoRouterState state) {
    if (!storage.isLoggedIn && isProtectedRoute) {
      return '/auth/login?redirect=${state.uri.path}';
    }
    return null;
  }
}

// 角色守卫
final adminGuard = RoleGuard.admin();
final vipGuard = RoleGuard.vip();

// 组合守卫
final compositeGuard = CompositeGuard([
  AuthGuard(),
  RoleGuard.admin(),
]);
```

### 5. 公共组件库

```dart
import 'package:flutter_demo/app/core/widgets/index.dart';

// 加载组件
AppLoadingWidget(message: '加载中...')
LoadingOverlay(child: content, isLoading: true)

// 错误组件
AppErrorWidget(message: '加载失败', onRetry: refresh)
AppErrorWidget.network(onRetry: refresh)
InlineErrorWidget(message: '错误')

// 空状态组件
AppEmptyWidget.noData(onRefresh: refresh)
AppEmptyWidget.noSearchResult(keyword: 'test')

// 按钮组件
AppButton.primary(text: '确认', onPressed: submit)
AppButton.danger(text: '删除', isLoading: loading)

// 对话框
await AppDialog.confirm(context, title: '确认', message: '是否删除？')
await AppDialog.input(context, title: '输入', hint: '请输入内容')

// 表单
AppTextField.email(controller: emailController)
AppTextField.password(controller: passwordController)
AppTextField.search(onChanged: search)
```

## 📝 迁移指南

### 从旧架构迁移到新架构

1. **导入路径更新**

```dart
// 旧
import 'package:flutter_demo/app/data/repositories/user_repository.dart';

// 新
import 'package:flutter_demo/app/features/user/user.dart';
// 或
import 'package:flutter_demo/app/features/user/data/repositories/user_repository.dart';
```

2. **使用 Result 类型**

```dart
// 旧（直接抛异常）
try {
  final users = await repository.getUsers();
} catch (e) {
  // 处理错误
}

// 新（Result类型）
final result = await repository.getUsers();
result.when(
  success: (users) => // 处理成功,
  failure: (error) => // 处理失败,
);
```

3. **路由迁移**

```dart
// 旧
context.go('/user/123');

// 新（推荐使用路由常量）
import 'package:flutter_demo/app/router/index.dart';

context.go(Routes.userDetailPath(123));
// 或使用扩展方法
context.goToUserDetail(123);
```

## 🚀 后续优化建议

1. **添加缓存层** - 使用 Drift 或 Hive 实现本地数据缓存
2. **添加 Flavor** - 区分开发/测试/生产环境的构建
3. **完善测试** - 为每个模块添加单元测试和集成测试
4. **性能监控** - 集成 Firebase Performance 或自定义监控
5. **重构其他模块** - 将 Article、Auth 等模块迁移到 features 目录

## 📦 命令参考

```bash
# 代码生成（Model序列化）
flutter pub run build_runner build --delete-conflicting-outputs

# 代码分析
flutter analyze

# 运行项目
flutter run

# 构建发布版本
flutter build apk --release
```

