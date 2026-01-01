import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossQuantityInputComponent = WidgetbookComponent(
  name: 'TossQuantityInput',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossQuantityInput\n(Quantity input field)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
