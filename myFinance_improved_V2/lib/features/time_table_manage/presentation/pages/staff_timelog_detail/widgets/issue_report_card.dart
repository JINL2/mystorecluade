import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toss_button_1.dart';

/// Issue report card showing employee's report with approve/reject options
class IssueReportCard extends StatelessWidget {
  final String issueReport;
  final bool isProblemSolved;
  final bool showBothButtons;
  final String? issueReportStatus;
  final VoidCallback onExpandButtons;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResetSelection;

  const IssueReportCard({
    super.key,
    required this.issueReport,
    required this.isProblemSolved,
    required this.showBothButtons,
    required this.issueReportStatus,
    required this.onExpandButtons,
    required this.onApprove,
    required this.onReject,
    required this.onResetSelection,
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
          Text(
            'Issue report from employee',
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            issueReport,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Case 1: User hasn't clicked yet, show single button based on is_problem_solved
          if (!showBothButtons && issueReportStatus == null) ...[
            if (isProblemSolved)
              TossButton1.outlined(
                text: 'Approved',
                fullWidth: true,
                onPressed: onExpandButtons,
              )
            else
              TossButton1.secondary(
                text: 'Reject explanation',
                fullWidth: true,
                onPressed: onExpandButtons,
              ),
          ],

          // Case 2: User clicked to expand, show both buttons for selection
          if (showBothButtons && issueReportStatus == null)
            Row(
              children: [
                Expanded(
                  child: TossButton1.secondary(
                    text: 'Reject explanation',
                    onPressed: onReject,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TossButton1.outlined(
                    text: 'Approve explanation',
                    onPressed: onApprove,
                  ),
                ),
              ],
            ),

          // Case 3: User has made a selection
          if (issueReportStatus == 'rejected')
            TossButton1.secondary(
              text: 'Rejected',
              fullWidth: true,
              onPressed: onResetSelection,
            ),
          if (issueReportStatus == 'approved')
            TossButton1.outlined(
              text: 'Approved',
              fullWidth: true,
              onPressed: onResetSelection,
            ),
        ],
      ),
    );
  }
}
