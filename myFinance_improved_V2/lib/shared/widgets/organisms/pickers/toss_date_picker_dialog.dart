import 'package:flutter/material.dart';
import 'toss_date_picker.dart';

/// Drop-in replacement for Flutter's showDatePicker
/// Uses TossSimpleWheelDatePicker for consistent Toss design
///
/// Same API as showDatePicker - only UI changes, no logic changes
///
/// Example:
/// ```dart
/// // Before:
/// final date = await showDatePicker(
///   context: context,
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
/// );
///
/// // After:
/// final date = await showTossDatePicker(
///   context: context,
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
/// );
/// ```
Future<DateTime?> showTossDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String title = 'Select date',
}) async {
  DateTime? selectedDate;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => TossSimpleWheelDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
      onDateSelected: (date) {
        selectedDate = date;
      },
    ),
  );

  return selectedDate;
}
