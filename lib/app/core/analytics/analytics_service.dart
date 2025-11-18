import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/config/app_config.dart';

/// 埋点事件类型
enum AnalyticsEventType {
  /// 页面浏览
  pageView,
  
  /// 按钮点击
  buttonClick,
  
  /// API调用
  apiCall,
  
  /// 错误事件
  error,
  
  /// 登录
  login,
  
  /// 登出
  logout,
  
  /// 注册
  register,
  
  /// 搜索
  search,
  
  /// 分享
  share,
  
  /// 自定义事件
  custom,
}

/// 埋点服务
/// 统一管理所有埋点上报，支持多平台扩展
abstract class AnalyticsService {
  /// 初始化埋点服务
  Future<void> init();
  
  /// 记录事件
  /// [eventType] 事件类型
  /// [eventName] 事件名称
  /// [parameters] 事件参数
  Future<void> logEvent({
    required AnalyticsEventType eventType,
    required String eventName,
    Map<String, dynamic>? parameters,
  });
  
  /// 记录页面浏览
  /// [pageName] 页面名称
  /// [parameters] 页面参数
  Future<void> logPageView({
    required String pageName,
    Map<String, dynamic>? parameters,
  });
  
  /// 记录按钮点击
  /// [buttonName] 按钮名称
  /// [parameters] 点击参数
  Future<void> logButtonClick({
    required String buttonName,
    Map<String, dynamic>? parameters,
  });
  
  /// 记录错误
  /// [error] 错误对象
  /// [stackTrace] 堆栈跟踪
  /// [fatal] 是否为致命错误
  Future<void> logError({
    required dynamic error,
    StackTrace? stackTrace,
    bool fatal = false,
  });
  
  /// 设置用户ID
  /// [userId] 用户ID
  Future<void> setUserId(String? userId);
  
  /// 设置用户属性
  /// [properties] 用户属性
  Future<void> setUserProperties(Map<String, dynamic> properties);
  
  /// 清除用户信息
  Future<void> clearUser();
}

/// 默认埋点服务实现
/// 可以集成Firebase、Sentry、友盟等第三方平台
class DefaultAnalyticsService implements AnalyticsService {
  /// 是否已初始化
  bool _isInitialized = false;
  
  /// 当前用户ID
  String? _currentUserId;

  @override
  Future<void> init() async {
    if (_isInitialized) return;
    
    if (!AppConfig.analytics.enabled) {
      debugPrint('📊 Analytics is disabled');
      return;
    }
    
    try {
      // TODO: 在这里初始化第三方埋点SDK
      // 例如：
      // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      // await SentryFlutter.init(...);
      
      _isInitialized = true;
      debugPrint('📊 Analytics initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize analytics: $e');
    }
  }

  @override
  Future<void> logEvent({
    required AnalyticsEventType eventType,
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_shouldLog()) return;
    
    try {
      final eventParams = {
        'event_type': eventType.name,
        'timestamp': DateTime.now().toIso8601String(),
        if (_currentUserId != null) 'user_id': _currentUserId,
        ...?parameters,
      };
      
      // TODO: 上报到第三方平台
      // 例如：
      // await FirebaseAnalytics.instance.logEvent(
      //   name: eventName,
      //   parameters: eventParams,
      // );
      
      debugPrint('📊 Event logged: $eventName, params: $eventParams');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }

  @override
  Future<void> logPageView({
    required String pageName,
    Map<String, dynamic>? parameters,
  }) async {
    return logEvent(
      eventType: AnalyticsEventType.pageView,
      eventName: 'page_view',
      parameters: {
        'page_name': pageName,
        ...?parameters,
      },
    );
  }

  @override
  Future<void> logButtonClick({
    required String buttonName,
    Map<String, dynamic>? parameters,
  }) async {
    return logEvent(
      eventType: AnalyticsEventType.buttonClick,
      eventName: 'button_click',
      parameters: {
        'button_name': buttonName,
        ...?parameters,
      },
    );
  }

  @override
  Future<void> logError({
    required dynamic error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) async {
    if (!AppConfig.analytics.enableCrashReport) return;
    
    try {
      // TODO: 上报错误到崩溃监控平台
      // 例如：
      // await Sentry.captureException(
      //   error,
      //   stackTrace: stackTrace,
      // );
      
      debugPrint('📊 Error logged: $error');
      if (stackTrace != null) {
        debugPrint('   Stack trace: $stackTrace');
      }
    } catch (e) {
      debugPrint('❌ Failed to log error: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!_shouldLog()) return;
    
    try {
      _currentUserId = userId;
      
      // TODO: 设置用户ID到第三方平台
      // 例如：
      // await FirebaseAnalytics.instance.setUserId(id: userId);
      
      debugPrint('📊 User ID set: $userId');
    } catch (e) {
      debugPrint('❌ Failed to set user ID: $e');
    }
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    if (!_shouldLog()) return;
    
    try {
      // TODO: 设置用户属性到第三方平台
      // 例如：
      // for (final entry in properties.entries) {
      //   await FirebaseAnalytics.instance.setUserProperty(
      //     name: entry.key,
      //     value: entry.value?.toString(),
      //   );
      // }
      
      debugPrint('📊 User properties set: $properties');
    } catch (e) {
      debugPrint('❌ Failed to set user properties: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    if (!_shouldLog()) return;
    
    try {
      _currentUserId = null;
      
      // TODO: 清除第三方平台的用户信息
      // 例如：
      // await FirebaseAnalytics.instance.setUserId(id: null);
      
      debugPrint('📊 User cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear user: $e');
    }
  }
  
  /// 判断是否应该记录埋点
  bool _shouldLog() {
    if (!_isInitialized) {
      debugPrint('⚠️ Analytics not initialized');
      return false;
    }
    
    if (!AppConfig.analytics.enabled) {
      return false;
    }
    
    return true;
  }
}

/// 埋点辅助类
/// 提供便捷的埋点方法
class AnalyticsHelper {
  AnalyticsHelper._();
  
  /// 记录页面进入
  static Future<void> trackPageEnter(String pageName) async {
    // 在DI中获取AnalyticsService实例并调用
    // final analytics = getIt<AnalyticsService>();
    // await analytics.logPageView(pageName: pageName);
    debugPrint('📊 Page entered: $pageName');
  }
  
  /// 记录页面退出
  static Future<void> trackPageExit(String pageName) async {
    debugPrint('📊 Page exited: $pageName');
  }
  
  /// 记录登录成功
  static Future<void> trackLoginSuccess(String method) async {
    debugPrint('📊 Login success: $method');
  }
  
  /// 记录登出
  static Future<void> trackLogout() async {
    debugPrint('📊 User logged out');
  }
  
  /// 记录搜索
  static Future<void> trackSearch(String keyword) async {
    debugPrint('📊 Search: $keyword');
  }
}

