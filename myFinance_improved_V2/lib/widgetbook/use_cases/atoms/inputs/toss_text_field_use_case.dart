import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';

final tossTextFieldComponent = WidgetbookComponent(
  name: 'TossTextField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossTextField(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Email',
          ),
          hintText: context.knobs.string(
            label: 'Hint',
            initialValue: 'Enter your email',
          ),
          enabled: context.knobs.boolean(
            label: 'Enabled',
            initialValue: true,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Required Field',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Email',
          hintText: 'Enter your email',
          isRequired: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Password',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiline',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Description',
          hintText: 'Enter description...',
          maxLines: 4,
        ),
      ),
    ),
  ],
);
