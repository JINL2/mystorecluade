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
            initialValue: 'Recent Transactions',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSectionHeader(
          title: 'Settings',
          icon: Icons.settings,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Action',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossSectionHeader(
          title: 'Products',
          trailing: TextButton(
            onPressed: () {},
            child: const Text('See All'),
          ),
        ),
      ),
    ),
  ],
);
