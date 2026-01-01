import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_navigation.dart';

final tossMonthNavigationComponent = WidgetbookComponent(
  name: 'TossMonthNavigation',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossMonthNavigation(
          currentMonth: context.knobs.string(
            label: 'Month',
            initialValue: 'January',
          ),
          year: context.knobs.int.slider(
            label: 'Year',
            initialValue: 2024,
            min: 2020,
            max: 2030,
          ),
          onPrevMonth: () {},
          onNextMonth: () {},
          onCurrentMonth: () {},
        ),
      ),
    ),
  ],
);
