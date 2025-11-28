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
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final ValueChanged<ViewMode> onViewModeChanged;

  const ScheduleHeader({
    super.key,
    this.cardKey,
    required this.viewMode,
    this.todayShift,
    this.onCheckIn,
    this.onCheckOut,
    required this.onViewModeChanged,
  });

  /// Determine ShiftStatus from ShiftCard data
  ShiftStatus _determineStatus(ShiftCard? card) {
    if (card == null) return ShiftStatus.noShift;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cardDate = _parseRequestDate(card.requestDate);

    if (cardDate == null) return ShiftStatus.noShift;

    // Future shift (hasn't come yet)
    if (cardDate.isAfter(today)) {
      return ShiftStatus.upcoming;
    }

    // Past or today's shift
    if (card.actualStartTime != null && card.actualEndTime != null) {
      // Check-in and check-out completed
      return card.isLate ? ShiftStatus.late : ShiftStatus.completed;
    }

    if (card.actualStartTime != null && card.actualEndTime == null) {
      // Currently working (checked in but not out)
      return ShiftStatus.inProgress;
    }

    // Past date but no check-in
    if (cardDate.isBefore(today)) {
      return ShiftStatus.undone;
    }

    // Today's shift that hasn't started yet
    return ShiftStatus.onTime;
  }

  /// Parse request_date string to DateTime
  DateTime? _parseRequestDate(String requestDate) {
    try {
      if (requestDate.contains('T')) {
        return DateTime.parse(requestDate).toLocal();
      }
      final parts = requestDate.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      return null;
    }
  }

  /// Format date to "Tue, 18 Jun 2025" format
  String _formatDate(String requestDate) {
    final date = _parseRequestDate(requestDate);
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

  /// Format shift time (e.g., "14:00 ~ 18:00" -> "14:00 - 18:00")
  String _formatTimeRange(String shiftTime) {
    return shiftTime.replaceAll('~', '-').trim();
  }

  @override
  Widget build(BuildContext context) {
    final status = _determineStatus(todayShift);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Shift Card (with GlobalKey to measure height)
        Container(
          key: cardKey,
          child: TossTodayShiftCard(
            shiftType: todayShift?.shiftName ?? 'No Shift',
            date: todayShift != null ? _formatDate(todayShift!.requestDate) : null,
            timeRange: todayShift != null ? _formatTimeRange(todayShift!.shiftTime) : null,
            location: todayShift?.storeName,
            status: status,
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
