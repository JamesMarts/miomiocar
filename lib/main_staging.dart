/// 测试环境入口文件
/// 运行命令: flutter run --flavor staging -t lib/main_staging.dart
library;

import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/main_common.dart';

void main() {
  // 初始化测试环境配置
  FlavorConfig.init(
    flavor: Flavor.staging,
    values: FlavorValues.staging(),
  );

  // 启动应用
  mainCommon();
}

