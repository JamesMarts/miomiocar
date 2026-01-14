import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/app/core/di/injector.dart';
import 'package:flutter_demo/app/core/error/app_exception.dart';
import 'package:flutter_demo/app/core/error/result.dart';
import 'package:flutter_demo/app/features/article/data/models/article_model.dart';
import 'package:flutter_demo/app/features/article/data/repositories/article_repository.dart';

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
  final AppException? error;

  const ArticleListState({
    this.articles = const [],
    this.currentPage = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
  });

  /// 初始状态
  factory ArticleListState.initial() => const ArticleListState();

  /// 复制并修改
  ArticleListState copyWith({
    List<ArticleModel>? articles,
    int? currentPage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    AppException? error,
    bool clearError = false,
  }) {
    return ArticleListState(
      articles: articles ?? this.articles,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// 是否有数据
  bool get hasData => articles.isNotEmpty;

  /// 是否有错误
  bool get hasError => error != null;
}

/// 文章列表状态管理
class ArticleListNotifier extends StateNotifier<ArticleListState> {
  final ArticleRepository _repository;

  ArticleListNotifier(this._repository) : super(ArticleListState.initial());

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
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    final page = refresh ? 0 : state.currentPage + 1;
    debugPrint('🔄 加载文章列表: page=$page, refresh=$refresh');

    final result = await _repository.getArticleList(page);

    result.when(
      success: (response) {
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
          clearError: true,
        );

        debugPrint('✅ 加载文章成功: 共${articles.length}篇');
      },
      failure: (exception) {
        debugPrint('❌ 加载文章失败: ${exception.message}');
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: exception,
        );
      },
    );
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
    final result = await _repository.collectArticle(articleId);

    return result.when(
      success: (_) {
        if (index < state.articles.length) {
          final articles = [...state.articles];
          articles[index] = articles[index].copyWith(collect: true);
          state = state.copyWith(articles: articles);
        }
        return true;
      },
      failure: (e) {
        debugPrint('❌ 收藏失败: ${e.message}');
        return false;
      },
    );
  }

  /// 取消收藏文章
  Future<bool> uncollectArticle(int articleId, int index) async {
    final result = await _repository.uncollectArticle(articleId);

    return result.when(
      success: (_) {
        if (index < state.articles.length) {
          final articles = [...state.articles];
          articles[index] = articles[index].copyWith(collect: false);
          state = state.copyWith(articles: articles);
        }
        return true;
      },
      failure: (e) {
        debugPrint('❌ 取消收藏失败: ${e.message}');
        return false;
      },
    );
  }
}

/// 文章列表 Provider
final articleListProvider =
    StateNotifierProvider<ArticleListNotifier, ArticleListState>((ref) {
  final repository = getIt<ArticleRepository>();
  return ArticleListNotifier(repository);
});

