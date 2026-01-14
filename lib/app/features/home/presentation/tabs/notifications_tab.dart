import 'package:flutter/material.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/core/widgets/empty/empty_widget.dart';

/// Notifications Tab页面
/// 通知列表
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // TODO: 标记全部已读
            },
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: AppEmptyWidget.noNotifications(),
    );
  }
}

