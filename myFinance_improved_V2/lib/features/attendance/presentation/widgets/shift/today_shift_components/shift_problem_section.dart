import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../domain/entities/shift_problem_info.dart';
import '../../../../domain/entities/shift_status.dart';

/// Problem badges section after check-in (max 2 visible, rest as +N)
/// Extracted from today_shift_card.dart for better modularity
class ShiftProblemSection extends StatelessWidget {
  final ShiftProblemInfo? problemInfo;
  final ShiftStatus status;
  final VoidCallback? onReportIssue;

  const ShiftProblemSection({
    super.key,
    this.problemInfo,
    required this.status,
    this.onReportIssue,
  });

  @override
  Widget build(BuildContext context) {
    if (problemInfo == null || !problemInfo!.hasProblem) {
      return const SizedBox.shrink();
    }

    final allProblems = <({IconData icon, String label, Color color})>[];

    // Late badge (priority 1 - most important)
    if (problemInfo!.isLate) {
      allProblems.add((
        icon: Icons.access_time,
        label: 'Late ${problemInfo!.lateMinutes}m',
        color: TossColors.error,
      ));
    }

    // No checkout badge (priority 2)
    if (problemInfo!.hasNoCheckout) {
      allProblems.add((
        icon: Icons.warning_amber,
        label: 'No Checkout',
        color: TossColors.error,
      ));
    }

    // Location issue badge (priority 3)
    if (problemInfo!.hasLocationIssue) {
      final distance = problemInfo!.checkinDistance;
      String label;
      if (distance != null && distance >= 1000) {
        label = 'Location ${(distance / 1000).toStringAsFixed(1)}km';
      } else if (distance != null) {
        label = 'Location ${distance}m';
      } else {
        label = 'Location Issue';
      }
      allProblems.add((
        icon: Icons.location_off,
        label: label,
        color: TossColors.warning,
      ));
    }

    // Early leave badge (priority 4)
    if (problemInfo!.isEarlyLeave) {
      allProblems.add((
        icon: Icons.exit_to_app,
        label: 'Early ${problemInfo!.earlyLeaveMinutes}m',
        color: TossColors.warning,
      ));
    }

    // Overtime badge (priority 5 - positive)
    if (problemInfo!.isOvertime) {
      allProblems.add((
        icon: Icons.more_time,
        label: 'OT ${problemInfo!.overtimeMinutes}m',
        color: TossColors.primary,
      ));
    }

    // Reported badge (priority 6)
    if (problemInfo!.isReported) {
      allProblems.add((
        icon: problemInfo!.isSolved ? Icons.check_circle : Icons.report,
        label: problemInfo!.isSolved ? 'Resolved' : 'Reported',
        color: problemInfo!.isSolved ? TossColors.success : TossColors.warning,
      ));
    }

    if (allProblems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show max 2 badges, rest as +N
    const maxVisible = 2;
    final visibleProblems = allProblems.take(maxVisible).toList();
    final hiddenCount = allProblems.length - maxVisible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: TossColors.gray200, height: 1),
        SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            ...visibleProblems.map((p) => Padding(
                  padding: EdgeInsets.only(right: TossSpacing.space2),
                  child: _ShiftProblemBadge(
                    icon: p.icon,
                    label: p.label,
                    color: p.color,
                  ),
                )),
            if (hiddenCount > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  '+$hiddenCount',
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.gray600,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
              ),
          ],
        ),
        // Report button if there are unresolved problems (NOT for Completed status - handled in ShiftActionButton)
        if (problemInfo!.hasProblem &&
            !problemInfo!.isSolved &&
            !problemInfo!.isReported &&
            status != ShiftStatus.completed &&
            onReportIssue != null) ...[
          SizedBox(height: TossSpacing.space3),
          TossButton.outlinedGray(
            text: 'Report Issue',
            onPressed: onReportIssue,
            leadingIcon: Icon(Icons.flag_outlined, size: TossSpacing.iconSM),
            fullWidth: true,
          ),
        ],
        SizedBox(height: TossSpacing.space3),
      ],
    );
  }
}

/// Problem badge widget
class _ShiftProblemBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ShiftProblemBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: TossOpacity.light),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: TossOpacity.heavy)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TossSpacing.iconXS, color: color),
          SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
        ],
      ),
    );
  }
}
