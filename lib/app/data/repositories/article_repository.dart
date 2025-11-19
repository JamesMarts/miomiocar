import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/core/network/api_exception.dart';
import 'package:flutter_demo/app/core/network/api_endpoints.dart';
import 'package:flutter_demo/app/data/models/article_model.dart';

/// 文章仓库
/// 负责文章相关的数据获取和操作
class ArticleRepository {
  /// Dio客户端
  final DioClient _client;

  /// 构造函数
  ArticleRepository(this._client);

  /// 获取首页文章列表
  /// [page] 页码，从0开始
  /// 返回文章列表响应
  Future<ArticleListResponse> getArticleList(int page) async {
    try {
      debugPrint('📡 正在获取首页文章列表: page=$page');

      final data = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.articleList(page),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final response = ArticleListResponse.fromJson(data);
      debugPrint('✅ 获取文章列表成功: ${response.datas?.length ?? 0} 篇');
      return response;
    } on ApiException catch (e) {
      debugPrint('❌ 获取文章列表失败: ${e.message}');
      rethrow;
    }
  }

  /// 获取首页Banner
  /// 返回Banner列表
  Future<List<Map<String, dynamic>>> getHomeBanner() async {
    try {
      debugPrint('📡 正在获取首页Banner');

      final data = await _client.get<List<dynamic>>(
        ApiEndpoints.homeBanner,
        fromJson: (json) => json as List<dynamic>,
      );

      debugPrint('✅ 获取Banner成功: ${data.length} 个');
      return data.map((item) => item as Map<String, dynamic>).toList();
    } on ApiException catch (e) {
      debugPrint('❌ 获取Banner失败: ${e.message}');
      rethrow;
    }
  }

  /// 收藏文章
  /// [articleId] 文章ID
  /// 返回是否成功
  Future<bool> collectArticle(int articleId) async {
    try {
      debugPrint('📡 正在收藏文章: articleId=$articleId');

      await _client.post<Map<String, dynamic>>(
        '/lg/collect/$articleId/json',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 收藏文章成功');
      return true;
    } on ApiException catch (e) {
      debugPrint('❌ 收藏文章失败: ${e.message}');
      return false;
    }
  }

  /// 取消收藏文章
  /// [articleId] 文章ID
  /// 返回是否成功
  Future<bool> uncollectArticle(int articleId) async {
    try {
      debugPrint('📡 正在取消收藏文章: articleId=$articleId');

      await _client.post<Map<String, dynamic>>(
        '/lg/uncollect_originId/$articleId/json',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      debugPrint('✅ 取消收藏成功');
      return true;
    } on ApiException catch (e) {
      debugPrint('❌ 取消收藏失败: ${e.message}');
      return false;
    }
  }
}

