import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';

/// 路由守卫基类
abstract class RouteGuard {
  /// 检查是否允许访问
  /// 返回 null 表示允许，返回路径表示重定向
  String? check(BuildContext context, GoRouterState state);
}

/// 认证守卫
/// 检查用户是否已登录
class AuthGuard extends RouteGuard {
  /// 需要登录的路由路径
  /// 注意：/settings 不需要登录，因为它是应用设置（主题、语言等）
  static const Set<String> _protectedRoutes = {
    '/profile',
    '/favorites',
    '/messages',
  };

  /// 认证相关路由（已登录时不能访问）
  static const Set<String> _authRoutes = {
    '/auth/login',
    '/auth/register',
    '/auth/forgot-password',
  };

  @override
  String? check(BuildContext context, GoRouterState state) {
    final storage = getIt<UserStorageManager>();
    final isLoggedIn = storage.isLoggedIn;
    final currentPath = state.uri.path;

    // 检查是否访问受保护路由
    final isProtectedRoute = _protectedRoutes.any((route) => currentPath.startsWith(route));

    // 检查是否访问认证路由
    final isAuthRoute = _authRoutes.any((route) => currentPath.startsWith(route));

    // 未登录访问受保护路由，重定向到登录页
    if (!isLoggedIn && isProtectedRoute) {
      // 保存原始路径，登录后重定向回来
      final redirectPath = Uri.encodeComponent(currentPath);
      return '/auth/login?redirect=$redirectPath';
    }

    // 已登录访问认证路由，重定向到首页
    if (isLoggedIn && isAuthRoute) {
      // 检查是否有重定向参数
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        return Uri.decodeComponent(redirect);
      }
      return '/';
    }

    return null;
  }

  /// 静态方法供路由使用
  static String? redirect(BuildContext context, GoRouterState state) {
    return AuthGuard().check(context, state);
  }
}

/// 角色守卫
/// 检查用户是否有特定角色
class RoleGuard extends RouteGuard {
  /// 需要的角色
  final List<String> requiredRoles;

  /// 无权限时重定向的路径
  final String? unauthorizedRedirect;

  RoleGuard({
    required this.requiredRoles,
    this.unauthorizedRedirect,
  });

  @override
  String? check(BuildContext context, GoRouterState state) {
    final storage = getIt<UserStorageManager>();

    // 首先检查是否登录
    if (!storage.isLoggedIn) {
      return '/auth/login?redirect=${Uri.encodeComponent(state.uri.path)}';
    }

    // 获取用户角色
    final userRoles = storage.getUserRoles();

    // 检查是否有必要的角色
    final hasRequiredRole = requiredRoles.any((role) => userRoles.contains(role));

    if (!hasRequiredRole) {
      return unauthorizedRedirect ?? '/unauthorized';
    }

    return null;
  }

  /// 创建管理员守卫
  factory RoleGuard.admin() {
    return RoleGuard(
      requiredRoles: ['admin', 'super_admin'],
      unauthorizedRedirect: '/unauthorized',
    );
  }

  /// 创建VIP守卫
  factory RoleGuard.vip() {
    return RoleGuard(
      requiredRoles: ['vip', 'premium'],
      unauthorizedRedirect: '/upgrade',
    );
  }
}

/// 功能开关守卫
/// 检查某功能是否启用
class FeatureGuard extends RouteGuard {
  /// 功能名称
  final String featureName;

  /// 功能禁用时重定向的路径
  final String disabledRedirect;

  /// 功能开关检查函数
  final bool Function() isEnabled;

  FeatureGuard({
    required this.featureName,
    required this.isEnabled,
    this.disabledRedirect = '/',
  });

  @override
  String? check(BuildContext context, GoRouterState state) {
    if (!isEnabled()) {
      return disabledRedirect;
    }
    return null;
  }
}

/// 组合守卫
/// 组合多个守卫，按顺序检查
class CompositeGuard extends RouteGuard {
  /// 守卫列表
  final List<RouteGuard> guards;

  CompositeGuard(this.guards);

  @override
  String? check(BuildContext context, GoRouterState state) {
    for (final guard in guards) {
      final result = guard.check(context, state);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

/// 路由守卫扩展
extension GoRouterStateExtension on GoRouterState {
  /// 获取重定向参数
  String? get redirectPath => uri.queryParameters['redirect'];

  /// 获取解码后的重定向路径
  String? get decodedRedirectPath {
    final redirect = redirectPath;
    if (redirect != null && redirect.isNotEmpty) {
      return Uri.decodeComponent(redirect);
    }
    return null;
  }
}

/// 守卫路由配置助手
class GuardedRoute {
  /// 创建带守卫的路由
  static GoRoute create({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<RouteGuard>? guards,
    List<RouteBase>? routes,
  }) {
    return GoRoute(
      path: path,
      name: name,
      redirect: guards != null
          ? (context, state) {
              final compositeGuard = CompositeGuard(guards);
              return compositeGuard.check(context, state);
            }
          : null,
      builder: builder,
      routes: routes ?? [],
    );
  }
}

