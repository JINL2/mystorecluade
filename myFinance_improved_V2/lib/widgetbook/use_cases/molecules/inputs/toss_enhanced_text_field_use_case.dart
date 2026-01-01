import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossEnhancedTextFieldComponent = WidgetbookComponent(
  name: 'TossEnhancedTextField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossEnhancedTextField\n(Enhanced text input)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
