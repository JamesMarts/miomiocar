/// 用户实体
/// 领域层的纯业务模型，不依赖数据层
/// 可以添加业务逻辑方法
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

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  /// 获取显示名称
  String get displayName => nickname?.isNotEmpty == true ? nickname! : username;

  /// 是否有头像
  bool get hasAvatar => avatarUrl?.isNotEmpty == true;

  /// 是否有简介
  bool get hasBio => bio?.isNotEmpty == true;

  /// 是否有手机号
  bool get hasPhone => phone?.isNotEmpty == true;

  /// 获取头像首字母（用于默认头像）
  String get avatarInitial {
    if (nickname?.isNotEmpty == true) {
      return nickname![0].toUpperCase();
    }
    return username.isNotEmpty ? username[0].toUpperCase() : '?';
  }

  /// 复制并修改
  UserEntity copyWith({
    int? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? nickname,
    String? phone,
    Gender? gender,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserEntity{id: $id, username: $username, displayName: $displayName}';
  }
}

/// 性别枚举
enum Gender {
  /// 未知
  unknown(0),

  /// 男
  male(1),

  /// 女
  female(2);

  /// 数值
  final int value;

  const Gender(this.value);

  /// 从数值创建
  factory Gender.fromValue(int? value) {
    return switch (value) {
      1 => Gender.male,
      2 => Gender.female,
      _ => Gender.unknown,
    };
  }

  /// 获取显示文本
  String get displayText {
    return switch (this) {
      Gender.male => 'Male',
      Gender.female => 'Female',
      Gender.unknown => 'Unknown',
    };
  }
}

