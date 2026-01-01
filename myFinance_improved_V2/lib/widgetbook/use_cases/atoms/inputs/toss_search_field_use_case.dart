import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';

final tossSearchFieldComponent = WidgetbookComponent(
  name: 'TossSearchField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSearchField(
          hintText: context.knobs.string(
            label: 'Hint',
            initialValue: 'Search...',
          ),
          onChanged: (value) {},
          onClear: () {},
        ),
      ),
    ),
  ],
);
