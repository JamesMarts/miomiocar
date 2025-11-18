import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/main_page.dart';
import 'pages/settings_page.dart';
import 'pages/user_detail_page.dart';

/// 路由配置
/// 使用GoRouter进行路由管理
class AppRouter {
  AppRouter._();

  /// 路由路径常量
  static const String home = '/';
  static const String settings = '/settings';
  static const String userDetail = '/user/:id';

  /// 创建路由配置
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: home,
      debugLogDiagnostics: true,
      routes: [
        /// 主页（包含4个Tab）
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const MainPage(),
        ),

        /// 设置页
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),

        /// 用户详情页
        GoRoute(
          path: userDetail,
          name: 'userDetail',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return UserDetailPage(userId: int.parse(id ?? '0'));
          },
        ),
      ],

      /// 错误页面
      errorBuilder: (context, state) => Scaffold(
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
                onPressed: () => context.go(home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),

      /// 路由重定向（示例：权限检查）
      redirect: (context, state) {
        // 可以在这里添加登录态检查等逻辑
        // final isLoggedIn = ...;
        // if (!isLoggedIn && state.uri.path != '/login') {
        //   return '/login';
        // }
        return null;
      },
    );
  }
}

/// 路由扩展方法
extension AppRouterExtension on BuildContext {
  /// 导航到设置页
  void goToSettings() => go(AppRouter.settings);

  /// 导航到用户详情页
  void goToUserDetail(int userId) => go('/user/$userId');

  /// 返回上一页
  void goBack() => pop();
}

