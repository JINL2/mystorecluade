import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_text_styles.dart';
import 'month_dates_picker.dart'; // For ProblemStatus

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
/// - Blue filled background: Selected date
///
/// Dot indicators (depends on mode):
/// - Schedule tab (shiftAvailabilityMap):
///   - Blue dot: Has available shifts (understaffed)
///   - Gray dot: All shifts full
/// - Problems tab (problemStatusMap):
///   - Red dot: Unsolved problem (highest priority)
///   - Orange dot: Unsolved report
///   - Green dot: All solved
///   - No dot: No problems
class WeekDatesPicker extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStartDate; // Monday of the week
  final Set<DateTime> datesWithUserApproved; // Dates where user has approved shift (blue border)
  final Map<DateTime, ShiftAvailabilityStatus> shiftAvailabilityMap; // Shift availability per date (Schedule tab)
  final Map<String, ProblemStatus>? problemStatusMap; // Problem status per date "yyyy-MM-dd" (Problems tab)
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatesPicker({
    super.key,
    required this.selectedDate,
    required this.weekStartDate,
    required this.datesWithUserApproved,
    required this.shiftAvailabilityMap,
    this.problemStatusMap, // Optional - only used in Problems tab
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final useProblemStatus = problemStatusMap != null;

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
          final isToday = _isSameDay(date, today);

          // Get problem status if using problem mode (Problems tab)
          final dateKey = DateFormat('yyyy-MM-dd').format(date);
          final problemStatus = problemStatusMap?[dateKey] ?? ProblemStatus.none;

          // Get shift availability if using availability mode (Schedule tab)
          final availabilityStatus = shiftAvailabilityMap[normalizedDate] ?? ShiftAvailabilityStatus.none;
          final hasAvailable = (availabilityStatus == ShiftAvailabilityStatus.available);
          final hasFull = (availabilityStatus == ShiftAvailabilityStatus.full);

          return _DateColumnWithDot(
            dayName: dayName,
            dayNumber: date.day,
            isSelected: isSelected,
            isAssigned: isAssigned,
            hasAvailableShifts: hasAvailable,
            hasFullShifts: hasFull,
            isToday: isToday,
            useProblemStatus: useProblemStatus,
            problemStatus: problemStatus,
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
  final bool hasAvailableShifts; // Has available shifts (blue dot) - Schedule tab
  final bool hasFullShifts; // All shifts full (gray dot) - Schedule tab
  final bool isToday;
  final bool useProblemStatus; // If true, use problemStatus for dot color
  final ProblemStatus problemStatus; // Problem status for dot color - Problems tab
  final VoidCallback onTap;

  const _DateColumnWithDot({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.isAssigned,
    required this.hasAvailableShifts,
    required this.hasFullShifts,
    required this.isToday,
    required this.useProblemStatus,
    required this.problemStatus,
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

              // Indicator dot (4×4)
              _buildDot(),
            ],
          ),
        ],
      ),
    );
  }

  /// Build dot indicator based on mode
  /// - Problems tab (useProblemStatus=true): orange/red/green for problem status
  /// - Schedule tab (useProblemStatus=false): blue/gray for shift availability
  Widget _buildDot() {
    final Color? dotColor;

    if (useProblemStatus) {
      // Problems tab: Use problem status colors
      // Priority: red (problem) > orange (report) > green (solved)
      switch (problemStatus) {
        case ProblemStatus.unsolvedProblem:
          dotColor = TossColors.error; // 🔴 Red (highest priority)
        case ProblemStatus.unsolvedReport:
          dotColor = TossColors.warning; // 🟠 Orange
        case ProblemStatus.solved:
          dotColor = TossColors.success; // 🟢 Green
        case ProblemStatus.none:
          dotColor = null; // No dot
      }
    } else {
      // Schedule tab: Use shift availability colors
      if (hasAvailableShifts) {
        dotColor = TossColors.primary; // 🔵 Blue - understaffed
      } else if (hasFullShifts) {
        dotColor = TossColors.gray400; // ⚪ Gray - fully staffed
      } else {
        dotColor = null; // No dot
      }
    }

    if (dotColor == null) {
      return const SizedBox(width: 4, height: 4);
    }

    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
