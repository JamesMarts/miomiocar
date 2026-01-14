/// 应用异常基类
/// 统一封装所有应用级别的异常
sealed class AppException implements Exception {
  /// 错误消息
  final String message;

  /// 错误码
  final String? code;

  /// 原始异常
  final dynamic originalException;

  /// 堆栈跟踪
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// 网络异常
/// 包含所有网络相关的错误
class NetworkException extends AppException {
  /// 网络异常类型
  final NetworkExceptionType type;

  /// HTTP状态码
  final int? statusCode;

  const NetworkException({
    required super.message,
    required this.type,
    this.statusCode,
    super.code,
    super.originalException,
    super.stackTrace,
  });

  /// 创建连接超时异常
  factory NetworkException.connectTimeout() {
    return const NetworkException(
      message: 'Connection timeout. Please check your network.',
      type: NetworkExceptionType.connectTimeout,
      code: 'CONNECT_TIMEOUT',
    );
  }

  /// 创建发送超时异常
  factory NetworkException.sendTimeout() {
    return const NetworkException(
      message: 'Send timeout. Please try again.',
      type: NetworkExceptionType.sendTimeout,
      code: 'SEND_TIMEOUT',
    );
  }

  /// 创建接收超时异常
  factory NetworkException.receiveTimeout() {
    return const NetworkException(
      message: 'Receive timeout. Please try again.',
      type: NetworkExceptionType.receiveTimeout,
      code: 'RECEIVE_TIMEOUT',
    );
  }

  /// 创建无网络异常
  factory NetworkException.noInternet() {
    return const NetworkException(
      message: 'No internet connection. Please check your network.',
      type: NetworkExceptionType.noInternet,
      code: 'NO_INTERNET',
    );
  }

  /// 创建请求取消异常
  factory NetworkException.cancelled() {
    return const NetworkException(
      message: 'Request cancelled.',
      type: NetworkExceptionType.cancelled,
      code: 'CANCELLED',
    );
  }

  /// 创建HTTP响应异常
  factory NetworkException.response({
    required int statusCode,
    String? message,
  }) {
    String errorMessage;
    String errorCode;

    switch (statusCode) {
      case 400:
        errorMessage = message ?? 'Bad request.';
        errorCode = 'BAD_REQUEST';
        break;
      case 401:
        errorMessage = message ?? 'Unauthorized. Please login again.';
        errorCode = 'UNAUTHORIZED';
        break;
      case 403:
        errorMessage = message ?? 'Forbidden. You have no permission.';
        errorCode = 'FORBIDDEN';
        break;
      case 404:
        errorMessage = message ?? 'Resource not found.';
        errorCode = 'NOT_FOUND';
        break;
      case 500:
        errorMessage = message ?? 'Internal server error.';
        errorCode = 'SERVER_ERROR';
        break;
      case 502:
        errorMessage = message ?? 'Bad gateway.';
        errorCode = 'BAD_GATEWAY';
        break;
      case 503:
        errorMessage = message ?? 'Service unavailable.';
        errorCode = 'SERVICE_UNAVAILABLE';
        break;
      default:
        errorMessage = message ?? 'Request failed with status $statusCode.';
        errorCode = 'HTTP_$statusCode';
    }

    return NetworkException(
      message: errorMessage,
      type: NetworkExceptionType.response,
      statusCode: statusCode,
      code: errorCode,
    );
  }

  /// 创建未知网络异常
  factory NetworkException.unknown([String? message]) {
    return NetworkException(
      message: message ?? 'Unknown network error occurred.',
      type: NetworkExceptionType.unknown,
      code: 'UNKNOWN_NETWORK',
    );
  }
}

/// 网络异常类型
enum NetworkExceptionType {
  /// 连接超时
  connectTimeout,

  /// 发送超时
  sendTimeout,

  /// 接收超时
  receiveTimeout,

  /// 无网络连接
  noInternet,

  /// 请求取消
  cancelled,

  /// 响应错误
  response,

  /// 未知错误
  unknown,
}

/// 业务异常
/// 后端返回的业务逻辑错误
class BusinessException extends AppException {
  /// 业务错误码
  final int businessCode;

  const BusinessException({
    required super.message,
    required this.businessCode,
    super.code,
    super.originalException,
    super.stackTrace,
  });

