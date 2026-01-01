import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossKeyboardToolbarComponent = WidgetbookComponent(
  name: 'TossKeyboardToolbar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossKeyboardToolbar\n(Keyboard toolbar widget)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
