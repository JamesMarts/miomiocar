import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';

/// 用户信息存储管理类
/// 负责用户信息的本地持久化，包括保存、读取、更新、清除等操作
class UserStorageManager {
  /// SharedPreferences实例
  final SharedPreferences _prefs;

  /// 构造函数
  UserStorageManager(this._prefs);

  // ==================== Token 管理 ====================

  /// 保存访问Token
  /// [token] 访问令牌
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConfig.storage.tokenKey, token);
    debugPrint('🔐 Token saved to local storage');
  }

  /// 获取访问Token
  /// 返回Token，如果不存在返回null
  String? getToken() {
    return _prefs.getString(AppConfig.storage.tokenKey);
  }

  /// 保存刷新Token
  /// [refreshToken] 刷新令牌
  Future<void> saveRefreshToken(String refreshToken) async {
    await _prefs.setString(AppConfig.storage.refreshTokenKey, refreshToken);
    debugPrint('🔄 Refresh token saved to local storage');
  }

  /// 获取刷新Token
  /// 返回刷新Token，如果不存在返回null
  String? getRefreshToken() {
    return _prefs.getString(AppConfig.storage.refreshTokenKey);
  }

  /// 清除所有Token
  Future<void> clearTokens() async {
    await _prefs.remove(AppConfig.storage.tokenKey);
    await _prefs.remove(AppConfig.storage.refreshTokenKey);
    debugPrint('🗑️ All tokens cleared from local storage');
  }

  /// 判断Token是否存在
  /// 返回true表示已登录，false表示未登录
  bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== 用户信息管理 ====================

  /// 保存用户信息
  /// [user] 用户模型
  Future<void> saveUserInfo(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _prefs.setString(AppConfig.storage.userInfoKey, userJson);
      debugPrint('👤 User info saved: ${user.username}');
    } catch (e) {
      debugPrint('❌ Failed to save user info: $e');
      rethrow;
    }
  }

  /// 获取用户信息
  /// 返回用户模型，如果不存在或解析失败返回null
  UserModel? getUserInfo() {
    try {
      final userJson = _prefs.getString(AppConfig.storage.userInfoKey);
      if (userJson == null || userJson.isEmpty) {
        return null;
      }

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      debugPrint('❌ Failed to get user info: $e');
      return null;
    }
  }

  /// 更新用户信息
  /// [user] 新的用户模型
  /// 如果本地没有用户信息，会自动保存
  Future<void> updateUserInfo(UserModel user) async {
    await saveUserInfo(user);
    debugPrint('✏️ User info updated: ${user.username}');
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    await _prefs.remove(AppConfig.storage.userInfoKey);
    debugPrint('🗑️ User info cleared from local storage');
  }

  /// 判断用户信息是否存在
  /// 返回true表示存在用户信息，false表示不存在
  bool hasUserInfo() {
    final userJson = _prefs.getString(AppConfig.storage.userInfoKey);
    return userJson != null && userJson.isNotEmpty;
  }

  /// 获取用户ID
  /// 返回用户ID，如果不存在返回null
  int? getUserId() {
    final user = getUserInfo();
    return user?.id;
  }

  /// 获取用户名
  /// 返回用户名，如果不存在返回null
  String? getUsername() {
    final user = getUserInfo();
    return user?.username;
  }

  /// 获取用户邮箱
  /// 返回邮箱，如果不存在返回null
  String? getUserEmail() {
    final user = getUserInfo();
    return user?.email;
  }

  /// 获取用户头像URL
  /// 返回头像URL，如果不存在返回null
  String? getUserAvatar() {
    final user = getUserInfo();
    return user?.avatarUrl;
  }

  // ==================== 登录状态管理 ====================

  /// 判断是否已登录
  /// 同时检查Token和用户信息是否存在
  /// 返回true表示已登录，false表示未登录
  bool get isLoggedIn => hasToken() && hasUserInfo();

  /// 获取用户角色列表
  /// 返回用户角色列表，用于路由守卫权限检查
  List<String> getUserRoles() {
    // TODO: 从用户信息或单独存储中获取角色
    // 这里暂时返回空列表，实际项目中需要根据后端返回的角色信息来实现
    final user = getUserInfo();
    if (user == null) {
      return [];
    }
    // 示例：根据用户ID返回角色（实际应从后端获取）
    return ['user'];
  }

  /// 保存完整的登录信息
  /// [token] 访问令牌
  /// [refreshToken] 刷新令牌（可选）
  /// [user] 用户信息
  Future<void> saveLoginInfo({
    required String token,
    String? refreshToken,
    required UserModel user,
  }) async {
    await saveToken(token);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    await saveUserInfo(user);
    debugPrint('✅ Login info saved successfully');
  }

  /// 清除所有登录信息
  /// 包括Token和用户信息
  Future<void> clearLoginInfo() async {
    await clearTokens();
    await clearUserInfo();
    debugPrint('🔓 All login info cleared');
  }

  // ==================== 其他设置 ====================

  /// 获取语言设置
  String? getLanguage() {
    return _prefs.getString(AppConfig.storage.languageKey);
  }

  /// 保存语言设置
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(AppConfig.storage.languageKey, languageCode);
    debugPrint('🌐 Language saved: $languageCode');
  }

  /// 获取主题模式
  String? getThemeMode() {
    return _prefs.getString(AppConfig.storage.themeModeKey);
  }

  /// 保存主题模式
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConfig.storage.themeModeKey, mode);
    debugPrint('🎨 Theme mode saved: $mode');
  }

  /// 判断是否首次启动
  bool isFirstLaunch() {
    return _prefs.getBool(AppConfig.storage.firstLaunchKey) ?? true;
  }

  /// 标记已启动过
  Future<void> markAsLaunched() async {
    await _prefs.setBool(AppConfig.storage.firstLaunchKey, false);
    debugPrint('🚀 App marked as launched');
  }

  // ==================== 调试工具 ====================

  /// 打印所有存储的键值（仅Debug模式）
  void printAllKeys() {
    if (kDebugMode) {
      debugPrint('📦 All stored keys:');
      debugPrint('  - Token: ${hasToken()}');
      debugPrint('  - Refresh Token: ${getRefreshToken() != null}');
      debugPrint('  - User Info: ${hasUserInfo()}');
      debugPrint('  - Language: ${getLanguage()}');
      debugPrint('  - Theme Mode: ${getThemeMode()}');
      debugPrint('  - First Launch: ${isFirstLaunch()}');
    }
  }

  /// 清除所有数据（慎用！）
  Future<void> clearAll() async {
    await _prefs.clear();
    debugPrint('⚠️ All local storage cleared!');
  }
}

