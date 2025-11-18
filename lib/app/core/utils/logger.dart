import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger_pkg;
import 'package:flutter_demo/app/config/env.dart';

/// 日志工具类
/// 统一管理应用日志输出
class AppLogger {
  /// Logger实例
  static final logger_pkg.Logger _logger = logger_pkg.Logger(
    printer: logger_pkg.PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: _getLogLevel(),
  );

  /// 获取日志级别
  static logger_pkg.Level _getLogLevel() {
    if (kReleaseMode || Env.isProduction) {
      return logger_pkg.Level.error;
    } else if (Env.isStaging) {
      return logger_pkg.Level.warning;
    } else {
      return logger_pkg.Level.debug;
    }
  }

  /// Debug日志
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Env.enableLogging) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Info日志
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (Env.enableLogging) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Warning日志
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error日志
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal日志
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// 打印API请求日志
  static void logApiRequest(String method, String url, [dynamic data]) {
    if (Env.enableLogging) {
      d('API Request: $method $url${data != null ? '\nData: $data' : ''}');
    }
  }

  /// 打印API响应日志
  static void logApiResponse(String url, int statusCode, [dynamic data]) {
    if (Env.enableLogging) {
      d('API Response: $url\nStatus: $statusCode${data != null ? '\nData: $data' : ''}');
    }
  }

  /// 打印API错误日志
  static void logApiError(String url, dynamic error, [StackTrace? stackTrace]) {
    e('API Error: $url\nError: $error', error, stackTrace);
  }
}

