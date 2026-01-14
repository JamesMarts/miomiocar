import 'package:flutter/material.dart';

/// 应用主按钮
/// 统一的按钮样式组件
class AppButton extends StatelessWidget {
  /// 按钮文字
  final String text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 是否加载中
  final bool isLoading;

  /// 按钮类型
  final AppButtonType type;

  /// 按钮大小
  final AppButtonSize size;

  /// 前置图标
  final IconData? prefixIcon;

  /// 后置图标
  final IconData? suffixIcon;

  /// 是否占满宽度
  final bool fullWidth;

  /// 是否禁用
  final bool disabled;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.fullWidth = false,
    this.disabled = false,
  });

  /// 主要按钮
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? prefixIcon,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      prefixIcon: prefixIcon,
      fullWidth: fullWidth,
      disabled: disabled,
    );
  }

  /// 次要按钮
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? prefixIcon,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      prefixIcon: prefixIcon,
      fullWidth: fullWidth,
      disabled: disabled,
    );
  }

  /// 文字按钮
  factory AppButton.text({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? prefixIcon,
    bool disabled = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.text,
      prefixIcon: prefixIcon,
      disabled: disabled,
    );
  }

  /// 危险按钮
  factory AppButton.danger({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? prefixIcon,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      prefixIcon: prefixIcon,
      fullWidth: fullWidth,
      disabled: disabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = (disabled || isLoading) ? null : onPressed;

    Widget child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getLoadingColor(context),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        Text(text),
        if (suffixIcon != null && !isLoading) ...[
          const SizedBox(width: 8),
          Icon(suffixIcon, size: _getIconSize()),
        ],
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context, child, effectiveOnPressed),
    );
  }

  /// 构建按钮
  Widget _buildButton(BuildContext context, Widget child, VoidCallback? onPressed) {
    final theme = Theme.of(context);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: _getPadding(),
          ),
          child: child,
        );

      case AppButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: _getPadding(),
          ),
          child: child,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: _getPadding(),
          ),
          child: child,
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            padding: _getPadding(),
          ),
          child: child,
        );
    }
  }

  /// 获取高度
  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  /// 获取内边距
  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  /// 获取图标大小
  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  /// 获取加载指示器大小
  double _getLoadingSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 22;
    }
  }

  /// 获取加载指示器颜色
  Color _getLoadingColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return theme.colorScheme.onPrimary;
      case AppButtonType.secondary:
      case AppButtonType.text:
        return theme.colorScheme.primary;
    }
  }
}

/// 按钮类型
enum AppButtonType {
  /// 主要按钮
  primary,

  /// 次要按钮
  secondary,

  /// 文字按钮
  text,

  /// 危险按钮
  danger,
}

/// 按钮大小
enum AppButtonSize {
  /// 小
  small,

  /// 中
  medium,

  /// 大
  large,
}

/// 图标按钮
class AppIconButton extends StatelessWidget {
  /// 图标
  final IconData icon;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 大小
  final double size;

  /// 颜色
  final Color? color;

  /// 背景色
  final Color? backgroundColor;

  /// 提示文字
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color,
      style: backgroundColor != null
          ? IconButton.styleFrom(backgroundColor: backgroundColor)
          : null,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

