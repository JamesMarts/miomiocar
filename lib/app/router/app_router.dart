import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/router/routes.dart';
import 'package:flutter_demo/app/router/route_guards.dart';
import 'package:flutter_demo/app/features/home/home.dart';
import 'package:flutter_demo/app/features/settings/settings.dart';
import 'package:flutter_demo/app/features/user/user.dart';
import 'package:flutter_demo/app/features/auth/auth.dart';

/// 应用路由配置
/// 使用GoRouter进行路由管理
class AppRouter {
  AppRouter._();

  /// 全局导航Key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 路由配置
  static GoRouter? _router;

  /// 获取路由实例
  static GoRouter get router => _router ?? createRouter();

  /// 创建路由配置
  static GoRouter createRouter() {
    _router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      routes: _routes,
      errorBuilder: _errorBuilder,
      redirect: _globalRedirect,
    );
    return _router!;
  }

  /// 全局重定向
  static String? _globalRedirect(BuildContext context, GoRouterState state) {
    // 使用认证守卫
    return AuthGuard.redirect(context, state);
  }

  /// 路由配置列表
  static final List<RouteBase> _routes = [
    /// 主页（包含底部导航）
    GoRoute(
      path: Routes.home,
      name: RouteNames.home,
      builder: (context, state) => const MainPage(),
    ),

    /// 登录页
    GoRoute(
      path: Routes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),

    /// 注册页
    GoRoute(
      path: Routes.register,
      name: RouteNames.register,
      builder: (context, state) => const RegisterPage(),
    ),

    /// 设置页
    GoRoute(
      path: Routes.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsPage(),
    ),

    /// 用户列表页
    GoRoute(
      path: Routes.userList,
      name: RouteNames.userList,
      builder: (context, state) => const UserListPage(),
    ),

    /// 用户详情页
    GoRoute(
      path: Routes.userDetail,
      name: RouteNames.userDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return UserDetailPage(userId: int.parse(id ?? '0'));
      },
    ),

    /// 用户编辑页
    GoRoute(
      path: Routes.userEdit,
      name: RouteNames.userEdit,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        // TODO: 返回用户编辑页面
        return Scaffold(
          appBar: AppBar(title: const Text('Edit User')),
          body: Center(child: Text('Edit User $id')),
        );
      },
    ),

    /// 个人资料页
    GoRoute(
      path: Routes.profile,
      name: RouteNames.profile,
      builder: (context, state) {
        // TODO: 返回个人资料页面
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: const Center(child: Text('Profile Page')),
        );
      },
    ),

    /// 搜索页
    GoRoute(
      path: Routes.search,
      name: RouteNames.search,
      builder: (context, state) {
        // TODO: 返回搜索页面
        return Scaffold(
          appBar: AppBar(title: const Text('Search')),
          body: const Center(child: Text('Search Page')),
        );
      },
    ),

    /// 收藏页
    GoRoute(
      path: Routes.favorites,
      name: RouteNames.favorites,
      builder: (context, state) {
        // TODO: 返回收藏页面
        return Scaffold(
          appBar: AppBar(title: const Text('Favorites')),
          body: const Center(child: Text('Favorites Page')),
        );
      },
    ),

    /// 消息列表页
    GoRoute(
      path: Routes.messages,
      name: RouteNames.messages,
      builder: (context, state) {
        // TODO: 返回消息页面
        return Scaffold(
          appBar: AppBar(title: const Text('Messages')),
          body: const Center(child: Text('Messages Page')),
        );
      },
    ),

    /// 通知列表页
    GoRoute(
      path: Routes.notifications,
      name: RouteNames.notifications,
      builder: (context, state) {
        // TODO: 返回通知页面
        return Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: const Center(child: Text('Notifications Page')),
        );
      },
    ),

    /// 未授权页
    GoRoute(
      path: Routes.unauthorized,
      name: RouteNames.unauthorized,
      builder: (context, state) => _buildUnauthorizedPage(context),
    ),
  ];

  /// 错误页面构建器
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// 未授权页面
  static Widget _buildUnauthorizedPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unauthorized'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'You don\'t have permission to access this page',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 路由扩展方法
extension AppRouterExtension on BuildContext {
  /// 导航到设置页
  void goToSettings() => go(Routes.settings);

  /// 导航到用户详情页
  void goToUserDetail(int userId) => go(Routes.userDetailPath(userId));

  /// 导航到用户编辑页
  void goToUserEdit(int userId) => go(Routes.userEditPath(userId));

  /// 导航到用户列表页
  void goToUserList() => go(Routes.userList);

  /// 导航到搜索页
  void goToSearch() => go(Routes.search);

  /// 导航到个人资料页
  void goToProfile() => go(Routes.profile);

  /// 导航到消息页
  void goToMessages() => go(Routes.messages);

  /// 导航到收藏页
  void goToFavorites() => go(Routes.favorites);

  /// 返回上一页
  void goBack() => pop();

  /// 返回首页
  void goHome() => go(Routes.home);

  /// 导航到登录页
  void goToLogin() => go(Routes.login);

  /// 导航到注册页
  void goToRegister() => go(Routes.register);

  /// 带参数Push导航
  void pushWithParams(String path, Map<String, String> params) {
    final uri = Uri(path: path, queryParameters: params);
    push(uri.toString());
  }
}

