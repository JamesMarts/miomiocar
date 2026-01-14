import 'package:flutter/material.dart';

/// 空状态组件
/// 统一的空数据状态显示组件
class AppEmptyWidget extends StatelessWidget {
  /// 提示信息
  final String message;

  /// 图标
  final IconData icon;

  /// 图标大小
  final double iconSize;

  /// 操作按钮文字
  final String? actionLabel;

  /// 操作按钮回调
  final VoidCallback? onAction;

  /// 副标题
  final String? subtitle;

  /// 自定义图片
  final Widget? image;

  const AppEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.iconSize = 64,
    this.actionLabel,
    this.onAction,
    this.subtitle,
    this.image,
  });

  /// 无数据
  factory AppEmptyWidget.noData({
    String? message,
    VoidCallback? onRefresh,
  }) {
    return AppEmptyWidget(
      message: message ?? 'No data available',
      icon: Icons.inbox_outlined,
      actionLabel: onRefresh != null ? 'Refresh' : null,
      onAction: onRefresh,
    );
  }

  /// 无搜索结果
  factory AppEmptyWidget.noSearchResult({
    String? keyword,
    VoidCallback? onClear,
  }) {
    return AppEmptyWidget(
      message: keyword != null
          ? 'No results found for "$keyword"'
          : 'No results found',
      icon: Icons.search_off_outlined,
      actionLabel: onClear != null ? 'Clear Search' : null,
      onAction: onClear,
    );
  }

  /// 无网络
  factory AppEmptyWidget.noNetwork({
    VoidCallback? onRetry,
  }) {
    return AppEmptyWidget(
      message: 'No internet connection',
      subtitle: 'Please check your network settings',
      icon: Icons.wifi_off_outlined,
      actionLabel: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
    );
  }

  /// 无收藏
  factory AppEmptyWidget.noFavorites({
    VoidCallback? onExplore,
  }) {
    return AppEmptyWidget(
      message: 'No favorites yet',
      subtitle: 'Start adding items to your favorites',
      icon: Icons.favorite_border_outlined,
      actionLabel: onExplore != null ? 'Explore' : null,
      onAction: onExplore,
    );
  }

  /// 无消息
  factory AppEmptyWidget.noMessages({
    VoidCallback? onCompose,
  }) {
    return AppEmptyWidget(
      message: 'No messages',
      subtitle: 'Start a conversation',
      icon: Icons.chat_bubble_outline,
      actionLabel: onCompose != null ? 'New Message' : null,
      onAction: onCompose,
    );
  }

  /// 无通知
  factory AppEmptyWidget.noNotifications() {
    return const AppEmptyWidget(
      message: 'No notifications',
      subtitle: 'You\'re all caught up!',
      icon: Icons.notifications_none_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 图片或图标
            if (image != null)
              image!
            else
              Icon(
                icon,
                size: iconSize,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),

            const SizedBox(height: 16),

            /// 主信息
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            /// 副标题
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],

            /// 操作按钮
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 列表空状态组件
/// 用于列表中显示空状态
class ListEmptyWidget extends StatelessWidget {
  /// 提示信息
  final String message;

  /// 图标
  final IconData icon;

  const ListEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

