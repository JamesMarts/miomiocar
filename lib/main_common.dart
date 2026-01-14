/// 通用入口文件
/// 包含应用初始化和启动的公共逻辑
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/app/config/app_config.dart';
import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/localization/locale_provider.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/router/app_router.dart';
import 'package:flutter_demo/app/theme/app_theme.dart';

/// 应用程序通用入口
/// 由各环境的 main_xxx.dart 调用
void mainCommon() {
  // 捕获所有错误
  runZonedGuarded(
    () async {
      // 确保Flutter绑定初始化
      WidgetsFlutterBinding.ensureInitialized();

      // 打印当前环境信息
      debugPrint('🚀 Starting app in ${FlavorConfig.name} mode');
      debugPrint('📡 API Base URL: ${FlavorConfig.values.apiBaseUrl}');

      // 初始化应用配置
      await AppConfig.init();

      // 初始化依赖注入
      await Injector.init();

      // 设置Flutter错误处理
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (FlavorConfig.values.enableLogging) {
          debugPrint('❌ Flutter Error: ${details.exception}');
          debugPrint('📋 Stack Trace: ${details.stack}');
        }

        // 生产环境上报崩溃
        if (FlavorConfig.values.enableCrashReporting) {
          _reportCrash(details.exception, details.stack);
        }
      };

      // 运行应用
      runApp(
        // ProviderScope是Riverpod的根组件，必须包裹整个应用
        ProviderScope(
          overrides: [
            // 覆盖Provider，注入实际实现
            localeProvider.overrideWith((ref) {
              final prefs = getIt<SharedPreferences>();
              final manager = LocaleManager(prefs);
              return LocaleNotifier(manager);
            }),
            themeModeProvider.overrideWith((ref) {
              final prefs = getIt<SharedPreferences>();
              final manager = ThemeModeManager(prefs);
              return ThemeModeNotifier(manager);
            }),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      // 捕获Zone中未处理的错误
      if (FlavorConfig.values.enableLogging) {
        debugPrint('❌ Unhandled Error: $error');
        debugPrint('📋 Stack Trace: $stack');
      }

      // 生产环境上报崩溃
      if (FlavorConfig.values.enableCrashReporting) {
        _reportCrash(error, stack);
      }
    },
  );
}

/// 上报崩溃信息（占位实现）
void _reportCrash(dynamic error, StackTrace? stack) {
  // TODO: 集成 Firebase Crashlytics 或其他崩溃报告服务
  // FirebaseCrashlytics.instance.recordError(error, stack);
}

/// 应用根组件
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听语言变化
    final locale = ref.watch(localeProvider);

    // 监听主题模式变化
    final themeMode = ref.watch(themeModeProvider);

    // 获取应用名称（带环境后缀）
    final appTitle = AppConfig.appName + FlavorConfig.appNameSuffix;

    return MaterialApp.router(
      /// 应用标题（带环境标识）
      title: appTitle,

      /// 根据 Flavor 配置决定是否显示 Debug 标签
      debugShowCheckedModeBanner: FlavorConfig.values.showDebugBanner,

      /// 主题配置
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      /// 国际化配置
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /// 路由配置
      routerConfig: AppRouter.router,

      /// 构建器 - 添加环境标识
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            // 非生产环境显示环境标识
            if (!FlavorConfig.isProd) _buildFlavorBanner(),
          ],
        );
      },
    );
  }

  /// 构建环境标识横幅
  Widget _buildFlavorBanner() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: Banner(
          message: FlavorConfig.shortName,
          location: BannerLocation.topEnd,
          color: FlavorConfig.isDev ? Colors.green : Colors.orange,
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

