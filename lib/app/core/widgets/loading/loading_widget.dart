import 'package:flutter/material.dart';

/// 加载组件
/// 统一的加载状态显示组件
class AppLoadingWidget extends StatelessWidget {
  /// 加载提示文字
  final String? message;

  /// 是否显示背景遮罩
  final bool showOverlay;

  /// 指示器颜色
  final Color? color;

  /// 指示器大小
  final double size;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.showOverlay = false,
    this.color,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: color ?? theme.colorScheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (showOverlay) {
      return Container(
        color: Colors.black26,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: content,
            ),
          ),
        ),
      );
    }

    return Center(child: content);
  }
}

/// 加载更多组件
class LoadMoreWidget extends StatelessWidget {
  /// 是否正在加载
  final bool isLoading;

  /// 是否有更多数据
  final bool hasMore;

  /// 加载更多文字
  final String? loadingText;

  /// 无更多数据文字
  final String? noMoreText;

  const LoadMoreWidget({
    super.key,
    required this.isLoading,
    required this.hasMore,
    this.loadingText,
    this.noMoreText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text(
              loadingText ?? 'Loading...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (!hasMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            noMoreText ?? 'No more data',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// 加载遮罩组件
/// 覆盖在内容上方显示加载状态
class LoadingOverlay extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 是否显示加载
  final bool isLoading;

  /// 加载提示
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AppLoadingWidget(
              showOverlay: true,
              message: message,
            ),
          ),
      ],
    );
  }
}

/// 骨架屏加载组件
class SkeletonLoadingWidget extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 是否启用动画
  final bool enableAnimation;

  const SkeletonLoadingWidget({
    super.key,
    required this.child,
    this.enableAnimation = true,
  });

  @override
  State<SkeletonLoadingWidget> createState() => _SkeletonLoadingWidgetState();
}

class _SkeletonLoadingWidgetState extends State<SkeletonLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

