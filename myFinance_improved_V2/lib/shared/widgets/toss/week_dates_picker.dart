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
/// Design Specs:
/// - 7 columns (Mon-Sun) with date numbers
/// - 32×32 circles for dates
/// - Blue filled background for selected date
/// - Blue border for dates where user has approved shift
/// - Blue dot: shift has available slots (future dates only)
/// - Gray dot: shift is full (future dates only)
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = weekStartDate.add(Duration(days: index));
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final dayName = DateFormat.E().format(date); // Mon, Tue, Wed, ...
          final isSelected = _isSameDay(date, selectedDate);
          final hasUserApproved =
              datesWithUserApproved.any((DateTime d) => _isSameDay(d, date));
          final availabilityStatus =
              shiftAvailabilityMap[normalizedDate] ?? ShiftAvailabilityStatus.none;

          return _DateColumnWithDot(
            dayName: dayName,
            dayNumber: date.day,
            isSelected: isSelected,
            hasUserApproved: hasUserApproved,
            availabilityStatus: availabilityStatus,
            onTap: () => onDateSelected(date),
          );
        }),
      ),
    );
  }
}

/// Internal widget: Date column with day name, circle, and dot(s)
class _DateColumnWithDot extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final bool isSelected;
  final bool hasUserApproved; // User has approved shift on this date (blue border)
  final ShiftAvailabilityStatus availabilityStatus; // Shift availability (dots)
  final VoidCallback onTap;

  const _DateColumnWithDot({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.hasUserApproved,
    required this.availabilityStatus,
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
                  color:
                      isSelected ? TossColors.primary : TossColors.transparent,
                  // Blue border if user has approved shift on this date (and not selected)
                  border: hasUserApproved && !isSelected
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

              // Shift availability indicator dot
              _buildAvailabilityDot(),
            ],
          ),
        ],
      ),
    );
  }

  /// Build availability dot based on shift availability status
  Widget _buildAvailabilityDot() {
    switch (availabilityStatus) {
      case ShiftAvailabilityStatus.available:
        // Blue dot - has available slots
        return _buildSingleDot(TossColors.primary);
      case ShiftAvailabilityStatus.full:
        // Gray dot - no available slots
        return _buildSingleDot(TossColors.gray400);
      case ShiftAvailabilityStatus.none:
        // Placeholder for alignment
        return const SizedBox(width: 4, height: 4);
    }
  }

  /// Build a single 4x4 dot with given color
  Widget _buildSingleDot(Color color) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
