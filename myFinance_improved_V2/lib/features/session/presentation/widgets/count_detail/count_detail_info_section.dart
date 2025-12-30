import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_badge.dart';

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
        if (child != null)
          child
        else
          Expanded(
            child: Text(
              value ?? '',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
            ),
          ),
      ],
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
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  void _showFullMemo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              // Title
              Text(
                'Memo',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              // Full memo content
              Text(
                memo!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
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
