/// 用户模块导出文件
/// 统一导出用户模块的所有公开API
library user;

// ============ Data Layer ============

/// Models
export 'data/models/user_model.dart';

/// Repositories
export 'data/repositories/user_repository.dart';

// ============ Domain Layer ============

/// Entities
export 'domain/entities/user_entity.dart';

/// Use Cases
export 'domain/usecases/get_user_usecase.dart';

// ============ Presentation Layer ============

/// Providers
export 'presentation/providers/user_providers.dart';

/// Pages
export 'presentation/pages/user_list_page.dart';
export 'presentation/pages/user_detail_page.dart';

/// Widgets
export 'presentation/widgets/user_list_item.dart';

