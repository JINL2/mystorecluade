import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Calendar Header Widget
///
/// Displays month/year with navigation buttons
class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback? onTodayPressed;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onTodayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMMM yyyy', 'en_US');
    final isCurrentMonth = _isCurrentMonth(currentMonth);

    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous month button
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: TossColors.gray700,
            ),
            onPressed: onPreviousMonth,
            tooltip: 'Previous Month',
          ),

          // Month/Year display
          Expanded(
            child: Center(
              child: Text(
                monthFormat.format(currentMonth),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Next month button
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: TossColors.gray700,
            ),
            onPressed: onNextMonth,
            tooltip: 'Next Month',
          ),

          // Today button (optional)
          if (onTodayPressed != null && !isCurrentMonth) ...[
            const SizedBox(width: TossSpacing.marginSM),
            TextButton(
              onPressed: onTodayPressed,
              style: TextButton.styleFrom(
                foregroundColor: TossColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.paddingMD,
                  vertical: TossSpacing.paddingXS,
                ),
              ),
              child: Text(
                'Today',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}

/// Week Day Header
///
/// Displays day of week labels (일, 월, 화, ...)
class WeekDayHeader extends StatelessWidget {
  const WeekDayHeader({super.key});

  static const List<String> _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.paddingXS,
        horizontal: TossSpacing.paddingMD,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: _weekDays.map((day) {
          final isSunday = day == 'Sun';
          final isSaturday = day == 'Sat';

          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TossTextStyles.labelLarge.copyWith(
                  color: isSunday
                      ? TossColors.error
                      : isSaturday
                          ? TossColors.primary
                          : TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
