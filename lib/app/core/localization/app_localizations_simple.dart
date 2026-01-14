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
  String get gender => locale.languageCode == 'ar' ? 'الجنس' : 'Gender';
  String get users => locale.languageCode == 'ar' ? 'المستخدمين' : 'Users';
  String get userDetail => locale.languageCode == 'ar' ? 'تفاصيل المستخدم' : 'User Detail';
  String get share => locale.languageCode == 'ar' ? 'مشاركة' : 'Share';
  String get message => locale.languageCode == 'ar' ? 'رسالة' : 'Message';
  String get follow => locale.languageCode == 'ar' ? 'متابعة' : 'Follow';
  String get posts => locale.languageCode == 'ar' ? 'المنشورات' : 'Posts';
  String get followers => locale.languageCode == 'ar' ? 'المتابعون' : 'Followers';
  String get following => locale.languageCode == 'ar' ? 'يتابع' : 'Following';
  String get joinDate => locale.languageCode == 'ar' ? 'تاريخ الانضمام' : 'Join Date';
  String get refresh => locale.languageCode == 'ar' ? 'تحديث' : 'Refresh';
  String get noMoreData => locale.languageCode == 'ar' ? 'لا يوجد المزيد من البيانات' : 'No more data';
  String get loadingMore => locale.languageCode == 'ar' ? 'جاري تحميل المزيد...' : 'Loading more...';
  String get searchHint => locale.languageCode == 'ar' ? 'بحث...' : 'Search...';
  String get noSearchResults => locale.languageCode == 'ar' ? 'لا توجد نتائج' : 'No results found';

  // ==================== 认证相关 ====================
  
  String get register => locale.languageCode == 'ar' ? 'تسجيل' : 'Register';
  String get confirmPassword => locale.languageCode == 'ar' ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get forgotPassword => locale.languageCode == 'ar' ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get noAccount => locale.languageCode == 'ar' ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get haveAccount => locale.languageCode == 'ar' ? 'لديك حساب بالفعل؟' : 'Already have an account?';
  String get loginSuccess => locale.languageCode == 'ar' ? 'تم تسجيل الدخول بنجاح' : 'Login successful';
  String get registerSuccess => locale.languageCode == 'ar' ? 'تم التسجيل بنجاح' : 'Registration successful';
  String get logoutSuccess => locale.languageCode == 'ar' ? 'تم تسجيل الخروج بنجاح' : 'Logout successful';
  String get loginFailed => locale.languageCode == 'ar' ? 'فشل تسجيل الدخول' : 'Login failed';
  String get registerFailed => locale.languageCode == 'ar' ? 'فشل التسجيل' : 'Registration failed';
  String get usernameRequired => locale.languageCode == 'ar' ? 'الرجاء إدخال اسم المستخدم' : 'Please enter username';
  String get passwordRequired => locale.languageCode == 'ar' ? 'الرجاء إدخال كلمة المرور' : 'Please enter password';
  String get confirmPasswordRequired => locale.languageCode == 'ar' ? 'الرجاء تأكيد كلمة المرور' : 'Please confirm password';
  String get passwordNotMatch => locale.languageCode == 'ar' ? 'كلمة المرور غير متطابقة' : 'Passwords do not match';
  String get usernameMinLength => locale.languageCode == 'ar' ? 'يجب أن يكون اسم المستخدم 3 أحرف على الأقل' : 'Username must be at least 3 characters';
  String get passwordMinLength => locale.languageCode == 'ar' ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل' : 'Password must be at least 6 characters';
  String get welcomeBack => locale.languageCode == 'ar' ? 'مرحبًا بعودتك' : 'Welcome Back';
  String get createAccount => locale.languageCode == 'ar' ? 'إنشاء حساب' : 'Create Account';
  String get signInToContinue => locale.languageCode == 'ar' ? 'سجل الدخول للمتابعة' : 'Sign in to continue';
  String get signUpToGetStarted => locale.languageCode == 'ar' ? 'سجل لتبدأ' : 'Sign up to get started';
  String get orContinueWith => locale.languageCode == 'ar' ? 'أو المتابعة باستخدام' : 'Or continue with';
  String get coins => locale.languageCode == 'ar' ? 'العملات' : 'Coins';
  String get level => locale.languageCode == 'ar' ? 'المستوى' : 'Level';
  String get rank => locale.languageCode == 'ar' ? 'الترتيب' : 'Rank';

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

