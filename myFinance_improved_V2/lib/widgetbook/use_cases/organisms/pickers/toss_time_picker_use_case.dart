import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_time_picker.dart';

final tossTimePickerComponent = WidgetbookComponent(
  name: 'TossTimePicker',
  useCases: [
    WidgetbookUseCase(
      name: '12-Hour Format',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: _TimePickerDemo(
          placeholder: context.knobs.string(
            label: 'Placeholder',
            initialValue: 'Select time',
          ),
          use24HourFormat: false,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '24-Hour Format',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: _TimePickerDemo(
          placeholder: 'Select time',
          use24HourFormat: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Initial Time',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: _TimePickerDemo(
          placeholder: 'Select time',
          initialTime: const TimeOfDay(hour: 14, minute: 30),
          use24HourFormat: false,
        ),
      ),
    ),
  ],
);

class _TimePickerDemo extends StatefulWidget {
  final String placeholder;
  final TimeOfDay? initialTime;
  final bool use24HourFormat;

  const _TimePickerDemo({
    required this.placeholder,
    this.initialTime,
    required this.use24HourFormat,
  });

  @override
  State<_TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<_TimePickerDemo> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return TossTimePicker(
      time: _selectedTime,
      placeholder: widget.placeholder,
      use24HourFormat: widget.use24HourFormat,
      onTimeChanged: (time) {
        setState(() {
          _selectedTime = time;
        });
      },
    );
  }
}
