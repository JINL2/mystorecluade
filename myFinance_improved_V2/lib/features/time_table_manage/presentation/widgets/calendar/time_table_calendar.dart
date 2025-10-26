import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Time Table Calendar Widget
///
/// Calendar widget for time table management with shift status indicators
class TimeTableCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final void Function(DateTime) onDateSelected;
  final dynamic shiftMetadata;
  final List<dynamic> monthlyShiftData;

  const TimeTableCalendar({
    super.key,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDateSelected,
    required this.shiftMetadata,
    required this.monthlyShiftData,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    final List<Widget> calendarDays = [];

    // Week day headers - Toss Style
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 0; i < weekDays.length; i++) {
      final isWeekend = i >= 5;
      calendarDays.add(
        Center(
          child: Text(
            weekDays[i],
            style: TossTextStyles.caption.copyWith(
              color: isWeekend ? TossColors.gray400 : TossColors.gray500,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    // Empty cells before first day of month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox.shrink());
    }

    // Days of the month - Toss Style
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      final isWeekend = date.weekday >= 6;

      // Check shift status for this date
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Determine dot color based on shift status
      final dotColor = _getDotColorForDate(dateStr);

      calendarDays.add(
        InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onDateSelected(date);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            margin: EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: isToday && !isSelected
                  ? Border.all(color: TossColors.primary, width: 1.5)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TossTextStyles.body.copyWith(
                          color: isSelected
                              ? TossColors.white
                              : isWeekend
                                  ? TossColors.gray400
                                  : TossColors.gray900,
                          fontWeight: isSelected || isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      if (dotColor != null)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected ? TossColors.white : dotColor,
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

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      childAspectRatio: 1,
      children: calendarDays,
    );
  }

  /// Calculate dot color based on shift status for a specific date
  Color? _getDotColorForDate(String dateStr) {
    // Only show dots if we have both shift metadata and monthly data loaded
    if (shiftMetadata == null ||
        shiftMetadata is! List ||
        (shiftMetadata as List).isEmpty ||
        monthlyShiftData.isEmpty) {
      return null;
    }

    // Find data for this date
    Map<String, dynamic>? dayData;
    for (var data in monthlyShiftData) {
      if (data['request_date'] == dateStr) {
        dayData = data as Map<String, dynamic>;
        break;
      }
    }

    if (dayData != null) {
      // We have data for this date
      final shifts = dayData['shifts'] as List? ?? [];
      final allShifts = shiftMetadata as List;

      // Priority 1: Check if ANY shift has 0 approved employees
      // This includes checking if all required shifts have coverage
      bool hasShiftWithNoApproved = false;
      bool hasUnderStaffedShiftWithPending = false;
      bool allShiftsFullyStaffed = true;

      // First, check all active shifts from metadata
      final Set<String> coveredShiftIds = {};
      final Map<String, Map<String, dynamic>> shiftDataMap = {};

      // Build a map of shift data for easy lookup
      for (var shift in shifts) {
        final shiftId = shift['shift_id'] as String;
        coveredShiftIds.add(shiftId);
        shiftDataMap[shiftId] = shift as Map<String, dynamic>;
      }

      // Check each active shift from metadata
      for (var metaShift in allShifts) {
        if (metaShift['is_active'] == true) {
          final shiftId = metaShift['shift_id'] as String;

          if (!coveredShiftIds.contains(shiftId)) {
            // This shift has no employees at all (not in the shifts array)
            hasShiftWithNoApproved = true;
            break;
          } else {
            // Check the shift data
            final shiftData = shiftDataMap[shiftId];
            final approvedCount = shiftData?['approved_count'] as int? ?? 0;
            final requiredEmployees = shiftData?['required_employees'] as int? ?? 1;
            final pendingCount = shiftData?['pending_count'] as int? ?? 0;

            if (approvedCount == 0) {
              // This shift has 0 approved employees
              hasShiftWithNoApproved = true;
              break;
            } else if (approvedCount < requiredEmployees) {
              // Under-staffed
              allShiftsFullyStaffed = false;
              if (pendingCount > 0) {
                hasUnderStaffedShiftWithPending = true;
              }
            }
          }
        }
      }

      // Determine the dot color based on priorities
      if (hasShiftWithNoApproved) {
        // RED: Priority 1 - At least one shift has no approved employees
        return TossColors.error;
      } else if (hasUnderStaffedShiftWithPending) {
        // ORANGE: Priority 2 - Under-staffed shifts with pending employees to approve
        return TossColors.warning;
      } else if (allShiftsFullyStaffed) {
        // GREEN: Priority 3 - All shifts meet or exceed required employees
        return TossColors.success;
      } else {
        // RED: Under-staffed but no pending employees (nothing to approve)
        return TossColors.error;
      }
    } else {
      // No data for this date means no shifts registered
      return TossColors.error;
    }
  }
}
