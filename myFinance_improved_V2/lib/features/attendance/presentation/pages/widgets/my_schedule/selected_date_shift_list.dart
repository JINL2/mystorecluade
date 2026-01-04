import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../domain/entities/shift_card.dart';
import '../../utils/schedule_date_utils.dart';
import 'schedule_shift_card.dart';

/// List of shift cards for a selected date
/// Filters and sorts shifts, displays empty message if none
/// Extracted from MyScheduleTab._buildSelectedDateShiftCards
class SelectedDateShiftList extends StatelessWidget {
  final List<ShiftCard> shiftCards;
  final DateTime selectedDate;

  const SelectedDateShiftList({
    super.key,
    required this.shiftCards,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Filter shifts for selected date
    final selectedDateShifts = shiftCards.where((card) {
      if (!card.isApproved) return false;
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) return false;
      final shiftDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return shiftDate.isAtSameMomentAs(selectedDay);
    }).toList();

    // Sort by start time
    selectedDateShifts.sort((a, b) {
      final timeA = ScheduleDateUtils.parseShiftDateTime(a.shiftStartTime);
      final timeB = ScheduleDateUtils.parseShiftDateTime(b.shiftStartTime);
      if (timeA == null || timeB == null) return 0;
      return timeA.compareTo(timeB);
    });

    if (selectedDateShifts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space8),
        child: Center(
          child: Text(
            'No shifts on this day',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
        ),
      );
    }

    return Column(
      children: selectedDateShifts.map((card) {
        return Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space2),
          child: ScheduleShiftCard(card: card),
        );
      }).toList(),
    );
  }
}
