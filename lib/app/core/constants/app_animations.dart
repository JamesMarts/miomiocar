/// 应用动画资源常量
/// 统一管理应用中使用的所有 Lottie 动画资源路径
class AppAnimations {
  AppAnimations._(); // 私有构造函数，防止实例化

  /// 动画资源基础路径
  static const String _base = 'assets/animations';

  // ==================== 加载动画 ====================

  /// 默认加载动画
  static const String loading = '$_base/loading.json';

  /// 圆形加载动画
  static const String loadingCircle = '$_base/loading_circle.json';

  /// 点状加载动画
  static const String loadingDots = '$_base/loading_dots.json';

  // ==================== 状态动画 ====================

  /// 成功动画
  static const String success = '$_base/success.json';

  /// 失败/错误动画
  static const String error = '$_base/error.json';

  /// 警告动画
  static const String warning = '$_base/warning.json';

  /// 信息动画
  static const String info = '$_base/info.json';

  // ==================== 空状态动画 ====================

  /// 通用空状态
  static const String empty = '$_base/empty.json';

  /// 空购物车
  static const String emptyCart = '$_base/empty_cart.json';

  /// 空搜索结果
  static const String emptySearch = '$_base/empty_search.json';

  /// 空收藏
  static const String emptyFavorite = '$_base/empty_favorite.json';

  /// 暂无数据
  static const String noData = '$_base/no_data.json';

  // ==================== 错误动画 ====================

  /// 网络错误
  static const String noNetwork = '$_base/no_network.json';

  /// 404 错误
  static const String error404 = '$_base/404.json';

  /// 500 错误
  static const String error500 = '$_base/500.json';

  // ==================== 功能动画 ====================

  /// 搜索动画
  static const String search = '$_base/search.json';

  /// 上传动画
  static const String upload = '$_base/upload.json';

  /// 下载动画
  static const String download = '$_base/download.json';

  /// 刷新动画
  static const String refresh = '$_base/refresh.json';

  /// 删除动画
  static const String delete = '$_base/delete.json';

  // ==================== 启动/引导动画 ====================

  /// 启动动画
  static const String splash = '$_base/splash.json';

  /// 欢迎动画
  static const String welcome = '$_base/welcome.json';

  // ==================== 交互动画 ====================

  /// 点赞动画
  static const String like = '$_base/like.json';

  /// 收藏动画
  static const String favorite = '$_base/favorite.json';

  /// 庆祝动画
  static const String celebrate = '$_base/celebrate.json';

  /// 鼓掌动画
  static const String clap = '$_base/clap.json';

  // ==================== 支付相关动画 ====================

  /// 支付成功
  static const String paymentSuccess = '$_base/payment_success.json';

  /// 支付处理中
  static const String paymentProcessing = '$_base/payment_processing.json';

  /// 支付失败
  static const String paymentFailed = '$_base/payment_failed.json';

  // ==================== 其他动画 ====================

  /// 扫描动画
  static const String scanning = '$_base/scanning.json';

  /// 定位动画
  static const String location = '$_base/location.json';

  /// 通知动画
  static const String notification = '$_base/notification.json';

  /// 邮件发送
  static const String mailSent = '$_base/mail_sent.json';

  // ==================== 工具方法 ====================

  /// 获取动画路径
  /// [name] 动画名称（不含扩展名）
  static String getAnimation(String name) {
    return '$_base/$name.json';
  }

  /// 检查动画是否存在
  /// [name] 动画名称（不含扩展名）
  /// 返回完整路径或默认加载动画
  static String getAnimationOrDefault(String name) {
    final path = '$_base/$name.json';
    // 在实际使用中，可以检查文件是否存在
    // 这里简化为直接返回路径，如果不存在会fallback到loading
    return path;
  }
}







