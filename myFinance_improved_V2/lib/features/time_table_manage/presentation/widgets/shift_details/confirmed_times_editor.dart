import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';

/// Confirmed Times Editor
///
/// A widget for editing confirmed start and end times in shift details.
class ConfirmedTimesEditor extends StatelessWidget {
  final String editedStartTime;
  final String editedEndTime;
  final ValueChanged<String> onStartTimeChanged;
  final ValueChanged<String> onEndTimeChanged;

  const ConfirmedTimesEditor({
    super.key,
    required this.editedStartTime,
    required this.editedEndTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  TimeOfDay? _parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty || timeStr == '--:--') {
      return null;
    }
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_outlined,
                size: 20,
                color: TossColors.gray700,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Edit Confirmed Times',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          // Start Time Editor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Start Time',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(
                width: 120,
                child: TossTimePicker(
                  time: _parseTimeString(editedStartTime),
                  placeholder: '--:--',
                  use24HourFormat: false,
                  onTimeChanged: (TimeOfDay time) {
                    onStartTimeChanged(ShiftTimeFormatter.formatTimeOfDay(time));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // End Time Editor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'End Time',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(
                width: 120,
                child: TossTimePicker(
                  time: _parseTimeString(editedEndTime),
                  placeholder: '--:--',
                  use24HourFormat: false,
                  onTimeChanged: (TimeOfDay time) {
                    onEndTimeChanged(ShiftTimeFormatter.formatTimeOfDay(time));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
