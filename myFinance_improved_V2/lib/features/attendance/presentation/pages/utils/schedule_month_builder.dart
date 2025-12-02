import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../dialogs/shift_detail_dialog.dart';
import 'schedule_date_utils.dart';
import 'schedule_shift_finder.dart';

/// Month view builders for calendar and shift lists
class ScheduleMonthBuilder {
  ScheduleMonthBuilder._();

  /// Build shifts map for calendar display
  /// Returns Map<DateTime, bool> where:
  /// - true = has available slots (blue dot)
  /// - false = all shifts full (gray dot)
  /// - no entry = no shifts defined for that date (no dot)
  static Map<DateTime, bool> buildShiftsInMonth({
    required DateTime currentMonth,
    required List<ShiftMetadata>? shiftMetadata,
    required List<MonthlyShiftStatus>? monthlyShiftStatus,
  }) {
    // If no shift metadata, we can't show availability dots
    if (shiftMetadata == null || shiftMetadata.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Map<DateTime, bool> shifts = {};

    // Build a map of date -> MonthlyShiftStatus for quick lookup
    final Map<String, MonthlyShiftStatus> statusByDate = {};
    if (monthlyShiftStatus != null) {
      for (final dayStatus in monthlyShiftStatus) {
        statusByDate[dayStatus.requestDate] = dayStatus;
      }
    }

    // Get active shifts from metadata
    final activeShifts = shiftMetadata.where((s) => s.isActive).toList();
    if (activeShifts.isEmpty) return {};

    // Get the number of days in the current month
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Iterate through all dates in the current month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Only show dots for dates from today onwards
      if (normalizedDate.isBefore(todayNormalized)) {
        continue;
      }

      // Format date to match monthlyShiftStatus format (yyyy-MM-dd)
      final dateString =
          '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';

      // Check if we have status data for this date
      final dayStatus = statusByDate[dateString];

      // Total active shifts from metadata
      final totalShiftsFromMetadata = activeShifts.length;

      if (dayStatus != null && dayStatus.shifts.isNotEmpty) {
        // We have RPC data - but it may not include all shifts
        // RPC only returns shifts that have at least one applicant
        final shiftsInRpc = dayStatus.shifts.length;

        // Shifts not in RPC response = no applicants = available
        final shiftsNotInRpc = totalShiftsFromMetadata - shiftsInRpc;

        // If there are shifts not in RPC, they are available
        // If any shift in RPC has available slots, it's available
        // Only gray if ALL shifts are full
        final hasAvailableSlots = shiftsNotInRpc > 0 ||
            dayStatus.shifts.any((s) => s.hasAvailableSlots);

        shifts[normalizedDate] = hasAvailableSlots;
      } else {
        // No status data - shifts exist (from shiftMetadata) but no one has applied yet
        // This means all slots are available (blue dot)
        shifts[normalizedDate] = true;
      }
    }

    return shifts;
  }

  /// Build user approved dates set for calendar display (blue border)
  /// Returns Set<DateTime> of dates where current user has approved shifts
  static Set<DateTime> buildUserApprovedDates({
    required DateTime currentMonth,
    required List<MonthlyShiftStatus>? monthlyShiftStatus,
    required String currentUserId,
  }) {
    if (monthlyShiftStatus == null || monthlyShiftStatus.isEmpty) {
      return {};
    }

    if (currentUserId.isEmpty) return {};

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Set<DateTime> userApprovedDates = {};

    for (final dayStatus in monthlyShiftStatus) {
      try {
        final date = DateTime.parse(dayStatus.requestDate);
        final normalizedDate = DateTime(date.year, date.month, date.day);

        // Only for dates from today onwards in the current month
        if (normalizedDate.isBefore(todayNormalized)) continue;
        if (normalizedDate.year != currentMonth.year ||
            normalizedDate.month != currentMonth.month) {
          continue;
        }

        // Check if current user has any approved shift on this date
        for (final shift in dayStatus.shifts) {
          if (shift.approvedEmployees.any((emp) => emp.userId == currentUserId)) {
            userApprovedDates.add(normalizedDate);
            break;
          }
        }
      } catch (_) {
        // Error parsing date
      }
    }

    return userApprovedDates;
  }

  /// Build day shifts for selected date
  /// Uses shift_start_time instead of request_date for filtering
  static List<Widget> buildDayShifts(
    BuildContext context,
    DateTime date,
    List<ShiftCard> shiftCards,
  ) {
    final shifts = <Widget>[];
    final closestUpcomingShift = ScheduleShiftFinder.findClosestUpcomingShift(shiftCards);

    // Filter shifts for the selected date and approved only
    // Use shift_start_time for date filtering
    final dayShifts = shiftCards.where((card) {
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) return false;
      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      // Only show approved shifts
      if (!card.isApproved) return false;
      return ScheduleDateUtils.isSameDay(startDate, date);
    }).toList();

    // Sort by start time
    dayShifts.sort((a, b) {
      final dateTimeA = ScheduleDateUtils.parseShiftDateTime(a.shiftStartTime);
      final dateTimeB = ScheduleDateUtils.parseShiftDateTime(b.shiftStartTime);
      if (dateTimeA == null || dateTimeB == null) return 0;
      return dateTimeA.compareTo(dateTimeB);
    });

    if (dayShifts.isEmpty) {
      shifts.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No shifts scheduled for this day',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      );
      return shifts;
    }

    for (final card in dayShifts) {
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

    return shifts;
  }
}
