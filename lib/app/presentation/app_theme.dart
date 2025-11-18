import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/app/config/app_config.dart';

/// 应用主题配置
/// 统一管理Light和Dark主题
class AppTheme {
  AppTheme._();

  /// 主色调
  static const Color primaryColor = Color(0xFF6200EE);
  
  /// 次要色调
  static const Color secondaryColor = Color(0xFF03DAC6);
  
  /// 错误色
  static const Color errorColor = Color(0xFFB00020);
  
  /// 背景色（浅色）
  static const Color lightBackground = Color(0xFFFFFFFF);
  
  /// 背景色（深色）
  static const Color darkBackground = Color(0xFF121212);

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        secondary: secondaryColor,
        error: errorColor,
      ),
      
      /// 文本主题使用自定义字体
      fontFamily: 'CustomFont',
      
      /// AppBar主题
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      
      /// 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      /// 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      /// 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      /// 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      
      /// 浮动按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      
      /// 底部导航栏主题
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: lightBackground,
      ),
      
      /// 列表磁贴主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        secondary: secondaryColor,
        error: errorColor,
      ),
      
      /// 文本主题使用自定义字体
      fontFamily: 'CustomFont',
      
      /// AppBar主题
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      
      /// 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      /// 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      /// 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      /// 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      
      /// 浮动按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      
      /// 底部导航栏主题
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: darkBackground,
      ),
      
      /// 列表磁贴主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }
}

/// 主题模式管理器
class ThemeModeManager {
  final SharedPreferences _prefs;
  
  ThemeModeManager(this._prefs);
  
  /// 获取保存的主题模式
  ThemeMode getSavedThemeMode() {
    final modeString = _prefs.getString(AppConfig.storage.themeModeKey);
    return _themeModeFromString(modeString);
  }
  
  /// 保存主题模式
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(
      AppConfig.storage.themeModeKey,
      mode.name,
    );
  }
  
  /// 从字符串转换为ThemeMode
  ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

/// 主题模式状态管理
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final ThemeModeManager _manager;
  
  ThemeModeNotifier(this._manager) : super(_manager.getSavedThemeMode());
  
  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    
    await _manager.saveThemeMode(mode);
    state = mode;
  }
  
  /// 切换主题模式
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

/// 主题模式Provider（在DI中注册）
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  throw UnimplementedError('themeModeProvider must be overridden');
});

