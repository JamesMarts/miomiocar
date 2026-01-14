import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/router/routes.dart';

/// Profile Tab页面
/// 个人中心
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
          _buildUserCard(context, theme),

          const SizedBox(height: 16),

          /// 功能列表
          _buildMenuSection(context, l10n, theme),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(BuildContext context, ThemeData theme) {
    return Container(
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
      ),
      child: Row(
        children: [
          /// 头像
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(
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
                  'Guest User',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to login',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          /// 箭头
          const Icon(
            Icons.chevron_right,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  /// 构建菜单区域
  Widget _buildMenuSection(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
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
      ],
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

