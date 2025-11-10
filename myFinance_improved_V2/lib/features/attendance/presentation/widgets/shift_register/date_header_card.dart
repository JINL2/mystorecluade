import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

class DateHeaderCard extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedShift;
  final String Function(int) getWeekdayFull;
  final String Function(int) getMonthName;

  const DateHeaderCard({
    super.key,
    required this.selectedDate,
    this.selectedShift,
    required this.getWeekdayFull,
    required this.getMonthName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            '${selectedDate.day}',
            style: TossTextStyles.h1.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getWeekdayFull(selectedDate.weekday),
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${getMonthName(selectedDate.month)} ${selectedDate.year}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (selectedShift != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              ),
              child: Text(
                '1 Selected',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
