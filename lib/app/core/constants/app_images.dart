/// 应用图片资源常量
/// 统一管理应用中使用的所有图片资源路径
class AppImages {
  AppImages._(); // 私有构造函数，防止实例化

  /// 图片资源基础路径
  static const String _base = 'assets/images';

  // ==================== Logo ====================

  /// 应用Logo
  static const String logo = '$_base/logo.png';

  /// 白色Logo
  static const String logoWhite = '$_base/logo_white.png';

  /// Logo文字版
  static const String logoText = '$_base/logo_text.png';

  // ==================== 背景图片 ====================

  /// 背景图片基础路径
  static const String _bgBase = '$_base/backgrounds';

  /// 登录页背景
  static const String bgLogin = '$_bgBase/bg_login.jpg';

  /// 启动页背景
  static const String bgSplash = '$_bgBase/bg_splash.png';

  /// 个人资料背景
  static const String bgProfile = '$_bgBase/bg_profile.jpg';

  /// 主背景图
  static const String bgMain = '$_bgBase/bg_main.jpg';

  // ==================== 占位图 ====================

  /// 占位图基础路径
  static const String _placeholderBase = '$_base/placeholders';

  /// 头像占位图
  static const String placeholderAvatar = '$_placeholderBase/avatar.png';

  /// 图片占位图
  static const String placeholderImage = '$_placeholderBase/image.png';

  /// 商品占位图
  static const String placeholderProduct = '$_placeholderBase/product.png';

  /// 封面占位图
  static const String placeholderCover = '$_placeholderBase/cover.png';

  /// 缩略图占位图
  static const String placeholderThumbnail = '$_placeholderBase/thumbnail.png';

  // ==================== 空状态插图 ====================

  /// 插图基础路径
  static const String _illustrationBase = '$_base/illustrations';

  /// 空购物车
  static const String emptyCart = '$_illustrationBase/empty_cart.png';

  /// 空搜索结果
  static const String emptySearch = '$_illustrationBase/empty_search.png';

  /// 空通知
  static const String emptyNotification = '$_illustrationBase/empty_notification.png';

  /// 空收藏
  static const String emptyFavorite = '$_illustrationBase/empty_favorite.png';

  /// 空订单
  static const String emptyOrder = '$_illustrationBase/empty_order.png';

  /// 空消息
  static const String emptyMessage = '$_illustrationBase/empty_message.png';

  /// 暂无数据
  static const String noData = '$_illustrationBase/no_data.png';

  // ==================== 错误插图 ====================

  /// 网络错误
  static const String errorNetwork = '$_illustrationBase/error_network.png';

  /// 404错误
  static const String error404 = '$_illustrationBase/error_404.png';

  /// 500错误
  static const String error500 = '$_illustrationBase/error_500.png';

  /// 通用错误
  static const String errorGeneral = '$_illustrationBase/error_general.png';

  // ==================== Banner ====================

  /// Banner基础路径
  static const String _bannerBase = '$_base/banners';

  /// 默认Banner
  static const String bannerDefault = '$_bannerBase/default.jpg';

  /// 促销Banner 1
  static const String bannerPromo1 = '$_bannerBase/promo_1.jpg';

  /// 促销Banner 2
  static const String bannerPromo2 = '$_bannerBase/promo_2.jpg';

  /// 促销Banner 3
  static const String bannerPromo3 = '$_bannerBase/promo_3.jpg';

  // ==================== 引导页 ====================

  /// 引导页基础路径
  static const String _onboardingBase = '$_base/onboarding';

  /// 引导页 1
  static const String onboarding1 = '$_onboardingBase/onboarding_1.png';

  /// 引导页 2
  static const String onboarding2 = '$_onboardingBase/onboarding_2.png';

  /// 引导页 3
  static const String onboarding3 = '$_onboardingBase/onboarding_3.png';

  // ==================== 产品图片（示例） ====================

  /// 产品图片基础路径
  static const String _productBase = '$_base/products';

  /// 产品示例图 1
  static const String productSample1 = '$_productBase/sample_1.jpg';

  /// 产品示例图 2
  static const String productSample2 = '$_productBase/sample_2.jpg';

  /// 产品示例图 3
  static const String productSample3 = '$_productBase/sample_3.jpg';

  // ==================== 分类图标 ====================

  /// 分类图标基础路径
  static const String _categoryBase = '$_base/categories';

  /// 电子产品分类
  static const String categoryElectronics = '$_categoryBase/electronics.png';

  /// 服装分类
  static const String categoryClothing = '$_categoryBase/clothing.png';

  /// 食品分类
  static const String categoryFood = '$_categoryBase/food.png';

  /// 图书分类
  static const String categoryBooks = '$_categoryBase/books.png';

  // ==================== 成就徽章 ====================

  /// 徽章基础路径
  static const String _badgeBase = '$_base/badges';

  /// 新手徽章
  static const String badgeNewbie = '$_badgeBase/newbie.png';

  /// 活跃徽章
  static const String badgeActive = '$_badgeBase/active.png';

  /// VIP徽章
  static const String badgeVip = '$_badgeBase/vip.png';

  /// 认证徽章
  static const String badgeVerified = '$_badgeBase/verified.png';

  // ==================== 支付方式图标 ====================

  /// 支付方式基础路径
  static const String _paymentBase = '$_base/payment';

  /// 信用卡
  static const String paymentCreditCard = '$_paymentBase/credit_card.png';

  /// PayPal
  static const String paymentPaypal = '$_paymentBase/paypal.png';

  /// Apple Pay
  static const String paymentApplePay = '$_paymentBase/apple_pay.png';

  /// Google Pay
  static const String paymentGooglePay = '$_paymentBase/google_pay.png';

  // ==================== 工具方法 ====================

  /// 获取背景图片路径
  /// [name] 图片名称（不含扩展名）
  static String getBackground(String name) {
    return '$_bgBase/$name.jpg';
  }

  /// 获取占位图路径
  /// [name] 图片名称（不含扩展名）
  static String getPlaceholder(String name) {
    return '$_placeholderBase/$name.png';
  }

  /// 获取插图路径
  /// [name] 图片名称（不含扩展名）
  static String getIllustration(String name) {
    return '$_illustrationBase/$name.png';
  }

  /// 获取Banner路径
  /// [name] 图片名称（不含扩展名）
  static String getBanner(String name) {
    return '$_bannerBase/$name.jpg';
  }

  /// 获取产品图片路径
  /// [name] 图片名称（不含扩展名）
  static String getProduct(String name) {
    return '$_productBase/$name.jpg';
  }
}







