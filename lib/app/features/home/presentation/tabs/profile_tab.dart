import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/router/routes.dart';
import 'package:flutter_demo/app/features/auth/auth.dart';

/// Profile Tab页面
/// 个人中心，集成登录状态
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: ListView(
        children: [
          /// 用户信息卡片
          _buildUserCard(context, theme, authState, ref),

          const SizedBox(height: 16),

          /// 积分信息（仅登录后显示）
          if (authState.isLoggedIn) ...[
            _buildCoinCard(context, theme, authState),
            const SizedBox(height: 16),
          ],

          /// 功能列表
          _buildMenuSection(context, l10n, theme, authState, ref),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(
    BuildContext context,
    ThemeData theme,
    AuthState authState,
    WidgetRef ref,
  ) {
    final isLoggedIn = authState.isLoggedIn;
    final user = authState.currentUser;

    return GestureDetector(
      onTap: () {
        if (!isLoggedIn) {
          // 未登录，跳转到登录页
          context.push(Routes.login);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 头像
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              backgroundImage: isLoggedIn && user?.icon.isNotEmpty == true
                  ? NetworkImage(user!.icon)
                  : null,
              child: isLoggedIn && user?.icon.isNotEmpty == true
                  ? null
                  : Icon(
                      Icons.person,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
            ),
            const SizedBox(width: 16),

            /// 用户信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedIn ? (user?.displayName ?? 'User') : 'Guest User',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLoggedIn
                        ? (user?.email.isNotEmpty == true
                            ? user!.email
                            : 'ID: ${user?.id ?? ""}')
                        : 'Tap to login',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// 箭头
            if (!isLoggedIn)
              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
              ),
          ],
        ),
      ),
    );
  }

  /// 构建积分信息卡片
  Widget _buildCoinCard(
    BuildContext context,
    ThemeData theme,
    AuthState authState,
  ) {
    final user = authState.currentUser;
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCoinInfoItem(
            context,
            icon: Icons.monetization_on_outlined,
            label: l10n.coins,
            value: '${user?.coinCount ?? 0}',
            color: Colors.amber,
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildCoinInfoItem(
            context,
            icon: Icons.leaderboard_outlined,
            label: l10n.level,
            value: '${user?.level ?? 0}',
            color: Colors.green,
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildCoinInfoItem(
            context,
            icon: Icons.emoji_events_outlined,
            label: l10n.rank,
            value: user?.rank ?? '-',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  /// 构建积分信息项
  Widget _buildCoinInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
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

  /// 构建菜单区域
  Widget _buildMenuSection(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    AuthState authState,
    WidgetRef ref,
  ) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.favorite_outline,
          title: 'Favorites',
          onTap: () => context.push(Routes.favorites),
        ),
        _buildMenuItem(
          context,
          icon: Icons.history,
          title: 'History',
          onTap: () {
            // TODO: 浏览历史
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.download_outlined,
          title: 'Downloads',
          onTap: () {
            // TODO: 下载
          },
        ),
        const Divider(height: 32),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: 'Help & Feedback',
          onTap: () {
            // TODO: 帮助与反馈
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.info_outline,
          title: 'About',
          onTap: () {
            // TODO: 关于
          },
        ),

        /// 登录/登出按钮
        const Divider(height: 32),
        if (authState.isLoggedIn)
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: l10n.logout,
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _handleLogout(context, ref, l10n),
          )
        else
          _buildMenuItem(
            context,
            icon: Icons.login,
            title: l10n.login,
            textColor: theme.colorScheme.primary,
            iconColor: theme.colorScheme.primary,
            onTap: () => context.push(Routes.login),
          ),
      ],
    );
  }

  /// 处理登出
  Future<void> _handleLogout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.logoutSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// 构建菜单项
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
