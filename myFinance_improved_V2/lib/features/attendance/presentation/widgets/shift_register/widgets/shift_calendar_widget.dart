import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../domain/entities/monthly_shift_status.dart';
import '../../../../data/models/monthly_shift_status_model.dart';

/// Calendar grid widget showing monthly view with shift status indicators
class ShiftCalendarWidget extends ConsumerWidget {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final List<dynamic>? monthlyShiftStatus;
  final List<dynamic>? shiftMetadata;
  final ValueChanged<DateTime> onDateSelected;

  const ShiftCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.focusedMonth,
    required this.monthlyShiftStatus,
    required this.shiftMetadata,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> calendarDays = [];

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
      final hasShift = _hasShiftOnDate(date);
      final shiftData = _getShiftForDate(date);

      // Get current user ID from app state
      final appState = ref.read(appStateProvider);
      final String currentUserId = (appState.user['user_id'] ?? '') as String;

      // Check user registration status for this date
      bool userIsApproved = false;
      bool userIsPending = false;

      if (shiftData != null && currentUserId.isNotEmpty) {
        // Check all shifts for this date
        final shifts = shiftData['shifts'] as List<dynamic>? ?? [];

        for (var shift in shifts) {
          // Check approved employees
          final approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
          for (var employee in approvedEmployees) {
            if (employee['user_id'] == currentUserId) {
              userIsApproved = true;
              break;
            }
          }

          // Check pending employees if not already approved
          if (!userIsApproved) {
            final pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
            for (var employee in pendingEmployees) {
              if (employee['user_id'] == currentUserId) {
                userIsPending = true;
                break;
              }
            }
          }

          if (userIsApproved || userIsPending) break;
        }
      }

      final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

      calendarDays.add(
        InkWell(
          onTap: () {
            onDateSelected(date);
            HapticFeedback.selectionClick();
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            margin: const EdgeInsets.all(TossSpacing.space1 * 0.75),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.gray100
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TossTextStyles.body.copyWith(
                        color: isSelected
                            ? TossColors.white
                            : isPast
                                ? TossColors.gray300
                                : isWeekend
                                    ? TossColors.gray500
                                    : TossColors.gray900,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (hasShift && (userIsApproved || userIsPending)) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TossColors.white
                              : userIsApproved
                                  ? TossColors.success  // Green - user is approved
                                  : TossColors.warning,  // Orange - user is pending
                          shape: BoxShape.circle,
                        ),
                      ),
                    ] else
                      const SizedBox(height: TossSpacing.space2),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: calendarDays,
    );
  }

  bool _hasShiftOnDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return false;

    // Check if there are any shifts registered for this date (for any employee)
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return monthlyShiftStatus!.any((dayData) {
      return dayData['request_date'] == dateStr &&
             (((dayData['total_approved'] ?? 0) as int) > 0 ||
              ((dayData['total_pending'] ?? 0) as int) > 0);
    });
  }

  Map<String, dynamic>? _getShiftForDate(DateTime date) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return null;

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      final result = monthlyShiftStatus!.firstWhere(
        (dayData) => (dayData as MonthlyShiftStatus).requestDate == dateStr,
      ) as MonthlyShiftStatus;
      return MonthlyShiftStatusModel.fromEntity(result).toJson();
    } catch (e) {
      return null;
    }
  }
}
