/// 用户实体
/// 领域层的纯业务模型，不依赖数据层
class UserEntity {
  /// 用户ID
  final int id;
  
  /// 用户名
  final String username;
  
  /// 邮箱
  final String email;
  
  /// 头像URL
  final String? avatarUrl;
  
  /// 昵称
  final String? nickname;
  
  /// 手机号
  final String? phone;
  
  /// 性别
  final Gender gender;
  
  /// 个人简介
  final String? bio;

  /// 构造函数
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.nickname,
    this.phone,
    this.gender = Gender.unknown,
    this.bio,
  });

  /// 获取显示名称
  String get displayName => nickname ?? username;

  /// 判断是否有头像
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// 判断是否有简介
  bool get hasBio => bio != null && bio!.isNotEmpty;

  @override
  String toString() {
    return 'UserEntity{id: $id, username: $username, email: $email}';
  }
}

/// 性别枚举
enum Gender {
  /// 未知
  unknown,
  
  /// 男
  male,
  
  /// 女
  female;

  /// 从整数转换
  static Gender fromInt(int? value) {
    switch (value) {
      case 1:
        return Gender.male;
      case 2:
        return Gender.female;
      default:
        return Gender.unknown;
    }
  }

  /// 转换为整数
  int toInt() {
    switch (this) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
      case Gender.unknown:
        return 0;
    }
  }
}

