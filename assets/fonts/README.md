# Fonts 字体资源

此文件夹用于存放应用中使用的自定义字体文件。

## 目录结构

```
fonts/
├── README.md
├── Roboto/           # 示例：Roboto 字体家族
│   ├── Roboto-Regular.ttf
│   ├── Roboto-Bold.ttf
│   ├── Roboto-Light.ttf
│   └── Roboto-Medium.ttf
├── Cairo/            # 示例：阿拉伯语字体
│   ├── Cairo-Regular.ttf
│   ├── Cairo-Bold.ttf
│   └── Cairo-SemiBold.ttf
└── Tajawal/          # 示例：另一个阿拉伯语字体
    ├── Tajawal-Regular.ttf
    ├── Tajawal-Bold.ttf
    └── Tajawal-Medium.ttf
```

## 支持的字体格式

- `.ttf` (TrueType Font) - 推荐
- `.otf` (OpenType Font)

## 命名规范

- 文件名使用 PascalCase
- 格式：`字体名-粗细.ttf`
- 例如：
  - `Roboto-Regular.ttf`
  - `Roboto-Bold.ttf`
  - `Cairo-SemiBold.ttf`

## 字体粗细对照表

| 名称        | 权重值 | CSS 名称      |
|-----------|------|-------------|
| Thin      | 100  | Hairline    |
| ExtraLight| 200  | Ultra Light |
| Light     | 300  | Light       |
| Regular   | 400  | Normal      |
| Medium    | 500  | Medium      |
| SemiBold  | 600  | Demi Bold   |
| Bold      | 700  | Bold        |
| ExtraBold | 800  | Ultra Bold  |
| Black     | 900  | Heavy       |

## 在 pubspec.yaml 中配置

```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto/Roboto-Regular.ttf
          weight: 400
        - asset: assets/fonts/Roboto/Roboto-Medium.ttf
          weight: 500
        - asset: assets/fonts/Roboto/Roboto-Bold.ttf
          weight: 700
          
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo/Cairo-Regular.ttf
          weight: 400
        - asset: assets/fonts/Cairo/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo/Cairo-Bold.ttf
          weight: 700
```

## 在代码中使用

### 方法1：直接使用

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
  ),
)
```

### 方法2：在主题中配置（推荐）

在 `app_theme.dart` 中：

```dart
ThemeData(
  fontFamily: 'Roboto', // 默认字体
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
  ),
)
```

### 方法3：创建常量类（最佳实践）

在 `lib/app/core/constants/app_fonts.dart`：

```dart
class AppFonts {
  static const String primary = 'Roboto';
  static const String arabic = 'Cairo';
  
  // 字体权重
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
```

使用：

```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: AppFonts.primary,
    fontWeight: AppFonts.medium,
  ),
)
```

## 阿拉伯语字体推荐

1. **Cairo** - 现代、清晰，适合UI
   - 下载：https://fonts.google.com/specimen/Cairo

2. **Tajawal** - 优雅、易读
   - 下载：https://fonts.google.com/specimen/Tajawal

3. **Amiri** - 传统、正式
   - 下载：https://fonts.google.com/specimen/Amiri

4. **IBM Plex Sans Arabic** - 专业、现代
   - 下载：https://fonts.google.com/specimen/IBM+Plex+Sans+Arabic

## 注意事项

1. **文件大小**：注意字体文件大小，避免包含不必要的字重
2. **版权**：确保字体有商业使用许可
3. **RTL支持**：阿拉伯语需要 RTL（从右到左）布局支持
4. **字体回退**：配置好字体回退链，确保所有字符都能正常显示
5. **性能**：不要加载过多字体，会增加应用体积和内存占用

## 常见问题

### Q: 字体不显示？
A: 
1. 检查 `pubspec.yaml` 中路径是否正确
2. 运行 `flutter clean` 和 `flutter pub get`
3. 完全重启应用（热重载可能不生效）

### Q: 如何测试字体是否加载成功？
A:
```dart
Text(
  'Test 测试 اختبار',
  style: TextStyle(fontFamily: 'YourFont'),
)
```

### Q: 阿拉伯语显示不正确？
A: 确保使用支持阿拉伯语的字体，并启用 RTL：
```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: Text('مرحبا'),
)
```

