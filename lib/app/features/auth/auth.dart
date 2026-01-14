/// 认证模块导出
/// 包含登录、注册、登出等认证相关功能
library auth;

// 数据模型
export 'data/models/login_user_model.dart';
export 'data/models/coin_info_model.dart';

// 仓库
export 'data/repositories/auth_repository.dart';

// 状态管理
export 'presentation/providers/auth_providers.dart';

// 页面
export 'presentation/pages/login_page.dart';
export 'presentation/pages/register_page.dart';

