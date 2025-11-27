import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../utils/attendance_helper_methods.dart';

/// Widget displaying recent attendance activity for the selected date
class AttendanceRecentActivity extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> allShiftCardsData;
  final Map<String, dynamic>? shiftOverviewData;
  final Function(Map<String, dynamic>) onActivityTap;
  final VoidCallback onViewAllTap;

  const AttendanceRecentActivity({
    super.key,
    required this.selectedDate,
    required this.allShiftCardsData,
    this.shiftOverviewData,
    required this.onActivityTap,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final recentActivities = _getRecentActivities();

    if (recentActivities.isEmpty) {
      return _buildEmptyState();
    }

    return _buildActivityList(recentActivities);
  }

  /// Get recent activities for the selected date
  List<Map<String, dynamic>> _getRecentActivities() {
    final selectedDateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Filter cards for the selected date only
    final selectedDateCards = allShiftCardsData.where((card) {
      final cardDate = card['request_date'] ?? '';
      return cardDate == selectedDateStr;
    }).toList();

    // Sort by shift_request_id or any other relevant field
    selectedDateCards.sort((a, b) {
      final idA = (a['shift_request_id'] ?? '') as String;
      final idB = (b['shift_request_id'] ?? '') as String;
      return idA.compareTo(idB);
    });

    return selectedDateCards.map((card) {
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

      // Use AttendanceHelpers to properly convert UTC to local time
      String checkInTime = AttendanceHelpers.formatTime(actualStart, requestDate: requestDate);
      String checkOutTime = AttendanceHelpers.formatTime(actualEnd, requestDate: requestDate);

      // Use paid_hours directly from RPC (already calculated server-side)
      // No need to recalculate from actual_start_time/actual_end_time
      final paidHours = (card['paid_hours'] as num?)?.toDouble() ?? 0.0;
      final hours = paidHours.floor();
      final minutes = ((paidHours - hours) * 60).round();
      String hoursWorked = '${hours}h ${minutes}m';

      // Check if shift is approved and reported
      final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
      final isReported = card['is_reported'] ?? false;

      // Determine the actual working status
      String workStatus = 'pending';
      if (isApproved == true) {
        if (actualStart != null && actualEnd == null) {
          workStatus = 'working'; // Currently working (checked in but not checked out)
        } else if (actualStart != null && actualEnd != null) {
          workStatus = 'completed'; // Finished working (checked in and checked out)
        } else {
          workStatus = 'approved'; // Approved but not started yet
        }
      }

      // shift_time is already converted to local timezone by RPC (user_shift_cards_v3)
      // RPC uses: to_char(vsr.start_time_utc AT TIME ZONE p_timezone, 'HH24:MI')
      // No additional conversion needed
      final shiftTime = (card['shift_time'] ?? '--:-- ~ --:--').toString();

      return {
        'date': date,
        'checkIn': checkInTime,
        'checkOut': checkOutTime,
        'hours': hoursWorked,
        'store': card['store_name'] ?? 'Store',
        'shiftInfo': '${card['shift_name'] ?? 'Shift'} • $shiftTime',
        'status': actualEnd != null ? 'completed' : 'in_progress',
        'lateMinutes': card['late_minutes'] ?? 0,
        'overtimeMinutes': card['overtime_minutes'] ?? 0,
        'isApproved': isApproved,
        'isReported': isReported,
        'workStatus': workStatus, // Add work status
        'rawCard': card, // Keep the raw card data for debugging
      };
    }).toList();
  }

  Widget _buildEmptyState() {
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

  Widget _buildActivityList(List<Map<String, dynamic>> recentActivities) {
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
                                              color: AttendanceHelpers.getActivityStatusColor(
                                                  (activity['workStatus'] ?? 'pending').toString()),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: TossSpacing.space1),
                                          Text(
                                            AttendanceHelpers.getActivityStatusText(
                                                (activity['workStatus'] ?? 'pending').toString()),
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
