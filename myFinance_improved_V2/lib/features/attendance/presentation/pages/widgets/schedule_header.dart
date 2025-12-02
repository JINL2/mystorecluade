import 'package:flutter/material.dart';

import '../../../../../shared/widgets/toss/toggle_button.dart';
import '../../../../../shared/widgets/toss/toss_today_shift_card.dart';
import '../../../domain/entities/shift_card.dart';

enum ViewMode { week, month }

/// Header component with Today's Shift Card and View Toggle
class ScheduleHeader extends StatelessWidget {
  final GlobalKey? cardKey;
  final ViewMode viewMode;
  final ShiftCard? todayShift; // Today's shift data
  final ShiftCard? upcomingShift; // Closest upcoming shift (when no today shift)
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final ValueChanged<ViewMode> onViewModeChanged;

  const ScheduleHeader({
    super.key,
    this.cardKey,
    required this.viewMode,
    this.todayShift,
    this.upcomingShift,
    this.onCheckIn,
    this.onCheckOut,
    required this.onViewModeChanged,
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

    // Future shift (hasn't come yet) - both start and end are in the future
    if (startDate.isAfter(today)) {
      return ShiftStatus.upcoming;
    }

    // Past or today's shift - use entity's isCheckedIn/isCheckedOut getters
    // which check both actualStartTime/actualEndTime AND confirmStartTime/confirmEndTime
    if (card.isCheckedIn && card.isCheckedOut) {
      // Check-in and check-out completed
      return card.isLate ? ShiftStatus.late : ShiftStatus.completed;
    }

    if (card.isCheckedIn && !card.isCheckedOut) {
      // Currently working (checked in but not out) - On-time
      return ShiftStatus.onTime;
    }

    // Past date but no check-in (both start and end dates are before today)
    if (endDate.isBefore(today)) {
      return ShiftStatus.undone;
    }

    // Today's shift that hasn't checked in yet (start or end date is today)
    return ShiftStatus.undone;
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
          ),
        ),
        const SizedBox(height: 16),

        // Toggle Button (Week/Month toggle) - Left aligned with 8px offset
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ToggleButtonGroup(
            items: const [
              ToggleButtonItem(id: 'week', label: 'Week'),
              ToggleButtonItem(id: 'month', label: 'Month'),
            ],
            selectedId: viewMode == ViewMode.week ? 'week' : 'month',
            onToggle: (id) {
              onViewModeChanged(
                id == 'week' ? ViewMode.week : ViewMode.month,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
