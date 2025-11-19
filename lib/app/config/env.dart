/// 环境类型枚举
enum Environment {
  /// 开发环境
  dev,
  
  /// 测试环境
  staging,
  
  /// 生产环境
  production,
}

/// 环境配置类
/// 负责管理不同环境的配置信息
class Env {
  /// 当前环境
  static Environment _currentEnvironment = Environment.dev;

  /// 获取当前环境
  static Environment get currentEnvironment => _currentEnvironment;

  /// 初始化环境
  /// 支持通过 --dart-define 传入环境参数
  /// 例如: flutter run --dart-define=ENVIRONMENT=production
  static void init() {
    const String? envString = String.fromEnvironment('ENVIRONMENT');
    
    switch (envString?.toLowerCase()) {
      case 'production':
      case 'prod':
        _currentEnvironment = Environment.production;
        break;
      case 'staging':
      case 'stg':
        _currentEnvironment = Environment.staging;
        break;
      case 'development':
      case 'dev':
      default:
        _currentEnvironment = Environment.dev;
        break;
    }
  }

  /// 判断是否为开发环境
  static bool get isDev => _currentEnvironment == Environment.dev;

  /// 判断是否为测试环境
  static bool get isStaging => _currentEnvironment == Environment.staging;

  /// 判断是否为生产环境
  static bool get isProduction => _currentEnvironment == Environment.production;

  /// 获取环境名称
  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  /// 获取API基础URL
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'https://www.wanandroid.com';
      case Environment.staging:
        return 'https://www.wanandroid.com';
      case Environment.production:
        return 'https://www.wanandroid.com';
    }
  }

  /// 获取WebSocket URL（示例）
  static String get websocketUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return 'wss://ws-dev.example.com';
      case Environment.staging:
        return 'wss://ws-staging.example.com';
      case Environment.production:
        return 'wss://ws.example.com';
    }
  }

  /// 是否启用日志
  static bool get enableLogging {
    return _currentEnvironment != Environment.production;
  }

  /// 是否启用调试模式
  static bool get enableDebugMode {
    return _currentEnvironment == Environment.dev;
  }

  /// API超时时间（毫秒）
  static int get connectTimeout {
    return _currentEnvironment == Environment.production ? 30000 : 60000;
  }

  /// 接收超时时间（毫秒）
  static int get receiveTimeout {
    return _currentEnvironment == Environment.production ? 30000 : 60000;
  }
}

