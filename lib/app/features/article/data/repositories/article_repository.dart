import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/error/result.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/network/api_endpoints.dart';
import 'package:flutter_demo/app/features/article/data/models/article_model.dart';

/// 文章仓库
/// 负责文章相关的数据获取和操作
class ArticleRepository {
  /// Dio客户端
  final DioClient _client;

  /// 构造函数
  ArticleRepository(this._client);

  /// 获取首页文章列表
  /// [page] 页码，从0开始
  /// 返回 Result 类型
  Future<Result<ArticleListResponse>> getArticleList(int page) async {
    return Result.fromAsync(() async {
      debugPrint('📡 正在获取首页文章列表: page=$page');

      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.articleList(page),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final response = ArticleListResponse.fromJson(data);
      debugPrint('✅ 获取文章列表成功: ${response.datas?.length ?? 0} 篇');
      return response;
    });
  }

  /// 获取首页Banner
  /// 返回 Result 类型
  Future<Result<List<Map<String, dynamic>>>> getHomeBanner() async {
    return Result.fromAsync(() async {
      debugPrint('📡 正在获取首页Banner');

      final data = await _client.get<List<dynamic>>(
        ApiEndpoints.homeBanner,
        fromJson: (json) => json as List<dynamic>,
      );

      debugPrint('✅ 获取Banner成功: ${data.length} 个');
      return data.map((item) => item as Map<String, dynamic>).toList();
    });
  }

  /// 收藏文章
  /// [articleId] 文章ID
  /// 返回 Result 类型
  Future<Result<bool>> collectArticle(int articleId) async {
    return Result.fromAsync(() async {
      debugPrint('📡 正在收藏文章: articleId=$articleId');

      await _client.post<Map<String, dynamic>>(
        '/lg/collect/$articleId/json',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 收藏文章成功');
      return true;
    });
  }

  /// 取消收藏文章
  /// [articleId] 文章ID
  /// 返回 Result 类型
  Future<Result<bool>> uncollectArticle(int articleId) async {
    return Result.fromAsync(() async {
      debugPrint('📡 正在取消收藏文章: articleId=$articleId');

      await _client.post<Map<String, dynamic>>(
        '/lg/uncollect_originId/$articleId/json',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 取消收藏成功');
      return true;
    });
  }

  // ============ 兼容旧API ============

  /// 获取文章列表（旧版API）
  @Deprecated('Use getArticleList instead')
  Future<ArticleListResponse> getArticleListLegacy(int page) async {
    final result = await getArticleList(page);
    return result.getOrThrow();
  }

  /// 收藏文章（旧版API）
  @Deprecated('Use collectArticle instead')
  Future<bool> collectArticleLegacy(int articleId) async {
    final result = await collectArticle(articleId);
    return result.getOrElse(false);
  }

  /// 取消收藏（旧版API）
  @Deprecated('Use uncollectArticle instead')
  Future<bool> uncollectArticleLegacy(int articleId) async {
    final result = await uncollectArticle(articleId);
    return result.getOrElse(false);
  }
}

