import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Calendar
import 'package:myfinance_improved/shared/widgets/calendar/index.dart';

// Buttons for demos
import 'package:myfinance_improved/shared/widgets/core/buttons/index.dart';

import '../component_showcase.dart';

/// Calendar Widgets Page - Date/time specialized components
class CalendarWidgetsPage extends StatefulWidget {
  const CalendarWidgetsPage({super.key});

  @override
  State<CalendarWidgetsPage> createState() => _CalendarWidgetsPageState();
}

class _CalendarWidgetsPageState extends State<CalendarWidgetsPage> {
  DateRange? _selectedDateRange;
  DateTime _selectedMonth = DateTime.now();
  DateTime _selectedWeek = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  String _getWeekDateRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${startOfWeek.day} - ${endOfWeek.day} ${months[endOfWeek.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // Section: Calendar Navigation
        _buildSectionHeader('Calendar Navigation', Icons.navigate_before),

        // TossMonthNavigation
        ComponentShowcase(
          name: 'TossMonthNavigation',
          filename: 'toss_month_navigation.dart',
          child: TossMonthNavigation(
            currentMonth: _getMonthName(_selectedMonth.month),
            year: _selectedMonth.year,
            onPrevMonth: () => setState(() {
              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
            }),
            onCurrentMonth: () => setState(() {
              _selectedMonth = DateTime.now();
            }),
            onNextMonth: () => setState(() {
              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
            }),
          ),
        ),

        // TossWeekNavigation
        ComponentShowcase(
          name: 'TossWeekNavigation',
          filename: 'toss_week_navigation.dart',
          child: TossWeekNavigation(
            weekLabel: 'This week',
            dateRange: _getWeekDateRange(_selectedWeek),
            onPrevWeek: () => setState(() {
              _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
            }),
            onCurrentWeek: () => setState(() {
              _selectedWeek = DateTime.now();
            }),
            onNextWeek: () => setState(() {
              _selectedWeek = _selectedWeek.add(const Duration(days: 7));
            }),
          ),
        ),

        // Section: Date Range Picker
        _buildSectionHeader('Date Range', Icons.date_range),

        // CalendarTimeRange
        ComponentShowcase(
          name: 'CalendarTimeRange',
          filename: 'calendar_time_range.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected: ${_selectedDateRange?.toShortString() ?? 'None'}',
                style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossPrimaryButton(
                text: 'Select Date Range',
                onPressed: () {
                  CalendarTimeRange.show(
                    context: context,
                    initialRange: _selectedDateRange,
                    onRangeSelected: (r) => setState(() => _selectedDateRange = r),
                  );
                },
              ),
            ],
          ),
        ),

        // Section: Month Calendar
        _buildSectionHeader('Month Calendar', Icons.calendar_month),

        // TossMonthCalendar
        ComponentShowcase(
          name: 'TossMonthCalendar',
          filename: 'toss_month_calendar.dart',
          child: TossMonthCalendar(
            selectedDate: _selectedDate,
            currentMonth: _selectedMonth,
            shiftsInMonth: {
              DateTime(_selectedMonth.year, _selectedMonth.month, 5): true,
              DateTime(_selectedMonth.year, _selectedMonth.month, 10): false,
              DateTime(_selectedMonth.year, _selectedMonth.month, 15): true,
              DateTime(_selectedMonth.year, _selectedMonth.month, 20): true,
            },
            onDateSelected: (date) => setState(() => _selectedDate = date),
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
