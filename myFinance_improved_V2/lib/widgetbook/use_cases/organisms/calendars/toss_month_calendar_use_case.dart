import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_calendar.dart';

final tossMonthCalendarComponent = WidgetbookComponent(
  name: 'TossMonthCalendar',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final now = DateTime.now();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TossMonthCalendar(
            selectedDate: now,
            currentMonth: now,
            shiftsInMonth: {
              DateTime(now.year, now.month, now.day + 1): true,
              DateTime(now.year, now.month, now.day + 2): true,
              DateTime(now.year, now.month, now.day + 3): false,
            },
            onDateSelected: (date) {},
          ),
        );
      },
    ),
  ],
);
