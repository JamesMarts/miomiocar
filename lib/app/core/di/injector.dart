import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/app/core/analytics/analytics_service.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/storage/user_storage_manager.dart';
import 'package:flutter_demo/app/features/user/data/repositories/user_repository.dart';
import 'package:flutter_demo/app/features/article/data/repositories/article_repository.dart';
import 'package:flutter_demo/app/features/auth/data/repositories/auth_repository.dart';

/// 依赖注入容器
/// 使用GetIt进行依赖注入管理
final getIt = GetIt.instance;

/// 依赖注入初始化
/// 注册所有需要注入的依赖
class Injector {
  Injector._();

  /// 是否已初始化
  static bool _isInitialized = false;

  /// 初始化依赖注入
  static Future<void> init() async {
    if (_isInitialized) return;

    // 1. 注册SharedPreferences（单例）
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    // 2. 注册用户存储管理器（单例）
    getIt.registerLazySingleton<UserStorageManager>(
      () => UserStorageManager(getIt<SharedPreferences>()),
    );

    // 3. 注册网络客户端（单例）
    getIt.registerLazySingleton<DioClient>(
      () => DioClient(getIt<UserStorageManager>()),
    );

    // 4. 注册埋点服务（单例）
    getIt.registerLazySingleton<AnalyticsService>(
      () => DefaultAnalyticsService(),
    );

    // 5. 注册Repository（单例）
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<DioClient>()),
    );

    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepository(getIt<DioClient>()),
    );

    // 注册认证仓库（单例）
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<DioClient>()),
    );

    // 6. 初始化埋点服务
    await getIt<AnalyticsService>().init();

    _isInitialized = true;
  }

  /// 重置依赖注入（主要用于测试）
  static Future<void> reset() async {
    await getIt.reset();
    _isInitialized = false;
  }
}
