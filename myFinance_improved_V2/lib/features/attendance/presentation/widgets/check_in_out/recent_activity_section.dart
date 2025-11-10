import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_card_data.dart';
import '../../utils/attendance_formatters.dart';
import '../../utils/date_format_utils.dart';

class RecentActivitySection extends StatelessWidget {
  final DateTime selectedDate;
  final List<ShiftCardData> allShiftCardsData;
  final Map<String, dynamic>? shiftOverviewData;
  final Function(Map<String, dynamic>) onShowActivityDetails;
  final VoidCallback onViewAllActivity;

  const RecentActivitySection({
    super.key,
    required this.selectedDate,
    required this.allShiftCardsData,
    this.shiftOverviewData,
    required this.onShowActivityDetails,
    required this.onViewAllActivity,
  });

  @override
  Widget build(BuildContext context) {
    // Filter activities for the selected date
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Filter cards for the selected date only
    final selectedDateCards = allShiftCardsData.where((card) {
      return card.requestDate == selectedDateStr;
    }).toList();

    // Sort by shift_request_id
    selectedDateCards.sort((a, b) {
      return a.shiftRequestId.compareTo(b.shiftRequestId);
    });

    final recentActivities = selectedDateCards.map((card) {
      // Parse date
      final dateStr = card.requestDate;
      final dateParts = dateStr.split('-');
      final date = dateParts.length == 3
          ? DateTime(
              int.parse(dateParts[0].toString()),
              int.parse(dateParts[1].toString()),
              int.parse(dateParts[2].toString()),
            )
          : DateTime.now();

      // Parse times - check both confirm_* and actual_* fields
      final actualStart = card.confirmStartTime ?? card.actualStartTime;
      final actualEnd = card.confirmEndTime ?? card.actualEndTime;
      final requestDate = card.requestDate;

      // Use AttendanceFormatters.formatTime() to properly convert UTC to local time
      String checkInTime = AttendanceFormatters.formatTime(actualStart, requestDate: requestDate);
      String checkOutTime = AttendanceFormatters.formatTime(actualEnd, requestDate: requestDate);
      String hoursWorked = '0h 0m';

      // Calculate hours worked if we have both times
      if (actualStart != null &&
          actualStart.toString().isNotEmpty &&
          actualEnd != null &&
          actualEnd.toString().isNotEmpty) {
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
              final utcTimestamp =
                  '${requestDate}T${actualStart.toString().padRight(8, ':00')}Z';
              startDateTime = DateTimeUtils.toLocal(utcTimestamp);
            } else {
              final hour = int.tryParse(startParts[0]) ?? 0;
              final minute =
                  startParts.length > 1 ? int.tryParse(startParts[1]) ?? 0 : 0;
              startDateTime = DateTime(
                  baseDate.year, baseDate.month, baseDate.day, hour, minute);
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
              final utcTimestamp =
                  '${requestDate}T${actualEnd.toString().padRight(8, ':00')}Z';
              endDateTime = DateTimeUtils.toLocal(utcTimestamp);
            } else {
              final hour = int.tryParse(endParts[0]) ?? 0;
              final minute =
                  endParts.length > 1 ? int.tryParse(endParts[1]) ?? 0 : 0;
              endDateTime = DateTime(
                  baseDate.year, baseDate.month, baseDate.day, hour, minute);
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
      final isApproved = card.isApproved || card.approvalStatus == 'approved';
      final isReported = card.isReported;

      // Determine the actual working status
      String workStatus = 'pending';
      if (isApproved) {
        if (actualStart != null && actualEnd == null) {
          workStatus =
              'working'; // Currently working (checked in but not checked out)
        } else if (actualStart != null && actualEnd != null) {
          workStatus =
              'completed'; // Finished working (checked in and checked out)
        } else {
          workStatus = 'approved'; // Approved but not started yet
        }
      }

      // Convert shift time from UTC to local time
      final rawShiftTime = card.shiftTime ?? '--:-- ~ --:--';
      final localShiftTime = AttendanceFormatters.formatShiftTime(rawShiftTime, requestDate: requestDate);

      return {
        'date': date,
        'checkIn': checkInTime,
        'checkOut': checkOutTime,
        'hours': hoursWorked,
        'store': card.storeName,
        'shiftInfo': '${card.shiftName ?? 'Shift'} • $localShiftTime',
        'status': actualEnd != null ? 'completed' : 'in_progress',
        'lateMinutes': card.lateMinutes,
        'overtimeMinutes': card.overtimeMinutes,
        'isApproved': isApproved,
        'isReported': isReported,
        'workStatus': workStatus, // Add work status
        'rawCard': card, // Keep the raw card data for debugging
      };
    }).toList();

    // Toss-style activity section - Minimalist design
    if (recentActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Activity',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Empty state - Simple and clean
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
                    Icon(
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header with View All
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
              // View All Button - Subtle text button
              GestureDetector(
                onTap: () {
                  onViewAllActivity();
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
          // Activity List - Clean card design
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
                final date = activity['date'] as DateTime;
                final isLast = index == recentActivities.length - 1;

                return Column(
                  children: [
                    Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: () {
                          onShowActivityDetails(activity);
                          HapticFeedback.selectionClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          child: Row(
                            children: [
                              // Time info - Simplified
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main time display - Show both confirm times
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
                                            color:
                                                activity['checkOut'] == '--:--'
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
                                              color: _getActivityStatusColor(
                                                  (activity['workStatus'] ??
                                                          'pending')
                                                      .toString()),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(
                                              width: TossSpacing.space1),
                                          Text(
                                            _getActivityStatusText(
                                                (activity['workStatus'] ??
                                                        'pending')
                                                    .toString()),
                                            style:
                                                TossTextStyles.caption.copyWith(
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
                                            Icon(
                                              Icons.flag,
                                              size: 10,
                                              color: TossColors.error,
                                            ),
                                            const SizedBox(
                                                width: TossSpacing.space1),
                                            Text(
                                              'Reported',
                                              style: TossTextStyles.caption
                                                  .copyWith(
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
                              Icon(
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
                            horizontal: TossSpacing.space4),
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

  Color _getActivityStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.primary; // Blue for currently working
      case 'completed':
        return TossColors.success; // Green for completed shift
      case 'approved':
        return TossColors.success
            .withOpacity(0.7); // Lighter green for approved but not started
      case 'pending':
        return TossColors.warning; // Orange for pending approval
      default:
        return TossColors.gray400;
    }
  }

  String _getActivityStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'completed':
        return 'Completed';
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
}
