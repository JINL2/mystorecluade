// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/issues_detail_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../../shared/themes/toss_shadows.dart';
import '../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';
import 'payment_time_bar.dart';

/// Issues Detail Section - Detailed issue information
class IssuesDetailSection extends StatefulWidget {
  final List<AttendanceIssue> issues;

  const IssuesDetailSection({
    super.key,
    required this.issues,
  });

  @override
  State<IssuesDetailSection> createState() => _IssuesDetailSectionState();
}

class _IssuesDetailSectionState extends State<IssuesDetailSection> {
  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    if (widget.issues.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.paddingLG),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.card,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(LucideIcons.checkCircle, size: 48, color: TossColors.success),
              SizedBox(height: TossSpacing.space3),
              Text(
                'No issues found',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Separate unsolved and solved issues
    final unsolvedIssues = widget.issues.where((i) => !i.isSolved).toList();
    final solvedIssues = widget.issues.where((i) => i.isSolved).toList();

    return Column(
      children: [
        // Unsolved Issues (Priority)
        if (unsolvedIssues.isNotEmpty) ...[
          IssueGroupContainer(
            title: 'Pending Issues',
            subtitle: '${unsolvedIssues.length} employees need attention',
            icon: LucideIcons.alertCircle,
            iconColor: TossColors.error,
            issues: unsolvedIssues,
            expandedStates: _expandedStates,
            onToggle: (index) {
              setState(() {
                _expandedStates[index] = !(_expandedStates[index] ?? false);
              });
            },
          ),
          SizedBox(height: TossSpacing.marginMD),
        ],

        // Solved Issues
        if (solvedIssues.isNotEmpty)
          IssueGroupContainer(
            title: 'Resolved Issues',
            subtitle: '${solvedIssues.length} issues resolved by managers',
            icon: LucideIcons.checkCircle,
            iconColor: TossColors.success,
            issues: solvedIssues,
            expandedStates: _expandedStates,
            onToggle: (index) {
              setState(() {
                final actualIndex = unsolvedIssues.length + index;
                _expandedStates[actualIndex] =
                    !(_expandedStates[actualIndex] ?? false);
              });
            },
            startIndex: unsolvedIssues.length,
          ),
      ],
    );
  }
}

/// Issue Group Container
class IssueGroupContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<AttendanceIssue> issues;
  final Map<int, bool> expandedStates;
  final Function(int) onToggle;
  final int startIndex;

  const IssueGroupContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.issues,
    required this.expandedStates,
    required this.onToggle,
    this.startIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  size: TossSpacing.iconSM,
                  color: iconColor,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.h4.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Issue Cards
          ...issues.asMap().entries.map((entry) {
            final index = entry.key;
            final issue = entry.value;
            final actualIndex = startIndex + index;
            final isExpanded = expandedStates[actualIndex] ?? false;
            final isCritical = issue.severity == 'critical';

            return _buildIssueCard(issue, index, actualIndex, isExpanded, isCritical);
          }),
        ],
      ),
    );
  }

  Widget _buildIssueCard(
    AttendanceIssue issue,
    int index,
    int actualIndex,
    bool isExpanded,
    bool isCritical,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Compact view - clickable
          InkWell(
            onTap: () => onToggle(index),
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              child: Column(
                children: [
                  // First row: Employee + Badge (minimal)
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          isCritical ? LucideIcons.userX : LucideIcons.clock,
                          size: TossSpacing.iconXS,
                          color: TossColors.gray600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Text(
                          issue.employeeName,
                          style: TossTextStyles.bodyMedium.copyWith(
                            color: TossColors.gray900,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.full),
                        ),
                        child: Text(
                          issue.problemType,
                          style: TossTextStyles.labelMedium.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Icon(
                        isExpanded
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: TossSpacing.iconXS,
                        color: TossColors.gray500,
                      ),
                    ],
                  ),

                  SizedBox(height: TossSpacing.space2),

                  // Second row: Store + Manager action
                  Row(
                    children: [
                      Icon(
                        LucideIcons.store,
                        size: 12,
                        color: TossColors.gray500,
                      ),
                      SizedBox(width: TossSpacing.marginXS),
                      Expanded(
                        child: Text(
                          issue.storeName,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            issue.isSolved
                                ? LucideIcons.userCheck
                                : LucideIcons.clock,
                            size: 12,
                            color: issue.isSolved
                                ? TossColors.success
                                : TossColors.gray500,
                          ),
                          SizedBox(width: 2),
                          Text(
                            issue.isSolved
                                ? (issue.managerAdjustment.adjustedBy != null
                                    ? 'by ${issue.managerAdjustment.adjustedBy}'
                                    : 'Resolved')
                                : 'Pending',
                            style: TossTextStyles.small.copyWith(
                              color: issue.isSolved
                                  ? TossColors.success
                                  : TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded details - time timeline
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: isCritical
                  ? TossColors.error.withValues(alpha: 0.1)
                  : TossColors.warning.withValues(alpha: 0.1),
            ),
            Padding(
              padding: EdgeInsets.all(TossSpacing.paddingSM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment timeline (shown for all cases)
                  PaymentTimeBar(
                    scheduledStart: issue.timeDetail.scheduledStart,
                    scheduledEnd: issue.timeDetail.scheduledEnd,
                    actualStart: issue.timeDetail.actualStart,
                    actualEnd: issue.timeDetail.actualEnd,
                    paymentStart: issue.managerAdjustment.paymentStart,
                    paymentEnd: issue.managerAdjustment.paymentEnd,
                    isManagerAdjusted: issue.managerAdjustment.isAdjusted,
                    managerName: issue.managerAdjustment.adjustedBy,
                    penalty: issue.managerAdjustment.finalPenaltyMinutes,
                    overtime: issue.managerAdjustment.finalOvertimeMinutes,
                    managerReason: issue.managerAdjustment.reason,
                  ),

                  SizedBox(height: TossSpacing.space3),

                  // AI Comment
                  if (issue.aiComment != null)
                    Container(
                      padding: EdgeInsets.all(TossSpacing.paddingSM),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withValues(alpha: 0.05),
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            LucideIcons.sparkles,
                            size: TossSpacing.iconXS,
                            color: TossColors.primary,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              issue.aiComment!,
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray700,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
