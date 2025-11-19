/// 应用图标资源常量
/// 统一管理应用中使用的所有图标路径
class AppIcons {
  AppIcons._(); // 私有构造函数，防止实例化

  // ==================== SVG 图标 ====================

  /// SVG 图标基础路径
  static const String _svgBase = 'assets/icons/svg';

  // 导航图标
  /// 首页图标
  static const String home = '$_svgBase/home.svg';

  /// 发现图标
  static const String discover = '$_svgBase/discover.svg';

  /// 通知图标
  static const String notifications = '$_svgBase/notifications.svg';

  /// 个人资料图标
  static const String profile = '$_svgBase/profile.svg';

  // 功能图标
  /// 设置图标
  static const String settings = '$_svgBase/settings.svg';

  /// 搜索图标
  static const String search = '$_svgBase/search.svg';

  /// 菜单图标
  static const String menu = '$_svgBase/menu.svg';

  /// 关闭图标
  static const String close = '$_svgBase/close.svg';

  /// 返回图标
  static const String back = '$_svgBase/back.svg';

  /// 添加图标
  static const String add = '$_svgBase/add.svg';

  /// 编辑图标
  static const String edit = '$_svgBase/edit.svg';

  /// 删除图标
  static const String delete = '$_svgBase/delete.svg';

  /// 分享图标
  static const String share = '$_svgBase/share.svg';

  /// 收藏图标
  static const String favorite = '$_svgBase/favorite.svg';

  /// 已收藏图标
  static const String favoriteFilled = '$_svgBase/favorite_filled.svg';

  /// 购物车图标
  static const String cart = '$_svgBase/cart.svg';

  /// 过滤器图标
  static const String filter = '$_svgBase/filter.svg';

  /// 排序图标
  static const String sort = '$_svgBase/sort.svg';

  /// 刷新图标
  static const String refresh = '$_svgBase/refresh.svg';

  /// 下载图标
  static const String download = '$_svgBase/download.svg';

  /// 上传图标
  static const String upload = '$_svgBase/upload.svg';

  /// 复制图标
  static const String copy = '$_svgBase/copy.svg';

  // 社交图标
  /// 点赞图标
  static const String like = '$_svgBase/like.svg';

  /// 已点赞图标
  static const String likeFilled = '$_svgBase/like_filled.svg';

  /// 评论图标
  static const String comment = '$_svgBase/comment.svg';

  /// 消息图标
  static const String message = '$_svgBase/message.svg';

  // 状态图标
  /// 成功图标
  static const String success = '$_svgBase/success.svg';

  /// 错误图标
  static const String error = '$_svgBase/error.svg';

  /// 警告图标
  static const String warning = '$_svgBase/warning.svg';

  /// 信息图标
  static const String info = '$_svgBase/info.svg';

  // 其他常用图标
  /// 电话图标
  static const String phone = '$_svgBase/phone.svg';

  /// 邮箱图标
  static const String email = '$_svgBase/email.svg';

  /// 定位图标
  static const String location = '$_svgBase/location.svg';

  /// 日历图标
  static const String calendar = '$_svgBase/calendar.svg';

  /// 时钟图标
  static const String clock = '$_svgBase/clock.svg';

  /// 眼睛图标（可见）
  static const String eye = '$_svgBase/eye.svg';

  /// 眼睛图标（不可见）
  static const String eyeOff = '$_svgBase/eye_off.svg';

  /// 锁图标
  static const String lock = '$_svgBase/lock.svg';

  /// 解锁图标
  static const String unlock = '$_svgBase/unlock.svg';

  /// 星星图标
  static const String star = '$_svgBase/star.svg';

  /// 已评分星星图标
  static const String starFilled = '$_svgBase/star_filled.svg';

  // ==================== PNG 图标 ====================

  /// PNG 图标基础路径
  static const String _pngBase = 'assets/icons/png';

  /// 应用Logo
  static const String logo = '$_pngBase/logo.png';

  /// 白色Logo
  static const String logoWhite = '$_pngBase/logo_white.png';

  /// 占位图标
  static const String placeholder = '$_pngBase/placeholder.png';

  // ==================== 第三方登录图标 ====================

  /// Google 图标
  static const String google = '$_pngBase/social/google.png';

  /// Facebook 图标
  static const String facebook = '$_pngBase/social/facebook.png';

  /// Twitter 图标
  static const String twitter = '$_pngBase/social/twitter.png';

  /// Apple 图标
  static const String apple = '$_pngBase/social/apple.png';

  // ==================== 工具方法 ====================

  /// 获取SVG图标路径
  /// [name] 图标名称（不含扩展名）
  static String getSvgIcon(String name) {
    return '$_svgBase/$name.svg';
  }

  /// 获取PNG图标路径
  /// [name] 图标名称（不含扩展名）
  static String getPngIcon(String name) {
    return '$_pngBase/$name.png';
  }
}







