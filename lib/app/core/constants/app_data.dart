/// 应用数据资源常量
/// 统一管理应用中使用的本地数据文件路径
class AppData {
  AppData._(); // 私有构造函数，防止实例化

  /// 数据资源基础路径
  static const String _base = 'assets/data';

  // ==================== Mock 数据 ====================

  /// Mock 数据基础路径
  static const String _mockBase = '$_base/mock';

  /// Mock 用户数据
  static const String mockUsers = '$_mockBase/users.json';

  /// Mock 商品数据
  static const String mockProducts = '$_mockBase/products.json';

  /// Mock 订单数据
  static const String mockOrders = '$_mockBase/orders.json';

  /// Mock 分类数据
  static const String mockCategories = '$_mockBase/categories.json';

  /// Mock 评论数据
  static const String mockComments = '$_mockBase/comments.json';

  /// Mock 通知数据
  static const String mockNotifications = '$_mockBase/notifications.json';

  // ==================== 配置数据 ====================

  /// 配置数据基础路径
  static const String _configBase = '$_base/config';

  /// 国家列表
  static const String countries = '$_configBase/countries.json';

  /// 城市列表
  static const String cities = '$_configBase/cities.json';

  /// 语言列表
  static const String languages = '$_configBase/languages.json';

  /// 货币列表
  static const String currencies = '$_configBase/currencies.json';

  /// 时区列表
  static const String timezones = '$_configBase/timezones.json';

  /// 应用配置
  static const String appConfig = '$_configBase/app_config.json';

  /// 功能开关配置
  static const String featureFlags = '$_configBase/feature_flags.json';

  // ==================== 静态内容 ====================

  /// 静态内容基础路径
  static const String _contentBase = '$_base/content';

  /// 服务条款
  static const String termsOfService = '$_contentBase/terms_of_service.json';

  /// 隐私政策
  static const String privacyPolicy = '$_contentBase/privacy_policy.json';

  /// 关于我们
  static const String aboutUs = '$_contentBase/about_us.json';

  /// 常见问题
  static const String faq = '$_contentBase/faq.json';

  /// 帮助文档
  static const String helpDocs = '$_contentBase/help_docs.json';

  // ==================== 示例数据 ====================

  /// 示例数据基础路径
  static const String _sampleBase = '$_base/samples';

  /// 示例JSON
  static const String sampleJson = '$_sampleBase/sample.json';

  /// 演示数据
  static const String demoData = '$_sampleBase/demo.json';

  // ==================== 本地化数据 ====================

  /// 本地化数据基础路径
  static const String _localizationBase = '$_base/localization';

  /// 英文本地化
  static const String localizationEn = '$_localizationBase/en.json';

  /// 阿拉伯语本地化
  static const String localizationAr = '$_localizationBase/ar.json';

  // ==================== 预设数据 ====================

  /// 预设数据基础路径
  static const String _presetBase = '$_base/presets';

  /// 主题预设
  static const String themePresets = '$_presetBase/themes.json';

  /// 颜色预设
  static const String colorPresets = '$_presetBase/colors.json';

  /// 字体预设
  static const String fontPresets = '$_presetBase/fonts.json';

  // ==================== 工具方法 ====================

  /// 获取Mock数据路径
  /// [name] 数据文件名称（不含扩展名）
  static String getMockData(String name) {
    return '$_mockBase/$name.json';
  }

  /// 获取配置数据路径
  /// [name] 配置文件名称（不含扩展名）
  static String getConfigData(String name) {
    return '$_configBase/$name.json';
  }

  /// 获取内容数据路径
  /// [name] 内容文件名称（不含扩展名）
  static String getContentData(String name) {
    return '$_contentBase/$name.json';
  }

  /// 获取本地化数据路径
  /// [languageCode] 语言代码（如：'en', 'ar'）
  static String getLocalizationData(String languageCode) {
    return '$_localizationBase/$languageCode.json';
  }

  /// 获取预设数据路径
  /// [name] 预设文件名称（不含扩展名）
  static String getPresetData(String name) {
    return '$_presetBase/$name.json';
  }
}

