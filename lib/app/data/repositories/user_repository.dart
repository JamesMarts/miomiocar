import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/network/api_exception.dart';
import 'package:flutter_demo/app/core/network/api_endpoints.dart';
import 'package:flutter_demo/app/data/models/user_model.dart';

/// 用户仓库
/// 负责用户相关的数据获取和操作
class UserRepository {
  /// Dio客户端
  final DioClient _client;

  /// 构造函数
  UserRepository(this._client);

  /// 登录
  /// [request] 登录请求参数
  /// 返回登录响应数据
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      debugPrint('🔐 Attempting to login: ${request.username}');
      
      final data = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final response = LoginResponse.fromJson(data);
      debugPrint('✅ Login successful: ${response.user.username}');
      
      return response;
    } on ApiException catch (e) {
      debugPrint('❌ Login failed: ${e.message}');
      rethrow;
    }
  }

  /// 注册
  /// [request] 注册请求参数
  /// 返回用户信息
  Future<UserModel> register(RegisterRequest request) async {
    try {
      debugPrint('📝 Attempting to register: ${request.username}');
      
      final data = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(data);
      debugPrint('✅ Registration successful: ${user.username}');
      
      return user;
    } on ApiException catch (e) {
      debugPrint('❌ Registration failed: ${e.message}');
      rethrow;
    }
  }

  /// 获取当前用户信息
  /// 返回用户信息
  Future<UserModel> getCurrentUser() async {
    try {
      debugPrint('👤 Fetching current user info');
      
      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.currentUser,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(data);
      debugPrint('✅ User info fetched: ${user.username}');
      
      return user;
    } on ApiException catch (e) {
      debugPrint('❌ Failed to fetch user info: ${e.message}');
      rethrow;
    }
  }

  /// 更新用户信息
  /// [userId] 用户ID
  /// [data] 更新的数据
  /// 返回更新后的用户信息
  Future<UserModel> updateUser(int userId, Map<String, dynamic> data) async {
    try {
      debugPrint('📝 Updating user: $userId');
      
      final responseData = await _client.put<Map<String, dynamic>>(
        ApiEndpoints.updateUser(userId),
        data: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(responseData);
      debugPrint('✅ User updated: ${user.username}');
      
      return user;
    } on ApiException catch (e) {
      debugPrint('❌ Failed to update user: ${e.message}');
      rethrow;
    }
  }

  /// 获取用户列表（分页）
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回用户列表分页数据
  Future<PageResponse<UserModel>> getUserList({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      debugPrint('📋 Fetching user list: page=$page, size=$pageSize');
      
      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.userList,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final pageResponse = PageResponse<UserModel>.fromJson(
        data,
        (json) => UserModel.fromJson(json),
      );
      
      debugPrint('✅ User list fetched: ${pageResponse.items.length} items');
      
      return pageResponse;
    } on ApiException catch (e) {
      debugPrint('❌ Failed to fetch user list: ${e.message}');
      rethrow;
    }
  }

  /// 根据ID获取用户信息
  /// [userId] 用户ID
  /// 返回用户信息
  Future<UserModel> getUserById(int userId) async {
    try {
      debugPrint('👤 Fetching user by ID: $userId');
      
      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.userDetail(userId),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(data);
      debugPrint('✅ User fetched: ${user.username}');
      
      return user;
    } on ApiException catch (e) {
      debugPrint('❌ Failed to fetch user: ${e.message}');
      rethrow;
    }
  }

  /// 删除用户
  /// [userId] 用户ID
  Future<void> deleteUser(int userId) async {
    try {
      debugPrint('🗑️ Deleting user: $userId');
      
      await _client.delete(
        ApiEndpoints.deleteUser(userId),
        fromJson: (json) => null,
      );

      debugPrint('✅ User deleted successfully');
    } on ApiException catch (e) {
      debugPrint('❌ Failed to delete user: ${e.message}');
      rethrow;
    }
  }

  /// 搜索用户
  /// [keyword] 搜索关键词
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回搜索结果分页数据
  Future<PageResponse<UserModel>> searchUsers({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      debugPrint('🔍 Searching users: $keyword');
      
      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.searchUsers,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'page_size': pageSize,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final pageResponse = PageResponse<UserModel>.fromJson(
        data,
        (json) => UserModel.fromJson(json),
      );
      
      debugPrint('✅ Search completed: ${pageResponse.items.length} results');
      
      return pageResponse;
    } on ApiException catch (e) {
      debugPrint('❌ Search failed: ${e.message}');
      rethrow;
    }
  }
}

