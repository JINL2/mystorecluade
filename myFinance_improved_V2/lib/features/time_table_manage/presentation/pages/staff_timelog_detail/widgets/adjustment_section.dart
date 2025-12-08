import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../../../shared/widgets/toss/toss_button_1.dart';

/// Adjustment section for shift details
///
/// Contains:
/// - Issue report card with avatar (if employee reported an issue)
/// - Add bonus text field
/// - Add penalty deduction text field
class AdjustmentSection extends StatelessWidget {
  final String? employeeName;
  final String? employeeAvatarUrl;
  final String? issueReport;
  final bool isProblemSolved;
  final bool showBothButtons;
  final String? issueReportStatus;
  final VoidCallback onExpandButtons;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResetSelection;
  final TextEditingController bonusController;
  final TextEditingController penaltyController;
  final ValueChanged<int> onBonusChanged;
  final ValueChanged<int> onPenaltyChanged;

  const AdjustmentSection({
    super.key,
    this.employeeName,
    this.employeeAvatarUrl,
    this.issueReport,
    required this.isProblemSolved,
    required this.showBothButtons,
    this.issueReportStatus,
    required this.onExpandButtons,
    required this.onApprove,
    required this.onReject,
    required this.onResetSelection,
    required this.bonusController,
    required this.penaltyController,
    required this.onBonusChanged,
    required this.onPenaltyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Adjustment for this shift',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // Issue report card (only if there's an issue report)
        if (issueReport != null && issueReport!.isNotEmpty) ...[
          _IssueReportCardWithAvatar(
            employeeName: employeeName ?? 'Employee',
            employeeAvatarUrl: employeeAvatarUrl,
            issueReport: issueReport!,
            isProblemSolved: isProblemSolved,
            showBothButtons: showBothButtons,
            issueReportStatus: issueReportStatus,
            onExpandButtons: onExpandButtons,
            onApprove: onApprove,
            onReject: onReject,
            onResetSelection: onResetSelection,
          ),
          const SizedBox(height: 16),
        ],

        // Add bonus text field
        _AdjustmentTextField(
          label: 'Add bonus',
          controller: bonusController,
          onChanged: onBonusChanged,
        ),
        const SizedBox(height: 8),

        // Add penalty deduction text field
        _AdjustmentTextField(
          label: 'Add penalty deduction',
          controller: penaltyController,
          onChanged: onPenaltyChanged,
        ),
      ],
    );
  }
}

/// Issue report card with employee avatar and name
class _IssueReportCardWithAvatar extends StatelessWidget {
  final String employeeName;
  final String? employeeAvatarUrl;
  final String issueReport;
  final bool isProblemSolved;
  final bool showBothButtons;
  final String? issueReportStatus;
  final VoidCallback onExpandButtons;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onResetSelection;

  const _IssueReportCardWithAvatar({
    required this.employeeName,
    this.employeeAvatarUrl,
    required this.issueReport,
    required this.isProblemSolved,
    required this.showBothButtons,
    this.issueReportStatus,
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
    // Case 1: User hasn't clicked yet, show single button based on is_problem_solved
    if (!showBothButtons && issueReportStatus == null) {
      if (isProblemSolved) {
        return TossButton1.outlined(
          text: 'Approved',
          fullWidth: true,
          onPressed: onExpandButtons,
        );
      } else {
        return TossButton1.secondary(
          text: 'Reject',
          fullWidth: true,
          onPressed: onExpandButtons,
        );
      }
    }

    // Case 2: User clicked to expand, show both buttons for selection
    if (showBothButtons && issueReportStatus == null) {
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

    // Case 3: User has made a selection
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

    return const SizedBox.shrink();
  }
}

/// Inline text field for Add bonus / Add penalty deduction
class _AdjustmentTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  const _AdjustmentTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Label
          Expanded(
            child: Text(
              label,
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
          // Text field with underline
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) return newValue;
                  final number = int.tryParse(newValue.text.replaceAll(',', ''));
                  if (number == null) return oldValue;
                  final formatted = NumberFormat('#,###').format(number);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }),
              ],
              decoration: const InputDecoration(
                hintText: '______',
                hintStyle: TextStyle(
                  color: TossColors.gray300,
                  letterSpacing: 2,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (value) {
                final amount = int.tryParse(value.replaceAll(',', '')) ?? 0;
                onChanged(amount);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Edit icon
          const Icon(
            Icons.edit_outlined,
            size: 20,
            color: TossColors.gray400,
          ),
        ],
      ),
    );
  }
}
