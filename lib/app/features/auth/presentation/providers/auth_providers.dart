import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/network/api_exception.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';
import 'package:flutter_demo/app/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_demo/app/features/auth/data/models/login_user_model.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';

/// 认证状态
/// 包含当前登录用户信息和加载状态
class AuthState {
  /// 当前登录用户
  final LoginUserModel? currentUser;

  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? error;

  /// 是否已登录
  bool get isLoggedIn => currentUser != null;

  /// 构造函数
  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  /// 初始状态
  factory AuthState.initial() => const AuthState();

  /// 加载中状态
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// 复制并修改
  AuthState copyWith({
    LoginUserModel? currentUser,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// 认证状态管理器
/// 负责管理登录、注册、登出等状态
class AuthNotifier extends StateNotifier<AuthState> {
  /// 认证仓库
  final AuthRepository _repository;

  /// 用户存储管理器
  final UserStorageManager _storage;

  /// 构造函数
  AuthNotifier(this._repository, this._storage) : super(AuthState.initial()) {
    // 初始化时检查本地登录状态
    _checkLocalAuth();
  }

  /// 检查本地登录状态
  void _checkLocalAuth() {
    final isLoggedIn = _storage.isLoggedIn;
    if (isLoggedIn) {
      // 从本地存储恢复用户信息
      final userInfo = _storage.getUserInfo();
      if (userInfo != null) {
        debugPrint('🔐 从本地恢复登录状态: ${userInfo.username}');
        // 注意：这里我们需要将 UserModel 转换为 LoginUserModel
        // 由于字段不完全匹配，这里只是恢复基本状态
      }
    }
  }

  /// 登录
  /// [username] 用户名
  /// [password] 密码
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      debugPrint('🚀 开始登录: $username');
      final user = await _repository.login(
        username: username,
        password: password,
      );

      // 保存登录信息到本地
      await _saveLoginInfo(user);

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
      );

      debugPrint('✅ 登录成功: ${user.username}');
      return true;
    } on ApiException catch (e) {
      debugPrint('❌ 登录失败: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      debugPrint('❌ 登录失败: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 注册
  /// [username] 用户名
  /// [password] 密码
  /// [repassword] 确认密码
  Future<bool> register({
    required String username,
    required String password,
    required String repassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      debugPrint('🚀 开始注册: $username');
      final user = await _repository.register(
        username: username,
        password: password,
        repassword: repassword,
      );

      // 注册成功后自动登录，保存登录信息
      await _saveLoginInfo(user);

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
      );

      debugPrint('✅ 注册成功: ${user.username}');
      return true;
    } on ApiException catch (e) {
      debugPrint('❌ 注册失败: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      debugPrint('❌ 注册失败: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      debugPrint('🚀 开始登出');
      await _repository.logout();

      // 清除本地登录信息
      await _storage.clearLoginInfo();

      state = state.copyWith(
        isLoading: false,
        clearUser: true,
      );

      debugPrint('✅ 登出成功');
    } catch (e) {
      debugPrint('❌ 登出失败: $e');
      // 即使API调用失败，也清除本地状态
      await _storage.clearLoginInfo();
      state = state.copyWith(
        isLoading: false,
        clearUser: true,
        error: e.toString(),
      );
    }
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// 保存登录信息到本地
  Future<void> _saveLoginInfo(LoginUserModel user) async {
    // 将 LoginUserModel 转换为 UserModel 保存
    final userModel = UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      nickname: user.nickname,
      avatarUrl: user.icon.isNotEmpty ? user.icon : null,
    );

    // 使用用户的token或者使用一个标记表示已登录
    // 玩Android API 使用 Cookie 保持登录状态
    await _storage.saveLoginInfo(
      token: user.token.isNotEmpty ? user.token : 'logged_in',
      user: userModel,
    );
  }
}

/// 认证状态 Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = getIt<AuthRepository>();
  final storage = getIt<UserStorageManager>();
  return AuthNotifier(repository, storage);
});

/// 是否已登录 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

/// 当前用户 Provider
final currentUserProvider = Provider<LoginUserModel?>((ref) {
  return ref.watch(authProvider).currentUser;
});

