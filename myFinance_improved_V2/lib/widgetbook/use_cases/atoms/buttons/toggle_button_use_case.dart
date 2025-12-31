import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';

final toggleButtonComponent = WidgetbookComponent(
  name: 'ToggleButtonGroup',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final selectedIndex = context.knobs.int.slider(
          label: 'Selected Index',
          initialValue: 0,
          min: 0,
          max: 2,
        );
        final labels = ['Day', 'Week', 'Month'];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ToggleButtonGroup(
            items: [
              ToggleButtonItem(id: '0', label: labels[0]),
              ToggleButtonItem(id: '1', label: labels[1]),
              ToggleButtonItem(id: '2', label: labels[2]),
            ],
            selectedId: '$selectedIndex',
            onToggle: (id) {},
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'With Icons',
      builder: (context) {
        final selectedIndex = context.knobs.int.slider(
          label: 'Selected Index',
          initialValue: 0,
          min: 0,
          max: 1,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ToggleButtonGroup(
            items: const [
              ToggleButtonItem(id: '0', label: 'List', icon: Icons.list),
              ToggleButtonItem(id: '1', label: 'Grid', icon: Icons.grid_view),
            ],
            selectedId: '$selectedIndex',
            onToggle: (id) {},
          ),
        );
      },
    ),
  ],
);
