import 'package:flutter/material.dart';

/// 应用对话框
/// 统一的对话框样式
class AppDialog extends StatelessWidget {
  /// 标题
  final String title;

  /// 内容
  final Widget content;

  /// 操作按钮
  final List<Widget>? actions;

  /// 是否可关闭
  final bool dismissible;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.dismissible = true,
  });

  /// 显示对话框
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        dismissible: dismissible,
      ),
    );
  }

  /// 确认对话框
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: isDanger
                  ? ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    )
                  : null,
              child: Text(confirmText ?? 'Confirm'),
            ),
          ],
        );
      },
    );
  }

  /// 警告对话框
  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  /// 输入对话框
  static Future<String?> input({
    required BuildContext context,
    required String title,
    String? hint,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(confirmText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  /// 选择对话框
  static Future<T?> select<T>({
    required BuildContext context,
    required String title,
    required List<SelectOption<T>> options,
    T? selectedValue,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          title: Text(title),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                final isSelected = option.value == selectedValue;

                return ListTile(
                  leading: option.icon != null ? Icon(option.icon) : null,
                  title: Text(option.label),
                  subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
                  trailing: isSelected
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  selected: isSelected,
                  onTap: () => Navigator.pop(context, option.value),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}

/// 选择选项
class SelectOption<T> {
  /// 显示标签
  final String label;

  /// 值
  final T value;

  /// 图标
  final IconData? icon;

  /// 副标题
  final String? subtitle;

  const SelectOption({
    required this.label,
    required this.value,
    this.icon,
    this.subtitle,
  });
}

/// 底部弹出菜单
class AppBottomSheet {
  /// 显示底部弹出菜单
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => child,
    );
  }

  /// 显示操作菜单
  static Future<T?> showActions<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetAction<T>> actions,
    bool showCancel = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 拖动指示器
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              /// 标题
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
              ),

              const Divider(height: 1),

              /// 操作列表
              ...actions.map((action) => ListTile(
                    leading: action.icon != null
                        ? Icon(
                            action.icon,
                            color: action.isDanger ? theme.colorScheme.error : null,
                          )
                        : null,
                    title: Text(
                      action.label,
                      style: action.isDanger
                          ? TextStyle(color: theme.colorScheme.error)
                          : null,
                    ),
                    onTap: () => Navigator.pop(context, action.value),
                  )),

              /// 取消按钮
              if (showCancel) ...[
                const Divider(height: 1),
                ListTile(
                  title: const Text('Cancel', textAlign: TextAlign.center),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// 底部弹出操作
class BottomSheetAction<T> {
  /// 显示标签
  final String label;

  /// 值
  final T value;

  /// 图标
  final IconData? icon;

  /// 是否危险操作
  final bool isDanger;

  const BottomSheetAction({
    required this.label,
    required this.value,
    this.icon,
    this.isDanger = false,
  });
}

