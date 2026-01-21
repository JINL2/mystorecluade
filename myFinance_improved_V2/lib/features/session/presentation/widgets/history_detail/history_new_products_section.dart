import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// New products section for receiving session detail
/// Shows products that are new to stock (first time in inventory)
class HistoryNewProductsSection extends StatelessWidget {
  final ReceivingInfo receivingInfo;

  const HistoryNewProductsSection({
    super.key,
    required this.receivingInfo,
  });

  @override
  Widget build(BuildContext context) {
    final newProducts = receivingInfo.newProducts;
    final restockProducts = receivingInfo.restockProducts;

    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space1),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: TossSpacing.iconSM,
                    color: TossColors.success,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Update',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Receiving #${receivingInfo.receivingNumber}',
                        style: TossTextStyles.micro.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Summary badges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Row(
              children: [
                _buildStockSummaryBadge(
                  icon: Icons.fiber_new,
                  label: 'New Products',
                  count: newProducts.length,
                  color: TossColors.warning,
                ),
                const SizedBox(width: TossSpacing.space2),
                _buildStockSummaryBadge(
                  icon: Icons.replay,
                  label: 'Restock',
                  count: restockProducts.length,
                  color: TossColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // New Products section (needs display)
          if (newProducts.isNotEmpty) ...[
            _buildStockCategoryCard(
              title: 'New Products',
              subtitle: 'First time in stock • Needs display',
              icon: Icons.fiber_new,
              color: TossColors.warning,
              items: newProducts,
              showNeedsDisplay: true,
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: TossSpacing.iconXL,
                      color: TossColors.success.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'No new products',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'All received items are restocks',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Restock Products section
          if (restockProducts.isNotEmpty) ...[
            _buildStockCategoryCard(
              title: 'Restocked Products',
              subtitle: 'Added to existing stock',
              icon: Icons.replay,
              color: TossColors.success,
              items: restockProducts,
            ),
          ],

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  Widget _buildStockSummaryBadge({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TossSpacing.iconSM2, color: color),
          const SizedBox(width: TossSpacing.space1),
          Text(
            '$count $label',
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<StockSnapshotItem> items,
    bool showNeedsDisplay = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: TossSpacing.iconSM2, color: color),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: color,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TossTextStyles.micro.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildStockSnapshotItemRow(item, color, showNeedsDisplay);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStockSnapshotItemRow(
    StockSnapshotItem item,
    Color accentColor,
    bool showNeedsDisplay,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Display indicator for new products
          if (showNeedsDisplay) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: TossColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.visibility,
                size: TossSpacing.iconXXS,
                color: TossColors.warning,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SKU: ${item.sku}',
                  style: TossTextStyles.micro.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Stock change indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.quantityBefore}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                const Icon(
                  Icons.arrow_forward,
                  size: TossSpacing.iconXXS,
                  color: TossColors.textTertiary,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  '${item.quantityAfter}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Received quantity
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              '+${item.quantityReceived}',
              style: TossTextStyles.caption.copyWith(
                fontWeight: TossFontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
