import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Public helper class for calendar-related utilities
/// Used by both AttendanceContent and CalendarBottomSheet
class CalendarHelpers {
  CalendarHelpers._(); // Private constructor to prevent instantiation

  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  static Widget buildCalendarGrid(
    DateTime focusedDate,
    DateTime selectedDate,
    Function(DateTime) onDateSelected, [
    List<Map<String, dynamic>>? shiftCardsData,
  ]) {
    // Use the passed shiftCardsData if available
    final shiftsData = shiftCardsData ?? [];

    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    // Build calendar grid
    final List<Widget> calendarDays = [];

    // Add weekday headers
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (final day in weekdays) {
      calendarDays.add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(TossSpacing.space2),
          child: Text(
            day,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      // Check if this date has shift data
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hasShift = shiftsData.any((shift) {
        final shiftDate = shift['request_date']?.toString() ?? '';
        return shiftDate == dateStr;
      });

      // Get shift status if exists
      String? shiftStatus;
      if (hasShift) {
        final dayShifts = shiftsData.where((shift) {
          final shiftDate = shift['request_date']?.toString() ?? '';
          return shiftDate == dateStr;
        }).toList();

        if (dayShifts.isNotEmpty) {
          final shift = dayShifts.first;
          final approvalLevel = shift['approval_level']?.toString() ?? 'pending';
          final isReported = shift['is_reported'] == true;

          if (isReported) {
            shiftStatus = 'reported';
          } else if (approvalLevel == 'approved') {
            shiftStatus = 'approved';
          } else if (approvalLevel == 'rejected') {
            shiftStatus = 'rejected';
          } else {
            shiftStatus = 'pending';
          }
        }
      }

      calendarDays.add(
        GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : hasShift
                      ? _getShiftStatusColor(shiftStatus).withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(
                      color: TossColors.primary,
                      width: 1.5,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TossTextStyles.body.copyWith(
                    color: isSelected
                        ? TossColors.white
                        : hasShift
                            ? _getShiftStatusColor(shiftStatus)
                            : TossColors.gray900,
                    fontWeight: hasShift || isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                if (hasShift && !isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _getShiftStatusColor(shiftStatus),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: calendarDays,
      ),
    );
  }

  static Color _getShiftStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return TossColors.success;
      case 'pending':
        return TossColors.warning;
      case 'rejected':
        return TossColors.error;
      case 'reported':
        return TossColors.error;
      default:
        return TossColors.gray400;
    }
  }
}
