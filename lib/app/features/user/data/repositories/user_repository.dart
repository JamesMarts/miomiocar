import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/error/result.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/network/api_endpoints.dart';
import 'package:flutter_demo/app/shared/models/page_response.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';

/// 用户仓库
/// 负责用户相关的数据获取和操作
class UserRepository {
  /// Dio客户端
  final DioClient _client;

  /// 构造函数
  UserRepository(this._client);

  /// 获取当前用户信息
  /// 返回 Result 类型，包含成功数据或失败异常
  Future<Result<UserModel>> getCurrentUser() async {
    return Result.fromAsync(() async {
      debugPrint('👤 Fetching current user info');

      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.currentUser,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(data);
      debugPrint('✅ User info fetched: ${user.username}');

      return user;
    });
  }

  /// 根据ID获取用户信息
  /// [userId] 用户ID
  /// 返回 Result 类型
  Future<Result<UserModel>> getUserById(int userId) async {
    return Result.fromAsync(() async {
      debugPrint('👤 Fetching user by ID: $userId');

      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.userDetail(userId),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(data);
      debugPrint('✅ User fetched: ${user.username}');

      return user;
    });
  }

  /// 获取用户列表（分页）
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回 Result 类型
  Future<Result<PageResponse<UserModel>>> getUserList({
    int page = 1,
    int pageSize = 20,
  }) async {
    return Result.fromAsync(() async {
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
    });
  }

  /// 更新用户信息
  /// [userId] 用户ID
  /// [data] 更新的数据
  /// 返回 Result 类型
  Future<Result<UserModel>> updateUser(int userId, Map<String, dynamic> data) async {
    return Result.fromAsync(() async {
      debugPrint('📝 Updating user: $userId');

      final responseData = await _client.put<Map<String, dynamic>>(
        ApiEndpoints.updateUser(userId),
        data: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final user = UserModel.fromJson(responseData);
      debugPrint('✅ User updated: ${user.username}');

      return user;
    });
  }

  /// 删除用户
  /// [userId] 用户ID
  /// 返回 Result 类型
  Future<Result<void>> deleteUser(int userId) async {
    return Result.fromAsync(() async {
      debugPrint('🗑️ Deleting user: $userId');

      await _client.delete(
        ApiEndpoints.deleteUser(userId),
        fromJson: (json) => null,
      );

      debugPrint('✅ User deleted successfully');
    });
  }

  /// 搜索用户
  /// [keyword] 搜索关键词
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回 Result 类型
  Future<Result<PageResponse<UserModel>>> searchUsers({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    return Result.fromAsync(() async {
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
    });
  }

  // ============ 兼容旧API的方法（不使用Result）============

  /// 获取用户列表（旧版API，兼容现有代码）
  @Deprecated('Use getUserList instead')
  Future<PageResponse<UserModel>> getUserListLegacy({
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await getUserList(page: page, pageSize: pageSize);
    return result.getOrThrow();
  }

  /// 根据ID获取用户（旧版API，兼容现有代码）
  @Deprecated('Use getUserById instead')
  Future<UserModel> getUserByIdLegacy(int userId) async {
    final result = await getUserById(userId);
    return result.getOrThrow();
  }

  /// 搜索用户（旧版API，兼容现有代码）
  @Deprecated('Use searchUsers instead')
  Future<PageResponse<UserModel>> searchUsersLegacy({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await searchUsers(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
    return result.getOrThrow();
  }
}

