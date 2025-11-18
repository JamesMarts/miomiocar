import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/app/config/app_config.dart';

/// 支持的语言列表
class SupportedLocales {
  /// 英语
  static const Locale english = Locale('en');
  
  /// 阿拉伯语
  static const Locale arabic = Locale('ar');
  
  /// 所有支持的语言列表
  static const List<Locale> all = [
    english,
    arabic,
  ];
  
  /// 默认语言
  static const Locale defaultLocale = english;
  
  /// 根据语言代码获取Locale
  static Locale? fromCode(String? code) {
    if (code == null) return null;
    
    switch (code) {
      case 'en':
        return english;
      case 'ar':
        return arabic;
      default:
        return null;
    }
  }
  
  /// 获取语言显示名称
  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }
}

/// 语言管理器
/// 负责语言的切换和持久化
class LocaleManager {
  final SharedPreferences _prefs;
  
  LocaleManager(this._prefs);
  
  /// 获取当前保存的语言
  Locale? getSavedLocale() {
    final code = _prefs.getString(AppConfig.storage.languageKey);
    return SupportedLocales.fromCode(code);
  }
  
  /// 保存语言设置
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(
      AppConfig.storage.languageKey,
      locale.languageCode,
    );
  }
  
  /// 清除语言设置
  Future<void> clearLocale() async {
    await _prefs.remove(AppConfig.storage.languageKey);
  }
}

/// 语言状态管理
/// 使用Riverpod管理当前语言状态
class LocaleNotifier extends StateNotifier<Locale> {
  final LocaleManager _manager;
  
  LocaleNotifier(this._manager) : super(_loadInitialLocale(_manager));
  
  /// 加载初始语言
  static Locale _loadInitialLocale(LocaleManager manager) {
    final savedLocale = manager.getSavedLocale();
    return savedLocale ?? SupportedLocales.defaultLocale;
  }
  
  /// 切换语言
  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    
    await _manager.saveLocale(locale);
    state = locale;
  }
  
  /// 重置为默认语言
  Future<void> resetToDefault() async {
    await _manager.clearLocale();
    state = SupportedLocales.defaultLocale;
  }
}

/// 语言Provider
/// 在DI模块中注册
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  throw UnimplementedError('localeProvider must be overridden');
});

