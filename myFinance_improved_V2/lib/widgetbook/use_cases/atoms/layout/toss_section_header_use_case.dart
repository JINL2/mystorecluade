import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/toss_section_header.dart';

final tossSectionHeaderComponent = WidgetbookComponent(
  name: 'TossSectionHeader',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSectionHeader(
          title: context.knobs.string(
            label: 'Title',
            initialValue: 'Section Title',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSectionHeader(
          title: 'Section Title',
          icon: Icons.settings,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Trailing',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSectionHeader(
          title: 'Section Title',
          icon: Icons.settings,
          trailing: TextButton(
            onPressed: () {},
            child: const Text('See All'),
          ),
        ),
      ),
    ),
  ],
);
