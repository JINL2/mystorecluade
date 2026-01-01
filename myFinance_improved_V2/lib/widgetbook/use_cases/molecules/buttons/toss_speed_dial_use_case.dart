import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossSpeedDialComponent = WidgetbookComponent(
  name: 'TossSpeedDial',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossSpeedDial\n(Speed dial menu button)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
