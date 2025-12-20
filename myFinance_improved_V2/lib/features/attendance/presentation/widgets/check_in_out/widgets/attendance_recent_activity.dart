import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/shift_card.dart';
import '../helpers/format_helpers.dart';

/// Recent activity widget displaying shift cards for selected date
///
/// Shows:
/// - Activity list for selected date
/// - Check-in/check-out times and duration
/// - Shift information and status indicators
/// - View all history button
///
/// ✅ Clean Architecture: Uses ShiftCard Entity instead of Map<String, dynamic>
class AttendanceRecentActivity extends StatelessWidget {
  final DateTime selectedDate;
  /// ✅ Clean Architecture: Use ShiftCard Entity list
  final List<ShiftCard> shiftCards;
  final Function(ShiftCard) onActivityTap;
  final VoidCallback onViewAllTap;
  final Color Function(String) getActivityStatusColor;
  final String Function(String) getActivityStatusText;

  const AttendanceRecentActivity({
    super.key,
    required this.selectedDate,
    required this.shiftCards,
    required this.onActivityTap,
    required this.onViewAllTap,
    required this.getActivityStatusColor,
    required this.getActivityStatusText,
  });

  /// Format shift time range from shiftStartTime and shiftEndTime
  /// e.g., "2025-06-01T14:00:00", "2025-06-01T18:00:00" -> "14:00 ~ 18:00"
  String _formatShiftTimeRange(String shiftStartTime, String shiftEndTime) {
    try {
      if (shiftStartTime.isEmpty || shiftEndTime.isEmpty) {
        return '--:-- ~ --:--';
      }
      final startDateTime = DateTime.parse(shiftStartTime);
      final endDateTime = DateTime.parse(shiftEndTime);
      final startStr =
          '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endStr =
          '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';
      return '$startStr ~ $endStr';
    } catch (e) {
      return '--:-- ~ --:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter activities for the selected date
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Filter cards for the selected date only using Entity property
    final selectedDateCards = shiftCards.where((card) {
      return card.requestDate == selectedDateStr;
    }).toList();

    // Sort by shift_request_id
    selectedDateCards.sort((a, b) {
      return a.shiftRequestId.compareTo(b.shiftRequestId);
    });

    // Build activity data from ShiftCard entities
    final recentActivities = selectedDateCards.map((card) {
      // Use Entity properties for check-in/check-out times
      final actualStart = card.confirmStartTime ?? card.actualStartTime;
      final actualEnd = card.confirmEndTime ?? card.actualEndTime;

      // Format times using helpers
      String checkInTime =
          FormatHelpers.formatTime(actualStart, requestDate: card.requestDate);
      String checkOutTime =
          FormatHelpers.formatTime(actualEnd, requestDate: card.requestDate);
      String hoursWorked = '0h 0m';

      // Calculate hours worked using Entity's paidHours if available
      if (card.isCheckedIn && card.isCheckedOut) {
        final hours = card.paidHours.floor();
        final minutes = ((card.paidHours - hours) * 60).round();
        hoursWorked = '${hours}h ${minutes}m';
      }

      // Determine work status using Entity properties
      String workStatus = 'pending';
      if (card.isApproved) {
        if (card.isCheckedIn && !card.isCheckedOut) {
          workStatus = 'working'; // Currently working
        } else if (card.isCheckedIn && card.isCheckedOut) {
          workStatus = 'completed'; // Finished working
        } else {
          workStatus = 'approved'; // Approved but not started yet
        }
      }

      // Format shift time from Entity properties
      final localShiftTime = _formatShiftTimeRange(
        card.shiftStartTime,
        card.shiftEndTime,
      );

      return _ActivityData(
        card: card,
        checkIn: checkInTime,
        checkOut: checkOutTime,
        hours: hoursWorked,
        store: card.storeName,
        shiftInfo: '${card.shiftName ?? 'Shift'} • $localShiftTime',
        status: card.isCheckedOut ? 'completed' : 'in_progress',
        lateMinutes: card.lateMinutes.toInt(),
        overtimeMinutes: card.overtimeMinutes.toInt(),
        isApproved: card.isApproved,
        isReported: card.isReported,
        workStatus: workStatus,
      );
    }).toList();

    // Empty state
    if (recentActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space6,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.event_busy,
                      size: 32,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'No activity',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Activity list
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    FormatHelpers.formatDateWithDay(selectedDate),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              Material(
                color: TossColors.transparent,
                child: InkWell(
                  onTap: () {
                    onViewAllTap();
                    HapticFeedback.selectionClick();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View All',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: TossColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          // Activity List
          Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Column(
              children: recentActivities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final isLast = index == recentActivities.length - 1;

                return Column(
                  children: [
                    Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: () {
                          onActivityTap(activity.card);
                          HapticFeedback.selectionClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          child: Row(
                            children: [
                              // Left: Time badge
                              Container(
                                padding:
                                    const EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: TossColors.primarySurface,
                                  borderRadius:
                                      BorderRadius.circular(TossBorderRadius.lg),
                                ),
                                child: const Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: TossColors.primary,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              // Time info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main time display
                                    Row(
                                      children: [
                                        Text(
                                          activity.checkIn,
                                          style:
                                              TossTextStyles.bodyMedium.copyWith(
                                            color: activity.checkIn == '--:--'
                                                ? TossColors.gray400
                                                : TossColors.gray900,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: TossSpacing.space2,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 14,
                                            color: TossColors.gray400,
                                          ),
                                        ),
                                        Text(
                                          activity.checkOut,
                                          style:
                                              TossTextStyles.bodyMedium.copyWith(
                                            color: activity.checkOut == '--:--'
                                                ? TossColors.gray400
                                                : TossColors.gray900,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TossSpacing.space1),
                                    // Shift Name and Time
                                    Text(
                                      activity.shiftInfo,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Duration and status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Duration
                                  Text(
                                    activity.hours,
                                    style: TossTextStyles.bodyMedium.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space1),
                                  // Status indicators
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Work status
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: getActivityStatusColor(
                                                activity.workStatus,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: TossSpacing.space1,
                                          ),
                                          Text(
                                            getActivityStatusText(
                                              activity.workStatus,
                                            ),
                                            style:
                                                TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Reported status if applicable
                                      if (activity.isReported) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.flag,
                                              size: 10,
                                              color: TossColors.error,
                                            ),
                                            const SizedBox(
                                              width: TossSpacing.space1,
                                            ),
                                            Text(
                                              'Reported',
                                              style:
                                                  TossTextStyles.caption.copyWith(
                                                color: TossColors.error,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              // Chevron
                              const SizedBox(width: TossSpacing.space3),
                              const Icon(
                                Icons.chevron_right,
                                color: TossColors.gray300,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Divider between items
                    if (!isLast)
                      Container(
                        height: 1,
                        color: TossColors.gray100,
                        margin: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal data class for activity display
class _ActivityData {
  final ShiftCard card;
  final String checkIn;
  final String checkOut;
  final String hours;
  final String store;
  final String shiftInfo;
  final String status;
  final int lateMinutes;
  final int overtimeMinutes;
  final bool isApproved;
  final bool isReported;
  final String workStatus;

  const _ActivityData({
    required this.card,
    required this.checkIn,
    required this.checkOut,
    required this.hours,
    required this.store,
    required this.shiftInfo,
    required this.status,
    required this.lateMinutes,
    required this.overtimeMinutes,
    required this.isApproved,
    required this.isReported,
    required this.workStatus,
  });
}
