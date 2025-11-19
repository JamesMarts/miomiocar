import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/presentation/states/article_state.dart';
import 'package:flutter_demo/app/presentation/widgets/article_list_item.dart';
import 'package:flutter_demo/app/presentation/widgets/loading_widget.dart';
import 'package:flutter_demo/app/presentation/widgets/error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home Tab页面
/// 显示玩Android首页文章列表
class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 首次加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articleListProvider.notifier).loadArticles(refresh: true);
    });

    // 监听滚动，实现加载更多
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 距离底部还有200像素时触发加载更多
      ref.read(articleListProvider.notifier).loadMore();
    }
  }

  /// 打开文章链接
  Future<void> _openArticle(String? url) async {
    if (url == null || url.isEmpty) return;
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('❌ 打开链接失败: $e');
    }
  }

  /// 切换收藏状态
  Future<void> _toggleFavorite(int? articleId, int index, bool isCollected) async {
    if (articleId == null) return;
    
    final notifier = ref.read(articleListProvider.notifier);

    if (isCollected) {
      // 取消收藏
      await notifier.uncollectArticle(articleId, index);
    } else {
      // 收藏
      await notifier.collectArticle(articleId, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final articleState = ref.watch(articleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        centerTitle: true,
      ),
      body: _buildBody(articleState, l10n),
    );
  }

  /// 构建主体内容
  Widget _buildBody(ArticleListState articleState, AppLocalizations l10n) {
    // 首次加载中
    if (articleState.isLoading && articleState.articles.isEmpty) {
      return const AppLoadingWidget();
    }

    // 错误状态（且没有数据）
    if (articleState.error != null && articleState.articles.isEmpty) {
      return AppErrorWidget(
        message: articleState.error!,
        onRetry: () {
          ref.read(articleListProvider.notifier).refresh();
        },
      );
    }

    // 空状态
    if (articleState.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noData,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 文章列表
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(articleListProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: articleState.articles.length + 1, // +1 用于底部加载更多提示
        itemBuilder: (context, index) {
          // 底部加载更多提示
          if (index == articleState.articles.length) {
            if (articleState.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (articleState.hasReachedEnd) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    '没有更多数据了',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          // 文章列表项
          final article = articleState.articles[index];
          return ArticleListItem(
            article: article,
            onTap: () => _openArticle(article.safeLink),
            onFavorite: () => _toggleFavorite(
              article.safeId,
              index,
              article.isCollected,
            ),
          );
        },
      ),
    );
  }
}

