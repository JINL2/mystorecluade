import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/problem_details.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shift info card showing date, name, time range and status
class ShiftInfoCard extends StatefulWidget {
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
  State<ShiftInfoCard> createState() => _ShiftInfoCardState();
}

class _ShiftInfoCardState extends State<ShiftInfoCard> {
  bool _showAllTags = false;

  /// Maximum number of tags to show before "more" button
  static const int _maxVisibleTags = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shiftDate,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1 + 2), // 6px
                    Text(
                      widget.shiftName,
                      style: TossTextStyles.titleMedium.copyWith(
                        color: TossColors.gray900,
                        fontWeight: TossFontWeight.bold,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1 + 2), // 6px
                    Text(
                      widget.shiftTimeRange,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Status Badges - displayed below shift info when present
          if (widget.problemDetails != null && widget.problemDetails!.problems.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space3),
            _buildProblemBadges(),
          ] else if (widget.isLate || widget.isOvertime) ...[
            SizedBox(height: TossSpacing.space3),
            TossBadge(
              label: widget.isLate ? 'Late' : 'OT',
              backgroundColor: TossColors.error,
              textColor: TossColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              borderRadius: 12,
            ),
          ],
        ],
      ),
    );
  }

  /// Build problem badges with "show more" functionality
  Widget _buildProblemBadges() {
    final problems = widget.problemDetails!.problems;
    final totalCount = problems.length;
    final hasMoreTags = totalCount > _maxVisibleTags;

    // Determine which tags to show
    final visibleProblems = _showAllTags ? problems : problems.take(_maxVisibleTags).toList();
    final hiddenCount = totalCount - _maxVisibleTags;

    return Wrap(
      spacing: TossSpacing.space1 + 2,
      runSpacing: TossSpacing.space1 + 2,
      children: [
        // Visible problem badges
        ...visibleProblems.map((problem) => TossBadge(
          label: _getProblemLabel(problem),
          backgroundColor: _getBadgeColor(problem),
          textColor: TossColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          borderRadius: 12,
        ),),
        // "More" or "Less" button when tags overflow
        if (hasMoreTags)
          GestureDetector(
            onTap: () => setState(() => _showAllTags = !_showAllTags),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Text(
                _showAllTags ? 'Less' : '+$hiddenCount',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ),
          ),
      ],
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
    if (problem.isSolved == true) {
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
