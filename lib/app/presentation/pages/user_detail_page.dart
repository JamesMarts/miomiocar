import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/user_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

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
    final userAsync = ref.watch(userDetailProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail'),
      ),
      body: userAsync.when(
        data: (user) => _buildContent(context, user),
        loading: () => const AppLoadingWidget(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(userDetailProvider(userId)),
        ),
      ),
    );
  }

  /// 构建内容
  Widget _buildContent(BuildContext context, user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// 头像
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const Icon(
              Icons.person,
              size: 60,
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// 用户信息卡片
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Username', user.username),
                const Divider(),
                _buildInfoRow(context, 'Email', user.email),
                if (user.phone != null) ...[
                  const Divider(),
                  _buildInfoRow(context, 'Phone', user.phone!),
                ],
                if (user.bio != null) ...[
                  const Divider(),
                  _buildInfoRow(context, 'Bio', user.bio!),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// 操作按钮
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 发送消息
                },
                icon: const Icon(Icons.message),
                label: const Text('Message'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: 关注
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Follow'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

