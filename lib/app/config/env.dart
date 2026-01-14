import 'package:flutter_demo/app/config/flavor_config.dart';

/// 环境类型枚举
/// @deprecated 请使用 [Flavor] 代替
@Deprecated('Use Flavor from flavor_config.dart instead')
enum Environment {
  /// 开发环境
  dev,

  /// 测试环境
  staging,

  /// 生产环境
  production,
}

/// 环境配置类
/// 提供对 FlavorConfig 的兼容访问
/// @deprecated 请使用 [FlavorConfig] 代替
@Deprecated('Use FlavorConfig instead')
class Env {
  /// 获取当前环境
  @Deprecated('Use FlavorConfig.flavor instead')
  static Environment get currentEnvironment {
    switch (FlavorConfig.flavor) {
      case Flavor.dev:
        return Environment.dev;
      case Flavor.staging:
        return Environment.staging;
      case Flavor.prod:
        return Environment.production;
    }
  }

  /// 初始化环境
  /// @deprecated 环境通过 FlavorConfig 在 main_xxx.dart 中初始化
  @Deprecated('Environment is now initialized via FlavorConfig in main entry files')
  static void init() {
    // 不再需要，保留空方法以兼容旧代码
  }

  /// 判断是否为开发环境
  static bool get isDev => FlavorConfig.isDev;

  /// 判断是否为测试环境
  static bool get isStaging => FlavorConfig.isStaging;

  /// 判断是否为生产环境
  static bool get isProduction => FlavorConfig.isProd;

  /// 获取环境名称
  static String get environmentName => FlavorConfig.name;

  /// 获取API基础URL
  static String get apiBaseUrl => FlavorConfig.values.apiBaseUrl;

  /// 获取WebSocket URL
  static String get websocketUrl => FlavorConfig.values.websocketUrl ?? '';

  /// 是否启用日志
  static bool get enableLogging => FlavorConfig.values.enableLogging;

  /// 是否启用调试模式
  static bool get enableDebugMode => FlavorConfig.values.enableDebugMode;

  /// API超时时间（毫秒）
  static int get connectTimeout => FlavorConfig.values.connectTimeout;

  /// 接收超时时间（毫秒）
  static int get receiveTimeout => FlavorConfig.values.receiveTimeout;
}
