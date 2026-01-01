import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final tossQuantityStepperComponent = WidgetbookComponent(
  name: 'TossQuantityStepper',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(
            'TossQuantityStepper\n(Quantity stepper control)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  ],
);
