import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Info section with session details (status, started, location, items, memo)
class CountDetailInfoSection extends StatelessWidget {
  final bool isActive;
  final String createdAt;
  final String storeName;
  final String? memo;

  const CountDetailInfoSection({
    super.key,
    required this.isActive,
    required this.createdAt,
    required this.storeName,
    this.memo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          // Status row
          _buildDetailRow(
            label: 'Status',
            child: _buildStatusBadge(),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Started row
          _buildDetailRow(
            label: 'Started',
            value: _formatDateTime(createdAt),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Location row
          _buildDetailRow(
            label: 'Location',
            value: storeName,
          ),
          const SizedBox(height: TossSpacing.space3),
          // Items row
          _buildDetailRow(
            label: 'Items',
            value: 'All items',
          ),
          const SizedBox(height: TossSpacing.space3),
          // Memo row
          _buildMemoRow(context),
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? child,
  }) {
    if (child != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
          child,
        ],
      );
    }
    return InfoRow.fixed(
      label: label,
      value: value ?? '',
      labelWidth: 80,
    );
  }

  Widget _buildStatusBadge() {
    return TossStatusBadge(
      label: isActive ? 'In Progress' : 'Done',
      status: isActive ? BadgeStatus.success : BadgeStatus.info,
    );
  }

  Widget _buildMemoRow(BuildContext context) {
    final hasMemo = memo != null && memo!.isNotEmpty;

    return GestureDetector(
      onTap: hasMemo ? () => _showFullMemo(context) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              'Memo',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              hasMemo ? memo! : '-',
              style: TossTextStyles.body.copyWith(
                color: hasMemo ? TossColors.gray900 : TossColors.gray400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasMemo) ...[
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: TossSpacing.iconMD,
            ),
          ],
        ],
      ),
    );
  }

  void _showFullMemo(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      title: 'Memo',
      content: Text(
        memo!,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          height: 1.5,
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final formatter = DateFormat('MMMM dd, yyyy h:mm a');
      return formatter.format(dateTime);
    } catch (_) {
      return dateTimeStr;
    }
  }
}
