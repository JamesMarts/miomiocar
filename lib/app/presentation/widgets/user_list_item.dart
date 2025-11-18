import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

/// 用户列表项组件
class UserListItem extends StatelessWidget {
  /// 用户数据
  final UserModel user;
  
  /// 点击回调
  final VoidCallback? onTap;

  const UserListItem({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            user.username.substring(0, 1).toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        title: Text(
          user.displayName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

