/// API异常类型枚举
enum ApiExceptionType {
  /// 网络连接异常
  connectTimeout,
  
  /// 发送超时
  sendTimeout,
  
  /// 接收超时
  receiveTimeout,
  
  /// 响应错误
  response,
  
  /// 取消请求
  cancel,
  
  /// 未知错误
  unknown,
  
  /// 无网络连接
  noInternet,
  
  /// 解析错误
  parseError,
  
  /// 业务错误
  businessError,
}

/// API异常类
/// 统一封装所有API相关的异常
class ApiException implements Exception {
  /// 异常类型
  final ApiExceptionType type;
  
  /// 错误消息
  final String message;
  
  /// 错误码（后端返回的业务错误码）
  final int? code;
  
  /// 原始异常
  final dynamic originalException;
  
  /// 堆栈跟踪
  final StackTrace? stackTrace;

  /// 构造函数
  ApiException({
    required this.type,
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  /// 创建连接超时异常
  factory ApiException.connectTimeout() {
    return ApiException(
      type: ApiExceptionType.connectTimeout,
      message: 'Connection timeout. Please check your network.',
    );
  }

  /// 创建发送超时异常
  factory ApiException.sendTimeout() {
    return ApiException(
      type: ApiExceptionType.sendTimeout,
      message: 'Send timeout. Please try again.',
    );
  }

  /// 创建接收超时异常
  factory ApiException.receiveTimeout() {
    return ApiException(
      type: ApiExceptionType.receiveTimeout,
      message: 'Receive timeout. Please try again.',
    );
  }

  /// 创建取消请求异常
  factory ApiException.cancel() {
    return ApiException(
      type: ApiExceptionType.cancel,
      message: 'Request cancelled.',
    );
  }

  /// 创建无网络异常
  factory ApiException.noInternet() {
    return ApiException(
      type: ApiExceptionType.noInternet,
      message: 'No internet connection. Please check your network.',
    );
  }

  /// 创建解析错误异常
  factory ApiException.parseError([String? details]) {
    return ApiException(
      type: ApiExceptionType.parseError,
      message: details ?? 'Failed to parse response data.',
    );
  }

  /// 创建响应错误异常
  factory ApiException.response({
    required int statusCode,
    String? message,
  }) {
    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = message ?? 'Bad request.';
        break;
      case 401:
        errorMessage = message ?? 'Unauthorized. Please login again.';
        break;
      case 403:
        errorMessage = message ?? 'Forbidden. You have no permission.';
        break;
      case 404:
        errorMessage = message ?? 'Resource not found.';
        break;
      case 500:
        errorMessage = message ?? 'Internal server error.';
        break;
      case 502:
        errorMessage = message ?? 'Bad gateway.';
        break;
      case 503:
        errorMessage = message ?? 'Service unavailable.';
        break;
      default:
        errorMessage = message ?? 'Request failed with status $statusCode.';
    }

    return ApiException(
      type: ApiExceptionType.response,
      message: errorMessage,
      code: statusCode,
    );
  }

  /// 创建业务错误异常
  factory ApiException.business({
    required int code,
    required String message,
  }) {
    return ApiException(
      type: ApiExceptionType.businessError,
      message: message,
      code: code,
    );
  }

  /// 创建未知错误异常
  factory ApiException.unknown([String? message]) {
    return ApiException(
      type: ApiExceptionType.unknown,
      message: message ?? 'Unknown error occurred.',
    );
  }

  @override
  String toString() {
    return 'ApiException{type: $type, code: $code, message: $message}';
  }
}

/// 标准API响应包装类
/// 后端返回的标准格式：{ "code": 0, "message": "success", "data": {} }
class ApiResponse<T> {
  /// 业务状态码（0表示成功）
  final int code;
  
  /// 响应消息
  final String message;
  
  /// 响应数据
  final T? data;

  /// 构造函数
  ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 从JSON创建
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  /// 判断是否成功
  bool get isSuccess => code == 0;

  /// 判断是否失败
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, data: $data}';
  }
}

/// 分页响应类
class PageResponse<T> {
  /// 当前页码
  final int page;
  
  /// 每页数量
  final int pageSize;
  
  /// 总数量
  final int total;
  
  /// 总页数
  final int totalPages;
  
  /// 数据列表
  final List<T> items;

  /// 构造函数
  PageResponse({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.items,
  });

  /// 从JSON创建
  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PageResponse<T>(
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      items: (json['items'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// 判断是否有更多数据
  bool get hasMore => page < totalPages;

  /// 判断是否为空
  bool get isEmpty => items.isEmpty;

  /// 判断是否不为空
  bool get isNotEmpty => items.isNotEmpty;

  @override
  String toString() {
    return 'PageResponse{page: $page, pageSize: $pageSize, total: $total, items: ${items.length}}';
  }
}

