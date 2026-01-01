import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_secondary_button.dart';

final tossSecondaryButtonComponent = WidgetbookComponent(
  name: 'TossSecondaryButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSecondaryButton(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Secondary Action',
          ),
          onPressed: context.knobs.boolean(
            label: 'Enabled',
            initialValue: true,
          )
              ? () {}
              : null,
        ),
      ),
    ),
  ],
);
