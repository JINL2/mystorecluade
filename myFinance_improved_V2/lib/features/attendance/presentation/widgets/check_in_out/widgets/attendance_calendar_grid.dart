import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Calendar grid widget for date selection
///
/// Displays:
/// - Month view calendar with weekday headers
/// - Shift indicators (approved/pending)
/// - Current day and selected day highlighting
class AttendanceCalendarGrid extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Map<String, dynamic>> shiftCardsData;

  const AttendanceCalendarGrid({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.onDateSelected,
    required this.shiftCardsData,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> calendarDays = [];

    // Week day headers
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (final day in weekDays) {
      calendarDays.add(
        Center(
          child: Text(
            day,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Empty cells before first day of month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      // Get shift data for this date
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Check if there are any shifts for this date
      final shiftsForDate = shiftCardsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();

      final hasShift = shiftsForDate.isNotEmpty;

      // Check approval status for shifts
      final hasApprovedShift = hasShift && shiftsForDate.any((card) {
        final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
        return isApproved == true;
      });
      final hasNonApprovedShift = hasShift && shiftsForDate.any((card) {
        final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
        return isApproved != true;
      });

      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            margin: const EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: isToday && !isSelected
                    ? TossColors.primary
                    : TossColors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TossTextStyles.body.copyWith(
                      color: isSelected
                          ? TossColors.white
                          : TossColors.gray900,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (hasShift)
                  Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show green dot for approved shifts
                        if (hasApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TossColors.white
                                  : TossColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        // Add spacing if both types exist
                        if (hasApprovedShift && hasNonApprovedShift)
                          const SizedBox(width: 2),
                        // Show orange dot for non-approved shifts
                        if (hasNonApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TossColors.white
                                  : TossColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: calendarDays,
      ),
    );
  }
}
