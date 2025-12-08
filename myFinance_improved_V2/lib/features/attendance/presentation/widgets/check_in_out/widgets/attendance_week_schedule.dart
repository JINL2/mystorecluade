import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/shift_card.dart';
import '../helpers/format_helpers.dart';

/// Weekly shift schedule widget
///
/// Displays:
/// - 7-day week view centered on selected date
/// - Date navigation with shift indicators
/// - Calendar button to view full month
///
/// ✅ Clean Architecture: Uses ShiftCard Entity instead of Map<String, dynamic>
class AttendanceWeekSchedule extends StatelessWidget {
  final DateTime selectedDate;
  /// ✅ Clean Architecture: Use ShiftCard Entity list instead of Map list
  final List<ShiftCard> shiftCards;
  final Function(DateTime) onDateSelected;
  final VoidCallback onCalendarTap;

  const AttendanceWeekSchedule({
    super.key,
    required this.selectedDate,
    required this.shiftCards,
    required this.onDateSelected,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate centered week schedule based on selected date
    // Always show 7 days with selected date in the center (position 3)
    final centeredWeekSchedule = <_WeekDayData>[];

    // Start from 3 days before selected date
    for (int i = -3; i <= 3; i++) {
      final date = selectedDate.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // ✅ Clean Architecture: Use ShiftCard Entity properties
      final dayCards = shiftCards.where((card) => card.requestDate == dateStr).toList();
      final hasData = dayCards.isNotEmpty;

      // Check approval status using Entity properties
      bool hasApprovedShift = false;
      bool hasNonApprovedShift = false;
      if (dayCards.isNotEmpty) {
        hasApprovedShift = dayCards.any((card) => card.isApproved);
        hasNonApprovedShift = dayCards.any((card) => !card.isApproved);
      }

      centeredWeekSchedule.add(_WeekDayData(
        date: date,
        hasShift: hasData,
        hasApprovedShift: hasApprovedShift,
        hasNonApprovedShift: hasNonApprovedShift,
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week Schedule',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '${FormatHelpers.getMonthName(selectedDate.month)} ${selectedDate.year}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              // View Calendar Button
              Material(
                color: TossColors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onCalendarTap();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'View Calendar',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Week Days
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(centeredWeekSchedule.length, (index) {
                final schedule = centeredWeekSchedule[index];
                final date = schedule.date;
                final hasShift = schedule.hasShift;
                final hasApprovedShift = schedule.hasApprovedShift;
                final isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;
                final isToday = date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;

                // Weekday names
                final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                final weekdayName = weekdays[date.weekday % 7];

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onDateSelected(date);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? TossColors.primary
                            : isToday
                                ? TossColors.primarySurface
                                : TossColors.transparent,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: isToday && !isSelected
                            ? Border.all(
                                color: TossColors.primary.withOpacity(0.3),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: TossColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Weekday
                          Text(
                            weekdayName,
                            style: TossTextStyles.small.copyWith(
                              color: isSelected
                                  ? TossColors.white
                                  : isToday
                                      ? TossColors.primary
                                      : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Day number
                          Text(
                            date.day.toString(),
                            style: TossTextStyles.h3.copyWith(
                              color: isSelected
                                  ? TossColors.white
                                  : isToday
                                      ? TossColors.primary
                                      : TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Status indicator
                          if (hasShift)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: hasApprovedShift
                                    ? (isSelected ? TossColors.white : TossColors.success)
                                    : (isSelected ? TossColors.white : TossColors.warning),
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            Container(
                              height: 6,
                              alignment: Alignment.center,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? TossColors.white.withValues(alpha: 0.5)
                                      : TossColors.gray300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal data class for week day information
class _WeekDayData {
  final DateTime date;
  final bool hasShift;
  final bool hasApprovedShift;
  final bool hasNonApprovedShift;

  const _WeekDayData({
    required this.date,
    required this.hasShift,
    required this.hasApprovedShift,
    required this.hasNonApprovedShift,
  });
}
