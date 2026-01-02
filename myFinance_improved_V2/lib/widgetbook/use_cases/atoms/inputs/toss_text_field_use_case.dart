import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_text_field.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';

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
          isRequired: context.knobs.boolean(
            label: 'Required',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Prefix Icon',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Name',
          hintText: 'Enter your name',
          isRequired: true,
          prefixIcon: Icon(
            Icons.person_outline,
            size: 20,
            color: TossColors.gray500,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Suffix Icon',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Search',
          hintText: 'Search...',
          suffixIcon: Icon(
            Icons.search,
            size: 20,
            color: TossColors.gray500,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Password',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossTextField(
          label: 'Password',
          hintText: 'Enter password',
          isRequired: true,
          obscureText: true,
        ),
      ),
    ),
  ],
);
