import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/data/models/article_model.dart';
import 'package:flutter_demo/app/data/repositories/article_repository.dart';

/// 文章列表状态
class ArticleListState {
  /// 文章列表
  final List<ArticleModel> articles;

  /// 当前页码
  final int currentPage;

  /// 是否正在加载
  final bool isLoading;

  /// 是否正在加载更多
  final bool isLoadingMore;

  /// 是否已到达末尾
  final bool hasReachedEnd;

  /// 错误信息
  final String? error;

  const ArticleListState({
    this.articles = const [],
    this.currentPage = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
  });

  /// 复制并修改
  ArticleListState copyWith({
    List<ArticleModel>? articles,
    int? currentPage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? error,
  }) {
    return ArticleListState(
      articles: articles ?? this.articles,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
    );
  }
}

/// 文章列表状态管理
class ArticleListNotifier extends StateNotifier<ArticleListState> {
  final ArticleRepository _repository;

  ArticleListNotifier(this._repository) : super(const ArticleListState());

  /// 加载首页文章列表
  Future<void> loadArticles({bool refresh = false}) async {
    // 如果正在加载，直接返回
    if (state.isLoading || state.isLoadingMore) {
      return;
    }

    // 如果是刷新，重置状态
    if (refresh) {
      state = const ArticleListState(isLoading: true);
    } else {
      // 如果已到达末尾，不再加载
      if (state.hasReachedEnd) {
        return;
      }
      state = state.copyWith(isLoadingMore: true, error: null);
    }

    try {
      final page = refresh ? 0 : state.currentPage + 1;
      debugPrint('🔄 加载文章列表: page=$page, refresh=$refresh');

      final response = await _repository.getArticleList(page);

      // 合并数据
      final newArticles = response.datas ?? [];
      final articles = refresh
          ? newArticles
          : [...state.articles, ...newArticles];

      state = state.copyWith(
        articles: articles,
        currentPage: page,
        isLoading: false,
        isLoadingMore: false,
        hasReachedEnd: response.over ?? false,
        error: null,
      );

      debugPrint('✅ 加载文章成功: 共${articles.length}篇');
    } catch (e) {
      debugPrint('❌ 加载文章失败: $e');
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await loadArticles(refresh: true);
  }

  /// 加载更多
  Future<void> loadMore() async {
    await loadArticles(refresh: false);
  }

  /// 收藏文章
  Future<bool> collectArticle(int articleId, int index) async {
    try {
      final success = await _repository.collectArticle(articleId);
      if (success && index < state.articles.length) {
        // 更新本地状态 - 使用copyWith创建新对象
        final articles = [...state.articles];
        final oldArticle = articles[index];
        
        // 创建更新后的文章对象
        final updatedArticle = ArticleModel(
          author: oldArticle.author,
          shareUser: oldArticle.shareUser,
          id: oldArticle.id,
          link: oldArticle.link,
          envelopePic: oldArticle.envelopePic,
          title: oldArticle.title,
          desc: oldArticle.desc,
          chapterName: oldArticle.chapterName,
          chapterId: oldArticle.chapterId,
          superChapterName: oldArticle.superChapterName,
          superChapterId: oldArticle.superChapterId,
          publishTime: oldArticle.publishTime,
          collect: true, // 更新收藏状态
          fresh: oldArticle.fresh,
          type: oldArticle.type,
          userId: oldArticle.userId,
          visible: oldArticle.visible,
          top: oldArticle.top,
          tags: oldArticle.tags,
        );
        
        articles[index] = updatedArticle;
        state = state.copyWith(articles: articles);
      }
      return success;
    } catch (e) {
      debugPrint('❌ 收藏失败: $e');
      return false;
    }
  }

  /// 取消收藏文章
  Future<bool> uncollectArticle(int articleId, int index) async {
    try {
      final success = await _repository.uncollectArticle(articleId);
      if (success && index < state.articles.length) {
        // 更新本地状态
        final articles = [...state.articles];
        final oldArticle = articles[index];
        
        // 创建更新后的文章对象
        final updatedArticle = ArticleModel(
          author: oldArticle.author,
          shareUser: oldArticle.shareUser,
          id: oldArticle.id,
          link: oldArticle.link,
          envelopePic: oldArticle.envelopePic,
          title: oldArticle.title,
          desc: oldArticle.desc,
          chapterName: oldArticle.chapterName,
          chapterId: oldArticle.chapterId,
          superChapterName: oldArticle.superChapterName,
          superChapterId: oldArticle.superChapterId,
          publishTime: oldArticle.publishTime,
          collect: false, // 更新收藏状态
          fresh: oldArticle.fresh,
          type: oldArticle.type,
          userId: oldArticle.userId,
          visible: oldArticle.visible,
          top: oldArticle.top,
          tags: oldArticle.tags,
        );
        
        articles[index] = updatedArticle;
        state = state.copyWith(articles: articles);
      }
      return success;
    } catch (e) {
      debugPrint('❌ 取消收藏失败: $e');
      return false;
    }
  }
}

/// 文章列表 Provider
final articleListProvider =
    StateNotifierProvider<ArticleListNotifier, ArticleListState>((ref) {
  final repository = getIt<ArticleRepository>();
  return ArticleListNotifier(repository);
});

