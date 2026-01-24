import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/index.dart';
import '../../domain/entities/purchase_order.dart';

class POListItemWidget extends StatelessWidget {
  final POListItem item;
  final VoidCallback? onTap;
  final String? baseCurrencyCode;

  const POListItemWidget({
    super.key,
    required this.item,
    this.onTap,
    this.baseCurrencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: PO number + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.poNumber,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.piNumber != null)
                        Text(
                          'From: ${item.piNumber}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ),
                TossBadge.status(
                  label: item.status.label,
                  status: _getStatusType(item.status),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),

            // Buyer name
            Text(
              item.buyerName ?? 'Unknown Buyer',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray700,
              ),
            ),

            // Buyer PO number if exists
            if (item.buyerPoNumber != null) ...[
              const SizedBox(height: TossSpacing.space1),
              Text(
                'Buyer PO: ${item.buyerPoNumber}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],

            const SizedBox(height: TossSpacing.space3),

            // Bottom row: Amount + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Amount (display in base currency)
                Text(
                  '${baseCurrencyCode ?? item.currencyCode} ${_formatAmount(item.totalAmount)}',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                // Date
                if (item.orderDateUtc != null)
                  Text(
                    _formatDate(item.orderDateUtc!),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
              ],
            ),

            // Shipment progress if applicable
            if (item.shippedPercent > 0) ...[
              const SizedBox(height: TossSpacing.space2),
              _ShipmentProgress(percent: item.shippedPercent),
            ],

            // Required shipment date warning
            if (item.requiredShipmentDateUtc != null) ...[
              const SizedBox(height: TossSpacing.space2),
              _ShipmentDateInfo(date: item.requiredShipmentDateUtc!),
            ],
          ],
        ),
      ),
    );
  }

  BadgeStatus _getStatusType(POStatus status) {
    switch (status) {
      case POStatus.pending:
        return BadgeStatus.neutral;
      case POStatus.process:
        return BadgeStatus.warning;
      case POStatus.complete:
        return BadgeStatus.success;
      case POStatus.cancelled:
        return BadgeStatus.error;
    }
  }

  String _formatAmount(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

class POStatusChip extends StatelessWidget {
  final POStatus status;

  const POStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _getStatusStyle();

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
        status.label,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  (Color, Color) _getStatusStyle() {
    switch (status) {
      case POStatus.pending:
        return (TossColors.gray700, TossColors.gray100);
      case POStatus.process:
        return (TossColors.warning, TossColors.warningLight);
      case POStatus.complete:
        return (TossColors.success, TossColors.successLight);
      case POStatus.cancelled:
        return (TossColors.error, TossColors.errorLight);
    }
  }
}

class _ShipmentProgress extends StatelessWidget {
  final double percent;

  const _ShipmentProgress({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipped',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space1),
        ClipRRect(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: TossColors.gray200,
            valueColor: const AlwaysStoppedAnimation<Color>(TossColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _ShipmentDateInfo extends StatelessWidget {
  final DateTime date;

  const _ShipmentDateInfo({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    final isOverdue = diff < 0;
    final isUrgent = diff >= 0 && diff <= 7;

    if (isOverdue) {
      return Row(
        children: [
          const Icon(LucideIcons.alertTriangle, size: 14, color: TossColors.error),
          const SizedBox(width: TossSpacing.space1),
          Text(
            'Shipment overdue by ${-diff} day${diff == -1 ? '' : 's'}',
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
      );
    }

    if (isUrgent) {
      return Row(
        children: [
          const Icon(LucideIcons.clock, size: 14, color: TossColors.warning),
          const SizedBox(width: TossSpacing.space1),
          Text(
            'Ship by ${DateFormat('MMM dd').format(date)} ($diff day${diff == 1 ? '' : 's'} left)',
            style: TossTextStyles.caption.copyWith(color: TossColors.warning),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Icon(LucideIcons.truck,
            size: 14, color: TossColors.gray500),
        const SizedBox(width: TossSpacing.space1),
        Text(
          'Ship by ${DateFormat('MMM dd, yyyy').format(date)}',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
        ),
      ],
    );
  }
}
