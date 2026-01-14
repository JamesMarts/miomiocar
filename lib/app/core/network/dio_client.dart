import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';
import 'api_exception.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/token_interceptor.dart';

/// Dio客户端封装
/// 统一管理所有HTTP请求
class DioClient {
  /// Dio实例
  late final Dio _dio;

  /// 用户存储管理器
  final UserStorageManager _storage;

  /// 构造函数
  DioClient(this._storage) {
    _dio = Dio(_createBaseOptions());
    _setupInterceptors();
  }

  /// 创建基础配置
  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: AppConfig.api.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.api.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.api.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConfig.api.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// 设置拦截器
  void _setupInterceptors() {
    _dio.interceptors.clear();

    // 添加Token拦截器
    _dio.interceptors.add(TokenInterceptor(_storage));

    // 添加日志拦截器（仅在非生产环境）
    if (AppConfig.api.enableRequestLog) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    // 添加错误拦截器
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// GET请求
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [options] 请求配置
  /// [cancelToken] 取消令牌
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on ApiException {
      // 如果已经是 ApiException，直接重新抛出
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in GET request: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// POST请求
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求配置
  /// [cancelToken] 取消令牌
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on ApiException {
      // 如果已经是 ApiException，直接重新抛出
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in POST request: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// PUT请求
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求配置
  /// [cancelToken] 取消令牌
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on ApiException {
      // 如果已经是 ApiException，直接重新抛出
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in PUT request: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// DELETE请求
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求配置
  /// [cancelToken] 取消令牌
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on ApiException {
      // 如果已经是 ApiException，直接重新抛出
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in DELETE request: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// PATCH请求
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求配置
  /// [cancelToken] 取消令牌
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } on ApiException {
      // 如果已经是 ApiException，直接重新抛出
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in PATCH request: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// 下载文件
  /// [urlPath] URL路径
  /// [savePath] 保存路径
  /// [onReceiveProgress] 下载进度回调
  /// [queryParameters] 查询参数
  /// [cancelToken] 取消令牌
  Future<void> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in download: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// 上传文件
  /// [path] 请求路径
  /// [formData] 表单数据
  /// [onSendProgress] 上传进度回调
  /// [cancelToken] 取消令牌
  Future<T> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in upload: $e');
      throw ApiException.unknown(e.toString());
    }
  }

  /// 处理响应数据
  /// 自动解析玩Android API响应格式：{ "data": ..., "errorCode": 0, "errorMsg": "" }
  T _handleResponse<T>(Response response, T Function(dynamic)? fromJson) {
    final data = response.data;

    // 如果响应不是Map，直接返回
    if (data is! Map<String, dynamic>) {
      return data as T;
    }

    // 玩Android API 响应格式
    // errorCode: 0 表示成功，非0表示失败
    // errorMsg: 错误信息
    // data: 实际数据
    final errorCode = data['errorCode'] as int? ?? -1;
    final errorMsg = data['errorMsg'] as String? ?? '';

    // 检查业务状态码
    if (errorCode != 0) {
      debugPrint('❌ API业务错误: errorCode=$errorCode, errorMsg=$errorMsg');
      throw ApiException.business(
        code: errorCode,
        message: errorMsg.isEmpty ? 'Unknown error' : errorMsg,
      );
    }

    // 获取实际数据
    final responseData = data['data'];

    // 如果提供了fromJson转换器，使用它转换数据
    if (fromJson != null) {
      return fromJson(responseData);
    }

    // 否则直接返回数据
    return responseData as T;
  }

  /// 处理Dio异常
  ApiException _handleDioException(DioException e) {
    // 如果error已经是ApiException，直接返回
    if (e.error is ApiException) {
      return e.error as ApiException;
    }

    // 否则创建通用错误
    return ApiException.unknown(e.message ?? e.toString());
  }

  /// 取消所有请求
  void cancelRequests([CancelToken? cancelToken]) {
    if (cancelToken != null) {
      cancelToken.cancel('Request cancelled by user');
    }
  }
}

