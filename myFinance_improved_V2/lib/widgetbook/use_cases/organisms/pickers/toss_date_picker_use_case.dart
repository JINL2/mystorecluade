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
        child: _DatePickerDemo(
          placeholder: context.knobs.string(
            label: 'Placeholder',
            initialValue: 'Select date',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Initial Date',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: _DatePickerDemo(
          placeholder: 'Select date',
          initialDate: DateTime.now(),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Date Range Limited',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: _DatePickerDemo(
          placeholder: 'Select date (last 30 days)',
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now(),
        ),
      ),
    ),
  ],
);

class _DatePickerDemo extends StatefulWidget {
  final String placeholder;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const _DatePickerDemo({
    required this.placeholder,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TossDatePicker(
      date: _selectedDate,
      placeholder: widget.placeholder,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onDateChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }
}
