import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

final tossButtonComponent = WidgetbookComponent(
  name: 'TossButton',
  useCases: [
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
          ),
          fullWidth: context.knobs.boolean(
            label: 'Full Width',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Secondary',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossButton.secondary(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Cancel',
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
          ),
          fullWidth: context.knobs.boolean(
            label: 'Full Width',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Outlined',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossButton.outlined(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Edit',
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
          ),
          fullWidth: context.knobs.boolean(
            label: 'Full Width',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Text Button',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossButton.textButton(
          text: context.knobs.string(
            label: 'Text',
            initialValue: 'Learn More',
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
