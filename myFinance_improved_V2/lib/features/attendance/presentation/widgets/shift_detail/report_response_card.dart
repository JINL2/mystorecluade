import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';
import '../../../../../shared/widgets/index.dart';
import '../../../domain/entities/shift_card.dart';

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
    return InfoRow.between(
      label: label,
      value: value,
      valueStyle: valueStyle,
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
        const SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: TossFontWeight.medium,
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
            if (hasReport) const SizedBox(height: TossSpacing.space4),
            _buildVerticalInfoRow(
              label: 'Manager response',
              value: managerMemoContent,
              valueStyle: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.primary,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ],
          if (hasReport) ...[
            const SizedBox(height: TossSpacing.space4),
            _buildInfoRow(
              label: 'Status',
              value: isSolved ? 'Resolved' : 'Pending',
              valueStyle: TossTextStyles.bodyLarge.copyWith(
                color: isSolved ? TossColors.success : TossColors.warning,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
