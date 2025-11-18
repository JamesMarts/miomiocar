import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../api_exception.dart';

/// 错误拦截器
/// 统一处理和格式化所有API错误
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // 将Dio错误转换为自定义的ApiException
    final apiException = _handleError(err);

    // 打印错误日志
    debugPrint('❌ API Error: ${apiException.toString()}');
    if (kDebugMode) {
      debugPrint('   URL: ${err.requestOptions.uri}');
      debugPrint('   Method: ${err.requestOptions.method}');
      if (err.response != null) {
        debugPrint('   Status Code: ${err.response?.statusCode}');
        debugPrint('   Response Data: ${err.response?.data}');
      }
    }

    // 创建包含ApiException的DioException
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiException,
      message: apiException.message,
    );

    // 继续传递错误
    handler.reject(newError);
  }

  /// 处理错误，转换为ApiException
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException.connectTimeout();

      case DioExceptionType.sendTimeout:
        return ApiException.sendTimeout();

      case DioExceptionType.receiveTimeout:
        return ApiException.receiveTimeout();

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return ApiException.cancel();

      case DioExceptionType.connectionError:
        // 检查是否是网络连接问题
        if (error.message?.contains('SocketException') ?? false) {
          return ApiException.noInternet();
        }
        return ApiException.unknown(error.message);

      case DioExceptionType.badCertificate:
        return ApiException.unknown('SSL certificate verification failed.');

      case DioExceptionType.unknown:
      default:
        if (error.error != null) {
          return ApiException.unknown(error.error.toString());
        }
        return ApiException.unknown(error.message);
    }
  }

  /// 处理响应错误
  ApiException _handleResponseError(DioException error) {
    final response = error.response;
    if (response == null) {
      return ApiException.unknown('No response from server.');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // 尝试从响应体中提取错误信息
    String? message;
    int? errorCode;

    if (data is Map<String, dynamic>) {
      // 玩Android API 返回的格式：{ "errorCode": xxx, "errorMsg": "xxx", "data": null }
      errorCode = data['errorCode'] as int?;
      message = data['errorMsg'] as String?;

      // 如果是业务错误（errorCode != 0）
      if (errorCode != null && errorCode != 0) {
        return ApiException.business(
          code: errorCode,
          message: message ?? 'Business error occurred.',
        );
      }
    } else if (data is String) {
      message = data;
    }

    // HTTP状态码错误
    return ApiException.response(
      statusCode: statusCode,
      message: message,
    );
  }
}

