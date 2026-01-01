import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final keyboardToolbarComponent = WidgetbookComponent(
  name: 'KeyboardToolbar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'KeyboardToolbar\n(Keyboard accessory toolbar)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
