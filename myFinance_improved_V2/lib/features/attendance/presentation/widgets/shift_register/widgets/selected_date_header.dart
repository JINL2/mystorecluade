import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../utils/shift_register_formatters.dart';

/// Header widget showing selected date with navigation and shift count
class SelectedDateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final List<dynamic>? monthlyShiftStatus;
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;

  const SelectedDateHeader({
    super.key,
    required this.selectedDate,
    required this.monthlyShiftStatus,
    required this.onPreviousDate,
    required this.onNextDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
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
          // Previous date button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousDate,
            color: TossColors.gray600,
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: TossSpacing.space2),

          // Date info
          Expanded(
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
                      ShiftRegisterFormatters.getWeekdayFull(selectedDate.weekday),
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${ShiftRegisterFormatters.getMonthName(selectedDate.month)} ${selectedDate.year}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: TossSpacing.space2),

          // Next date button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextDate,
            color: TossColors.gray600,
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
