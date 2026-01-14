import 'package:flutter_demo/app/core/error/app_exception.dart';
import 'package:flutter_demo/app/core/error/result.dart';
import 'package:flutter_demo/app/shared/models/page_response.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';
import 'package:flutter_demo/app/features/user/data/repositories/user_repository.dart';

/// 获取用户信息用例
/// 封装获取用户信息的业务逻辑
class GetUserUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  GetUserUseCase(this._repository);

  /// 执行用例 - 根据ID获取用户
  /// [userId] 用户ID
  /// 返回 Result 类型
  Future<Result<UserModel>> call(int userId) async {
    // 验证参数
    if (userId <= 0) {
      return Result.failure(
        const ValidationException(
          message: 'Invalid user ID',
          field: 'userId',
          code: 'INVALID_USER_ID',
        ),
      );
    }

    return await _repository.getUserById(userId);
  }

  /// 获取当前用户
  Future<Result<UserModel>> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }
}

/// 获取用户列表用例
/// 封装获取用户列表的业务逻辑
class GetUserListUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  GetUserListUseCase(this._repository);

  /// 执行用例 - 获取用户列表
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回 Result 类型
  Future<Result<PageResponse<UserModel>>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
    // 验证参数
    if (page < 1) {
      return Result.failure(
        const ValidationException(
          message: 'Page must be greater than 0',
          field: 'page',
          code: 'INVALID_PAGE',
        ),
      );
    }

    if (pageSize < 1 || pageSize > 100) {
      return Result.failure(
        const ValidationException(
          message: 'Page size must be between 1 and 100',
          field: 'pageSize',
          code: 'INVALID_PAGE_SIZE',
        ),
      );
    }

    return await _repository.getUserList(
      page: page,
      pageSize: pageSize,
    );
  }
}

/// 搜索用户用例
/// 封装搜索用户的业务逻辑
class SearchUserUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  SearchUserUseCase(this._repository);

  /// 执行用例 - 搜索用户
  /// [keyword] 搜索关键词
  /// [page] 页码
  /// [pageSize] 每页数量
  /// 返回 Result 类型
  Future<Result<PageResponse<UserModel>>> call({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    // 验证搜索关键词
    final trimmedKeyword = keyword.trim();
    if (trimmedKeyword.isEmpty) {
      return Result.failure(
        const ValidationException(
          message: 'Search keyword cannot be empty',
          field: 'keyword',
          code: 'EMPTY_KEYWORD',
        ),
      );
    }

    if (trimmedKeyword.length < 2) {
      return Result.failure(
        const ValidationException(
          message: 'Search keyword must be at least 2 characters',
          field: 'keyword',
          code: 'KEYWORD_TOO_SHORT',
        ),
      );
    }

    return await _repository.searchUsers(
      keyword: trimmedKeyword,
      page: page,
      pageSize: pageSize,
    );
  }
}

/// 更新用户用例
/// 封装更新用户信息的业务逻辑
class UpdateUserUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  UpdateUserUseCase(this._repository);

  /// 执行用例 - 更新用户信息
  /// [userId] 用户ID
  /// [data] 更新的数据
  /// 返回 Result 类型
  Future<Result<UserModel>> call(int userId, Map<String, dynamic> data) async {
    // 验证用户ID
    if (userId <= 0) {
      return Result.failure(
        const ValidationException(
          message: 'Invalid user ID',
          field: 'userId',
          code: 'INVALID_USER_ID',
        ),
      );
    }

    // 验证更新数据
    if (data.isEmpty) {
      return Result.failure(
        const ValidationException(
          message: 'Update data cannot be empty',
          field: 'data',
          code: 'EMPTY_DATA',
        ),
      );
    }

    // 验证邮箱格式（如果提供）
    if (data.containsKey('email')) {
      final email = data['email'] as String?;
      if (email != null && !_isValidEmail(email)) {
        return Result.failure(
          ValidationException.invalidFormat('email', 'example@domain.com'),
        );
      }
    }

    // 验证昵称长度（如果提供）
    if (data.containsKey('nickname')) {
      final nickname = data['nickname'] as String?;
      if (nickname != null && (nickname.length < 2 || nickname.length > 50)) {
        return Result.failure(
          ValidationException.length('nickname', min: 2, max: 50),
        );
      }
    }

    return await _repository.updateUser(userId, data);
  }

  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

