import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_week_navigation.dart';

final tossWeekNavigationComponent = WidgetbookComponent(
  name: 'TossWeekNavigation',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossWeekNavigation(
          weekLabel: context.knobs.string(
            label: 'Week Label',
            initialValue: 'This week',
          ),
          dateRange: context.knobs.string(
            label: 'Date Range',
            initialValue: '1 - 7 Jan',
          ),
          onPrevWeek: () {},
          onNextWeek: () {},
          onCurrentWeek: () {},
        ),
      ),
    ),
  ],
);
