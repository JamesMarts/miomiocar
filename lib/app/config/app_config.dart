import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/config/flavor_config.dart';

/// 应用配置类
/// 统一管理应用级别的配置信息
class AppConfig {
  /// 私有构造函数
  AppConfig._();

  /// 单例实例
  static final AppConfig _instance = AppConfig._();

  /// 获取单例
  static AppConfig get instance => _instance;

  /// 应用名称
  static const String appName = 'Flutter Demo';

  /// 应用包名
  static const String packageName = 'com.example.flutter_demo';

  /// 应用版本
  static const String appVersion = '1.0.0';

  /// 构建号
  static const String buildNumber = '1';

  /// 是否是Debug模式
  static bool get isDebugMode => kDebugMode;

  /// 是否是Release模式
  static bool get isReleaseMode => kReleaseMode;

  /// 是否是Profile模式
  static bool get isProfileMode => kProfileMode;

  /// API配置
  static AppApiConfig get api => AppApiConfig._();

  /// 存储配置
  static AppStorageConfig get storage => AppStorageConfig._();

  /// 埋点配置
  static AppAnalyticsConfig get analytics => AppAnalyticsConfig._();

  /// 分页配置
  static AppPaginationConfig get pagination => AppPaginationConfig._();

  /// 初始化应用配置
  static Future<void> init() async {
    // FlavorConfig 已在 main_xxx.dart 中初始化
    // 这里可以添加其他初始化逻辑
    // 例如：读取本地配置、初始化第三方SDK等
    debugPrint('🚀 App Config Initialized');
    debugPrint('📍 Environment: ${FlavorConfig.name}');
    debugPrint('🌐 API Base URL: ${FlavorConfig.values.apiBaseUrl}');
  }
}

/// API相关配置
class AppApiConfig {
  AppApiConfig._();

  /// API基础URL
  String get baseUrl => FlavorConfig.values.apiBaseUrl;

  /// 连接超时时间
  int get connectTimeout => FlavorConfig.values.connectTimeout;

  /// 接收超时时间
  int get receiveTimeout => FlavorConfig.values.receiveTimeout;

  /// 发送超时时间
  int get sendTimeout => FlavorConfig.values.sendTimeout;

  /// API版本
  String get apiVersion => 'v1';

  /// 是否启用请求日志
  bool get enableRequestLog => FlavorConfig.values.enableLogging;

  /// 是否启用响应日志
  bool get enableResponseLog => FlavorConfig.values.enableLogging;

  /// 是否启用错误日志
  bool get enableErrorLog => true;

  /// 最大重试次数
  int get maxRetries => 3;

  /// 重试延迟（毫秒）
  int get retryDelay => 1000;
}

/// 本地存储配置
class AppStorageConfig {
  AppStorageConfig._();

  /// Token存储key
  String get tokenKey => 'auth_token';

  /// 刷新Token存储key
  String get refreshTokenKey => 'refresh_token';

  /// 用户信息存储key
  String get userInfoKey => 'user_info';

  /// 语言设置存储key
  String get languageKey => 'app_language';

  /// 主题模式存储key
  String get themeModeKey => 'theme_mode';

  /// 是否首次启动存储key
  String get firstLaunchKey => 'is_first_launch';
}

/// 埋点配置
class AppAnalyticsConfig {
  AppAnalyticsConfig._();

  /// 是否启用埋点
  bool get enabled => FlavorConfig.values.enableAnalytics;

  /// 是否启用自动埋点
  bool get autoTrack => FlavorConfig.values.enableAnalytics;

  /// 是否启用崩溃上报
  bool get enableCrashReport => FlavorConfig.values.enableCrashReporting;

  /// 是否启用性能监控
  bool get enablePerformanceMonitoring => FlavorConfig.values.enablePerformanceMonitoring;

  /// Firebase项目ID（示例）
  String get firebaseProjectId => 'flutter-demo-project';

  /// 自定义埋点平台key（示例）
  String get customAnalyticsKey => 'YOUR_ANALYTICS_KEY';
}

/// 分页配置
class AppPaginationConfig {
  AppPaginationConfig._();

  /// 默认每页数量
  int get defaultPageSize => 20;

  /// 最大每页数量
  int get maxPageSize => 100;

  /// 初始页码
  int get initialPage => 1;
}

/// 应用常量
class AppConstants {
  AppConstants._();

  /// 默认头像
  static const String defaultAvatar = 'assets/images/default_avatar.png';

  /// 默认占位图
  static const String defaultPlaceholder = 'assets/images/placeholder.png';

  /// 最小密码长度
  static const int minPasswordLength = 6;

  /// 最大密码长度
  static const int maxPasswordLength = 20;

  /// 验证码长度
  static const int verificationCodeLength = 6;

  /// 验证码倒计时（秒）
  static const int verificationCountdown = 60;
}
