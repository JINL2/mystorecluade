import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/index.dart';
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
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: TossCard(
        onTap: onTap,
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
                TossBadge.status(
                  label: item.status.label,
                  status: _getStatusType(item.status),
                ),
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
              TossBadge.status(
                label: 'Linked order',
                status: BadgeStatus.info,
                icon: LucideIcons.link,
              ),
            ],

            // Notes preview
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  const Icon(
                    LucideIcons.fileText,
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
    );
  }

  String _formatAmount(double amount) {
    final symbol = baseCurrencyCode ?? '\$';
    return NumberFormat.currency(symbol: '$symbol ', decimalDigits: 2).format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  BadgeStatus _getStatusType(ShipmentStatus status) {
    switch (status) {
      case ShipmentStatus.pending:
        return BadgeStatus.neutral;
      case ShipmentStatus.process:
        return BadgeStatus.warning;
      case ShipmentStatus.complete:
        return BadgeStatus.success;
      case ShipmentStatus.cancelled:
        return BadgeStatus.error;
    }
  }
}
