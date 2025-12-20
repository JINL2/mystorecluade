import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toss_badge.dart';
import '../../../../domain/entities/problem_details.dart';

/// Shift info card showing date, name, time range and status
class ShiftInfoCard extends StatelessWidget {
  final String shiftDate;
  final String shiftName;
  final String shiftTimeRange;
  final bool isLate;
  final bool isOvertime;
  /// Problem details for displaying badges with minutes (from StaffTimeRecord)
  final ProblemDetails? problemDetails;

  const ShiftInfoCard({
    super.key,
    required this.shiftDate,
    required this.shiftName,
    required this.shiftTimeRange,
    required this.isLate,
    required this.isOvertime,
    this.problemDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shiftDate,
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shiftName,
                      style: TossTextStyles.titleMedium.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shiftTimeRange,
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badges - show all problems from problemDetails
              if (problemDetails != null && problemDetails!.problems.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: problemDetails!.problems.map((problem) => TossBadge(
                    label: _getProblemLabel(problem),
                    backgroundColor: _getBadgeColor(problem),
                    textColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    borderRadius: 12,
                  )).toList(),
                )
              // Fallback to legacy isLate/isOvertime if problemDetails is empty
              else if (isLate || isOvertime)
                TossBadge(
                  label: isLate ? 'Late' : 'OT',
                  backgroundColor: TossColors.error,
                  textColor: TossColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  borderRadius: 12,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get display label for problem item (with minutes if available)
  /// Same format as StaffTimelogCard: "Late +2m", "OT +5m", "Early -116m"
  String _getProblemLabel(ProblemItem problem) {
    final minutes = problem.actualMinutes ?? 0;
    switch (problem.type) {
      case 'no_checkout':
        return 'No Checkout';
      case 'absence':
        return 'Absent';
      case 'late':
        return minutes > 0 ? 'Late +${minutes}m' : 'Late';
      case 'early_leave':
        return minutes > 0 ? 'Early -${minutes}m' : 'Early';
      case 'overtime':
        return minutes > 0 ? 'OT +${minutes}m' : 'OT';
      case 'reported':
        return 'Reported';
      case 'location_issue':
        return 'Location';
      case 'invalid_checkin':
        return 'Invalid Check-in';
      default:
        return problem.type;
    }
  }

  /// Get badge background color for problem item
  Color _getBadgeColor(ProblemItem problem) {
    if (problem.isSolved) {
      return TossColors.gray400; // Gray for solved
    }
    switch (problem.type) {
      case 'reported':
        return TossColors.warning; // Orange for reports
      default:
        return TossColors.error; // Red for all attendance problems
    }
  }
}
