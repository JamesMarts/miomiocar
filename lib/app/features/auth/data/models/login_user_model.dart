import 'package:json_annotation/json_annotation.dart';

part 'login_user_model.g.dart';

/// 登录用户模型
/// 玩Android API 登录/注册成功后返回的用户信息
/// 注意：注册接口返回的数据中不包含 level 和 rank 字段
@JsonSerializable()
class LoginUserModel {
  /// 是否为管理员
  @JsonKey(defaultValue: false)
  final bool admin;

  /// 章节ID列表
  @JsonKey(defaultValue: [])
  final List<int> chapterTops;

  /// 收藏ID列表
  @JsonKey(name: 'collectIds', defaultValue: [])
  final List<int> collectIds;

  /// 邮箱
  @JsonKey(defaultValue: '')
  final String email;

  /// 图标
  @JsonKey(defaultValue: '')
  final String icon;

  /// 用户ID
  final int id;

  /// 昵称
  @JsonKey(defaultValue: '')
  final String nickname;

  /// 密码（加密后）
  @JsonKey(defaultValue: '')
  final String password;

  /// 公开名称
  @JsonKey(defaultValue: '')
  final String publicName;

  /// Token
  @JsonKey(defaultValue: '')
  final String token;

  /// 用户类型
  @JsonKey(defaultValue: 0)
  final int type;

  /// 用户名
  final String username;

  /// 积分
  @JsonKey(name: 'coinCount', defaultValue: 0)
  final int coinCount;

  /// 等级（注册接口可能不返回此字段）
  @JsonKey(name: 'level', defaultValue: 0)
  final int level;

  /// 排名（注册接口可能不返回此字段）
  @JsonKey(name: 'rank', defaultValue: '-')
  final String rank;

  /// 构造函数
  const LoginUserModel({
    required this.admin,
    required this.chapterTops,
    required this.collectIds,
    required this.email,
    required this.icon,
    required this.id,
    required this.nickname,
    required this.password,
    required this.publicName,
    required this.token,
    required this.type,
    required this.username,
    required this.coinCount,
    required this.level,
    required this.rank,
  });

  /// 从JSON创建
  factory LoginUserModel.fromJson(Map<String, dynamic> json) =>
      _$LoginUserModelFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$LoginUserModelToJson(this);

  /// 获取显示名称（优先显示昵称，否则显示用户名）
  String get displayName => nickname.isNotEmpty ? nickname : username;

  /// 复制并修改
  LoginUserModel copyWith({
    bool? admin,
    List<int>? chapterTops,
    List<int>? collectIds,
    String? email,
    String? icon,
    int? id,
    String? nickname,
    String? password,
    String? publicName,
    String? token,
    int? type,
    String? username,
    int? coinCount,
    int? level,
    String? rank,
  }) {
    return LoginUserModel(
      admin: admin ?? this.admin,
      chapterTops: chapterTops ?? this.chapterTops,
      collectIds: collectIds ?? this.collectIds,
      email: email ?? this.email,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
      publicName: publicName ?? this.publicName,
      token: token ?? this.token,
      type: type ?? this.type,
      username: username ?? this.username,
      coinCount: coinCount ?? this.coinCount,
      level: level ?? this.level,
      rank: rank ?? this.rank,
    );
  }

  @override
  String toString() {
    return 'LoginUserModel{id: $id, username: $username, nickname: $nickname}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginUserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
