import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/proforma_invoice.dart';

class PIListItemWidget extends StatelessWidget {
  final PIListItem item;
  final VoidCallback? onTap;

  const PIListItemWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: PI number + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.piNumber,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _StatusChip(status: item.status),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),

                // Counterparty name
                Text(
                  item.counterpartyName ?? 'Unknown Counterparty',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Bottom row: Amount + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Amount
                    Text(
                      '${item.currencyCode} ${_formatAmount(item.totalAmount)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    // Date
                    if (item.createdAtUtc != null)
                      Text(
                        _formatDate(item.createdAtUtc!),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                  ],
                ),

                // Validity date warning if applicable
                if (item.validityDate != null) ...[
                  const SizedBox(height: TossSpacing.space2),
                  _ValidityInfo(validityDate: item.validityDate!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

class _StatusChip extends StatelessWidget {
  final PIStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusStyle() {
    switch (status) {
      case PIStatus.draft:
        return (TossColors.gray700, TossColors.gray100, 'Draft');
      case PIStatus.sent:
        return (TossColors.primary, TossColors.primarySurface, 'Sent');
      case PIStatus.negotiating:
        return (TossColors.warning, TossColors.warningLight, 'Negotiating');
      case PIStatus.accepted:
        return (TossColors.success, TossColors.successLight, 'Accepted');
      case PIStatus.rejected:
        return (TossColors.error, TossColors.errorLight, 'Rejected');
      case PIStatus.expired:
        return (TossColors.gray500, TossColors.gray100, 'Expired');
      case PIStatus.converted:
        return (TossColors.info, TossColors.infoLight, 'Converted');
    }
  }
}

class _ValidityInfo extends StatelessWidget {
  final DateTime validityDate;

  const _ValidityInfo({required this.validityDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = validityDate.difference(now).inDays;
    final isExpired = diff < 0;
    final isUrgent = diff >= 0 && diff <= 3;

    if (isExpired) {
      return Row(
        children: [
          const Icon(Icons.warning_amber, size: 14, color: TossColors.error),
          const SizedBox(width: TossSpacing.space1),
          Text(
            'Expired',
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      );
    }

    if (isUrgent) {
      return Row(
        children: [
          const Icon(Icons.schedule, size: 14, color: TossColors.warning),
          const SizedBox(width: TossSpacing.space1),
          Text(
            'Expires in $diff day${diff == 1 ? '' : 's'}',
            style: TossTextStyles.caption.copyWith(color: TossColors.warning),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Icon(Icons.event, size: 14, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          'Valid until ${DateFormat('MMM dd').format(validityDate)}',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
        ),
      ],
    );
  }
}
