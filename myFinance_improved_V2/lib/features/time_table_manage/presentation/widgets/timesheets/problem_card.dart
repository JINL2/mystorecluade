import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/attendance_problem.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../../domain/entities/attendance_problem.dart';

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
    return Material(
      color: TossColors.transparent,
      child: InkWell(
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
                  width: TossDimensions.avatarLG,
                  height: TossDimensions.avatarLG,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    Icons.access_time,
                    size: TossSpacing.iconMD,
                    color: TossColors.gray600,
                  ),
                )
              else
                EmployeeProfileAvatar(
                  imageUrl: problem.avatarUrl,
                  name: problem.name,
                  size: TossDimensions.avatarLG,
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
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space0_5),
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
              // Use filteredTypes to exclude premature problems for in-progress shifts
              Wrap(
                spacing: TossSpacing.space1,
                runSpacing: TossSpacing.space1,
                children: [
                  // Show "In Progress" badge if shift is ongoing with checkin
                  if (problem.isInProgress && problem.clockIn != null)
                    TossStatusBadge(
                      label: 'In Progress',
                      status: BadgeStatus.success,
                    ),
                  // Show remaining problem badges (filtered)
                  ...problem.filteredTypes.map((type) => TossStatusBadge(
                    label: _getProblemLabel(type),
                    status: _getBadgeStatus(type),
                  )),
                ],
              ),

              const SizedBox(width: TossSpacing.space2),

              // Chevron
              Icon(
                Icons.chevron_right,
                size: TossSpacing.iconMD,
                color: TossColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
