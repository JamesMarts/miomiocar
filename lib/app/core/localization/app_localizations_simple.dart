import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// 简化的国际化类
/// 临时使用，后续可以替换为完整的flutter_localizations
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// 从Context获取实例
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  /// 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  /// 本地化代理
  /// 包含自定义、本地化以及Material/Cupertino组件的本地化
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // 翻译字符串
  String get appName => 'Flutter Demo';
  String get home => locale.languageCode == 'ar' ? 'الرئيسية' : 'Home';
  String get discover => locale.languageCode == 'ar' ? 'اكتشف' : 'Discover';
  String get notifications => locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications';
  String get profile => locale.languageCode == 'ar' ? 'الملف الشخصي' : 'Profile';
  String get settings => locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings';
  String get language => locale.languageCode == 'ar' ? 'اللغة' : 'Language';
  String get themeMode => locale.languageCode == 'ar' ? 'وضع السمة' : 'Theme Mode';
  String get lightMode => locale.languageCode == 'ar' ? 'فاتح' : 'Light';
  String get darkMode => locale.languageCode == 'ar' ? 'داكن' : 'Dark';
  String get systemMode => locale.languageCode == 'ar' ? 'النظام' : 'System';
  String get english => 'English';
  String get arabic => 'العربية';
  String get loading => locale.languageCode == 'ar' ? 'جاري التحميل...' : 'Loading...';
  String get retry => locale.languageCode == 'ar' ? 'إعادة المحاولة' : 'Retry';
  String get cancel => locale.languageCode == 'ar' ? 'إلغاء' : 'Cancel';
  String get confirm => locale.languageCode == 'ar' ? 'تأكيد' : 'Confirm';
  String get save => locale.languageCode == 'ar' ? 'حفظ' : 'Save';
  String get delete => locale.languageCode == 'ar' ? 'حذف' : 'Delete';
  String get edit => locale.languageCode == 'ar' ? 'تعديل' : 'Edit';
  String get submit => locale.languageCode == 'ar' ? 'إرسال' : 'Submit';
  String get search => locale.languageCode == 'ar' ? 'بحث' : 'Search';
  String get noData => locale.languageCode == 'ar' ? 'لا توجد بيانات' : 'No data available';
  String get error => locale.languageCode == 'ar' ? 'خطأ' : 'Error';
  String get success => locale.languageCode == 'ar' ? 'نجح' : 'Success';
  String get networkError => locale.languageCode == 'ar' 
      ? 'خطأ في الشبكة. يرجى التحقق من الاتصال.' 
      : 'Network error. Please check your connection.';
  String get serverError => locale.languageCode == 'ar'
      ? 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقًا.'
      : 'Server error. Please try again later.';
  String get unknownError => locale.languageCode == 'ar'
      ? 'حدث خطأ غير معروف.'
      : 'An unknown error occurred.';
  String get welcome => locale.languageCode == 'ar' ? 'مرحبا' : 'Welcome';
  String get login => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get logout => locale.languageCode == 'ar' ? 'تسجيل الخروج' : 'Logout';
  String get username => locale.languageCode == 'ar' ? 'اسم المستخدم' : 'Username';
  String get password => locale.languageCode == 'ar' ? 'كلمة المرور' : 'Password';
  String get email => locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get phone => locale.languageCode == 'ar' ? 'الهاتف' : 'Phone';
  
  String userCount(int count) {
    return locale.languageCode == 'ar' ? '$count مستخدمين' : '$count users';
  }
  
  String helloUser(String name) {
    return locale.languageCode == 'ar' ? 'مرحبًا، $name!' : 'Hello, $name!';
  }
}

/// 国际化代理
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

