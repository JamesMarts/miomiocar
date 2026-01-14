import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/core/error/error_handler.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';
import 'package:flutter_demo/app/features/user/presentation/providers/user_providers.dart';
import 'package:flutter_demo/app/core/widgets/loading/loading_widget.dart';
import 'package:flutter_demo/app/core/widgets/error/error_widget.dart';

/// 用户详情页面
class UserDetailPage extends ConsumerWidget {
  /// 用户ID
  final int userId;

  const UserDetailPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(userDetailProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userDetail),
        actions: [
          /// 更多操作
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    Text(l10n.share),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => _buildContent(context, user, l10n),
        loading: () => const AppLoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(userDetailProvider(userId)),
        ),
      ),
    );
  }

  /// 处理菜单操作
  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        // TODO: 跳转到编辑页面
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit feature coming soon')),
        );
        break;
      case 'share':
        // TODO: 分享用户
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share feature coming soon')),
        );
        break;
    }
  }

  /// 构建内容
  Widget _buildContent(BuildContext context, UserModel user, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        // 刷新需要通过ProviderContainer
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 头像区域
          _buildAvatarSection(context, user),

          const SizedBox(height: 24),

          /// 用户信息卡片
          _buildInfoCard(context, user, l10n),

          const SizedBox(height: 16),

          /// 操作按钮
          _buildActionButtons(context, l10n),

          const SizedBox(height: 24),

          /// 统计信息
          _buildStatsSection(context, l10n),
        ],
      ),
    );
  }

  /// 构建头像区域
  Widget _buildAvatarSection(BuildContext context, UserModel user) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// 头像
        Hero(
          tag: 'user_avatar_${user.id}',
          child: CircleAvatar(
            radius: 60,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    user.displayName[0].toUpperCase(),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
        ),

        const SizedBox(height: 16),

        /// 用户名
        Text(
          user.displayName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        /// 用户名（如果显示的是昵称）
        if (user.nickname != null && user.nickname != user.username)
          Text(
            '@${user.username}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

        /// 简介
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              user.bio!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard(BuildContext context, UserModel user, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              icon: Icons.email_outlined,
              label: l10n.email,
              value: user.email,
            ),
            const Divider(),
            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: l10n.username,
              value: user.username,
            ),
            if (user.phone != null) ...[
              const Divider(),
              _buildInfoRow(
                context,
                icon: Icons.phone_outlined,
                label: l10n.phone,
                value: user.phone!,
              ),
            ],
            const Divider(),
            _buildInfoRow(
              context,
              icon: Icons.wc_outlined,
              label: l10n.gender,
              value: user.genderText,
            ),
            if (user.createdAt != null) ...[
              const Divider(),
              _buildInfoRow(
                context,
                icon: Icons.calendar_today_outlined,
                label: l10n.joinDate,
                value: _formatDate(user.createdAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: 发送消息
            },
            icon: const Icon(Icons.message_outlined),
            label: Text(l10n.message),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: 关注
            },
            icon: const Icon(Icons.person_add_outlined),
            label: Text(l10n.follow),
          ),
        ),
      ],
    );
  }

  /// 构建统计区域
  Widget _buildStatsSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, '0', l10n.posts),
            _buildStatItem(context, '0', l10n.followers),
            _buildStatItem(context, '0', l10n.following),
          ],
        ),
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(BuildContext context, String count, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          count,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// 格式化日期
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}

