import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../helpers/format_helpers.dart';

/// Recent activity widget displaying shift cards for selected date
///
/// Shows:
/// - Activity list for selected date
/// - Check-in/check-out times and duration
/// - Shift information and status indicators
/// - View all history button
class AttendanceRecentActivity extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> allShiftCardsData;
  final Function(Map<String, dynamic>) onActivityTap;
  final VoidCallback onViewAllTap;
  final Color Function(String) getActivityStatusColor;
  final String Function(String) getActivityStatusText;

  const AttendanceRecentActivity({
    super.key,
    required this.selectedDate,
    required this.allShiftCardsData,
    required this.onActivityTap,
    required this.onViewAllTap,
    required this.getActivityStatusColor,
    required this.getActivityStatusText,
  });

  @override
  Widget build(BuildContext context) {
    // Filter activities for the selected date
    final selectedDateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Filter cards for the selected date only
    final selectedDateCards = allShiftCardsData.where((card) {
      final cardDate = card['request_date'] ?? '';
      return cardDate == selectedDateStr;
    }).toList();

    // Sort by shift_request_id
    selectedDateCards.sort((a, b) {
      final idA = (a['shift_request_id'] ?? '') as String;
      final idB = (b['shift_request_id'] ?? '') as String;
      return idA.compareTo(idB);
    });

    final recentActivities = selectedDateCards.map((card) {
      // Parse date
      final dateStr = (card['request_date'] ?? '').toString();
      final dateParts = dateStr.split('-');
      final date = dateParts.length == 3
          ? DateTime(
              int.parse(dateParts[0].toString()),
              int.parse(dateParts[1].toString()),
              int.parse(dateParts[2].toString()),
            )
          : DateTime.now();

      // Parse times - check both confirm_* and actual_* fields
      final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
      final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];
      final requestDate = card['request_date']?.toString();

      // Use FormatHelpers to properly convert UTC to local time
      String checkInTime = FormatHelpers.formatTime(actualStart, requestDate: requestDate);
      String checkOutTime = FormatHelpers.formatTime(actualEnd, requestDate: requestDate);
      String hoursWorked = '0h 0m';

      // Calculate hours worked if we have both times
      if (actualStart != null && actualStart.toString().isNotEmpty &&
          actualEnd != null && actualEnd.toString().isNotEmpty) {
        try {
          // Parse the request_date and combine with times to get full DateTime
          final baseDate = date;

          // Parse start time (UTC from DB - convert to local time)
          DateTime startDateTime;
          if (actualStart.toString().contains('T')) {
            startDateTime = DateTimeUtils.toLocal(actualStart.toString());
          } else {
            // Time-only format from RPC - combine with date and convert
            final startParts = actualStart.toString().split(':');
            if (startParts.length >= 2 && requestDate != null) {
              final utcTimestamp = '${requestDate}T${actualStart.toString().padRight(8, ':00')}Z';
              startDateTime = DateTimeUtils.toLocal(utcTimestamp);
            } else {
              final hour = int.tryParse(startParts[0]) ?? 0;
              final minute = startParts.length > 1 ? int.tryParse(startParts[1]) ?? 0 : 0;
              startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
            }
          }

          // Parse end time (UTC from DB - convert to local time)
          DateTime endDateTime;
          if (actualEnd.toString().contains('T')) {
            endDateTime = DateTimeUtils.toLocal(actualEnd.toString());
          } else {
            // Time-only format from RPC - combine with date and convert
            final endParts = actualEnd.toString().split(':');
            if (endParts.length >= 2 && requestDate != null) {
              final utcTimestamp = '${requestDate}T${actualEnd.toString().padRight(8, ':00')}Z';
              endDateTime = DateTimeUtils.toLocal(utcTimestamp);
            } else {
              final hour = int.tryParse(endParts[0]) ?? 0;
              final minute = endParts.length > 1 ? int.tryParse(endParts[1]) ?? 0 : 0;
              endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
            }
          }

          // Calculate hours worked based on converted local times
          final duration = endDateTime.difference(startDateTime);
          final hours = duration.inHours;
          final minutes = duration.inMinutes % 60;
          hoursWorked = '${hours}h ${minutes}m';
        } catch (e) {
          // Error calculating duration
        }
      }

      // Check if shift is approved and reported
      final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
      final isReported = card['is_reported'] ?? false;

      // Determine the actual working status
      String workStatus = 'pending';
      if (isApproved == true) {
        if (actualStart != null && actualEnd == null) {
          workStatus = 'working'; // Currently working
        } else if (actualStart != null && actualEnd != null) {
          workStatus = 'completed'; // Finished working
        } else {
          workStatus = 'approved'; // Approved but not started yet
        }
      }

      // Convert shift time from UTC to local time
      final rawShiftTime = (card['shift_time'] ?? '--:-- ~ --:--').toString();
      final localShiftTime = FormatHelpers.formatShiftTime(rawShiftTime, requestDate: requestDate);

      return {
        'date': date,
        'checkIn': checkInTime,
        'checkOut': checkOutTime,
        'hours': hoursWorked,
        'store': card['store_name'] ?? 'Store',
        'shiftInfo': '${card['shift_name'] ?? 'Shift'} • $localShiftTime',
        'status': actualEnd != null ? 'completed' : 'in_progress',
        'lateMinutes': card['late_minutes'] ?? 0,
        'overtimeMinutes': card['overtime_minutes'] ?? 0,
        'isApproved': isApproved,
        'isReported': isReported,
        'workStatus': workStatus,
        'rawCard': card,
      };
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
              Text(
                'Activity',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onViewAllTap();
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Text(
                    'View All',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Activity List
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray100,
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
                          onActivityTap(activity);
                          HapticFeedback.selectionClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          child: Row(
                            children: [
                              // Time info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main time display
                                    Row(
                                      children: [
                                        Text(
                                          activity['checkIn'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkIn'] == '--:--'
                                                ? TossColors.gray400
                                                : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ' → ',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray400,
                                          ),
                                        ),
                                        Text(
                                          activity['checkOut'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkOut'] == '--:--'
                                                ? TossColors.gray400
                                                : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TossSpacing.space1),
                                    // Shift Name and Time
                                    Text(
                                      activity['shiftInfo'] as String,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
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
                                    activity['hours'] as String,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
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
                                              color: getActivityStatusColor((activity['workStatus'] ?? 'pending').toString()),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: TossSpacing.space1),
                                          Text(
                                            getActivityStatusText((activity['workStatus'] ?? 'pending').toString()),
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Reported status if applicable
                                      if (activity['isReported'] as bool) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.flag,
                                              size: 10,
                                              color: TossColors.error,
                                            ),
                                            const SizedBox(width: TossSpacing.space1),
                                            Text(
                                              'Reported',
                                              style: TossTextStyles.caption.copyWith(
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
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
