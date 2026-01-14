// 基础 Flutter 组件测试
//
// 使用 WidgetTester 与组件进行交互测试。
// 例如，你可以发送点击和滚动手势，
// 也可以使用 WidgetTester 在组件树中查找子组件、
// 读取文本、验证组件属性值是否正确。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_demo/app/config/flavor_config.dart';
import 'package:flutter_demo/main_common.dart';

void main() {
  // 在测试前初始化 Flavor 配置
  setUpAll(() {
    FlavorConfig.init(
      flavor: Flavor.dev,
      values: FlavorValues.dev(),
    );
  });

  testWidgets('App should launch successfully', (WidgetTester tester) async {
    // 构建应用并触发一帧
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // 等待应用初始化
    await tester.pumpAndSettle();

    // 验证应用已启动 - 检查是否有 MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
