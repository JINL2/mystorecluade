import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/shipment.dart';

class ShipmentListItemWidget extends StatelessWidget {
  final ShipmentListItem item;
  final VoidCallback? onTap;
  final String? baseCurrencyCode;

  const ShipmentListItemWidget({
    super.key,
    required this.item,
    this.onTap,
    this.baseCurrencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Shipment number + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.shipmentNumber,
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.trackingNumber != null)
                            Text(
                              'Tracking: ${item.trackingNumber}',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    ShipmentStatusChip(status: item.status),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),

                // Supplier name
                Text(
                  item.supplierName ?? 'Unknown Supplier',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.gray700,
                  ),
                ),

                const SizedBox(height: TossSpacing.space3),

                // Bottom row: Amount + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Amount and item count
                    Row(
                      children: [
                        if (item.totalAmount > 0) ...[
                          Text(
                            _formatAmount(item.totalAmount),
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (item.itemCount > 0) ...[
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              '(${item.itemCount} items)',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                          ],
                        ] else if (item.itemCount > 0) ...[
                          Text(
                            '${item.itemCount} items',
                            style: TossTextStyles.bodyMedium.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Date
                    if (item.shippedDate != null)
                      Text(
                        _formatDate(item.shippedDate!),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                  ],
                ),

                // Order linkage info
                if (item.hasOrders) ...[
                  const SizedBox(height: TossSpacing.space2),
                  const _OrderLinkageInfo(),
                ],

                // Notes preview
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  Row(
                    children: [
                      const Icon(
                        Icons.notes,
                        size: 14,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          item.notes!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final symbol = baseCurrencyCode ?? '\$';
    return NumberFormat.currency(symbol: '$symbol ', decimalDigits: 2).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

class ShipmentStatusChip extends StatelessWidget {
  final ShipmentStatus status;

  const ShipmentStatusChip({super.key, required this.status});

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
      case ShipmentStatus.pending:
        return (TossColors.gray700, TossColors.gray100);
      case ShipmentStatus.process:
        return (TossColors.warning, TossColors.warningLight);
      case ShipmentStatus.complete:
        return (TossColors.success, TossColors.successLight);
      case ShipmentStatus.cancelled:
        return (TossColors.error, TossColors.errorLight);
    }
  }
}

class _OrderLinkageInfo extends StatelessWidget {
  const _OrderLinkageInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.link,
          size: 14,
          color: TossColors.primary,
        ),
        const SizedBox(width: TossSpacing.space1),
        Text(
          'Linked order',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
          ),
        ),
      ],
    );
  }
}
