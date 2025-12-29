import 'package:flutter/material.dart';

import '../../../../../../core/constants/icon_mapper.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../dialog_utils.dart';

/// Duration Display Widget
///
/// Shows calculated shift duration based on start and end times
class DurationDisplay extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DurationDisplay({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.success.withValues(alpha: 0.2),
          width: TossSpacing.space1 / 4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            IconMapper.getIcon('stopwatch'),
            color: TossColors.success,
            size: TossSpacing.iconSM,
          ),
          const SizedBox(width: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Duration',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                calculateDuration(startTime, endTime),
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
