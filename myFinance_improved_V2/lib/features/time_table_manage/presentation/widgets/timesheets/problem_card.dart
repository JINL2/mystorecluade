import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';

import '../../../domain/entities/problem_details.dart';

/// Problem types for attendance tracking
enum ProblemType {
  noCheckout,
  noCheckin,
  overtime,
  late,
  understaffed,
  reported, // Staff reported an issue
  earlyLeave, // Left before shift end
}

/// Model for attendance problem
class AttendanceProblem {
  final String id;
  /// @deprecated Use [types] instead. Kept for backward compatibility.
  final ProblemType type;
  /// List of problem types for this shift (e.g., [late, noCheckout])
  final List<ProblemType> types;
  final String name; // Staff name or "Evening Shift"
  final DateTime date;
  final String shiftName; // "Morning", "Afternoon", "Night"
  final String? timeRange; // For shift problems (e.g., "18:00 - 22:00")
  final String? avatarUrl; // For staff problems
  final bool isShiftProblem; // True if understaffed, false if staff problem

  // Staff-specific fields for navigation to detail page
  final String? staffId;
  final String? shiftRequestId; // Required for RPC calls (manager_shift_input_card_v4)
  final String? clockIn;
  final String? clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool isConfirmed;
  final String? actualStart;
  final String? actualEnd;
  final String? confirmStartTime;
  final String? confirmEndTime;
  final bool isReported;
  final String? reportReason;
  final bool isProblemSolved;
  final double bonusAmount;
  final String? salaryType;
  final String? salaryAmount;
  final String? basePay;
  final String? totalPayWithBonus;
  final double paidHour;
  final int lateMinute;
  final int overtimeMinute;
  final DateTime? shiftEndTime;

  // v5: Problem details for passing to StaffTimeRecord
  final ProblemDetails? problemDetails;

  const AttendanceProblem({
    required this.id,
    required this.type,
    this.types = const [],
    required this.name,
    required this.date,
    required this.shiftName,
    this.timeRange,
    this.avatarUrl,
    this.isShiftProblem = false,
    // Staff-specific fields
    this.staffId,
    this.shiftRequestId,
    this.clockIn,
    this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.isConfirmed = false,
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
    this.shiftEndTime,
    this.problemDetails,
  });

  /// Get all problem types (uses types if not empty, otherwise falls back to single type)
  List<ProblemType> get allTypes => types.isNotEmpty ? types : [type];
}

/// Card displaying an attendance problem
class ProblemCard extends StatelessWidget {
  final AttendanceProblem problem;
  final VoidCallback? onTap;
  /// If true, show day number (e.g., "7") instead of weekday (e.g., "Sun")
  /// Useful for "This month" filter where weekday alone is ambiguous
  final bool showDayNumber;

  const ProblemCard({
    super.key,
    required this.problem,
    this.onTap,
    this.showDayNumber = false,
  });

  String _getProblemLabel(ProblemType type) {
    switch (type) {
      case ProblemType.noCheckout:
        return 'No check-out';
      case ProblemType.noCheckin:
        return 'No check-in';
      case ProblemType.overtime:
        return 'OT';
      case ProblemType.late:
        return 'Late';
      case ProblemType.understaffed:
        return 'Understaffed';
      case ProblemType.reported:
        return 'Reported';
      case ProblemType.earlyLeave:
        return 'Early leave';
    }
  }

  BadgeStatus _getBadgeStatus(ProblemType type) {
    switch (type) {
      case ProblemType.noCheckout:
      case ProblemType.noCheckin:
      case ProblemType.overtime:
      case ProblemType.late:
      case ProblemType.earlyLeave:
        return BadgeStatus.error;
      case ProblemType.understaffed:
        return BadgeStatus.info;
      case ProblemType.reported:
        return BadgeStatus.warning; // Orange for reports
    }
  }

  String _formatDate(DateTime date) {
    if (showDayNumber) {
      // Show day number for "This month" filter (e.g., "7")
      return date.day.toString();
    }
    // Show weekday for "Today" and "This week" filters (e.g., "Sun")
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    return weekday;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Avatar or Shift Icon
            if (problem.isShiftProblem)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  Icons.access_time,
                  size: 20,
                  color: TossColors.gray600,
                ),
              )
            else if (problem.avatarUrl != null)
              CircleAvatar(
                radius: 20,
                backgroundColor: TossColors.gray200,
                backgroundImage: NetworkImage(problem.avatarUrl!),
                onBackgroundImageError: (_, __) {},
              )
            else
              CircleAvatar(
                radius: 20,
                backgroundColor: TossColors.gray200,
                child: const Icon(Icons.person, size: 20, color: TossColors.gray500),
              ),

            const SizedBox(width: TossSpacing.space3),

            // Name and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    problem.name,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDate(problem.date)} • ${problem.shiftName}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space2),

            // Problem Badges (multiple if shift has multiple problems)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: problem.allTypes.map((type) => TossStatusBadge(
                label: _getProblemLabel(type),
                status: _getBadgeStatus(type),
              )).toList(),
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
    );
  }
}
