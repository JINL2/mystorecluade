import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';

final toggleButtonComponent = WidgetbookComponent(
  name: 'ToggleButtonGroup',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            String selectedId = 'day';
            return ToggleButtonGroup(
              items: const [
                ToggleButtonItem(id: 'day', label: 'Day'),
                ToggleButtonItem(id: 'week', label: 'Week'),
                ToggleButtonItem(id: 'month', label: 'Month'),
              ],
              selectedId: selectedId,
              onToggle: (id) => setState(() => selectedId = id),
            );
          },
        ),
      ),
    ),
  ],
);
