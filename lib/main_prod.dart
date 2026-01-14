/// 生产环境入口文件
/// 运行命令: flutter run --flavor prod -t lib/main_prod.dart
library;

import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/main_common.dart';

void main() {
  // 初始化生产环境配置
  FlavorConfig.init(
    flavor: Flavor.prod,
    values: FlavorValues.prod(),
  );

  // 启动应用
  mainCommon();
}

