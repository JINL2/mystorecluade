import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_time_picker.dart';

final tossTimePickerComponent = WidgetbookComponent(
  name: 'TossTimePicker',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            TimeOfDay? selectedTime;
            return TossTimePicker(
              time: selectedTime,
              placeholder: context.knobs.string(
                label: 'Placeholder',
                initialValue: 'Select time',
              ),
              onTimeChanged: (time) => setState(() => selectedTime = time),
            );
          },
        ),
      ),
    ),
  ],
);
