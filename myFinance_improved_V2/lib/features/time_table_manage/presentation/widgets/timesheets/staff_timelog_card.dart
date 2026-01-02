import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../domain/entities/manager_memo.dart';
import '../../../domain/entities/problem_details.dart';

/// Model for staff time record
class StaffTimeRecord {
  final String staffId;
  final String staffName;
  final String? avatarUrl;
  final String clockIn;
  final String clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool needsConfirm;
  final bool isConfirmed;

  // Additional fields from RPC (manager_shift_get_cards_v4)
  final String? shiftRequestId; // shift_request_id - Required for RPC calls
  final String? actualStart; // actual_start - Recorded check-in
  final String? actualEnd; // actual_end - Recorded check-out
  final String? confirmStartTime; // confirm_start_time - Confirmed check-in
  final String? confirmEndTime; // confirm_end_time - Confirmed check-out
  final bool isReported; // is_reported - Issue report exists
  final String? reportReason; // report_reason - Issue report content
  final bool isProblemSolved; // is_problem_solved
  final double bonusAmount; // bonus_amount - Default bonus
  final String? salaryType; // salary_type - 'hourly' or 'monthly'
  final String? salaryAmount; // salary_amount - Hourly rate
  final String? basePay; // base_pay
  final String? totalPayWithBonus; // total_pay_with_bonus
  final double paidHour; // paid_hour
  final int lateMinute; // late_minute
  final int overtimeMinute; // over_time_minute

  // v4: New fields
  final bool? isReportedSolved; // is_reported_solved - Whether report is resolved
  final List<ManagerMemo> managerMemos; // manager_memo - Manager memos

  // Shift end time - used to determine if shift has ended yet
  // If current time is before this, don't show "Need confirm"
  final DateTime? shiftEndTime;

  // v5: Problem details from problem_details_v2
  final ProblemDetails? problemDetails;

  const StaffTimeRecord({
    required this.staffId,
    required this.staffName,
    this.avatarUrl,
    required this.clockIn,
    required this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.needsConfirm = false,
    this.isConfirmed = false,
    // New fields
    this.shiftRequestId,
    this.actualStart,
    this.actualEnd,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isReported = false,
    this.reportReason,
    this.isProblemSolved = false,
    this.bonusAmount = 0.0,
    this.salaryType,
    this.salaryAmount,
    this.basePay,
    this.totalPayWithBonus,
    this.paidHour = 0.0,
    this.lateMinute = 0,
    this.overtimeMinute = 0,
    // v4: New fields
    this.isReportedSolved,
    this.managerMemos = const [],
    this.shiftEndTime,
    // v5: Problem details
    this.problemDetails,
  });
}

/// Card displaying staff clock in/out record with problem tags
///
/// Shows problem tags based on problem_details_v2:
/// - 🔴 Red tag: Unsolved problem (Late, OT, No Checkout, etc.)
/// - 🟠 Orange tag: Unsolved report
/// - ⚪ Gray tag with ✓: Solved problem
class StaffTimelogCard extends StatelessWidget {
  final StaffTimeRecord record;
  final VoidCallback? onTap;

  const StaffTimelogCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final problemTags = _buildProblemTags();

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              // Avatar
              EmployeeProfileAvatar(
                imageUrl: record.avatarUrl,
                name: record.staffName,
                size: 28,
              ),

              const SizedBox(width: TossSpacing.space3),

              // Name, Time, and Tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.staffName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Time row - show actual → confirmed if different
                    _buildTimeRow(),
                    // Problem tags row (if any)
                    if (problemTags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: problemTags,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: TossSpacing.space2),

