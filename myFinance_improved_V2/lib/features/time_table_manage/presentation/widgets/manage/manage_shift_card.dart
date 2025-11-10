import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Manage Shift Card
///
/// Displays shift request details for the Manage tab with problem indicators
class ManageShiftCard extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback onTap;

  const ManageShiftCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final userName = card['user_name'] as String? ?? 'Unknown';
    final profileImage = card['profile_image'] as String?;
    final shiftName = card['shift_name'] as String? ?? 'Unknown Shift';
    final rawShiftTime = card['shift_time'] as String? ?? '--:--';
    final requestDate = card['request_date'] as String?;
    // Convert shift time from UTC to local time
    final shiftTime = _formatShiftTime(rawShiftTime, requestDate);
    final isApproved = (card['is_approved'] as bool?) ?? false;
    final isProblem = (card['is_problem'] as bool?) ?? false;
    final isProblemSolved = (card['is_problem_solved'] as bool?) ?? false;
    final isLate = (card['is_late'] as bool?) ?? false;
    final lateMinute = ((card['late_minute'] as num?) ?? 0).toInt();
    final isOverTime = (card['is_over_time'] as bool?) ?? false;
    final overTimeMinute = ((card['over_time_minute'] as num?) ?? 0).toInt();
    final paidHour = (card['paid_hour'] as num?) ?? 0;
    final isReported = (card['is_reported'] as bool?) ?? false;

    // Parse confirmed times
    final confirmStartTimeStr = card['confirm_start_time'] as String?;
    final confirmEndTimeStr = card['confirm_end_time'] as String?;
    // Show confirmed time if at least one is present
    final hasConfirmedTime = confirmStartTimeStr != null || confirmEndTimeStr != null;

    // Check if problem is unsolved
    final hasUnsolvedProblem = isProblem && !isProblemSolved;

    // Check if reported AND problem not solved
    final isReportedUnsolvedProblem = isReported && !isProblemSolved;

    // Determine card border color based on status
    final borderColor = _getBorderColor(
      isReportedUnsolvedProblem,
      hasUnsolvedProblem,
      isApproved,
    );

    final backgroundColor = _getBackgroundColor(
      isReportedUnsolvedProblem,
      hasUnsolvedProblem,
      isApproved,
    );

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
        margin: const EdgeInsets.only(bottom: TossSpacing.space3),
        decoration: BoxDecoration(
          color: isReportedUnsolvedProblem
              ? TossColors.primary.withValues(alpha: 0.05)
              : TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Card header
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  // User avatar
                  _buildAvatar(profileImage, userName),
                  const SizedBox(width: TossSpacing.space3),

                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shiftName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shiftTime,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  _buildStatusBadge(
                    isReportedUnsolvedProblem,
                    hasUnsolvedProblem,
                    isApproved,
                  ),
                ],
              ),
            ),

            // Card body with details
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show confirmed time if available, otherwise show plan time
                  Row(
                    children: [
                      if (hasConfirmedTime) ...[
                        // Confirmed time with arrow icons
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          confirmStartTimeStr != null
                              ? _formatConfirmedTime(confirmStartTimeStr)
                              : '--:--',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          confirmEndTimeStr != null
                              ? _formatConfirmedTime(confirmEndTimeStr)
                              : '--:--',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else ...[
                        // Plan time with clock icon (when no confirmed time yet)
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          shiftTime,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Show paid hours if available
                      if (paidHour > 0) ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          '${paidHour}h',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Problem indicators
                  if (isLate || isOverTime || isReported) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Wrap(
                      spacing: TossSpacing.space2,
                      runSpacing: TossSpacing.space1,
                      children: [
                        if (isLate)
                          _buildProblemBadge(
                            'Late ${lateMinute}min',
                            TossColors.warning,
                          ),
                        if (isOverTime)
                          _buildProblemBadge(
                            'OT ${overTimeMinute}min',
                            TossColors.info,
                          ),
                        if (isReported)
                          _buildProblemBadge(
                            'Reported',
                            TossColors.primary,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? profileImage, String userName) {
    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: TossColors.primary.withValues(alpha: 0.1),
        ),
        child: profileImage != null && profileImage.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImage,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: Icon(
                    Icons.person,
                    color: TossColors.primary,
                    size: 24,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.person,
                    color: TossColors.primary,
                    size: 24,
                  ),
                ),
              )
            : Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatusBadge(
    bool isReportedUnsolvedProblem,
    bool hasUnsolvedProblem,
    bool isApproved,
  ) {
    String text;
    Color color;
    Color bgColor;

    if (isReportedUnsolvedProblem) {
      text = 'Reported';
      color = TossColors.primary;
      bgColor = TossColors.primary.withValues(alpha: 0.1);
    } else if (hasUnsolvedProblem) {
      text = 'Problem';
      color = TossColors.error;
      bgColor = TossColors.error.withValues(alpha: 0.1);
    } else if (isApproved) {
      text = 'Approved';
      color = TossColors.success;
      bgColor = TossColors.success.withValues(alpha: 0.1);
    } else {
      text = 'Pending';
      color = TossColors.warning;
      bgColor = TossColors.warning.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Text(
        text,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProblemBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        text,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _getBorderColor(
    bool isReportedUnsolvedProblem,
    bool hasUnsolvedProblem,
    bool isApproved,
  ) {
    if (isReportedUnsolvedProblem) {
      return TossColors.primary;
    } else if (hasUnsolvedProblem) {
      return TossColors.error;
    } else if (isApproved) {
      return TossColors.success;
    } else {
      return TossColors.warning;
    }
  }

  Color _getBackgroundColor(
    bool isReportedUnsolvedProblem,
    bool hasUnsolvedProblem,
    bool isApproved,
  ) {
    if (isReportedUnsolvedProblem) {
      return TossColors.primary.withValues(alpha: 0.08);
    } else if (hasUnsolvedProblem) {
      return TossColors.error.withValues(alpha: 0.05);
    } else if (isApproved) {
      return TossColors.success.withValues(alpha: 0.05);
    } else {
      return TossColors.warning.withValues(alpha: 0.05);
    }
  }

  /// Convert shift time from UTC to local time
  /// Input: "14:56-17:56" or "14:56 ~ 17:56" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56-00:56" (Local time, Vietnam = UTC+7)
  String _formatShiftTime(String shiftTime, String? requestDate) {
    if (shiftTime == '--:--' || requestDate == null) {
      return shiftTime;
    }

    try {
      // Parse shift time format: "14:56-17:56" or "14:56 ~ 17:56"
      final separator = shiftTime.contains('~') ? '~' : '-';
      final parts = shiftTime.split(separator).map((e) => e.trim()).toList();

      if (parts.length != 2) {
        return shiftTime;
      }

      final startTime = parts[0].trim();
      final endTime = parts[1].trim();

      // Convert each time from UTC to local
      final localStartTime = _formatTime(startTime, requestDate);
      final localEndTime = _formatTime(endTime, requestDate);

      return '$localStartTime$separator$localEndTime';
    } catch (e) {
      return shiftTime;
    }
  }

  /// Convert time string from UTC to local time
  /// Input: "14:56" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56" (Local time, Vietnam = UTC+7)
  String _formatTime(String time, String requestDate) {
    if (time.isEmpty || time == '--:--') {
      return time;
    }

    try {
      // Combine date + time and treat as UTC
      final utcTimestamp = '${requestDate}T$time:00Z';
      final dateTime = DateTimeUtils.toLocal(utcTimestamp);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }

  /// Format confirmed time from ISO8601 string to HH:mm format
  /// Input: "2025-11-07T11:40:00.000Z" or "2025-11-07T11:40:00.000"
  /// Output: "11:40" (already in local time from Entity)
  String _formatConfirmedTime(String isoString) {
    if (isoString.isEmpty) {
      return '--:--';
    }

    try {
      final dateTime = DateTime.parse(isoString);
      return DateTimeUtils.formatTimeOnly(dateTime);
    } catch (e) {
      return '--:--';
    }
  }
}
