import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_product.dart';
import '../../domain/entities/inventory_status.dart';

/// Clean & intuitive product list tile
///
/// Layout: Product name | Stock · Sales/day | Days left badge
class ProductListTile extends StatelessWidget {
  final InventoryProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onOrderTap;

  const ProductListTile({
    super.key,
    required this.product,
    this.onTap,
    this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingMD,
          vertical: TossSpacing.paddingSM,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.card),
          border: Border.all(color: TossColors.gray100),
        ),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: TossSpacing.gapMD),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Product name
                  Text(
                    product.productName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.semibold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Row 2: Stock · Sales/day
                  Row(
                    children: [
                      Text(
                        '${product.currentStock}',
                        style: TossTextStyles.caption.copyWith(
                          color: product.currentStock <= 0
                              ? TossColors.error
                              : TossColors.textPrimary,
                          fontWeight: TossFontWeight.semibold,
                        ),
                      ),
                      Text(
                        ' in stock',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      _buildDot(),
                      Text(
                        '${product.avgDailyDemand.toStringAsFixed(1)}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: TossFontWeight.medium,
                        ),
                      ),
                      Text(
                        '/day',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Days left badge
            _buildDaysLeftBadge(),

            const SizedBox(width: TossSpacing.gapSM),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '·',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray300,
        ),
      ),
    );
  }

  Widget _buildDaysLeftBadge() {
    final days = product.daysOfInventory;
    final color = _getDaysLeftColor();
    final text = _getDaysLeftText(days);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: TossFontWeight.bold,
        ),
      ),
    );
  }

  String _getDaysLeftText(double days) {
    if (days <= 0) {
      return 'Out';
    } else if (days < 1) {
      return 'Today';
    } else if (days < 2) {
      return '1 day';
    } else if (days < 30) {
      return '${days.toInt()}d';
    } else {
      return '${(days / 30).toInt()}mo+';
    }
  }

  Color _getStatusColor() {
    return switch (product.status) {
      InventoryStatus.abnormal => TossColors.error,
      InventoryStatus.stockout => TossColors.error,
      InventoryStatus.critical => TossColors.amber,
      InventoryStatus.warning => TossColors.amberDark,
      InventoryStatus.reorderNeeded => TossColors.primary,
      InventoryStatus.deadStock => TossColors.gray500,
      InventoryStatus.overstock => TossColors.purple,
      InventoryStatus.normal => TossColors.success,
    };
  }

  Color _getDaysLeftColor() {
    if (product.daysOfInventory <= 0) return TossColors.error;
    if (product.daysOfInventory < 2) return TossColors.error;
    if (product.daysOfInventory < 7) return TossColors.amber;
    return TossColors.success;
  }
}
