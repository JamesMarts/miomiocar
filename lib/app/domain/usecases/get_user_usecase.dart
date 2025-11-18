import '../../core/network/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

/// 获取用户信息用例
/// 封装获取用户信息的业务逻辑
class GetUserUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  GetUserUseCase(this._repository);

  /// 执行用例 - 根据ID获取用户
  /// [userId] 用户ID
  /// 返回用户信息
  Future<UserModel> call(int userId) async {
    return await _repository.getUserById(userId);
  }

  /// 获取当前用户
  Future<UserModel> getCurrentUser() async {
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
  /// 返回分页用户列表
  Future<PageResponse<UserModel>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
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
  /// 返回搜索结果
  Future<PageResponse<UserModel>> call({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    // 验证搜索关键词
    if (keyword.trim().isEmpty) {
      throw ArgumentError('Search keyword cannot be empty');
    }

    return await _repository.searchUsers(
      keyword: keyword,
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
  /// 返回更新后的用户信息
  Future<UserModel> call(int userId, Map<String, dynamic> data) async {
    // 可以在这里添加业务逻辑验证
    // 例如：验证邮箱格式、昵称长度等
    
    return await _repository.updateUser(userId, data);
  }
}

