import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Calendar Month Header
///
/// Month navigation header with previous/next buttons
class CalendarMonthHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final Future<void> Function() onPreviousMonth;
  final Future<void> Function() onNextMonth;
  final String Function(int) getMonthName;

  const CalendarMonthHeader({
    super.key,
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.getMonthName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              HapticFeedback.selectionClick();
              await onPreviousMonth();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.chevron_left,
                size: 24,
                color: TossColors.gray600,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          Text(
            '${getMonthName(focusedMonth.month)} ${focusedMonth.year}',
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          InkWell(
            onTap: () async {
              HapticFeedback.selectionClick();
              await onNextMonth();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.chevron_right,
                size: 24,
                color: TossColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
