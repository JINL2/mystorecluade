import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_date_picker.dart';

final tossDatePickerComponent = WidgetbookComponent(
  name: 'TossDatePicker',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setState) {
            DateTime? selectedDate;
            return TossDatePicker(
              date: selectedDate,
              placeholder: context.knobs.string(
                label: 'Placeholder',
                initialValue: 'Select date',
              ),
              onDateChanged: (date) => setState(() => selectedDate = date),
            );
          },
        ),
      ),
    ),
  ],
);
