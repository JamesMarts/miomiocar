import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import '../../states/user_state.dart';
import '../../widgets/user_list_item.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Home Tab页面
/// 显示用户列表
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
      ref.read(userListProvider.notifier).loadUsers(refresh: true);
    });

    // 监听滚动，实现无限加载
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
        _scrollController.position.maxScrollExtent * 0.8) {
      // 滚动到底部80%时加载更多
      ref.read(userListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 跳转到设置页
              // context.goToSettings();
            },
          ),
        ],
      ),
      body: _buildBody(state, l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(userListProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// 构建主体内容
  Widget _buildBody(UserListState state, AppLocalizations l10n) {
    // 显示错误
    if (state.error != null && state.users.isEmpty) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () => ref.read(userListProvider.notifier).refresh(),
      );
    }

    // 首次加载
    if (state.isLoading && state.users.isEmpty) {
      return const AppLoadingWidget();
    }

    // 显示列表
    if (state.users.isEmpty) {
      return Center(
        child: Text(l10n.noData),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(userListProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.users.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 加载更多指示器
          if (index >= state.users.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final user = state.users[index];
          return UserListItem(
            user: user,
            onTap: () {
              // 跳转到用户详情页
              // context.goToUserDetail(user.id);
            },
          );
        },
      ),
    );
  }
}

