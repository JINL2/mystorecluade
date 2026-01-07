import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'month_dates_picker.dart'; // For ProblemStatus

/// Shift availability status for a specific date (for dots)
/// Schedule tab uses this to show staffing status per date
enum ShiftAvailabilityStatus {
  none,        // No shifts configured - no dot
  empty,       // 🔴 At least one shift has 0 approved employees (RED - critical)
  understaffed,// 🟠 All shifts have ≥1 employee, but below target (ORANGE - warning)
  full,        // No dot - all shifts meet or exceed target (no problem)
}

/// WeekDatesPicker - 7 date circles for week selection with shift indicators
///
/// Design Logic:
/// - 7 columns (Mon-Sun) with date numbers
/// - 32×32 circles for dates
/// - Blue number text: Today
/// - Blue filled background: Selected date
///
/// Dot indicators (problemStatusMap):
/// - Red dot 🔴: Unsolved problem (highest priority)
/// - Orange dot 🟠: Reported (waiting)
/// - Green dot 🟢: Problem solved
/// - Blue dot 🔵: Has shift, no problems
/// - No dot: No shift
///
/// Layout: Same structure as MonthDatesPicker for consistent alignment
/// - Weekday labels row (Mon-Sun) with Expanded
/// - Date circles row with Expanded
class WeekDatesPicker extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStartDate; // Monday of the week
  final Map<DateTime, ShiftAvailabilityStatus> shiftAvailabilityMap; // For Schedule tab compatibility
  final Map<String, ProblemStatus>? problemStatusMap; // Problem status per date "yyyy-MM-dd"
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatesPicker({
    super.key,
    required this.selectedDate,
    required this.weekStartDate,
    this.shiftAvailabilityMap = const {},
    this.problemStatusMap,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final useProblemStatus = problemStatusMap != null;

    // Generate week data
    final weekDates = List.generate(7, (index) => weekStartDate.add(Duration(days: index)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3), // Same as MonthDatesPicker
      child: Column(
        children: [
          // Weekday labels row - Same structure as MonthDatesPicker
          _buildWeekdayLabels(weekDates),

          SizedBox(height: TossSpacing.space1), // Same as MonthDatesPicker

          // Date circles row - Expanded to match MonthDatesPicker grid alignment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDates.map((date) {
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);

              // Get problem status if using problem mode
              final dateKey = DateFormat('yyyy-MM-dd').format(date);
              final problemStatus = problemStatusMap?[dateKey] ?? ProblemStatus.none;

              // Get shift availability if using availability mode (Schedule tab)
              final availabilityStatus = shiftAvailabilityMap[normalizedDate] ?? ShiftAvailabilityStatus.none;

              return Expanded(
                child: _DateCell(
                  dayNumber: date.day,
                  isSelected: isSelected,
                  isToday: isToday,
                  useProblemStatus: useProblemStatus,
                  problemStatus: problemStatus,
                  availabilityStatus: availabilityStatus,
                  onTap: () => onDateSelected(date),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Build weekday labels row (Mon-Sun) - Same structure as MonthDatesPicker
  Widget _buildWeekdayLabels(List<DateTime> weekDates) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDates.map((date) {
        final dayName = DateFormat.E().format(date); // Mon, Tue, Wed, ...
        return Expanded(
          child: Center(
            child: Text(
              dayName,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Internal widget: Date cell with circle and dot
/// Same structure as MonthDatesPicker._DateCell for consistent layout
class _DateCell extends StatelessWidget {
  final int dayNumber;
  final bool isSelected;
  final bool isToday;
  final bool useProblemStatus; // If true, use problemStatus for dot color
  final ProblemStatus problemStatus; // Problem status for dot color
  final ShiftAvailabilityStatus availabilityStatus; // Shift availability - Schedule tab
  final VoidCallback onTap;

  const _DateCell({
    required this.dayNumber,
    required this.isSelected,
    required this.isToday,
    required this.useProblemStatus,
    required this.problemStatus,
    required this.availabilityStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date circle (32x32) - Same as MonthDatesPicker
          Container(
            width: TossSpacing.iconLG2,
            height: TossSpacing.iconLG2,
            decoration: BoxDecoration(
              // Selected date: blue filled background
              color: isSelected ? TossColors.primary : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            alignment: Alignment.center,
            child: Text(
              dayNumber.toString(),
              style: TossTextStyles.body.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space1), // Same as MonthDatesPicker

          // Indicator dot (4×4) - Same as MonthDatesPicker
          _buildStatusDot(),
        ],
      ),
    );
  }

  /// Text color logic - Same as MonthDatesPicker
  Color _getTextColor() {
    if (isSelected) return TossColors.white;
    if (isToday) return TossColors.primary;
    return TossColors.gray900;
  }

  /// Build dot indicator based on mode - Same logic as MonthDatesPicker
  Widget _buildStatusDot() {
    final Color? dotColor;

    if (useProblemStatus) {
      // Use problem status colors
      switch (problemStatus) {
        case ProblemStatus.unsolvedProblem:
          dotColor = TossColors.error; // 🔴 Red (highest priority)
        case ProblemStatus.unsolvedReport:
          dotColor = TossColors.warning; // 🟠 Orange
        case ProblemStatus.solved:
          dotColor = TossColors.success; // 🟢 Green
        case ProblemStatus.hasShift:
          dotColor = TossColors.primary; // 🔵 Blue - has shift, no problems
        case ProblemStatus.none:
          dotColor = null; // No dot
      }
    } else {
      // Schedule tab: Use shift availability colors
      // Red = empty shift (0 employees), Orange = understaffed, No dot = full
      switch (availabilityStatus) {
        case ShiftAvailabilityStatus.empty:
          dotColor = TossColors.error; // 🔴 Red - at least one shift has 0 employees
        case ShiftAvailabilityStatus.understaffed:
          dotColor = TossColors.warning; // 🟠 Orange - all shifts have ≥1 but below target
        case ShiftAvailabilityStatus.full:
          dotColor = null; // No dot - all shifts fully staffed (no problem)
        case ShiftAvailabilityStatus.none:
          dotColor = null; // No dot - no shifts configured
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
        borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2),
      ),
    );
  }
}
