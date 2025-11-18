import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import '../../app_router.dart';

/// Profile Tab页面
/// 个人中心页面
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: ListView(
        children: [
          /// 用户信息卡片
          _buildUserCard(context),

          const SizedBox(height: 16),

          /// 设置选项
          _buildSettingsSection(context, l10n),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// 头像
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(
                Icons.person,
                size: 40,
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'guest@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            
            /// 编辑按钮
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: 编辑个人资料
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建设置区域
  Widget _buildSettingsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(l10n.settings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            context.goToSettings();
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: 帮助与支持
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: 关于
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: Text(
            l10n.logout,
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () {
            // TODO: 退出登录
          },
        ),
      ],
    );
  }
}

