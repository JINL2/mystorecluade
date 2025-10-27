import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/shift_time_range.dart';

/// Shift Time Display
///
/// Displays shift time range in a formatted way
class ShiftTimeDisplay extends StatelessWidget {
  final ShiftTimeRange timeRange;
  final bool showDuration;
  final TextStyle? style;

  const ShiftTimeDisplay({
    super.key,
    required this.timeRange,
    this.showDuration = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: TossColors.gray600,
            ),
            const SizedBox(width: 4),
            Text(
              timeRange.toDisplayString(),
              style: style ?? TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (showDuration) ...[
          const SizedBox(height: 2),
          Text(
            '${timeRange.durationInHours.toStringAsFixed(1)}시간',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Simple Time Display
///
/// Just shows the time string without icons
class SimpleTimeDisplay extends StatelessWidget {
  final DateTime time;
  final bool is24Hour;

  const SimpleTimeDisplay({
    super.key,
    required this.time,
    this.is24Hour = true,
  });

  @override
  Widget build(BuildContext context) {
    final hour = is24Hour ? time.hour : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = is24Hour ? '' : (time.hour >= 12 ? ' PM' : ' AM');

    return Text(
      '${hour.toString().padLeft(2, '0')}:$minute$amPm',
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray900,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
