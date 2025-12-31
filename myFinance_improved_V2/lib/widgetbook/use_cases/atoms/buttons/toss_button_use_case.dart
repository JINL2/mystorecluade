import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

final tossButtonComponent = WidgetbookComponent(
  name: 'TossButton',
  useCases: [
    // Primary Button
    WidgetbookUseCase(
      name: 'Primary',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossButton.primary(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Save',
          ),
          onPressed: context.knobs.boolean(
            label: 'Enabled',
            initialValue: true,
          )
              ? () {}
              : null,
          isLoading: context.knobs.boolean(
            label: 'Loading',
            initialValue: false,
          fullWidth: context.knobs.boolean(
            label: 'Full Width',
        ),
      ),
    ),
    // Secondary Button
      name: 'Secondary',
        child: TossButton.secondary(
            initialValue: 'Cancel',
    // Outlined Button
      name: 'Outlined',
        child: TossButton.outlined(
            initialValue: 'Edit',
    // Text Button
      name: 'Text Button',
        child: TossButton.textButton(
            initialValue: 'Learn More',
  ],
);
