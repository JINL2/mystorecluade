import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossTabBarComponent = WidgetbookComponent(
  name: 'TossTabBar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossTabBar\n(Tab bar navigation)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
