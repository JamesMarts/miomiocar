/// Flavor 类型枚举
/// 用于区分不同的构建环境
enum Flavor {
  /// 开发环境
  dev,

  /// 测试环境
  staging,

  /// 生产环境
  prod,
}

/// Flavor 配置类
/// 存储当前 Flavor 的所有配置信息
class FlavorConfig {
  /// 私有构造函数，防止外部实例化
  FlavorConfig._();

  /// 单例实例
  static FlavorConfig? _instance;

  /// 当前 Flavor
  static Flavor _flavor = Flavor.dev;

  /// Flavor 值映射
  static late FlavorValues _values;

  /// 初始化 Flavor 配置
  /// [flavor] Flavor 类型
  /// [values] Flavor 对应的配置值
  static void init({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _flavor = flavor;
    _values = values;
    _instance = FlavorConfig._();
  }

  /// 获取单例实例
  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig has not been initialized. Call init() first.');
    }
    return _instance!;
  }

  /// 获取当前 Flavor
  static Flavor get flavor => _flavor;

  /// 获取当前 Flavor 配置值
  static FlavorValues get values => _values;

  /// 判断是否为开发环境
  static bool get isDev => _flavor == Flavor.dev;

  /// 判断是否为测试环境
  static bool get isStaging => _flavor == Flavor.staging;

  /// 判断是否为生产环境
  static bool get isProd => _flavor == Flavor.prod;

  /// 获取 Flavor 名称
  static String get name {
    switch (_flavor) {
      case Flavor.dev:
        return 'Development';
      case Flavor.staging:
        return 'Staging';
      case Flavor.prod:
        return 'Production';
    }
  }

  /// 获取 Flavor 简称
  static String get shortName {
    switch (_flavor) {
      case Flavor.dev:
        return 'DEV';
      case Flavor.staging:
        return 'STG';
      case Flavor.prod:
        return 'PROD';
    }
  }

  /// 获取应用名称后缀（用于在设备上区分不同版本）
  static String get appNameSuffix {
    switch (_flavor) {
      case Flavor.dev:
        return ' (Dev)';
      case Flavor.staging:
        return ' (Staging)';
      case Flavor.prod:
        return '';
    }
  }
}

/// Flavor 配置值类
/// 存储特定 Flavor 的所有配置
class FlavorValues {
  /// API 基础 URL
  final String apiBaseUrl;

  /// WebSocket URL
  final String? websocketUrl;

  /// 是否启用日志
  final bool enableLogging;

  /// 是否启用调试模式
  final bool enableDebugMode;

  /// 是否显示调试标识
  final bool showDebugBanner;

  /// 连接超时时间（毫秒）
  final int connectTimeout;

  /// 接收超时时间（毫秒）
  final int receiveTimeout;

  /// 发送超时时间（毫秒）
  final int sendTimeout;

  /// 是否启用性能监控
  final bool enablePerformanceMonitoring;

  /// 是否启用崩溃报告
  final bool enableCrashReporting;

  /// 是否启用分析
  final bool enableAnalytics;

  /// 自定义配置
  final Map<String, dynamic>? customConfig;

  const FlavorValues({
    required this.apiBaseUrl,
    this.websocketUrl,
    this.enableLogging = true,
    this.enableDebugMode = false,
    this.showDebugBanner = false,
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.enablePerformanceMonitoring = false,
    this.enableCrashReporting = false,
    this.enableAnalytics = false,
    this.customConfig,
  });

  /// 开发环境默认配置
  factory FlavorValues.dev() {
    return const FlavorValues(
      apiBaseUrl: 'https://www.wanandroid.com',
      websocketUrl: 'wss://ws-dev.example.com',
      enableLogging: true,
      enableDebugMode: true,
      showDebugBanner: true,
      connectTimeout: 60000,
      receiveTimeout: 60000,
      sendTimeout: 60000,
      enablePerformanceMonitoring: false,
      enableCrashReporting: false,
      enableAnalytics: false,
    );
  }

  /// 测试环境默认配置
  factory FlavorValues.staging() {
    return const FlavorValues(
      apiBaseUrl: 'https://www.wanandroid.com',
      websocketUrl: 'wss://ws-staging.example.com',
      enableLogging: true,
      enableDebugMode: false,
      showDebugBanner: true,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      sendTimeout: 30000,
      enablePerformanceMonitoring: true,
      enableCrashReporting: true,
      enableAnalytics: false,
    );
  }

  /// 生产环境默认配置
  factory FlavorValues.prod() {
    return const FlavorValues(
      apiBaseUrl: 'https://www.wanandroid.com',
      websocketUrl: 'wss://ws.example.com',
      enableLogging: false,
      enableDebugMode: false,
      showDebugBanner: false,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      sendTimeout: 30000,
      enablePerformanceMonitoring: true,
      enableCrashReporting: true,
      enableAnalytics: true,
    );
  }
}

