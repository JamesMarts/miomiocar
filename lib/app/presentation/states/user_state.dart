import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injector.dart';
import '../../core/network/api_exception.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

/// 用户列表状态
class UserListState {
  /// 用户列表
  final List<UserModel> users;
  
  /// 是否正在加载
  final bool isLoading;
  
  /// 错误信息
  final String? error;
  
  /// 当前页码
  final int currentPage;
  
  /// 是否有更多数据
  final bool hasMore;

  const UserListState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  /// 复制并修改
  UserListState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 用户列表状态管理
class UserListNotifier extends StateNotifier<UserListState> {
  final UserRepository _repository;

  UserListNotifier(this._repository) : super(const UserListState());

  /// 加载用户列表
  Future<void> loadUsers({bool refresh = false}) async {
    if (state.isLoading) return;

    // 如果是刷新，重置状态
    if (refresh) {
      state = const UserListState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final page = refresh ? 1 : state.currentPage;
      final response = await _repository.getUserList(page: page);

      final newUsers = refresh ? response.items : [...state.users, ...response.items];

      state = state.copyWith(
        users: newUsers,
        isLoading: false,
        currentPage: page + 1,
        hasMore: response.hasMore,
        error: null,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadUsers();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadUsers(refresh: true);
  }
}

/// 用户列表Provider
final userListProvider = StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  final repository = getIt<UserRepository>();
  return UserListNotifier(repository);
});

/// 用户详情Provider
/// 根据用户ID获取用户详情
final userDetailProvider = FutureProvider.family<UserModel, int>((ref, userId) async {
  final repository = getIt<UserRepository>();
  return await repository.getUserById(userId);
});

/// 当前用户Provider
/// 获取当前登录用户信息
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final repository = getIt<UserRepository>();
  return await repository.getCurrentUser();
});

/// 搜索用户状态
class SearchUserState {
  /// 搜索关键词
  final String keyword;
  
  /// 搜索结果
  final List<UserModel> results;
  
  /// 是否正在搜索
  final bool isSearching;
  
  /// 错误信息
  final String? error;

  const SearchUserState({
    this.keyword = '',
    this.results = const [],
    this.isSearching = false,
    this.error,
  });

  /// 复制并修改
  SearchUserState copyWith({
    String? keyword,
    List<UserModel>? results,
    bool? isSearching,
    String? error,
  }) {
    return SearchUserState(
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }
}

/// 搜索用户状态管理
class SearchUserNotifier extends StateNotifier<SearchUserState> {
  final UserRepository _repository;

  SearchUserNotifier(this._repository) : super(const SearchUserState());

  /// 搜索用户
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      state = const SearchUserState();
      return;
    }

    state = state.copyWith(
      keyword: keyword,
      isSearching: true,
      error: null,
    );

    try {
      final response = await _repository.searchUsers(keyword: keyword);

      state = state.copyWith(
        results: response.items,
        isSearching: false,
        error: null,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  /// 清除搜索
  void clear() {
    state = const SearchUserState();
  }
}

/// 搜索用户Provider
final searchUserProvider = StateNotifierProvider<SearchUserNotifier, SearchUserState>((ref) {
  final repository = getIt<UserRepository>();
  return SearchUserNotifier(repository);
});

