import 'package:flutter/material.dart';

/// 错误组件
/// 统一的错误状态显示组件
class AppErrorWidget extends StatelessWidget {
  /// 错误信息
  final String message;

  /// 重试回调
  final VoidCallback? onRetry;

  /// 重试按钮文字
  final String? retryText;

  /// 错误图标
  final IconData icon;

  /// 图标大小
  final double iconSize;

  /// 是否显示详情按钮
  final bool showDetails;

  /// 详情内容
  final String? details;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon = Icons.error_outline,
    this.iconSize = 64,
    this.showDetails = false,
    this.details,
  });

  /// 网络错误
  factory AppErrorWidget.network({
    VoidCallback? onRetry,
    String? message,
  }) {
    return AppErrorWidget(
      message: message ?? 'Network error. Please check your connection.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
    );
  }

  /// 服务器错误
  factory AppErrorWidget.server({
    VoidCallback? onRetry,
    String? message,
  }) {
    return AppErrorWidget(
      message: message ?? 'Server error. Please try again later.',
      icon: Icons.cloud_off_outlined,
      onRetry: onRetry,
    );
  }

  /// 未授权错误
  factory AppErrorWidget.unauthorized({
    VoidCallback? onRetry,
    String? message,
  }) {
    return AppErrorWidget(
      message: message ?? 'Session expired. Please login again.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      retryText: 'Login',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 错误图标
            Icon(
              icon,
              size: iconSize,
              color: theme.colorScheme.error,
            ),

            const SizedBox(height: 16),

            /// 错误信息
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            /// 详情按钮
            if (showDetails && details != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _showDetailsDialog(context),
                child: const Text('Show Details'),
              ),
            ],

            const SizedBox(height: 24),

            /// 重试按钮
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Retry'),
              ),
          ],
        ),
      ),
    );
  }

  /// 显示详情对话框
  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: SelectableText(details ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// 行内错误提示组件
class InlineErrorWidget extends StatelessWidget {
  /// 错误信息
  final String message;

  /// 重试回调
  final VoidCallback? onRetry;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                color: theme.colorScheme.error,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}

/// 错误边界组件
/// 捕获子组件的错误并显示友好的错误界面
class ErrorBoundary extends StatefulWidget {
  /// 子组件
  final Widget child;

  /// 自定义错误组件构建器
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;

  /// 错误回调
  final void Function(Object error, StackTrace? stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    setState(() {
      _error = error;
      _stackTrace = stackTrace;
    });
    widget.onError?.call(error, stackTrace);
  }

  void _retry() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _stackTrace);
      }

      return AppErrorWidget(
        message: 'Something went wrong',
        onRetry: _retry,
        showDetails: true,
        details: '$_error\n\n$_stackTrace',
      );
    }

    return widget.child;
  }
}

