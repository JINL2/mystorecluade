import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_chip.dart';

final tossChipComponent = WidgetbookComponent(
  name: 'TossChip',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Chip Label',
          ),
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Category',
          ),
          icon: Icons.category,
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Selected',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: 'Selected Chip',
          isSelected: true,
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Count',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: 'Items',
          showCount: true,
          count: 5,
          onTap: () {},
        ),
      ),
    ),
  ],
);
