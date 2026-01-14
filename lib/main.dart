/// 默认入口文件
/// 等同于开发环境，方便直接运行 `flutter run`
///
/// 推荐使用带 flavor 的入口文件:
/// - flutter run --flavor dev -t lib/main_dev.dart
/// - flutter run --flavor staging -t lib/main_staging.dart
/// - flutter run --flavor prod -t lib/main_prod.dart
library;

import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/main_common.dart';

void main() {
  // 默认使用开发环境配置
  FlavorConfig.init(
    flavor: Flavor.dev,
    values: FlavorValues.dev(),
  );

  // 启动应用
  mainCommon();
}
