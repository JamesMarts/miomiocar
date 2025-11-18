import 'package:flutter/material.dart';

/// 应用字体常量
/// 统一管理应用中使用的字体家族和字重
class AppFonts {
  AppFonts._(); // 私有构造函数，防止实例化

  // ==================== 字体家族 ====================

  /// 默认字体
  static const String primary = 'Roboto';

  /// 阿拉伯语字体
  static const String arabic = 'Cairo';

  /// 备用字体
  static const String fallback = 'SF Pro Text';

  // ==================== 字体权重 ====================

  /// 极细 (Thin)
  static const FontWeight thin = FontWeight.w100;

  /// 特细 (ExtraLight)
  static const FontWeight extraLight = FontWeight.w200;

  /// 细体 (Light)
  static const FontWeight light = FontWeight.w300;

  /// 常规 (Regular)
  static const FontWeight regular = FontWeight.w400;

  /// 中等 (Medium)
  static const FontWeight medium = FontWeight.w500;

  /// 半粗 (SemiBold)
  static const FontWeight semiBold = FontWeight.w600;

  /// 粗体 (Bold)
  static const FontWeight bold = FontWeight.w700;

  /// 特粗 (ExtraBold)
  static const FontWeight extraBold = FontWeight.w800;

  /// 极粗 (Black)
  static const FontWeight black = FontWeight.w900;

  // ==================== 字体大小 ====================

  /// 超小字体
  static const double sizeXs = 10.0;

  /// 小字体
  static const double sizeSm = 12.0;

  /// 常规字体
  static const double sizeMd = 14.0;

  /// 大字体
  static const double sizeLg = 16.0;

  /// 超大字体
  static const double sizeXl = 18.0;

  /// 标题字体
  static const double size2xl = 20.0;

  /// 大标题
  static const double size3xl = 24.0;

  /// 超大标题
  static const double size4xl = 32.0;

  // ==================== 行高 ====================

  /// 紧凑行高
  static const double lineHeightTight = 1.2;

  /// 常规行高
  static const double lineHeightNormal = 1.5;

  /// 宽松行高
  static const double lineHeightLoose = 1.8;

  // ==================== 字间距 ====================

  /// 紧凑字间距
  static const double letterSpacingTight = -0.5;

  /// 常规字间距
  static const double letterSpacingNormal = 0.0;

  /// 宽松字间距
  static const double letterSpacingWide = 0.5;

  /// 超宽字间距
  static const double letterSpacingExtraWide = 1.0;

  // ==================== 预定义文本样式 ====================

  /// 标题1样式
  static TextStyle h1({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: size4xl,
      fontWeight: bold,
      height: lineHeightTight,
      color: color,
    );
  }

  /// 标题2样式
  static TextStyle h2({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: size3xl,
      fontWeight: semiBold,
      height: lineHeightTight,
      color: color,
    );
  }

  /// 标题3样式
  static TextStyle h3({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: size2xl,
      fontWeight: semiBold,
      height: lineHeightNormal,
      color: color,
    );
  }

  /// 正文大字样式
  static TextStyle bodyLarge({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeLg,
      fontWeight: regular,
      height: lineHeightNormal,
      color: color,
    );
  }

  /// 正文常规样式
  static TextStyle bodyMedium({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeMd,
      fontWeight: regular,
      height: lineHeightNormal,
      color: color,
    );
  }

  /// 正文小字样式
  static TextStyle bodySmall({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeSm,
      fontWeight: regular,
      height: lineHeightNormal,
      color: color,
    );
  }

  /// 按钮文本样式
  static TextStyle button({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeMd,
      fontWeight: medium,
      letterSpacing: letterSpacingWide,
      color: color,
    );
  }

  /// 提示文本样式
  static TextStyle caption({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeXs,
      fontWeight: regular,
      height: lineHeightNormal,
      color: color,
    );
  }

  /// 标签文本样式
  static TextStyle label({Color? color}) {
    return TextStyle(
      fontFamily: primary,
      fontSize: sizeSm,
      fontWeight: medium,
      letterSpacing: letterSpacingWide,
      color: color,
    );
  }

  // ==================== 阿拉伯语样式 ====================

  /// 阿拉伯语标题样式
  static TextStyle arabicH1({Color? color}) {
    return TextStyle(
      fontFamily: arabic,
      fontSize: size4xl,
      fontWeight: bold,
      height: lineHeightNormal, // 阿拉伯语需要更大的行高
      color: color,
    );
  }

  /// 阿拉伯语正文样式
  static TextStyle arabicBody({Color? color}) {
    return TextStyle(
      fontFamily: arabic,
      fontSize: sizeMd,
      fontWeight: regular,
      height: lineHeightLoose, // 阿拉伯语需要更大的行高
      color: color,
    );
  }
}







