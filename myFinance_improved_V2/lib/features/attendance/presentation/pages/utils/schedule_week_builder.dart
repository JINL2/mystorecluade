import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../domain/entities/shift_card.dart';
import '../dialogs/shift_detail_dialog.dart';
import 'schedule_date_utils.dart';
import 'schedule_shift_finder.dart';

/// Week view shift list builder
class ScheduleWeekBuilder {
  ScheduleWeekBuilder._();

  /// Build week shifts from real data
  /// Returns (shifts, closestUpcomingIndex) for auto-scroll functionality
  /// Uses shift_start_time instead of request_date for filtering and display
  static ({List<Widget> shifts, int? closestUpcomingIndex}) buildWeekShiftsWithIndex(
    BuildContext context,
    DateTimeRange weekRange,
    List<ShiftCard> shiftCards,
  ) {
    final shifts = <Widget>[];
    final closestUpcomingShift = ScheduleShiftFinder.findClosestUpcomingShift(shiftCards);
    int? closestUpcomingIndex;

    // Filter shifts within the week range and approved only
    // Use shift_start_time for date filtering
    final weekShifts = shiftCards.where((card) {
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) return false;
      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      // Only show approved shifts
      if (!card.isApproved) return false;
      return !startDate.isBefore(weekRange.start) && !startDate.isAfter(weekRange.end);
    }).toList();

    // Sort by date and time
    weekShifts.sort((a, b) {
      final dateTimeA = ScheduleDateUtils.parseShiftDateTime(a.shiftStartTime);
      final dateTimeB = ScheduleDateUtils.parseShiftDateTime(b.shiftStartTime);
      if (dateTimeA == null || dateTimeB == null) return 0;
      return dateTimeA.compareTo(dateTimeB);
    });

    for (int i = 0; i < weekShifts.length; i++) {
      final card = weekShifts[i];
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;
      final cardDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      final dayName = DateFormat.E().format(cardDate);
      final dayNumber = cardDate.day;
      final shiftType = ScheduleDateUtils.extractShiftTypeFromDateTime(card.shiftStartTime);
      final timeRange = ScheduleDateUtils.formatTimeRangeFromDateTime(
        card.shiftStartTime,
        card.shiftEndTime,
      );
      final status = ScheduleShiftFinder.determineStatus(card, cardDate);
      // Compare by ShiftCard identity (shiftRequestId) instead of just date
      final isClosest = closestUpcomingShift != null &&
          card.shiftRequestId == closestUpcomingShift.shiftRequestId;

      // Track the index of closest upcoming shift for auto-scroll
      if (isClosest) {
        closestUpcomingIndex = shifts.length;
      }

      shifts.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TossWeekShiftCard(
            date: '$dayName $dayNumber',
            shiftType: shiftType,
            timeRange: timeRange,
            status: status,
            isClosestUpcoming: isClosest,
            onTap: () {
              ShiftDetailDialog.show(
                context,
                shiftCard: card,
              );
            },
          ),
        ),
      );
    }

    return (shifts: shifts, closestUpcomingIndex: closestUpcomingIndex);
  }
}
