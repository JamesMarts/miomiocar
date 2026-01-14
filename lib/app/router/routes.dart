/// 路由路径常量
/// 统一管理所有路由路径
class Routes {
  Routes._();

  // ============ 根路由 ============

  /// 首页
  static const String home = '/';

  /// 启动页
  static const String splash = '/splash';

  /// 引导页
  static const String onboarding = '/onboarding';

  // ============ 认证路由 ============

  /// 登录页
  static const String login = '/auth/login';

  /// 注册页
  static const String register = '/auth/register';

  /// 忘记密码页
  static const String forgotPassword = '/auth/forgot-password';

  /// 重置密码页
  static const String resetPassword = '/auth/reset-password';

  // ============ 用户路由 ============

  /// 用户列表
  static const String userList = '/users';

  /// 用户详情
  static const String userDetail = '/user/:id';

  /// 用户编辑
  static const String userEdit = '/user/:id/edit';

  /// 当前用户资料
  static const String profile = '/profile';

  /// 编辑资料
  static const String profileEdit = '/profile/edit';

  // ============ 文章路由 ============

  /// 文章列表
  static const String articleList = '/articles';

  /// 文章详情
  static const String articleDetail = '/article/:id';

  /// 创建文章
  static const String articleCreate = '/article/create';

  /// 编辑文章
  static const String articleEdit = '/article/:id/edit';

  // ============ 设置路由 ============

  /// 设置页
  static const String settings = '/settings';

  /// 账号安全
  static const String accountSecurity = '/settings/security';

  /// 通知设置
  static const String notificationSettings = '/settings/notifications';

  /// 隐私设置
  static const String privacySettings = '/settings/privacy';

  /// 关于
  static const String about = '/settings/about';

  // ============ 其他路由 ============

  /// 搜索页
  static const String search = '/search';

  /// 消息列表
  static const String messages = '/messages';

  /// 聊天详情
  static const String chat = '/messages/:id';

  /// 收藏列表
  static const String favorites = '/favorites';

  /// 通知列表
  static const String notifications = '/notifications';

  /// 未授权页
  static const String unauthorized = '/unauthorized';

  /// 404页面
  static const String notFound = '/404';

  // ============ 动态路由构建方法 ============

  /// 构建用户详情路由
  static String userDetailPath(int userId) => '/user/$userId';

  /// 构建用户编辑路由
  static String userEditPath(int userId) => '/user/$userId/edit';

  /// 构建文章详情路由
  static String articleDetailPath(int articleId) => '/article/$articleId';

  /// 构建文章编辑路由
  static String articleEditPath(int articleId) => '/article/$articleId/edit';

  /// 构建聊天路由
  static String chatPath(String conversationId) => '/messages/$conversationId';

  /// 构建带重定向的登录路由
  static String loginWithRedirect(String redirectPath) {
    final encodedPath = Uri.encodeComponent(redirectPath);
    return '$login?redirect=$encodedPath';
  }
}

/// 路由名称常量
/// 用于命名路由导航
class RouteNames {
  RouteNames._();

  static const String home = 'home';
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';

  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';

  static const String userList = 'userList';
  static const String userDetail = 'userDetail';
  static const String userEdit = 'userEdit';
  static const String profile = 'profile';
  static const String profileEdit = 'profileEdit';

  static const String articleList = 'articleList';
  static const String articleDetail = 'articleDetail';
  static const String articleCreate = 'articleCreate';
  static const String articleEdit = 'articleEdit';

  static const String settings = 'settings';
  static const String accountSecurity = 'accountSecurity';
  static const String notificationSettings = 'notificationSettings';
  static const String privacySettings = 'privacySettings';
  static const String about = 'about';

  static const String search = 'search';
  static const String messages = 'messages';
  static const String chat = 'chat';
  static const String favorites = 'favorites';
  static const String notifications = 'notifications';

  static const String unauthorized = 'unauthorized';
  static const String notFound = 'notFound';
}

