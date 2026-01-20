import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// v4: Counting info section showing zeroed items
/// Items that were in stock but not counted (set to 0 during counting submit)
class HistoryCountingInfoSection extends StatelessWidget {
  final CountingInfo countingInfo;

  const HistoryCountingInfoSection({
    super.key,
    required this.countingInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (!countingInfo.hasZeroedItems) {
      return const SizedBox.shrink();
    }

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
                    color: TossColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: TossSpacing.iconSM,
                    color: TossColors.error,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items Zeroed',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Not counted, stock set to 0',
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
                    color: TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${countingInfo.itemsZeroedCount} items',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Zeroed items list
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.error.withValues(alpha: 0.2)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: countingInfo.zeroedItems.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 12,
                endIndent: 12,
              ),
              itemBuilder: (context, index) {
                final item = countingInfo.zeroedItems[index];
                return _buildZeroedItemRow(item);
              },
            ),
          ),

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  Widget _buildZeroedItemRow(ZeroedItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
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
          // Stock change indicator (before -> 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.quantityBefore}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                const Icon(
                  Icons.arrow_forward,
                  size: TossSpacing.iconXXS,
                  color: TossColors.error,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  '0',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
