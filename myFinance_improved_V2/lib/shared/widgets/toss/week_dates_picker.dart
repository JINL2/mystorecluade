import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';

/// WeekDatesPicker - 7 date circles for week selection with shift indicators
///
/// Design Specs:
/// - 7 columns (Mon-Sun) with date numbers
/// - 32×32 circles for dates
/// - Blue border for dates with shifts
/// - Blue filled background for selected date
/// - 4×4 blue dots under dates with shifts
class WeekDatesPicker extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStartDate; // Monday of the week
  final Set<DateTime> datesWithShifts; // Dates that have available shifts
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatesPicker({
    super.key,
    required this.selectedDate,
    required this.weekStartDate,
    required this.datesWithShifts,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = weekStartDate.add(Duration(days: index));
          final dayName = DateFormat.E().format(date); // Mon, Tue, Wed, ...
          final isSelected = _isSameDay(date, selectedDate);
          final hasShift = datesWithShifts.any((d) => _isSameDay(d, date));

          return _DateColumnWithDot(
            dayName: dayName,
            dayNumber: date.day,
            isSelected: isSelected,
            hasShift: hasShift,
            onTap: () => onDateSelected(date),
          );
        }),
      ),
    );
  }
}

/// Internal widget: Date column with day name, circle, and dot
class _DateColumnWithDot extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final bool isSelected;
  final bool hasShift;
  final VoidCallback onTap;

  const _DateColumnWithDot({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.hasShift,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day name (Mon, Tue, Wed, ...)
          Text(
            dayName,
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: 4),

          // Date circle
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : TossColors.transparent,
                  border: hasShift && !isSelected
                      ? Border.all(color: TossColors.primary, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  dayNumber.toString(),
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Shift indicator dot (4×4)
              if (hasShift)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(width: 4, height: 4), // Placeholder for alignment
            ],
          ),
        ],
      ),
    );
  }
}
