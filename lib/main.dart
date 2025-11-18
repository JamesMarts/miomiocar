import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/config/app_config.dart';
import 'app/core/di/injector.dart';
import 'app/core/localization/locale_provider.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'app/presentation/app_router.dart';
import 'app/presentation/app_theme.dart';

/// 应用程序入口
void main() {
  // 捕获所有错误
  runZonedGuarded(
    () async {
      // 确保Flutter绑定初始化
      WidgetsFlutterBinding.ensureInitialized();

      // 初始化应用配置
      await AppConfig.init();

      // 初始化依赖注入
      await Injector.init();

      // 设置Flutter错误处理
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint('Flutter Error: ${details.exception}');
        debugPrint('Stack Trace: ${details.stack}');
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
      debugPrint('Unhandled Error: $error');
      debugPrint('Stack Trace: $stack');
    },
  );
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

    return MaterialApp.router(
      /// 应用标题
      title: AppConfig.appName,

      /// 调试模式下隐藏Debug标签
      debugShowCheckedModeBanner: false,

      /// 主题配置
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      /// 国际化配置
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      /// 路由配置
      routerConfig: AppRouter.createRouter(),
    );
  }
}