              // Chevron
              Icon(
                Icons.chevron_right,
                size: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build time row showing actual → confirmed if adjusted
  /// Example: "10:05 → 10:00 - 14:11 → 14:00" or just "10:00 - 14:00"
  Widget _buildTimeRow() {
    final actualIn = record.actualStart;
    final confirmedIn = record.confirmStartTime;
    final actualOut = record.actualEnd;
    final confirmedOut = record.confirmEndTime;

    // Check if times were adjusted
    final inAdjusted = actualIn != null && confirmedIn != null && actualIn != confirmedIn;
    final outAdjusted = actualOut != null && confirmedOut != null && actualOut != confirmedOut;

    if (!inAdjusted && !outAdjusted) {
      // No adjustments - simple display
      return Text(
        '${record.clockIn} - ${record.clockOut}',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // Has adjustments - show with arrows
    return Row(
      children: [
        // Check-in time
        if (inAdjusted) ...[
          Text(
            _formatTime(actualIn),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            ' → ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatTime(confirmedIn),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else
          Text(
            record.clockIn,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        // Separator
        Text(
          ' - ',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Check-out time
        if (outAdjusted) ...[
          Text(
            _formatTime(actualOut),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            ' → ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray400,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatTime(confirmedOut),
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else
          Text(
            record.clockOut,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  /// Format time string to HH:mm
  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    // Handle formats like "10:05:00" or "10:05:00+07"
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return time;
  }

  /// Build problem tags from problem_details_v2 exclusively
  /// Priority order: No Checkout > Absence > Late > Early Leave > Overtime > Reported
  ///
  /// NEW: If shift is still in progress (current time < shift end time),
  /// show "In Progress" instead of "No Checkout" or "Absent"
  List<Widget> _buildProblemTags() {
    final List<Widget> tags = [];
    final pd = record.problemDetails;

    // Check if shift is still in progress
    final shiftEnd = record.shiftEndTime;
    final now = DateTime.now().toUtc();
    final isInProgress = shiftEnd != null && now.isBefore(shiftEnd);

    // If shift is in progress AND has checkin, show "In Progress" tag
    if (isInProgress && record.actualStart != null) {
      tags.add(const _StatusTag(
        label: 'In Progress',
        isPositive: true,
      ));

      // Still show other relevant problems (Late, Reported, etc.) but filter out future problems
      if (pd != null && pd.problemCount > 0) {
        for (final problem in pd.problems) {
          // Skip "no_checkout" and "absence" for in-progress shifts
          if (problem.type == 'no_checkout' || problem.type == 'absence') {
            continue;
          }
          final tag = _buildTagForProblem(problem);
          if (tag != null) tags.add(tag);
        }
      }
      return tags;
    }

    // If shift hasn't started yet (no checkin) and shift hasn't ended, show nothing or "Scheduled"
    if (isInProgress && record.actualStart == null) {
      // Shift hasn't started yet - don't show "Absent" prematurely
      return tags; // Empty - wait until shift ends
    }

    // Only use problem_details_v2 - no legacy fallback
    if (pd == null || pd.problemCount == 0) {
      return tags; // Empty - no problems
    }

    // Build tags from problem_details.problems array
    for (final problem in pd.problems) {
      final tag = _buildTagForProblem(problem);
      if (tag != null) tags.add(tag);
    }

    return tags;
  }

  /// Build tag widget for a single problem item
  Widget? _buildTagForProblem(ProblemItem problem) {
    final isSolved = problem.isSolved;

    switch (problem.type) {
      case 'no_checkout':
        return _ProblemTag(
          label: 'No Checkout',
          isSolved: isSolved,
          isReport: false,
        );
      case 'absence':
        return _ProblemTag(
          label: 'Absent',
          isSolved: isSolved,
          isReport: false,
        );
      case 'late':
        final minutes = problem.actualMinutes ?? 0;
        return _ProblemTag(
          label: minutes > 0 ? 'Late +${minutes}m' : 'Late',
          isSolved: isSolved,
          isReport: false,
        );
      case 'early_leave':
        final minutes = problem.actualMinutes ?? 0;
        return _ProblemTag(
          label: minutes > 0 ? 'Early -${minutes}m' : 'Early',
          isSolved: isSolved,
          isReport: false,
        );
      case 'overtime':
        final minutes = problem.actualMinutes ?? 0;
        return _ProblemTag(
          label: minutes > 0 ? 'OT +${minutes}m' : 'OT',
          isSolved: isSolved,
          isReport: false,
        );
      case 'reported':
        return _ProblemTag(
          label: 'Reported',
          isSolved: isSolved,
          isReport: true,
        );
      case 'location_issue':
        return _ProblemTag(
          label: 'Location',
          isSolved: isSolved,
          isReport: false,
        );
      case 'invalid_checkin':
        return _ProblemTag(
          label: 'Invalid Check-in',
          isSolved: isSolved,
          isReport: false,
        );
      default:
        // Unknown type - show generic tag with type name
        return _ProblemTag(
          label: problem.type,
          isSolved: isSolved,
          isReport: false,
        );
    }
  }

}

/// Problem tag widget
///
/// Colors:
/// - 🔴 Red background: Unsolved problem
/// - 🟠 Orange background: Unsolved report
/// - ⚪ Gray background + ✓: Solved
class _ProblemTag extends StatelessWidget {
  final String label;
  final bool isSolved;
  final bool isReport; // Orange for reports, red for problems

  const _ProblemTag({
    required this.label,
    required this.isSolved,
    required this.isReport,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    if (isSolved) {
      // Solved: Gray background
      backgroundColor = TossColors.gray200;
      textColor = TossColors.gray600;
    } else if (isReport) {
      // Unsolved report: Orange background
      backgroundColor = TossColors.warning.withValues(alpha: 0.15);
      textColor = TossColors.warning;
    } else {
      // Unsolved problem: Red background
      backgroundColor = TossColors.error.withValues(alpha: 0.15);
      textColor = TossColors.error;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          if (isSolved) ...[
            const SizedBox(width: 2),
            Icon(
              Icons.check,
              size: 10,
              color: textColor,
            ),
          ],
        ],
      ),
    );
  }
}

/// Status tag widget for non-problem statuses
///
/// Colors:
/// - 🟢 Green/Primary background: Positive status (In Progress, Working)
/// - 🔵 Blue background: Info status
class _StatusTag extends StatelessWidget {
  final String label;
  final bool isPositive; // Green for positive, blue for info

  const _StatusTag({
    required this.label,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;

    if (isPositive) {
      // Positive status: Green background
      backgroundColor = TossColors.success.withValues(alpha: 0.15);
      textColor = TossColors.success;
    } else {
      // Info status: Blue background
      backgroundColor = TossColors.primary.withValues(alpha: 0.15);
      textColor = TossColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
