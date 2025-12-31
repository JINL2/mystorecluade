import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// TossMonthCalendar - Full month calendar grid with shift indicators
///
/// Design Specs:
/// - Container: 1px gray200 border, 12px radius, 16px padding
/// - Header: 7 columns (Mon-Sun) in label2, gray500
/// - Grid: 7 columns × 5-6 rows (35-42 cells)
/// - Cell: 24x24 date circle + 4x4 shift dot
/// - Date states: Past, Today, Upcoming, Selected
/// - Dot colors: Blue (shifts available to sign up), Gray (all shifts assigned)
class TossMonthCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final Map<DateTime, bool> shiftsInMonth; // true = shifts available (blue), false = all assigned (gray)
  final Set<DateTime>? userApprovedDates; // Dates where user has approved shifts (blue border)
  final ValueChanged<DateTime> onDateSelected;

  const TossMonthCalendar({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.shiftsInMonth,
    this.userApprovedDates,
    required this.onDateSelected,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _getFirstWeekdayOfMonth() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    return firstDay.weekday - 1; // 0=Mon, 6=Sun
  }

  int _getDaysInMonth() {
    return DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday = _getFirstWeekdayOfMonth();
    final daysInMonth = _getDaysInMonth();
    final totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;
    final today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Mon - Sun
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 3,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Center(
                      child: Text(
                        day,
                        style: TossTextStyles.labelSmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.95, // Slightly taller than wide to fit date + dot
              crossAxisSpacing: 4,
              mainAxisSpacing: 2,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final dayNumber = index - firstWeekday + 1;

              // Empty cell for days outside the month
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
              final isToday = _isSameDay(date, today);
              final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
              final isSelected = _isSameDay(date, selectedDate);
              final shiftAvailability = shiftsInMonth[DateTime(date.year, date.month, date.day)];
              final hasShift = shiftAvailability != null;
              final shiftsAvailable = shiftAvailability == true; // true = available (blue), false = assigned (gray)

              return _CalendarDayCell(
                date: date,
                isToday: isToday,
                isPast: isPast,
                isSelected: isSelected,
                hasShift: hasShift,
                shiftsAvailable: shiftsAvailable,
                onTap: () => onDateSelected(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// _CalendarDayCell - Individual calendar cell with date and shift indicator
///
/// Design Pattern: One component with multiple visual variants
/// States: Past, Today, Upcoming, Selected
/// Dot colors: Blue (shifts available), Gray (all assigned)
class _CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isPast;
  final bool isSelected;
  final bool hasShift;
  final bool shiftsAvailable; // true = shifts available (blue), false = all assigned (gray)
  final VoidCallback? onTap;

  const _CalendarDayCell({
    required this.date,
    required this.isToday,
    required this.isPast,
    required this.isSelected,
    required this.hasShift,
    required this.shiftsAvailable,
    this.onTap,
  });

  Color _getBackgroundColor() {
    if (isSelected) return TossColors.primary;
    return TossColors.transparent;
  }

  BoxBorder? _getBorder() {
    // Only show border if has shift or is selected
    if (isSelected) return null; // No border when selected (has background)
    if (!hasShift) return null; // No border if no shift

    // Has shift - show colored border
    if (isPast) return Border.all(color: TossColors.gray100, width: 1); // Past shift
    return Border.all(color: TossColors.primary, width: 1); // Today or future shift
  }

  Color _getTextColor() {
    if (isSelected) return TossColors.white;
    if (isPast) return TossColors.gray400; // Past dates: gray
    if (isToday && hasShift) return TossColors.primary; // Today with shift: blue
    if (isToday) return TossColors.gray900; // Today without shift: black
    // Future dates (not past, not today): black
    return TossColors.gray900;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DateCircle(
            date: date.day,
            backgroundColor: _getBackgroundColor(),
            border: _getBorder(),
            textColor: _getTextColor(),
          ),
          // Always render dot space to maintain alignment
          const SizedBox(height: 2),
          _DateDot(
            hasShift: hasShift,
            shiftsAvailable: shiftsAvailable,
            isVisible: !isPast && !isToday,
          ),
        ],
      ),
    );
  }
}

/// _DateCircle - Circular container for date number
///
/// Design Specs:
/// - Size: 32×32
/// - Border radius: 16px (circle)
/// - Typography: body (bigger font)
class _DateCircle extends StatelessWidget {
  final int date;
  final Color backgroundColor;
  final BoxBorder? border;
  final Color textColor;

  const _DateCircle({
    required this.date,
    required this.backgroundColor,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        date.toString(),
        style: TossTextStyles.body.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// _DateDot - Shift indicator dot below date
///
/// Design Specs:
/// - Size: 4×4
/// - Border radius: 2px (circle)
/// - Colors:
///   - Blue (primary): Shifts available to sign up
///   - Gray (gray300): All shifts assigned (full)
/// - Invisible for past dates and today to maintain alignment
class _DateDot extends StatelessWidget {
  final bool hasShift;
  final bool shiftsAvailable; // true = available (blue), false = assigned (gray)
  final bool isVisible;

  const _DateDot({
    required this.hasShift,
    required this.shiftsAvailable,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: isVisible
            ? (hasShift
                ? (shiftsAvailable ? TossColors.primary : TossColors.gray300)
                : TossColors.transparent)
            : TossColors.transparent, // Invisible but maintains space
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
