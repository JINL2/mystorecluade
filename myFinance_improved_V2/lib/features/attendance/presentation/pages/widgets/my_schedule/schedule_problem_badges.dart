import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../domain/entities/problem_details.dart';

/// Problem badges for shift card
/// Shows additional details like late minutes, overtime, location issues
/// Note: Status badge already shows main problem (Reported/Resolved/Late/etc)
/// These badges show additional details
/// Extracted from MyScheduleTab._buildProblemBadges
class ScheduleProblemBadges extends StatelessWidget {
  final ProblemDetails problemDetails;
  final bool hasManagerMemo;

  const ScheduleProblemBadges({
    super.key,
    required this.problemDetails,
    this.hasManagerMemo = false,
  });

  @override
  Widget build(BuildContext context) {
    final badges = <Widget>[];
    final pd = problemDetails;

    // Late with minutes detail (status badge just shows "Late") - RED (problem)
    if (pd.hasLate && pd.lateMinutes > 0) {
      badges.add(_buildProblemBadge('${pd.lateMinutes}m late', isProblem: true));
    }
    // Location issue - RED (problem)
    if (pd.hasLocationIssue) {
      badges.add(_buildProblemBadge('Location', isProblem: true));
    }
    // Overtime with minutes detail - not a problem, neutral style
    if (pd.hasOvertime && pd.overtimeMinutes > 0) {
      badges.add(_buildProblemBadge('OT ${pd.overtimeMinutes}m', isProblem: false));
    }
    // Early leave with minutes detail - RED (problem)
    if (pd.hasEarlyLeave && pd.earlyLeaveMinutes > 0) {
      badges.add(_buildProblemBadge('${pd.earlyLeaveMinutes}m early', isProblem: true));
    }

    if (badges.isEmpty) return const SizedBox.shrink();

    // Show max 2, rest as +N
    final visibleBadges = badges.take(2).toList();
    final hiddenCount = badges.length - 2;

    // Build badges with dot separator between them
    final List<Widget> badgesWithSeparators = [];
    for (int i = 0; i < visibleBadges.length; i++) {
      badgesWithSeparators.add(visibleBadges[i]);
      // Add dot separator after each badge except the last one
      if (i < visibleBadges.length - 1) {
        badgesWithSeparators.add(
          Text(
            ' \u00b7 ',
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray400,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...badgesWithSeparators,
        if (hiddenCount > 0)
          Text(
            ' +$hiddenCount',
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  /// Build problem badge - text only, no background
  /// isProblem: true = red text (late, early, location), false = gray text (OT)
  Widget _buildProblemBadge(String label, {required bool isProblem}) {
    return Text(
      label,
      style: TossTextStyles.labelSmall.copyWith(
        color: isProblem ? TossColors.error : TossColors.gray600,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
