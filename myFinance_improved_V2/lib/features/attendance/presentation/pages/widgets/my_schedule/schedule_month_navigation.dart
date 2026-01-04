import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import 'calendar_icon_with_badge.dart';

/// Month navigation with calendar toggle button
/// Extracted from MyScheduleTab._buildMonthNavigationWithToggle
class ScheduleMonthNavigation extends StatelessWidget {
  final DateTime currentMonth;
  final int unsolvedCount;
  final VoidCallback onPrevMonth;
  final VoidCallback onCurrentMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToggleExpanded;

  const ScheduleMonthNavigation({
    super.key,
    required this.currentMonth,
    required this.unsolvedCount,
    required this.onPrevMonth,
    required this.onCurrentMonth,
    required this.onNextMonth,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM().format(currentMonth);

    return Row(
      children: [
        Expanded(
          child: TossMonthNavigation(
            currentMonth: monthName,
            year: currentMonth.year,
            onPrevMonth: onPrevMonth,
            onCurrentMonth: onCurrentMonth,
            onNextMonth: onNextMonth,
          ),
        ),
        // Calendar toggle button (active state) with problem count badge
        CalendarIconWithBadge(
          icon: Icons.calendar_view_week,
          iconColor: TossColors.primary,
          badgeCount: unsolvedCount,
          onPressed: onToggleExpanded,
          tooltip: 'Show week view',
        ),
      ],
    );
  }
}
