import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/shift/toss_week_shift_card.dart';

final tossWeekShiftCardComponent = WidgetbookComponent(
  name: 'TossWeekShiftCard',
  useCases: [
    WidgetbookUseCase(
      name: 'On Time',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossWeekShiftCard(
          date: 'Mon, 30 Dec',
          shiftType: 'Morning Shift',
          timeRange: '09:00 - 17:00',
          status: ShiftCardStatus.onTime,
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Upcoming',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossWeekShiftCard(
          date: 'Tue, 31 Dec',
          shiftType: 'Evening Shift',
          timeRange: '14:00 - 22:00',
          status: ShiftCardStatus.upcoming,
          isClosestUpcoming: true,
          onTap: () {},
        ),
      ),
    ),
  ],
);
