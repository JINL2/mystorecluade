import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_primary_button.dart';

final tossPrimaryButtonComponent = WidgetbookComponent(
  name: 'TossPrimaryButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossPrimaryButton(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Primary Action',
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
