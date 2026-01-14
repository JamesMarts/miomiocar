/// API端点统一管理类
/// 所有API地址都在这里定义，便于维护和修改
class ApiEndpoints {
  ApiEndpoints._();

  // ==================== 首页相关 ====================

  /// 首页文章列表
  /// [page] 页码，从0开始
  static String articleList(int page) => '/article/list/$page/json';

  /// 首页Banner
  static const String homeBanner = '/banner/json';

  // ==================== 认证相关（玩Android API） ====================
  
  /// 登录
  /// 方法：POST
  /// 参数：username, password
  /// 返回：用户信息，登录后会在cookie中返回账号密码
  static const String login = '/user/login';
  
  /// 注册
  /// 方法：POST
  /// 参数：username, password, repassword
  static const String register = '/user/register';
  
  /// 登出
  /// 方法：GET
  static const String logout = '/user/logout/json';
  
  /// 获取个人积分（需要登录）
  /// 方法：GET
  static const String coinInfo = '/lg/coin/userinfo/json';
  
  /// 获取积分排行榜
  /// 方法：GET
  /// 参数：page，从1开始
  static String coinRank(int page) => '/coin/rank/$page/json';
  
  /// 获取个人积分列表
  /// 方法：GET
  /// 参数：page，从1开始
  static String coinList(int page) => '/lg/coin/list/$page/json';
  
  /// 获取个人收藏文章列表
  /// 方法：GET
  /// 参数：page，从0开始
  static String collectList(int page) => '/lg/collect/list/$page/json';
  
  /// 收藏站内文章
  /// 方法：POST
  /// 参数：id，文章id
  static String collectArticle(int id) => '/lg/collect/$id/json';
  
  /// 取消收藏文章（文章列表）
  /// 方法：POST
  /// 参数：id，文章id
  static String uncollectArticle(int id) => '/lg/uncollect_originId/$id/json';
  
  /// 取消收藏（我的收藏页面）
  /// 方法：POST
  /// 参数：id，originId（可选，收藏时文章的原始id）
  static String uncollectFromMyPage(int id) => '/lg/uncollect/$id/json';

  // ==================== 用户相关 ====================
  
  /// 获取当前用户信息
  static const String currentUser = '/user/profile';
  
  /// 更新用户信息
  static String updateUser(int userId) => '/user/$userId';
  
  /// 获取用户列表
  static const String userList = '/users';

  /// 获取指定用户信息
  static String userDetail(int userId) => '/users/$userId';

  /// 删除用户
  static String deleteUser(int userId) => '/users/$userId';

  /// 搜索用户
  static const String searchUsers = '/users/search';

  /// 上传用户头像
  static const String uploadAvatar = '/user/avatar';

  // ==================== 商品相关 ====================

  /// 获取商品列表
  static const String productList = '/products';

  /// 获取商品详情
  static String productDetail(int productId) => '/products/$productId';

  /// 创建商品
  static const String createProduct = '/products';

  /// 更新商品
  static String updateProduct(int productId) => '/products/$productId';

  /// 删除商品
  static String deleteProduct(int productId) => '/products/$productId';

  /// 搜索商品
  static const String searchProducts = '/products/search';

  /// 商品分类列表
  static const String productCategories = '/products/categories';

  // ==================== 订单相关 ====================

  /// 获取订单列表
  static const String orderList = '/orders';

  /// 获取订单详情
  static String orderDetail(int orderId) => '/orders/$orderId';

  /// 创建订单
  static const String createOrder = '/orders';

  /// 取消订单
  static String cancelOrder(int orderId) => '/orders/$orderId/cancel';

  /// 确认收货
  static String confirmOrder(int orderId) => '/orders/$orderId/confirm';

  // ==================== 购物车相关 ====================

  /// 获取购物车
  static const String cart = '/cart';

  /// 添加到购物车
  static const String addToCart = '/cart/add';

  /// 更新购物车项
  static String updateCartItem(int itemId) => '/cart/items/$itemId';

  /// 删除购物车项
  static String removeCartItem(int itemId) => '/cart/items/$itemId';

  /// 清空购物车
  static const String clearCart = '/cart/clear';

  // ==================== 收藏相关 ====================

  /// 获取收藏列表
  static const String favoriteList = '/favorites';

  /// 添加收藏
  static const String addFavorite = '/favorites';

  /// 取消收藏
  static String removeFavorite(int productId) => '/favorites/$productId';

  // ==================== 地址相关 ====================

  /// 获取地址列表
  static const String addressList = '/addresses';

  /// 获取地址详情
  static String addressDetail(int addressId) => '/addresses/$addressId';



}

