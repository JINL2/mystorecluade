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
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isSelected = false;
            return TossChip(
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Chip',
              ),
              isSelected: isSelected,
              onTap: () => setState(() => isSelected = !isSelected),
            );
          },
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: 'With Icon',
          icon: Icons.star,
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Count',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossChip(
          label: 'Count',
          showCount: true,
          count: context.knobs.int.slider(
            label: 'Count',
            initialValue: 5,
            min: 0,
            max: 100,
          ),
          onTap: () {},
        ),
      ),
    ),
  ],
);
