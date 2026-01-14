import 'package:json_annotation/json_annotation.dart';

part 'coin_info_model.g.dart';

/// 积分信息模型
/// 玩Android API 获取个人积分返回的数据
@JsonSerializable()
class CoinInfoModel {
  /// 积分数量
  @JsonKey(name: 'coinCount')
  final int coinCount;

  /// 等级
  final int level;

  /// 昵称
  final String nickname;

  /// 排名
  final String rank;

  /// 用户ID
  @JsonKey(name: 'userId')
  final int userId;

  /// 用户名
  final String username;

  /// 构造函数
  const CoinInfoModel({
    required this.coinCount,
    required this.level,
    required this.nickname,
    required this.rank,
    required this.userId,
    required this.username,
  });

  /// 从JSON创建
  factory CoinInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CoinInfoModelFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$CoinInfoModelToJson(this);

  @override
  String toString() {
    return 'CoinInfoModel{userId: $userId, coinCount: $coinCount, level: $level}';
  }
}

