import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/config/app_config.dart';

/// 日志拦截器
/// 打印详细的请求和响应日志（仅在非生产环境）
class LoggingInterceptor extends Interceptor {
  /// 是否启用
  final bool enabled;

  /// 构造函数
  LoggingInterceptor({this.enabled = true});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!enabled || !AppConfig.api.enableRequestLog) {
      super.onRequest(options, handler);
      return;
    }

    debugPrint('╔═══════════════════════════════════════════════════════');
    debugPrint('║ 📤 REQUEST');
    debugPrint('╠═══════════════════════════════════════════════════════');
    debugPrint('║ URL: ${options.uri}');
    debugPrint('║ Method: ${options.method}');
    debugPrint('║ Headers:');
    options.headers.forEach((key, value) {
      debugPrint('║   $key: $value');
    });

    if (options.queryParameters.isNotEmpty) {
      debugPrint('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        debugPrint('║   $key: $value');
      });
    }

    if (options.data != null) {
      debugPrint('║ Body: ${options.data}');
    }

    debugPrint('╚═══════════════════════════════════════════════════════');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (!enabled || !AppConfig.api.enableResponseLog) {
      super.onResponse(response, handler);
      return;
    }

    debugPrint('╔═══════════════════════════════════════════════════════');
    debugPrint('║ 📥 RESPONSE');
    debugPrint('╠═══════════════════════════════════════════════════════');
    debugPrint('║ URL: ${response.requestOptions.uri}');
    debugPrint('║ Status Code: ${response.statusCode}');
    debugPrint('║ Headers:');
    response.headers.forEach((key, values) {
      debugPrint('║   $key: ${values.join(', ')}');
    });

    if (response.data != null) {
      final data = response.data;
      if (data is Map || data is List) {
        debugPrint('║ Body: $data');
      } else {
        debugPrint('║ Body: ${data.toString()}');
      }
    }

    debugPrint('╚═══════════════════════════════════════════════════════');

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (!enabled || !AppConfig.api.enableErrorLog) {
      super.onError(err, handler);
      return;
    }

    debugPrint('╔═══════════════════════════════════════════════════════');
    debugPrint('║ ❌ ERROR');
    debugPrint('╠═══════════════════════════════════════════════════════');
    debugPrint('║ URL: ${err.requestOptions.uri}');
    debugPrint('║ Method: ${err.requestOptions.method}');
    debugPrint('║ Error Type: ${err.type}');
    debugPrint('║ Error Message: ${err.message}');

    if (err.response != null) {
      debugPrint('║ Status Code: ${err.response?.statusCode}');
      debugPrint('║ Response Data: ${err.response?.data}');
    }

    debugPrint('╚═══════════════════════════════════════════════════════');

    super.onError(err, handler);
  }
}

