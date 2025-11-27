import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/toss/toss_month_navigation.dart';
import '../../../../../shared/widgets/toss/toss_month_calendar.dart';

/// Month view component with navigation, calendar, and filtered shift list
class ScheduleMonthView extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final int monthOffset;
  final Map<DateTime, bool> shiftsInMonth;
  final List<Widget> dayShifts;
  final ValueChanged<int> onNavigate;
  final ValueChanged<DateTime> onDateSelected;

  const ScheduleMonthView({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.monthOffset,
    required this.shiftsInMonth,
    required this.dayShifts,
    required this.onNavigate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM().format(currentMonth);
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate extra bottom padding to allow scrolling calendar to middle of screen
    final extraBottomPadding = screenHeight * 0.5;

    return Column(
      key: const ValueKey('month'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Navigation
        TossMonthNavigation(
          currentMonth: monthName,
          year: currentMonth.year,
          onPrevMonth: () => onNavigate(-1),
          onCurrentMonth: () => onNavigate(0),
          onNextMonth: () => onNavigate(1),
        ),
        const SizedBox(height: 12),

        // Month Calendar
        TossMonthCalendar(
          selectedDate: selectedDate,
          currentMonth: currentMonth,
          shiftsInMonth: shiftsInMonth,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(height: 12),

        // Filtered shift list
        ...dayShifts,

        // Extra padding to allow scrolling calendar to middle of screen
        SizedBox(height: extraBottomPadding),
      ],
    );
  }
}
