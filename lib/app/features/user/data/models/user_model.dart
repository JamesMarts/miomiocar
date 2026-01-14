import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// 用户模型
/// 使用json_serializable自动生成序列化代码
@JsonSerializable()
class UserModel {
  /// 用户ID
  final int id;

  /// 用户名
  final String username;

  /// 邮箱
  final String email;

  /// 头像URL
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// 昵称
  final String? nickname;

  /// 手机号
  final String? phone;

  /// 性别（0: 未知, 1: 男, 2: 女）
  final int? gender;

  /// 个人简介
  final String? bio;

  /// 创建时间
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  /// 构造函数
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.nickname,
    this.phone,
    this.gender,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  /// 从JSON创建
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// 复制并修改
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? nickname,
    String? phone,
    int? gender,
    String? bio,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
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

  /// 获取显示名称（优先显示昵称，否则显示用户名）
  String get displayName => nickname ?? username;

  /// 获取性别文本
  String get genderText {
    switch (gender) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

