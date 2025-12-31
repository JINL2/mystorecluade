import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_input.dart';

final tossQuantityInputComponent = WidgetbookComponent(
  name: 'TossQuantityInput',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossQuantityInput(
          value: context.knobs.int.slider(
            label: 'Value',
            initialValue: 1,
            min: 0,
            max: 100,
          ),
          minValue: 0,
          maxValue: 100,
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Range',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossQuantityInput(
          value: 5,
          minValue: 1,
          maxValue: 99,
          step: context.knobs.int.slider(
            label: 'Step',
            initialValue: 1,
            min: 1,
            max: 10,
          ),
          onChanged: (value) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Disabled',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossQuantityInput(
          value: 3,
          minValue: 0,
          maxValue: 10,
          enabled: false,
        ),
      ),
    ),
  ],
);
