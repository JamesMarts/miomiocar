import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/network/api_endpoints.dart';
import 'package:flutter_demo/app/core/network/api_exception.dart';
import 'package:flutter_demo/app/features/auth/data/models/login_user_model.dart';
import 'package:flutter_demo/app/features/auth/data/models/coin_info_model.dart';

/// 认证仓库
/// 负责处理登录、注册、登出等认证相关的API请求
class AuthRepository {
  /// Dio客户端
  final DioClient _client;

  /// 构造函数
  AuthRepository(this._client);

  /// 登录
  /// [username] 用户名
  /// [password] 密码
  /// 返回登录用户信息
  Future<LoginUserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      debugPrint('📡 正在登录: $username');

      // 玩Android API 登录接口使用表单提交
      final data = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 登录成功');
      return LoginUserModel.fromJson(data);
    } on ApiException catch (e) {
      debugPrint('❌ 登录失败: ${e.message}');
      rethrow;
    }
  }

  /// 注册
  /// [username] 用户名
  /// [password] 密码
  /// [repassword] 确认密码
  /// 返回注册后的用户信息
  Future<LoginUserModel> register({
    required String username,
    required String password,
    required String repassword,
  }) async {
    try {
      debugPrint('📡 正在注册: $username');

      // 玩Android API 注册接口使用表单提交
      final data = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: FormData.fromMap({
          'username': username,
          'password': password,
          'repassword': repassword,
        }),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 注册成功');
      return LoginUserModel.fromJson(data);
    } on ApiException catch (e) {
      debugPrint('❌ 注册失败: ${e.message}');
      rethrow;
    }
  }

  /// 登出
  /// 返回是否登出成功
  Future<void> logout() async {
    try {
      debugPrint('📡 正在登出');

      await _client.get<dynamic>(
        ApiEndpoints.logout,
        fromJson: (json) => json,
      );

      debugPrint('✅ 登出成功');
    } on ApiException catch (e) {
      debugPrint('❌ 登出失败: ${e.message}');
      rethrow;
    }
  }

  /// 获取个人积分信息
  /// 需要登录状态
  /// 返回积分信息
  Future<CoinInfoModel> getCoinInfo() async {
    try {
      debugPrint('📡 正在获取积分信息');

      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.coinInfo,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 获取积分信息成功');
      return CoinInfoModel.fromJson(data);
    } on ApiException catch (e) {
      debugPrint('❌ 获取积分信息失败: ${e.message}');
      rethrow;
    }
  }
}

