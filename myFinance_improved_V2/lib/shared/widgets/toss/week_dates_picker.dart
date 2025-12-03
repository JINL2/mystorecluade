import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';

/// Shift availability status for a specific date (for dots)
enum ShiftAvailabilityStatus {
  none, // No shifts on this date
  available, // Has available slots (approvedCount < requiredEmployees) - blue dot
  full, // No available slots (approvedCount >= requiredEmployees) - gray dot
}

/// WeekDatesPicker - 7 date circles for week selection with shift indicators
///
/// Design Logic:
/// - 7 columns (Mon-Sun) with date numbers
/// - 32×32 circles for dates
/// - Blue number text: Today
/// - Blue circle border: Days you're assigned (must work)
/// - Blue dot: Days with available shifts (can apply)
/// - Gray dot: Days with all shifts full (nothing available)
/// - Blue filled background: Selected date
class WeekDatesPicker extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStartDate; // Monday of the week
  final Set<DateTime> datesWithUserApproved; // Dates where user has approved shift (blue border)
  final Map<DateTime, ShiftAvailabilityStatus> shiftAvailabilityMap; // Shift availability per date (dots)
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatesPicker({
    super.key,
    required this.selectedDate,
    required this.weekStartDate,
    required this.datesWithUserApproved,
    required this.shiftAvailabilityMap,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = weekStartDate.add(Duration(days: index));
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final dayName = DateFormat.E().format(date); // Mon, Tue, Wed, ...
          final isSelected = _isSameDay(date, selectedDate);
          final isAssigned = datesWithUserApproved.any((d) => _isSameDay(d, date));

          final availabilityStatus = shiftAvailabilityMap[normalizedDate] ?? ShiftAvailabilityStatus.none;
          final hasAvailable = (availabilityStatus == ShiftAvailabilityStatus.available);
          final hasFull = (availabilityStatus == ShiftAvailabilityStatus.full);

          final isToday = _isSameDay(date, today);

          return _DateColumnWithDot(
            dayName: dayName,
            dayNumber: date.day,
            isSelected: isSelected,
            isAssigned: isAssigned,
            hasAvailableShifts: hasAvailable,
            hasFullShifts: hasFull,
            isToday: isToday,
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
  final bool isAssigned; // User is assigned this day (blue circle border)
  final bool hasAvailableShifts; // Has available shifts (blue dot)
  final bool hasFullShifts; // All shifts full (gray dot)
  final bool isToday;
  final VoidCallback onTap;

  const _DateColumnWithDot({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.isAssigned,
    required this.hasAvailableShifts,
    required this.hasFullShifts,
    required this.isToday,
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
                  // Selected date: blue filled background
                  color: isSelected ? TossColors.primary : TossColors.transparent,
                  // Assigned day (not selected): blue circle border
                  border: isAssigned && !isSelected
                      ? Border.all(color: TossColors.primary, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  dayNumber.toString(),
                  style: TossTextStyles.body.copyWith(
                    // Selected: white text
                    // Today: blue text
                    // Other: black text
                    color: isSelected
                        ? TossColors.white
                        : (isToday ? TossColors.primary : TossColors.gray900),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Shift indicator dot (4×4)
              // Blue dot: has available shifts
              // Gray dot: all shifts full
              if (hasAvailableShifts)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else if (hasFullShifts)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray400,
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
