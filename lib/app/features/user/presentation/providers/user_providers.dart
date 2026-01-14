import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/error/app_exception.dart';
import 'package:flutter_demo/app/core/error/result.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';
import 'package:flutter_demo/app/features/user/data/repositories/user_repository.dart';

/// 用户列表状态
class UserListState {
  /// 用户列表
  final List<UserModel> users;

  /// 是否正在加载
  final bool isLoading;

  /// 是否正在刷新
  final bool isRefreshing;

  /// 错误信息
  final AppException? error;

  /// 当前页码
  final int currentPage;

  /// 是否有更多数据
  final bool hasMore;

  const UserListState({
    this.users = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
  });

  /// 初始状态
  factory UserListState.initial() => const UserListState();

  /// 加载中状态
  factory UserListState.loading() => const UserListState(isLoading: true);

  /// 复制并修改
  UserListState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    bool? isRefreshing,
    AppException? error,
    bool clearError = false,
    int? currentPage,
    bool? hasMore,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// 是否为空
  bool get isEmpty => users.isEmpty && !isLoading && error == null;

  /// 是否有数据
  bool get hasData => users.isNotEmpty;

  /// 是否有错误
  bool get hasError => error != null;
}

/// 用户列表状态管理
class UserListNotifier extends StateNotifier<UserListState> {
  final UserRepository _repository;

  UserListNotifier(this._repository) : super(UserListState.initial());

  /// 加载用户列表
  Future<void> loadUsers({bool refresh = false}) async {
    // 防止重复加载
    if (state.isLoading || state.isRefreshing) return;

    // 如果是刷新，重置状态
    if (refresh) {
      state = state.copyWith(
        isRefreshing: true,
        clearError: true,
      );
    } else if (state.currentPage == 0) {
      // 首次加载
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );
    } else {
      // 加载更多
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );
    }

    final page = refresh ? 1 : state.currentPage + 1;
    final result = await _repository.getUserList(page: page);

    result.when(
      success: (response) {
        final newUsers = refresh ? response.items : [...state.users, ...response.items];

        state = state.copyWith(
          users: newUsers,
          isLoading: false,
          isRefreshing: false,
          currentPage: page,
          hasMore: response.hasMore,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          error: exception,
        );
      },
    );
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading || state.isRefreshing) return;
    await loadUsers();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadUsers(refresh: true);
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 移除用户（本地）
  void removeUser(int userId) {
    state = state.copyWith(
      users: state.users.where((u) => u.id != userId).toList(),
    );
  }

  /// 更新用户（本地）
  void updateUser(UserModel user) {
    state = state.copyWith(
      users: state.users.map((u) => u.id == user.id ? user : u).toList(),
    );
  }
}

/// 用户列表Provider
final userListProvider = StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  final repository = getIt<UserRepository>();
  return UserListNotifier(repository);
});

/// 用户详情Provider
/// 使用 FutureProvider.family 根据用户ID获取用户详情
final userDetailProvider = FutureProvider.family<UserModel, int>((ref, userId) async {
  final repository = getIt<UserRepository>();
  final result = await repository.getUserById(userId);
  return result.getOrThrow();
});

/// 当前用户Provider
/// 获取当前登录用户信息
final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final repository = getIt<UserRepository>();
  final result = await repository.getCurrentUser();
  return result.getOrThrow();
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
  final AppException? error;

  /// 当前页码
  final int currentPage;

  /// 是否有更多数据
  final bool hasMore;

  const SearchUserState({
    this.keyword = '',
    this.results = const [],
    this.isSearching = false,
    this.error,
    this.currentPage = 0,
    this.hasMore = true,
  });

  /// 复制并修改
  SearchUserState copyWith({
    String? keyword,
    List<UserModel>? results,
    bool? isSearching,
    AppException? error,
    bool clearError = false,
    int? currentPage,
    bool? hasMore,
  }) {
    return SearchUserState(
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// 是否为空搜索
  bool get isEmpty => results.isEmpty && !isSearching && keyword.isEmpty;

  /// 是否有搜索结果
  bool get hasResults => results.isNotEmpty;

  /// 是否无结果
  bool get noResults => results.isEmpty && !isSearching && keyword.isNotEmpty;
}

/// 搜索用户状态管理
class SearchUserNotifier extends StateNotifier<SearchUserState> {
  final UserRepository _repository;

  SearchUserNotifier(this._repository) : super(const SearchUserState());

  /// 搜索用户
  Future<void> search(String keyword, {bool loadMore = false}) async {
    final trimmedKeyword = keyword.trim();

    // 如果关键词为空，清空结果
    if (trimmedKeyword.isEmpty) {
      state = const SearchUserState();
      return;
    }

    // 如果是新搜索（关键词改变）
    if (!loadMore || trimmedKeyword != state.keyword) {
      state = SearchUserState(
        keyword: trimmedKeyword,
        isSearching: true,
      );
    } else {
      // 加载更多
      state = state.copyWith(isSearching: true);
    }

    final page = loadMore && trimmedKeyword == state.keyword ? state.currentPage + 1 : 1;
    final result = await _repository.searchUsers(
      keyword: trimmedKeyword,
      page: page,
    );

    result.when(
      success: (response) {
        final newResults = page == 1 ? response.items : [...state.results, ...response.items];

        state = state.copyWith(
          results: newResults,
          isSearching: false,
          currentPage: page,
          hasMore: response.hasMore,
        );
      },
      failure: (exception) {
        state = state.copyWith(
          isSearching: false,
          error: exception,
        );
      },
    );
  }

  /// 加载更多搜索结果
  Future<void> loadMore() async {
    if (!state.hasMore || state.isSearching || state.keyword.isEmpty) return;
    await search(state.keyword, loadMore: true);
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

