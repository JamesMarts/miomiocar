import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';

/// Token拦截器
/// 自动在请求头中添加认证Token
class TokenInterceptor extends Interceptor {
  /// 用户存储管理器
  final UserStorageManager _storage;

  /// 构造函数
  TokenInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 从存储管理器获取Token
    final token = _storage.getToken();

    // 如果Token存在，添加到请求头
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('🔐 Token added to request: ${options.path}');
    }

    // 添加其他通用请求头
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = _storage.getLanguage() ?? 'en';

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // 可以在这里处理响应中的新Token
    // 例如：如果后端在响应头中返回新Token，可以自动更新
    final newToken = response.headers.value('x-new-token');
    if (newToken != null && newToken.isNotEmpty) {
      await _storage.saveToken(newToken);
      debugPrint('🔄 Token refreshed from response');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 处理401未授权错误
    if (err.response?.statusCode == 401) {
      debugPrint('❌ Unauthorized: Token expired or invalid');
      // 可以在这里触发Token刷新逻辑或跳转到登录页
      // 例如：_refreshToken() 或 _navigateToLogin()
      
      // 清除过期的Token
      await _storage.clearTokens();
    }

    super.onError(err, handler);
  }

  /// 刷新Token（示例方法）
  /// 实际项目中应该调用刷新Token的API
  Future<void> _refreshToken() async {
    try {
      final refreshToken = _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ No refresh token available');
        return;
      }

      // TODO: 调用刷新Token的API
      // final newToken = await authRepository.refreshToken(refreshToken);
      // await _storage.saveToken(newToken);
      
      debugPrint('✅ Token refreshed successfully');
    } catch (e) {
      debugPrint('❌ Failed to refresh token: $e');
    }
  }
}

