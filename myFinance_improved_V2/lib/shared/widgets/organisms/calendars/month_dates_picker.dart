import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'week_dates_picker.dart'; // For ShiftAvailabilityStatus

/// Problem status for a calendar day (for colored dots)
/// Priority: unsolvedProblem (red) > unsolvedReport (orange) > solved (green) > hasShift (blue) > none
enum ProblemStatus {
  none, // No shift - no dot
  hasShift, // Has shift, no problems - blue dot 🔵
  solved, // All problems solved - green dot 🟢
  unsolvedReport, // Has report (waiting) - orange dot 🟠
  unsolvedProblem, // Has unsolved problems - red dot 🔴 (highest priority)
}

/// MonthDatesPicker - Monthly calendar for problem tracking or schedule viewing
///
/// Design: Same style as WeekDatesPicker but for full month
/// - 7 columns (Mon-Sun) with date numbers
/// - 32×32 circles for dates
/// - Blue number text: Today
/// - Blue filled background: Selected date
///
/// Dot indicators (depends on mode):
/// - Problems tab (problemStatusByDate):
///   - Red dot: Unsolved problem (highest priority)
///   - Orange dot: Unsolved report
///   - Green dot: All solved
///   - No dot: No problems
/// - Schedule tab (shiftAvailabilityMap):
///   - Red dot: At least one shift has 0 employees (empty)
///   - Orange dot: All shifts have ≥1 employee but understaffed
///   - No dot: All shifts fully staffed (no problem)
class MonthDatesPicker extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  /// Problem status per date "yyyy-MM-dd" (Problems tab)
  final Map<String, ProblemStatus> problemStatusByDate;
  /// Shift availability per date (Schedule tab)
  final Map<DateTime, ShiftAvailabilityStatus>? shiftAvailabilityMap;
  final ValueChanged<DateTime> onDateSelected;

  const MonthDatesPicker({
    super.key,
    required this.currentMonth,
    this.selectedDate,
    required this.problemStatusByDate,
    this.shiftAvailabilityMap,
    required this.onDateSelected,
  });

  /// Determine which mode to use based on provided data
  /// - Problems tab: provides problemStatusByDate, does NOT provide shiftAvailabilityMap
  /// - Schedule tab: provides shiftAvailabilityMap (and empty problemStatusByDate)
  /// Logic: If shiftAvailabilityMap is provided (not null), use Schedule mode (blue/gray)
  ///        Otherwise, use Problems mode (red/orange/green)
  bool get _useProblemStatus => shiftAvailabilityMap == null;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysInMonth = _getDaysInMonth();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3), // Same as WeekDatesPicker
      child: Column(
        children: [
          // Weekday labels - Same style as WeekDatesPicker
          _buildWeekdayLabels(),

          SizedBox(height: TossSpacing.space1), // Same as WeekDatesPicker

          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.85, // Adjusted for circle + dot spacing
              mainAxisSpacing: 2,
              crossAxisSpacing: 0,
            ),
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              final date = daysInMonth[index];
              final isCurrentMonth = date.month == currentMonth.month;
              final isSelected =
                  selectedDate != null && _isSameDay(date, selectedDate!);
              final isToday = _isSameDay(date, today);

              // Get problem status for this date
              final dateKey = DateFormat('yyyy-MM-dd').format(date);
              final status = problemStatusByDate[dateKey] ?? ProblemStatus.none;

              // Get shift availability for understaffed indicator
              final normalizedDate = DateTime(date.year, date.month, date.day);
              final availability = shiftAvailabilityMap?[normalizedDate];

              return _DateCell(
                dayNumber: date.day,
                isCurrentMonth: isCurrentMonth,
                isSelected: isSelected,
                isToday: isToday,
                useProblemStatus: _useProblemStatus,
                status: status,
                availabilityStatus: availability ?? ShiftAvailabilityStatus.none,
                onTap: isCurrentMonth ? () => onDateSelected(date) : null,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build weekday labels row (Mon-Sun) - Same style as WeekDatesPicker
  Widget _buildWeekdayLabels() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Use Row with spaceBetween + Expanded to match GridView column alignment
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Get all days to display in the calendar grid
  List<DateTime> _getDaysInMonth() {
    final List<DateTime> days = [];

    // First day of the month
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);

    // Last day of the month
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    // Calculate padding days from previous month (Monday = 1)
    final firstWeekday = firstDay.weekday;
    final paddingBefore = firstWeekday - 1;

    // Add padding days from previous month
    for (int i = paddingBefore; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    // Add all days of current month
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, day));
    }

    // Add padding days from next month (complete to 35 or 42 days)
    final totalRows = (days.length / 7).ceil();
    final totalCells = totalRows * 7;
    final paddingAfter = totalCells - days.length;
    for (int i = 1; i <= paddingAfter; i++) {
      days.add(lastDay.add(Duration(days: i)));
    }

    return days;
  }
}

/// Internal widget: Date cell with circle and dot
/// Design unified with WeekDatesPicker - no special colors for Sat/Sun
class _DateCell extends StatelessWidget {
  final int dayNumber;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool useProblemStatus; // If true, use problem status for dot color
  final ProblemStatus status; // Problem status for dot color - Problems tab
  final ShiftAvailabilityStatus availabilityStatus; // Shift availability - Schedule tab
  final VoidCallback? onTap;

  const _DateCell({
    required this.dayNumber,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.useProblemStatus,
    required this.status,
    required this.availabilityStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date circle (32x32)
          Container(
            width: TossSpacing.iconLG2,
            height: TossSpacing.iconLG2,
            decoration: BoxDecoration(
              color: isSelected ? TossColors.primary : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            ),
            alignment: Alignment.center,
            child: Text(
              dayNumber.toString(),
              style: TossTextStyles.body.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w600, // Same as WeekDatesPicker
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space1), // Same as WeekDatesPicker

          // Status indicator dot (4×4)
          if (isCurrentMonth) _buildStatusDot() else SizedBox(height: TossSpacing.space1),
        ],
      ),
    );
  }

  /// Text color logic - Same as WeekDatesPicker
  /// - Selected: white text
  /// - Today: blue text
  /// - Not current month: gray300 (faded)
  /// - Other: gray900 (black)
  Color _getTextColor() {
    if (!isCurrentMonth) return TossColors.gray300;
    if (isSelected) return TossColors.white;
    if (isToday) return TossColors.primary;
    return TossColors.gray900;
  }

  /// Build dot indicator based on mode (same logic as WeekDatesPicker)
  /// - Problems tab (useProblemStatus=true): red/orange/green/blue for problem status
  /// - Schedule tab (useProblemStatus=false): blue/gray for shift availability
  Widget _buildStatusDot() {
    final Color? dotColor;

    if (useProblemStatus) {
      // Use problem status colors
      // Priority: red (problem) > orange (report) > green (solved) > blue (shift)
      switch (status) {
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
