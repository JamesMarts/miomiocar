import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';
import 'package:flutter_demo/app/data/models/user_model.dart';

/// UserStorageManager 使用示例
/// 
/// 这个文件展示了如何使用 UserStorageManager 进行用户信息的本地持久化操作
class StorageExample {
  StorageExample._();

  /// 示例1：登录成功后保存用户信息
  static Future<void> exampleSaveLoginInfo() async {
    // 获取存储管理器实例
    final storage = getIt<UserStorageManager>();

    // 假设这是从API获取的用户信息
    final user = UserModel(
      id: 1,
      username: 'john_doe',
      email: 'john@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
      nickname: 'John',
    );

    // 保存完整的登录信息（Token + 用户信息）
    await storage.saveLoginInfo(
      token: 'access_token_here',
      refreshToken: 'refresh_token_here',
      user: user,
    );

    // 或者分别保存
    // await storage.saveToken('access_token_here');
    // await storage.saveUserInfo(user);
  }

  /// 示例2：获取当前登录用户信息
  static void exampleGetUserInfo() {
    final storage = getIt<UserStorageManager>();

    // 获取完整用户信息
    final user = storage.getUserInfo();
    if (user != null) {
      print('User ID: ${user.id}');
      print('Username: ${user.username}');
      print('Email: ${user.email}');
    }

    // 或者只获取特定字段
    final userId = storage.getUserId();
    final username = storage.getUsername();
    final email = storage.getUserEmail();
    final avatar = storage.getUserAvatar();
  }

  /// 示例3：检查登录状态
  static void exampleCheckLoginStatus() {
    final storage = getIt<UserStorageManager>();

    // 检查是否已登录
    if (storage.isLoggedIn()) {
      print('用户已登录');
      
      // 获取用户信息
      final user = storage.getUserInfo();
      print('当前用户: ${user?.username}');
    } else {
      print('用户未登录');
    }

    // 只检查Token是否存在
    if (storage.hasToken()) {
      print('Token存在');
    }

    // 只检查用户信息是否存在
    if (storage.hasUserInfo()) {
      print('用户信息存在');
    }
  }

  /// 示例4：更新用户信息
  static Future<void> exampleUpdateUserInfo() async {
    final storage = getIt<UserStorageManager>();

    // 获取当前用户信息
    final user = storage.getUserInfo();
    if (user != null) {
      // 更新用户信息（例如修改了昵称）
      final updatedUser = user.copyWith(
        nickname: 'New Nickname',
        avatarUrl: 'https://example.com/new_avatar.jpg',
      );

      // 保存更新后的信息
      await storage.updateUserInfo(updatedUser);
    }
  }

  /// 示例5：登出清除信息
  static Future<void> exampleLogout() async {
    final storage = getIt<UserStorageManager>();

    // 清除所有登录信息（Token + 用户信息）
    await storage.clearLoginInfo();

    // 或者分别清除
    // await storage.clearTokens();
    // await storage.clearUserInfo();
  }

  /// 示例6：在 UseCase 中使用
  static Future<void> exampleUseInUseCase() async {
    final storage = getIt<UserStorageManager>();

    // 在登录UseCase中
    // final response = await _repository.login(request);
    // await storage.saveLoginInfo(
    //   token: response.accessToken,
    //   refreshToken: response.refreshToken,
    //   user: response.user,
    // );

    // 在获取用户信息UseCase中
    // final localUser = storage.getUserInfo();
    // if (localUser != null) {
    //   return localUser; // 先返回缓存数据
    // }
    // final remoteUser = await _repository.getCurrentUser();
    // await storage.saveUserInfo(remoteUser);
    // return remoteUser;
  }

  /// 示例7：在 Widget 中使用
  static void exampleUseInWidget() {
    final storage = getIt<UserStorageManager>();

    // 在 initState 中检查登录状态
    // @override
    // void initState() {
    //   super.initState();
    //   if (!storage.isLoggedIn()) {
    //     // 跳转到登录页
    //     context.go('/login');
    //   }
    // }

    // 在 build 中显示用户信息
    // final username = storage.getUsername() ?? 'Guest';
    // Text('Hello, $username');
  }

  /// 示例8：调试工具
  static void exampleDebugTools() {
    final storage = getIt<UserStorageManager>();

    // 打印所有存储的键值（仅Debug模式）
    storage.printAllKeys();

    // 清除所有数据（慎用！）
    // await storage.clearAll();
  }
}

