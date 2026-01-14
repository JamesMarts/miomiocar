/// 开发环境入口文件
/// 运行命令: flutter run --flavor dev -t lib/main_dev.dart
library;

import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/main_common.dart';

void main() {
  // 初始化开发环境配置
  FlavorConfig.init(
    flavor: Flavor.dev,
    values: FlavorValues.dev(),
  );

  // 启动应用
  mainCommon();
}

