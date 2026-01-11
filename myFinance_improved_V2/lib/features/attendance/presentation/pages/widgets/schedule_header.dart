import 'package:flutter/material.dart';

import '../../../domain/entities/shift_card.dart';
import '../../widgets/shift/index.dart';

/// Header component with Today's Shift Card only
/// (View toggle removed - now using calendar icon button in navigation)
class ScheduleHeader extends StatelessWidget {
  final GlobalKey? cardKey;
  final ShiftCard? todayShift; // Today's shift data
  final ShiftCard? upcomingShift; // Closest upcoming shift (when no today shift)
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final VoidCallback? onGoToShiftSignUp;
  final VoidCallback? onReportIssue;

  /// True if this shift is part of a continuous chain that's in-progress
  /// (e.g., night shift in 08:00~13:00, 13:00~19:00, 19:00~02:00 chain)
  /// When true, show "Check-out" button even if this shift's isCheckedIn is false
  final bool isPartOfInProgressChain;

  const ScheduleHeader({
    super.key,
    this.cardKey,
    this.todayShift,
    this.upcomingShift,
    this.onCheckIn,
    this.onCheckOut,
    this.onGoToShiftSignUp,
    this.onReportIssue,
    this.isPartOfInProgressChain = false,
  });

  /// Parse shift datetime from ISO format string (e.g., "2025-06-01T14:00:00")
  DateTime? _parseShiftDateTime(String dateTimeStr) {
    try {
      if (dateTimeStr.contains('T')) {
        return DateTime.parse(dateTimeStr);
      }
      if (dateTimeStr.contains(' ')) {
        return DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Determine ShiftStatus from ShiftCard data
  /// Uses shift_start_time/shift_end_time for date comparison (not request_date)
  ShiftStatus _determineStatus(ShiftCard? card) {
    if (card == null) return ShiftStatus.noShift;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse start and end datetime for date comparison
    final startDateTime = _parseShiftDateTime(card.shiftStartTime);
    final endDateTime = _parseShiftDateTime(card.shiftEndTime);

    if (startDateTime == null || endDateTime == null) return ShiftStatus.noShift;

    final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
    final endDate = DateTime(endDateTime.year, endDateTime.month, endDateTime.day);

    // Future shift (hasn't come yet)
    if (startDate.isAfter(today)) return ShiftStatus.upcoming;

    // Past or today's shift - use entity's isCheckedIn/isCheckedOut getters
    if (card.isCheckedIn && card.isCheckedOut) return ShiftStatus.completed;

    if (card.isCheckedIn && !card.isCheckedOut) {
      return card.isLate ? ShiftStatus.late : ShiftStatus.onTime;
    }

    // ✅ Continuous chain: this shift is part of an in-progress chain
    // Even though this specific shift doesn't have isCheckedIn=true,
    // an earlier shift in the chain was checked in, so show "Check-out" button
    if (isPartOfInProgressChain && !card.isCheckedOut) {
      return ShiftStatus.inProgress;
    }

    // Past date but no check-in
    if (endDate.isBefore(today)) return ShiftStatus.undone;

    // Today's shift - check if started
    if (now.isBefore(startDateTime)) {
      return ShiftStatus.upcoming;
    } else if (now.isBefore(endDateTime)) {
      return ShiftStatus.undone; // Shift started but not checked in
    } else {
      return ShiftStatus.undone; // Shift ended without check-in
    }
  }

  /// Convert ShiftCard problemDetails to ShiftProblemInfo for UI
  ShiftProblemInfo? _buildProblemInfo(ShiftCard? card) {
    if (card == null) return null;

    final problemDetails = card.problemDetails;
    if (problemDetails == null) return null;

    return ShiftProblemInfo(
      isLate: problemDetails.hasLate,
      lateMinutes: problemDetails.lateMinutes,
      isOvertime: problemDetails.hasOvertime,
      overtimeMinutes: problemDetails.overtimeMinutes,
      hasLocationIssue: problemDetails.hasLocationIssue,
      checkinDistance: problemDetails.checkinDistance,
      hasNoCheckout: problemDetails.hasNoCheckout,
      isEarlyLeave: problemDetails.hasEarlyLeave,
      earlyLeaveMinutes: problemDetails.earlyLeaveMinutes,
      isReported: problemDetails.hasReported,
      isSolved: problemDetails.isSolved,
      problemCount: problemDetails.problemCount,
    );
  }

  /// Format date to "Tue, 18 Jun 2025" format
  /// Uses shift_start_time instead of request_date
  String _formatDate(String shiftStartTime) {
    final date = _parseShiftDateTime(shiftStartTime);
    if (date == null) return 'Unknown date';

    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final weekDay = weekDays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekDay, ${date.day} $month ${date.year}';
  }

  /// Format shift time from shiftStartTime and shiftEndTime
  /// (e.g., "2025-06-01T14:00:00", "2025-06-01T18:00:00" -> "14:00 - 18:00")
  String _formatTimeRange(String shiftStartTime, String shiftEndTime) {
    try {
      final startDateTime = DateTime.parse(shiftStartTime);
      final endDateTime = DateTime.parse(shiftEndTime);

      final startTimeStr = '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

      return '$startTimeStr - $endTimeStr';
    } catch (e) {
      return '--:-- - --:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use todayShift if available, otherwise use upcomingShift
    final displayShift = todayShift ?? upcomingShift;
    final isUpcoming = todayShift == null && upcomingShift != null;
    final status = _determineStatus(displayShift);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Shift Card (with GlobalKey to measure height)
        Container(
          key: cardKey,
          child: TossTodayShiftCard(
            shiftType: displayShift?.shiftName ?? 'No Shift',
            date: displayShift != null ? _formatDate(displayShift.shiftStartTime) : null,
            timeRange: displayShift != null ? _formatTimeRange(displayShift.shiftStartTime, displayShift.shiftEndTime) : null,
            location: displayShift?.storeName,
            status: status,
            isUpcoming: isUpcoming,
            onCheckIn: onCheckIn ?? () {},
            onCheckOut: onCheckOut ?? () {},
            onGoToShiftSignUp: onGoToShiftSignUp,
            onReportIssue: onReportIssue,
            // v5: Problem details from JSONB
            problemInfo: _buildProblemInfo(displayShift),
            // v5: Actual times for completed shifts
            actualStartTime: displayShift?.actualStartTime,
            actualEndTime: displayShift?.actualEndTime,
            confirmStartTime: displayShift?.confirmStartTime,
            confirmEndTime: displayShift?.confirmEndTime,
          ),
        ),
        // Note: No bottom padding here - gray section divider follows directly in parent
      ],
    );
  }
}