  /// 从API响应创建
  factory BusinessException.fromResponse({
    required int code,
    required String message,
  }) {
    return BusinessException(
      message: message,
      businessCode: code,
      code: 'BIZ_$code',
    );
  }

  /// 判断是否为特定业务错误
  bool isCode(int code) => businessCode == code;
}

/// 缓存异常
/// 本地缓存相关错误
class CacheException extends AppException {
  /// 缓存异常类型
  final CacheExceptionType type;

  const CacheException({
    required super.message,
    required this.type,
    super.code,
    super.originalException,
    super.stackTrace,
  });

  /// 缓存未命中
  factory CacheException.notFound([String? key]) {
    return CacheException(
      message: key != null ? 'Cache not found for key: $key' : 'Cache not found.',
      type: CacheExceptionType.notFound,
      code: 'CACHE_NOT_FOUND',
    );
  }

  /// 缓存过期
  factory CacheException.expired([String? key]) {
    return CacheException(
      message: key != null ? 'Cache expired for key: $key' : 'Cache expired.',
      type: CacheExceptionType.expired,
      code: 'CACHE_EXPIRED',
    );
  }

  /// 缓存写入失败
  factory CacheException.writeFailed([String? details]) {
    return CacheException(
      message: details ?? 'Failed to write cache.',
      type: CacheExceptionType.writeFailed,
      code: 'CACHE_WRITE_FAILED',
    );
  }

  /// 缓存读取失败
  factory CacheException.readFailed([String? details]) {
    return CacheException(
      message: details ?? 'Failed to read cache.',
      type: CacheExceptionType.readFailed,
      code: 'CACHE_READ_FAILED',
    );
  }
}

/// 缓存异常类型
enum CacheExceptionType {
  /// 未找到
  notFound,

  /// 已过期
  expired,

  /// 写入失败
  writeFailed,

  /// 读取失败
  readFailed,
}

/// 验证异常
/// 数据验证错误
class ValidationException extends AppException {
  /// 字段名
  final String? field;

  /// 验证规则
  final String? rule;

  const ValidationException({
    required super.message,
    this.field,
    this.rule,
    super.code,
    super.originalException,
    super.stackTrace,
  });

  /// 创建必填字段异常
  factory ValidationException.required(String field) {
    return ValidationException(
      message: '$field is required.',
      field: field,
      rule: 'required',
      code: 'VALIDATION_REQUIRED',
    );
  }

  /// 创建格式错误异常
  factory ValidationException.invalidFormat(String field, [String? expectedFormat]) {
    return ValidationException(
      message: expectedFormat != null
          ? '$field has invalid format. Expected: $expectedFormat'
          : '$field has invalid format.',
      field: field,
      rule: 'format',
      code: 'VALIDATION_FORMAT',
    );
  }

  /// 创建长度异常
  factory ValidationException.length(String field, {int? min, int? max}) {
    String message;
    if (min != null && max != null) {
      message = '$field length must be between $min and $max.';
    } else if (min != null) {
      message = '$field must be at least $min characters.';
    } else if (max != null) {
      message = '$field must be at most $max characters.';
    } else {
      message = '$field has invalid length.';
    }

    return ValidationException(
      message: message,
      field: field,
      rule: 'length',
      code: 'VALIDATION_LENGTH',
    );
  }

  /// 创建范围异常
  factory ValidationException.range(String field, {num? min, num? max}) {
    String message;
    if (min != null && max != null) {
      message = '$field must be between $min and $max.';
    } else if (min != null) {
      message = '$field must be at least $min.';
    } else if (max != null) {
      message = '$field must be at most $max.';
    } else {
      message = '$field is out of range.';
    }

    return ValidationException(
      message: message,
      field: field,
      rule: 'range',
      code: 'VALIDATION_RANGE',
    );
  }
}

/// 未知异常
/// 捕获所有其他未分类的异常
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });

  /// 从任意异常创建
  factory UnknownException.from(dynamic error, [StackTrace? stackTrace]) {
    return UnknownException(
      message: error?.toString() ?? 'Unknown error occurred.',
      code: 'UNKNOWN',
      originalException: error,
      stackTrace: stackTrace,
    );
  }
}

