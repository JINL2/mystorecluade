import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_shift_data.dart';

/// Calendar Day Cell
///
/// Individual date cell in the calendar grid with shift status indicators
class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final DailyShiftData? dailyData;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    this.dailyData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSunday = date.weekday == DateTime.sunday;
    final isSaturday = date.weekday == DateTime.saturday;

    // Determine status indicators
    final hasPending = dailyData?.hasPendingRequests ?? false;
    final hasUnderstaffed = dailyData?.hasUnderStaffedShifts ?? false;
    final hasShifts = (dailyData?.shifts.length ?? 0) > 0;

    return GestureDetector(
      onTap: isCurrentMonth ? onTap : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: Border.all(
            color: isSelected ? TossColors.primary : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Date number
            Text(
              '${date.day}',
              style: TossTextStyles.body.copyWith(
                color: _getTextColor(isSunday, isSaturday),
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              ),
            ),

            const SizedBox(height: TossSpacing.marginXS),

            // Status indicators
            if (isCurrentMonth && hasShifts)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pending indicator
                  if (hasPending)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.marginXS / 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),

                  // Understaffed indicator
                  if (hasUnderstaffed)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.marginXS / 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),

                  // All good indicator
                  if (!hasPending && !hasUnderstaffed)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.marginXS / 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),

            // Shift count
            if (isCurrentMonth && hasShifts)
              Padding(
                padding: const EdgeInsets.only(top: TossSpacing.marginXS / 2),
                child: Text(
                  '${dailyData!.shifts.length} shifts',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isToday) {
      return isSelected
          ? TossColors.primarySurface
          : TossColors.primarySurface.withValues(alpha: 0.3);
    }
    if (isSelected) {
      return TossColors.primarySurface;
    }
    if (!isCurrentMonth) {
      return TossColors.gray50;
    }
    return TossColors.white;
  }

  Color _getTextColor(bool isSunday, bool isSaturday) {
    if (!isCurrentMonth) {
      return TossColors.gray400;
    }
    if (isToday) {
      return TossColors.primary;
    }
    if (isSunday) {
      return TossColors.error;
    }
    if (isSaturday) {
      return TossColors.primary;
    }
    return TossColors.gray900;
  }
}
