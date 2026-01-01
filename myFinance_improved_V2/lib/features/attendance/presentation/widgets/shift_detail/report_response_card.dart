import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/shift_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Report and response card widget - shows user report and manager response
class ReportResponseCard extends StatelessWidget {
  final ShiftCard shift;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ReportResponseCard({
    super.key,
    required this.shift,
    required this.isExpanded,
    required this.onToggle,
  });

  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildVerticalInfoRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportedProblem = shift.problemDetails?.reportedProblem;
    final reportReason = reportedProblem?.reason ?? '';
    final hasReport = reportReason.isNotEmpty;
    final hasManagerMemo = shift.managerMemos.isNotEmpty;
    final managerMemoContent =
        hasManagerMemo ? shift.managerMemos.first.content : '';

    final isSolved =
        (reportedProblem?.isReportSolved ?? false) || hasManagerMemo;

    return TossExpandableCard(
      title: 'Report & Response',
      isExpanded: isExpanded,
      onToggle: onToggle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasReport) ...[
            _buildVerticalInfoRow(
              label: 'Your report',
              value: reportReason,
            ),
          ],
          if (hasManagerMemo) ...[
            if (hasReport) const SizedBox(height: 16),
            _buildVerticalInfoRow(
              label: 'Manager response',
              value: managerMemoContent,
              valueStyle: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (hasReport) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              label: 'Status',
              value: isSolved ? 'Resolved' : 'Pending',
              valueStyle: TossTextStyles.bodyLarge.copyWith(
                color: isSolved ? TossColors.success : TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
