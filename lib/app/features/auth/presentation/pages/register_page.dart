import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_demo/app/core/localization/app_localizations_simple.dart';
import 'package:flutter_demo/app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_demo/app/router/routes.dart';

/// 注册页面
/// 玩Android 注册功能实现
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  /// 表单Key
  final _formKey = GlobalKey<FormState>();

  /// 用户名控制器
  final _usernameController = TextEditingController();

  /// 密码控制器
  final _passwordController = TextEditingController();

  /// 确认密码控制器
  final _confirmPasswordController = TextEditingController();

  /// 密码是否可见
  bool _isPasswordVisible = false;

  /// 确认密码是否可见
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 执行注册
  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(authProvider.notifier).register(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            repassword: _confirmPasswordController.text,
          );

      if (success && mounted) {
        final l10n = AppLocalizations.of(context);
        // 显示成功提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        // 注册成功后跳转到首页
        context.go(Routes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // 返回按钮
                _buildBackButton(colorScheme),
                const SizedBox(height: 24),
                // 头部
                _buildHeader(l10n, colorScheme),
                const SizedBox(height: 40),
                // 用户名输入框
                _buildUsernameField(l10n, colorScheme),
                const SizedBox(height: 16),
                // 密码输入框
                _buildPasswordField(l10n, colorScheme),
                const SizedBox(height: 16),
                // 确认密码输入框
                _buildConfirmPasswordField(l10n, colorScheme),
                const SizedBox(height: 24),
                // 注册按钮
                _buildRegisterButton(l10n, authState, colorScheme),
                const SizedBox(height: 16),
                // 错误信息
                if (authState.error != null) _buildErrorMessage(authState.error!),
                const SizedBox(height: 24),
                // 登录链接
                _buildLoginLink(l10n, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建返回按钮
  Widget _buildBackButton(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      children: [
        // App Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.person_add,
            size: 48,
            color: colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 24),
        // 创建账户文字
        Text(
          l10n.createAccount,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.signUpToGetStarted,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// 构建用户名输入框
  Widget _buildUsernameField(AppLocalizations l10n, ColorScheme colorScheme) {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.username,
        hintText: l10n.usernameRequired,
        prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.usernameRequired;
        }
        if (value.trim().length < 3) {
          return l10n.usernameMinLength;
        }
        return null;
      },
    );
  }

  /// 构建密码输入框
  Widget _buildPasswordField(AppLocalizations l10n, ColorScheme colorScheme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.password,
        hintText: l10n.passwordRequired,
        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.passwordRequired;
        }
        if (value.length < 6) {
          return l10n.passwordMinLength;
        }
        return null;
      },
    );
  }

  /// 构建确认密码输入框
  Widget _buildConfirmPasswordField(
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleRegister(),
      decoration: InputDecoration(
        labelText: l10n.confirmPassword,
        hintText: l10n.confirmPasswordRequired,
        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.confirmPasswordRequired;
        }
        if (value != _passwordController.text) {
          return l10n.passwordNotMatch;
        }
        return null;
      },
    );
  }

  /// 构建注册按钮
  Widget _buildRegisterButton(
    AppLocalizations l10n,
    AuthState authState,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: authState.isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                l10n.register,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// 构建错误信息
  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.red.shade700,
            onPressed: () {
              ref.read(authProvider.notifier).clearError();
            },
          ),
        ],
      ),
    );
  }

  /// 构建登录链接
  Widget _buildLoginLink(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.haveAccount,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            context.go(Routes.login);
          },
          child: Text(
            l10n.login,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

