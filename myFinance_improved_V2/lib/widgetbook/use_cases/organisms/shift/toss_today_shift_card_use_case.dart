import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/shift/toss_today_shift_card.dart';

final tossTodayShiftCardComponent = WidgetbookComponent(
  name: 'TossTodayShiftCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Upcoming',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossTodayShiftCard(
          shiftType: context.knobs.string(
            label: 'Shift Type',
            initialValue: 'Morning Shift',
          ),
          date: 'Tue, 31 Dec 2024',
          timeRange: '09:00 - 17:00',
          location: 'Downtown Store',
          status: ShiftStatus.upcoming,
          onCheckIn: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'In Progress',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossTodayShiftCard(
          shiftType: 'Evening Shift',
          date: 'Tue, 31 Dec 2024',
          timeRange: '14:00 - 22:00',
          location: 'Main Office',
          status: ShiftStatus.inProgress,
          onCheckOut: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'No Shift',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossTodayShiftCard(
          status: ShiftStatus.noShift,
          onGoToShiftSignUp: () {},
        ),
      ),
    ),
  ],
);
