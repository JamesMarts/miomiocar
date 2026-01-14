import 'package:flutter/foundation.dart';
import 'app_exception.dart';

/// 错误处理器
/// 统一处理应用中的各类错误
class ErrorHandler {
  ErrorHandler._();

  /// 错误回调列表
  static final List<void Function(AppException, StackTrace?)> _errorCallbacks = [];

  /// 添加错误回调
  static void addErrorCallback(void Function(AppException, StackTrace?) callback) {
    _errorCallbacks.add(callback);
  }

  /// 移除错误回调
  static void removeErrorCallback(void Function(AppException, StackTrace?) callback) {
    _errorCallbacks.remove(callback);
  }

  /// 清除所有错误回调
  static void clearErrorCallbacks() {
    _errorCallbacks.clear();
  }

  /// 处理异常
  /// 统一处理并分类异常
  static AppException handle(dynamic error, [StackTrace? stackTrace]) {
    final appException = _convertToAppException(error, stackTrace);

    // 记录日志
    _logError(appException, stackTrace);

    // 通知所有回调
    for (final callback in _errorCallbacks) {
      try {
        callback(appException, stackTrace);
      } catch (e) {
        debugPrint('❌ Error in error callback: $e');
      }
    }

    return appException;
  }

  /// 转换为 AppException
  static AppException _convertToAppException(dynamic error, StackTrace? stackTrace) {
    // 如果已经是 AppException，直接返回
    if (error is AppException) {
      return error;
    }

    // 处理字符串错误
    if (error is String) {
      return UnknownException(
        message: error,
        code: 'STRING_ERROR',
        stackTrace: stackTrace,
      );
    }

    // 处理其他类型
    return UnknownException.from(error, stackTrace);
  }

  /// 记录错误日志
  static void _logError(AppException exception, StackTrace? stackTrace) {
    final emoji = _getEmojiForException(exception);

    debugPrint('$emoji Error: ${exception.message}');
    debugPrint('  Code: ${exception.code}');

    if (exception case NetworkException(statusCode: final status) when status != null) {
      debugPrint('  HTTP Status: $status');
    }

    if (exception case BusinessException(businessCode: final code)) {
      debugPrint('  Business Code: $code');
    }

    if (stackTrace != null) {
      debugPrint('  Stack trace:');
      debugPrint('  ${stackTrace.toString().split('\n').take(5).join('\n  ')}');
    }
  }

  /// 获取错误对应的emoji
  static String _getEmojiForException(AppException exception) {
    return switch (exception) {
      NetworkException(type: NetworkExceptionType.noInternet) => '📶',
      NetworkException(type: NetworkExceptionType.connectTimeout) => '⏱️',
      NetworkException(type: NetworkExceptionType.response) => '🌐',
      NetworkException() => '🔌',
      BusinessException() => '💼',
      CacheException() => '💾',
      ValidationException() => '⚠️',
      UnknownException() => '❓',
    };
  }

  /// 获取用户友好的错误消息
  static String getUserFriendlyMessage(AppException exception) {
    return switch (exception) {
      NetworkException(type: NetworkExceptionType.noInternet) =>
        'Please check your internet connection and try again.',
      NetworkException(type: NetworkExceptionType.connectTimeout) =>
        'Connection timed out. Please try again.',
      NetworkException(type: NetworkExceptionType.sendTimeout) =>
        'Request timed out. Please try again.',
      NetworkException(type: NetworkExceptionType.receiveTimeout) =>
        'Server is taking too long to respond. Please try again.',
      NetworkException(statusCode: 401) =>
        'Your session has expired. Please login again.',
      NetworkException(statusCode: 403) =>
        'You don\'t have permission to perform this action.',
      NetworkException(statusCode: 404) =>
        'The requested resource was not found.',
      NetworkException(statusCode: final status) when status != null && status >= 500 =>
        'Server error. Please try again later.',
      NetworkException() =>
        'Network error. Please check your connection.',
      BusinessException() => exception.message,
      CacheException() =>
        'Failed to load cached data. Please try again.',
      ValidationException(field: final field) when field != null =>
        'Please check the $field field.',
      ValidationException() => exception.message,
      UnknownException() =>
        'An unexpected error occurred. Please try again.',
    };
  }

  /// 判断是否需要重试
  static bool shouldRetry(AppException exception) {
    return switch (exception) {
      NetworkException(type: NetworkExceptionType.connectTimeout) => true,
      NetworkException(type: NetworkExceptionType.sendTimeout) => true,
      NetworkException(type: NetworkExceptionType.receiveTimeout) => true,
      NetworkException(statusCode: final status) when status != null && status >= 500 => true,
      _ => false,
    };
  }

  /// 判断是否需要重新登录
  static bool shouldRelogin(AppException exception) {
    return switch (exception) {
      NetworkException(statusCode: 401) => true,
      BusinessException(businessCode: -1001) => true, // 假设 -1001 是 token 过期
      _ => false,
    };
  }
}

/// 错误处理 Mixin
/// 可以混入到 Widget 或 State 中使用
mixin ErrorHandlerMixin {
  /// 处理错误并显示提示
  void handleError(AppException exception, {
    void Function(String message)? showError,
    void Function()? onRelogin,
  }) {
    final message = ErrorHandler.getUserFriendlyMessage(exception);

    // 显示错误
    showError?.call(message);

    // 需要重新登录
    if (ErrorHandler.shouldRelogin(exception)) {
      onRelogin?.call();
    }
  }
}

