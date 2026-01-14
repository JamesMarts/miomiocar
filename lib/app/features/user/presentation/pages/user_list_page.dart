import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/core/error/error_handler.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';
import 'package:flutter_demo/app/features/user/presentation/providers/user_providers.dart';
import 'package:flutter_demo/app/features/user/presentation/widgets/user_list_item.dart';
import 'package:flutter_demo/app/core/widgets/loading/loading_widget.dart';
import 'package:flutter_demo/app/core/widgets/error/error_widget.dart';
import 'package:flutter_demo/app/core/widgets/empty/empty_widget.dart';

/// 用户列表页面
class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 首次加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userListProvider.notifier).loadUsers();
    });

    // 添加滚动监听（加载更多）
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动监听
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(userListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.users),
        actions: [
          /// 搜索按钮
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: _buildBody(context, state, l10n),
    );
  }

  /// 构建主体内容
  Widget _buildBody(BuildContext context, UserListState state, AppLocalizations l10n) {
    // 首次加载中
    if (state.isLoading && state.users.isEmpty) {
      return const AppLoadingWidget();
    }

    // 错误状态（无数据时显示）
    if (state.hasError && state.users.isEmpty) {
      return AppErrorWidget(
        message: ErrorHandler.getUserFriendlyMessage(state.error!),
        onRetry: () => ref.read(userListProvider.notifier).refresh(),
      );
    }

    // 空状态
    if (state.isEmpty) {
      return AppEmptyWidget(
        message: l10n.noData,
        icon: Icons.person_off_outlined,
        onAction: () => ref.read(userListProvider.notifier).refresh(),
        actionLabel: l10n.refresh,
      );
    }

    // 用户列表
    return RefreshIndicator(
      onRefresh: () => ref.read(userListProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.users.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 加载更多指示器
          if (index == state.users.length) {
            return _buildLoadMoreIndicator(state);
          }

          final user = state.users[index];
          return UserListItem(
            user: user,
            onTap: () => _onUserTap(user),
          );
        },
      ),
    );
  }

  /// 构建加载更多指示器
  Widget _buildLoadMoreIndicator(UserListState state) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// 点击用户
  void _onUserTap(UserModel user) {
    context.push('/user/${user.id}');
  }

  /// 显示搜索对话框
  void _showSearchDialog(BuildContext context) {
    // TODO: 实现搜索功能
    showSearch(
      context: context,
      delegate: _UserSearchDelegate(ref),
    );
  }
}

/// 用户搜索委托
class _UserSearchDelegate extends SearchDelegate<UserModel?> {
  final WidgetRef ref;

  _UserSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search users...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          ref.read(searchUserProvider.notifier).clear();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length >= 2) {
      // 延迟搜索，避免频繁请求
      Future.delayed(const Duration(milliseconds: 300), () {
        if (query.isNotEmpty) {
          ref.read(searchUserProvider.notifier).search(query);
        }
      });
    }

    return _buildSearchResults(context);
  }

  /// 构建搜索结果
  Widget _buildSearchResults(BuildContext context) {
    final state = ref.watch(searchUserProvider);

    if (state.isSearching && state.results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.noResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No results found for "$query"',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Text(
          'Enter at least 2 characters to search',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final user = state.results[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.displayName[0].toUpperCase()),
          ),
          title: Text(user.displayName),
          subtitle: Text(user.email),
          onTap: () {
            close(context, user);
            context.push('/user/${user.id}');
          },
        );
      },
    );
  }
}

