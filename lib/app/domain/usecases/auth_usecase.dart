import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/app_config.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

/// 登录用例
/// 封装登录的业务逻辑
class LoginUseCase {
  /// 用户仓库
  final UserRepository _repository;
  
  /// 本地存储
  final SharedPreferences _prefs;

  /// 构造函数
  LoginUseCase(this._repository, this._prefs);

  /// 执行用例 - 登录
  /// [username] 用户名
  /// [password] 密码
  /// 返回登录响应
  Future<LoginResponse> call({
    required String username,
    required String password,
  }) async {
    // 验证输入
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    // 调用登录API
    final request = LoginRequest(
      username: username,
      password: password,
    );
    
    final response = await _repository.login(request);

    // 保存Token到本地
    await _saveToken(response.accessToken);
    if (response.refreshToken != null) {
      await _saveRefreshToken(response.refreshToken!);
    }

    return response;
  }

  /// 保存访问令牌
  Future<void> _saveToken(String token) async {
    await _prefs.setString(AppConfig.storage.tokenKey, token);
  }

  /// 保存刷新令牌
  Future<void> _saveRefreshToken(String refreshToken) async {
    await _prefs.setString(AppConfig.storage.refreshTokenKey, refreshToken);
  }
}

/// 注册用例
/// 封装注册的业务逻辑
class RegisterUseCase {
  /// 用户仓库
  final UserRepository _repository;

  /// 构造函数
  RegisterUseCase(this._repository);

  /// 执行用例 - 注册
  /// [username] 用户名
  /// [email] 邮箱
  /// [password] 密码
  /// [passwordConfirmation] 确认密码
  /// 返回用户信息
  Future<UserModel> call({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    // 验证输入
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    
    if (email.trim().isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    
    if (password != passwordConfirmation) {
      throw ArgumentError('Passwords do not match');
    }
    
    if (password.length < AppConstants.minPasswordLength) {
      throw ArgumentError(
        'Password must be at least ${AppConstants.minPasswordLength} characters',
      );
    }

    // 调用注册API
    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    
    return await _repository.register(request);
  }
}

/// 登出用例
/// 封装登出的业务逻辑
class LogoutUseCase {
  /// 本地存储
  final SharedPreferences _prefs;

  /// 构造函数
  LogoutUseCase(this._prefs);

  /// 执行用例 - 登出
  Future<void> call() async {
    // 清除本地Token
    await _prefs.remove(AppConfig.storage.tokenKey);
    await _prefs.remove(AppConfig.storage.refreshTokenKey);
    await _prefs.remove(AppConfig.storage.userInfoKey);
    
    // 可以在这里调用后端的登出API
    // await _repository.logout();
  }
}

/// 检查登录状态用例
/// 封装检查登录状态的业务逻辑
class CheckAuthStatusUseCase {
  /// 本地存储
  final SharedPreferences _prefs;

  /// 构造函数
  CheckAuthStatusUseCase(this._prefs);

  /// 执行用例 - 检查是否已登录
  /// 返回是否已登录
  bool call() {
    final token = _prefs.getString(AppConfig.storage.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// 获取保存的Token
  String? getToken() {
    return _prefs.getString(AppConfig.storage.tokenKey);
  }

  /// 获取保存的刷新Token
  String? getRefreshToken() {
    return _prefs.getString(AppConfig.storage.refreshTokenKey);
  }
}

