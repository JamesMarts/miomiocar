import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 应用文本输入框
/// 统一的文本输入组件
class AppTextField extends StatefulWidget {
  /// 控制器
  final TextEditingController? controller;

  /// 标签
  final String? label;

  /// 占位符
  final String? hint;

  /// 前缀图标
  final IconData? prefixIcon;

  /// 后缀图标
  final IconData? suffixIcon;

  /// 后缀图标点击回调
  final VoidCallback? onSuffixTap;

  /// 是否密码输入
  final bool obscureText;

  /// 是否显示密码切换按钮
  final bool showPasswordToggle;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 输入格式化
  final List<TextInputFormatter>? inputFormatters;

  /// 最大行数
  final int maxLines;

  /// 最小行数
  final int? minLines;

  /// 最大长度
  final int? maxLength;

  /// 是否启用
  final bool enabled;

  /// 是否只读
  final bool readOnly;

  /// 自动焦点
  final bool autofocus;

  /// 文本变化回调
  final ValueChanged<String>? onChanged;

  /// 提交回调
  final ValueChanged<String>? onSubmitted;

  /// 点击回调
  final VoidCallback? onTap;

  /// 验证器
  final FormFieldValidator<String>? validator;

  /// 错误文本
  final String? errorText;

  /// 帮助文本
  final String? helperText;

  /// 焦点节点
  final FocusNode? focusNode;

  /// 文本对齐
  final TextAlign textAlign;

  /// 输入动作
  final TextInputAction? textInputAction;

  /// 自动填充
  final Iterable<String>? autofillHints;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.errorText,
    this.helperText,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.autofillHints,
  });

  /// 邮箱输入框
  factory AppTextField.email({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      autofillHints: const [AutofillHints.email],
    );
  }

  /// 密码输入框
  factory AppTextField.password({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      prefixIcon: Icons.lock_outlined,
      obscureText: true,
      showPasswordToggle: true,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      autofillHints: const [AutofillHints.password],
    );
  }

  /// 搜索输入框
  factory AppTextField.search({
    TextEditingController? controller,
    String? hint,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onClear,
  }) {
    return AppTextField(
      controller: controller,
      hint: hint ?? 'Search...',
      prefixIcon: Icons.search,
      suffixIcon: Icons.clear,
      onSuffixTap: onClear,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
    );
  }

  /// 多行文本输入框
  factory AppTextField.multiline({
    TextEditingController? controller,
    String? label,
    String? hint,
    int maxLines = 5,
    int? minLines = 3,
    int? maxLength,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }

  /// 手机号输入框
  factory AppTextField.phone({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Phone',
      hint: hint ?? 'Enter your phone number',
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      autofillHints: const [AutofillHints.telephoneNumber],
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      textAlign: widget.textAlign,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  /// 构建后缀图标
  Widget? _buildSuffixIcon() {
    // 密码切换按钮
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // 自定义后缀图标
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon),
        onPressed: widget.onSuffixTap,
      );
    }

    return null;
  }
}

/// 表单验证器
class AppValidators {
  AppValidators._();

  /// 必填验证
  static FormFieldValidator<String> required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// 邮箱验证
  static FormFieldValidator<String> email([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!regex.hasMatch(value)) {
        return message ?? 'Please enter a valid email';
      }
      return null;
    };
  }

  /// 最小长度验证
  static FormFieldValidator<String> minLength(int min, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) {
        return message ?? 'Must be at least $min characters';
      }
      return null;
    };
  }

  /// 最大长度验证
  static FormFieldValidator<String> maxLength(int max, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > max) {
        return message ?? 'Must be at most $max characters';
      }
      return null;
    };
  }

  /// 正则验证
  static FormFieldValidator<String> pattern(RegExp regex, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// 组合验证器
  static FormFieldValidator<String> compose(List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

