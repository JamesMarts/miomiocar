// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Flutter Demo';

  @override
  String get home => 'الرئيسية';

  @override
  String get discover => 'اكتشف';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'وضع السمة';

  @override
  String get lightMode => 'فاتح';

  @override
  String get darkMode => 'داكن';

  @override
  String get systemMode => 'النظام';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get submit => 'إرسال';

  @override
  String get search => 'بحث';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get networkError => 'خطأ في الشبكة. يرجى التحقق من الاتصال.';

  @override
  String get serverError => 'خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get unknownError => 'حدث خطأ غير معروف.';

  @override
  String get welcome => 'مرحبا';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String userCount(int count) {
    return '$count مستخدمين';
  }

  @override
  String helloUser(String name) {
    return 'مرحبًا، $name!';
  }
}
