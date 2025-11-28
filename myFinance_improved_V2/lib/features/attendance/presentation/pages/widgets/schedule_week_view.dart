import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../../../shared/widgets/toss/toss_week_navigation.dart';

/// Week view component with navigation and shift list
class ScheduleWeekView extends StatelessWidget {
  final DateTime currentWeek;
  final int weekOffset;
  final List<Widget> shifts;
  final ValueChanged<int> onNavigate;

  const ScheduleWeekView({
    super.key,
    required this.currentWeek,
    required this.weekOffset,
    required this.shifts,
    required this.onNavigate,
  });

  DateTimeRange get _weekRange {
    final weekday = currentWeek.weekday;
    final monday = currentWeek.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  int get _weekNumber {
    final firstDayOfYear = DateTime(currentWeek.year, 1, 1);
    final daysSinceFirstDay = currentWeek.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('week'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week Navigation
        TossWeekNavigation(
          weekLabel: weekOffset == 0 ? 'This week' : 'Week $_weekNumber',
          dateRange:
              '${DateFormat('d').format(_weekRange.start)} - ${DateFormat('d MMM').format(_weekRange.end)}',
          onPrevWeek: () => onNavigate(-1),
          onCurrentWeek: () => onNavigate(0),
          onNextWeek: () => onNavigate(1),
        ),
        const SizedBox(height: 16),

        // Shift List
        ...shifts,
      ],
    );
  }
}
