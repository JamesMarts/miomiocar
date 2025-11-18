/// 表单验证工具类
/// 提供常用的表单验证方法
class Validator {
  Validator._();

  /// 验证是否为空
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// 验证是否非空
  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }

  /// 验证邮箱格式
  static bool isEmail(String? value) {
    if (isEmpty(value)) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(value!);
  }

  /// 验证手机号格式（示例：简单验证）
  static bool isPhone(String? value) {
    if (isEmpty(value)) return false;
    
    // 这里可以根据实际需求调整正则表达式
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    
    return phoneRegex.hasMatch(value!);
  }

  /// 验证密码长度
  static bool isValidPassword(String? value, {int minLength = 6, int maxLength = 20}) {
    if (isEmpty(value)) return false;
    
    final length = value!.length;
    return length >= minLength && length <= maxLength;
  }

  /// 验证密码强度（包含数字和字母）
  static bool isStrongPassword(String? value) {
    if (!isValidPassword(value)) return false;
    
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value!);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    
    return hasLetter && hasDigit;
  }

  /// 验证用户名（字母、数字、下划线）
  static bool isUsername(String? value, {int minLength = 3, int maxLength = 20}) {
    if (isEmpty(value)) return false;
    
    final length = value!.length;
    if (length < minLength || length > maxLength) return false;
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(value);
  }

  /// 验证URL格式
  static bool isUrl(String? value) {
    if (isEmpty(value)) return false;
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    return urlRegex.hasMatch(value!);
  }

  /// 验证数字
  static bool isNumber(String? value) {
    if (isEmpty(value)) return false;
    
    return double.tryParse(value!) != null;
  }

  /// 验证整数
  static bool isInteger(String? value) {
    if (isEmpty(value)) return false;
    
    return int.tryParse(value!) != null;
  }

  /// 验证是否在指定范围内
  static bool isInRange(String? value, num min, num max) {
    if (!isNumber(value)) return false;
    
    final number = double.parse(value!);
    return number >= min && number <= max;
  }

  /// 验证字符串长度
  static bool hasLength(String? value, int min, [int? max]) {
    if (isEmpty(value)) return false;
    
    final length = value!.length;
    if (max != null) {
      return length >= min && length <= max;
    }
    return length >= min;
  }

  /// 验证是否匹配指定的正则表达式
  static bool matches(String? value, String pattern) {
    if (isEmpty(value)) return false;
    
    final regex = RegExp(pattern);
    return regex.hasMatch(value!);
  }

  /// 获取邮箱验证错误消息
  static String? validateEmail(String? value) {
    if (isEmpty(value)) {
      return 'Email is required';
    }
    if (!isEmail(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  /// 获取手机号验证错误消息
  static String? validatePhone(String? value) {
    if (isEmpty(value)) {
      return 'Phone number is required';
    }
    if (!isPhone(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  /// 获取密码验证错误消息
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (isEmpty(value)) {
      return 'Password is required';
    }
    if (!isValidPassword(value, minLength: minLength)) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// 获取用户名验证错误消息
  static String? validateUsername(String? value) {
    if (isEmpty(value)) {
      return 'Username is required';
    }
    if (!isUsername(value)) {
      return 'Username can only contain letters, numbers and underscores';
    }
    return null;
  }

  /// 获取必填字段验证错误消息
  static String? validateRequired(String? value, String fieldName) {
    if (isEmpty(value)) {
      return '$fieldName is required';
    }
    return null;
  }
}

