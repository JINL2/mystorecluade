import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../domain/entities/shift_card.dart';
import 'calendar_icon_with_badge.dart';

/// Week navigation with calendar toggle button
/// Extracted from MyScheduleTab._buildWeekNavigationWithToggle
class ScheduleWeekNavigation extends StatelessWidget {
  final DateTimeRange weekRange;
  final int currentWeekOffset;
  final int unsolvedCount;
  final VoidCallback onPrevWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onToggleExpanded;

  const ScheduleWeekNavigation({
    super.key,
    required this.weekRange,
    required this.currentWeekOffset,
    required this.unsolvedCount,
    required this.onPrevWeek,
    required this.onCurrentWeek,
    required this.onNextWeek,
    required this.onToggleExpanded,
  });

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  @override
  Widget build(BuildContext context) {
    final weekDate = DateTime.now().add(Duration(days: currentWeekOffset * 7));

    return Row(
      children: [
        Expanded(
          child: TossWeekNavigation(
            weekLabel: currentWeekOffset == 0 ? 'This week' : 'Week ${_getWeekNumber(weekDate)}',
            dateRange: '${DateFormat('d').format(weekRange.start)} - ${DateFormat('d MMM').format(weekRange.end)}',
            onPrevWeek: onPrevWeek,
            onCurrentWeek: onCurrentWeek,
            onNextWeek: onNextWeek,
          ),
        ),
        // Calendar toggle button with problem count badge
        CalendarIconWithBadge(
          icon: Icons.calendar_month,
          iconColor: TossColors.gray600,
          badgeCount: unsolvedCount,
          onPressed: onToggleExpanded,
          tooltip: 'Show month calendar',
        ),
      ],
    );
  }
}
