import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

/// 文章列表响应模型
@JsonSerializable()
class ArticleListResponse {
  /// 当前页码
  @JsonKey(name: 'curPage')
  final int? curPage;

  /// 数据列表
  @JsonKey(name: 'datas')
  final List<ArticleModel>? datas;

  /// 偏移量
  final int? offset;

  /// 是否结束
  final bool? over;

  /// 每页大小
  @JsonKey(name: 'pageCount')
  final int? pageCount;

  /// 总数
  final int? size;

  /// 总数
  final int? total;

  ArticleListResponse({
    this.curPage,
    this.datas,
    this.offset,
    this.over,
    this.pageCount,
    this.size,
    this.total,
  });

  /// 从JSON创建
  factory ArticleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleListResponseFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ArticleListResponseToJson(this);
}

/// 文章模型
@JsonSerializable()
class ArticleModel {
  /// 作者
  final String? author;

  /// 分享人
  @JsonKey(name: 'shareUser')
  final String? shareUser;

  /// 文章ID
  final int? id;

  /// 文章链接
  final String? link;

  /// 随机图片链接
  @JsonKey(name: 'envelopePic')
  final String? envelopePic;

  /// 文章标题
  final String? title;

  /// 文章描述
  @JsonKey(name: 'desc')
  final String? desc;

  /// 分类名称
  @JsonKey(name: 'chapterName')
  final String? chapterName;

  /// 分类ID
  @JsonKey(name: 'chapterId')
  final int? chapterId;

  /// 超级分类名称
  @JsonKey(name: 'superChapterName')
  final String? superChapterName;

  /// 超级分类ID
  @JsonKey(name: 'superChapterId')
  final int? superChapterId;

  /// 发布时间戳
  @JsonKey(name: 'publishTime')
  final int? publishTime;

  /// 是否收藏
  final bool? collect;

  /// 是否新文章
  final bool? fresh;

  /// 文章类型
  final int? type;

  /// 用户ID
  @JsonKey(name: 'userId')
  final int? userId;

  /// 可见性
  final int? visible;

  /// 置顶
  final int? top;

  /// 标签
  final List<ArticleTag>? tags;

  ArticleModel({
    this.author,
    this.shareUser,
    this.id,
    this.link,
    this.envelopePic,
    this.title,
    this.desc,
    this.chapterName,
    this.chapterId,
    this.superChapterName,
    this.superChapterId,
    this.publishTime,
    this.collect,
    this.fresh,
    this.type,
    this.userId,
    this.visible,
    this.top,
    this.tags,
  });

  /// 从JSON创建
  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  /// 获取作者名称（优先显示shareUser）
  String get authorName {
    if (shareUser?.isNotEmpty == true) {
      return shareUser!;
    }
    return author ?? '未知作者';
  }

  /// 获取格式化的发布时间
  String get formattedTime {
    if (publishTime == null) return '未知时间';
    
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(publishTime!);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 365) {
        return '${(diff.inDays / 365).floor()}年前';
      } else if (diff.inDays > 30) {
        return '${(diff.inDays / 30).floor()}个月前';
      } else if (diff.inDays > 0) {
        return '${diff.inDays}天前';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}小时前';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}分钟前';
      } else {
        return '刚刚';
      }
    } catch (e) {
      return '未知时间';
    }
  }

  /// 获取完整分类路径
  String get fullCategory {
    if (superChapterName != null && superChapterName!.isNotEmpty) {
      return '$superChapterName / ${chapterName ?? ''}';
    }
    return chapterName ?? '未分类';
  }

  /// 获取标题（带默认值）
  String get safeTitle => title ?? '无标题';

  /// 获取链接（带默认值）
  String get safeLink => link ?? '';

  /// 获取ID（带默认值）
  int get safeId => id ?? 0;

  /// 是否已收藏（带默认值）
  bool get isCollected => collect ?? false;
}

/// 文章标签模型
@JsonSerializable()
class ArticleTag {
  /// 标签名称
  final String name;

  /// 标签URL
  final String url;

  ArticleTag({
    required this.name,
    required this.url,
  });

  /// 从JSON创建
  factory ArticleTag.fromJson(Map<String, dynamic> json) =>
      _$ArticleTagFromJson(json);

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$ArticleTagToJson(this);
}

