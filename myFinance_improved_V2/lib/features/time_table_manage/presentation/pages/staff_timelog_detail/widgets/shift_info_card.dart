import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toss_badge.dart';

/// Shift info card showing date, name, time range and status
class ShiftInfoCard extends StatelessWidget {
  final String shiftDate;
  final String shiftName;
  final String shiftTimeRange;
  final bool isLate;
  final bool isOvertime;

  const ShiftInfoCard({
    super.key,
    required this.shiftDate,
    required this.shiftName,
    required this.shiftTimeRange,
    required this.isLate,
    required this.isOvertime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shiftDate,
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shiftName,
                      style: TossTextStyles.titleMedium.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shiftTimeRange,
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              if (isLate || isOvertime)
                TossBadge(
                  label: isLate ? 'Late' : 'OT',
                  backgroundColor: TossColors.error,
                  textColor: TossColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  borderRadius: 12,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
