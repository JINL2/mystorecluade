import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toss_button_1.dart';

/// Issue report card with employee avatar and name
///
/// Shows employee's reported issue with approve/reject actions
/// v4: Uses isReportedSolved (bool?) from RPC:
/// - null: Show both buttons (Reject/Approve)
/// - false: Show Rejected button
/// - true: Show Approved button
class IssueReportCard extends StatelessWidget {
  final String employeeName;
  final String? employeeAvatarUrl;
  final String issueReport;
  final bool? isReportedSolved;
  final String? issueReportStatus;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResetSelection;

  const IssueReportCard({
    super.key,
    required this.employeeName,
    this.employeeAvatarUrl,
    required this.issueReport,
    required this.isReportedSolved,
    this.issueReportStatus,
    required this.onApprove,
    required this.onReject,
    required this.onResetSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: TossColors.gray100,
                backgroundImage: employeeAvatarUrl != null && employeeAvatarUrl!.isNotEmpty
                    ? NetworkImage(employeeAvatarUrl!)
                    : null,
                child: employeeAvatarUrl == null || employeeAvatarUrl!.isEmpty
                    ? Text(
                        employeeName.isNotEmpty ? employeeName[0].toUpperCase() : '?',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Name + "reported"
              Expanded(
                child: Text(
                  '$employeeName reported',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Issue report text with quotes
          Text(
            '"$issueReport"',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    // Case 1: User has made a selection in this session (overrides RPC value)
    if (issueReportStatus == 'rejected') {
      return TossButton1.secondary(
        text: 'Rejected',
        fullWidth: true,
        onPressed: onResetSelection,
      );
    }

    if (issueReportStatus == 'approved') {
      return TossButton1.outlined(
        text: 'Approved',
        fullWidth: true,
        onPressed: onResetSelection,
      );
    }

    // Case 2: No user selection, use RPC value (isReportedSolved)
    // null → Show both buttons
    if (isReportedSolved == null) {
      return Row(
        children: [
          Expanded(
            child: TossButton1.secondary(
              text: 'Reject',
              onPressed: onReject,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TossButton1.outlined(
              text: 'Approve',
              onPressed: onApprove,
            ),
          ),
        ],
      );
    }

    // false → Show Rejected
    if (isReportedSolved == false) {
      return TossButton1.secondary(
        text: 'Rejected',
        fullWidth: true,
        onPressed: onResetSelection,
      );
    }

    // true → Show Approved
    if (isReportedSolved == true) {
      return TossButton1.outlined(
        text: 'Approved',
        fullWidth: true,
        onPressed: onResetSelection,
      );
    }

    return const SizedBox.shrink();
  }
}
