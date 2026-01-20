import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/session_review_provider.dart';
import '../../providers/states/session_review_state.dart';
import 'review_edit_quantity_dialog.dart';
import 'review_item_detail_sheet.dart';

/// Review item card - shows stock changes
class ReviewItemCard extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const ReviewItemCard({
    super.key,
    required this.item,
    required this.params,
  });

  void _showDetailBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => ReviewItemDetailSheet(
        item: item,
        params: params,
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, SessionReviewState state) {
    // v2: Use item-based getEffectiveQuantity for variant support
    final currentQuantity = state.getEffectiveQuantity(item);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => ReviewEditQuantityDialog(
        item: item,
        currentQuantity: currentQuantity,
        onSave: (newQuantity) {
          // v2: Pass item instead of productId for variant support
          ref.read(sessionReviewNotifierProvider(params).notifier).updateQuantity(
                item,
                newQuantity,
              );
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionReviewNotifierProvider(params));
    // v2: Use item-based isEdited for variant support
    final isEdited = state.isEdited(item);
    final effectiveNewStock = state.getEffectiveNewStock(item);
    final effectiveStockChange = state.getEffectiveStockChange(item);

    // Determine change color based on effective values
    Color changeColor;
    String changePrefix = '';
    if (effectiveStockChange > 0) {
      changeColor = TossColors.success;
      changePrefix = '+';
    } else if (effectiveStockChange < 0) {
      changeColor = TossColors.loss;
      changePrefix = '';
    } else {
      changeColor = TossColors.textSecondary;
    }

    return GestureDetector(
      onTap: () => _showDetailBottomSheet(context, ref),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space1,
        ),
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.gray100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: TossSpacing.icon3XL,
              height: TossSpacing.icon3XL,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.inventory_2_outlined,
                            color: TossColors.textTertiary,
                            size: TossSpacing.iconMD2,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.inventory_2_outlined,
                      color: TossColors.textTertiary,
                      size: TossSpacing.iconMD2,
                    ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name, // Uses displayName for variants
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: TossFontWeight.medium,
                      color: TossColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TossSpacing.space0_5),
                  if (item.effectiveSku != null) ...[
                    Text(
                      item.effectiveSku!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                  if (item.brand != null || item.category != null) ...[
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      [item.brand, item.category].whereType<String>().join(' · '),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Stock Change Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Previous → New stock display
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item.previousStock}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    const Icon(
                      Icons.arrow_forward,
                      size: TossSpacing.iconXS,
                      color: TossColors.textTertiary,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      '$effectiveNewStock',
                      style: TossTextStyles.body.copyWith(
                        color: isEdited ? TossColors.primary : TossColors.textPrimary,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space1),
                // Change indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '$changePrefix$effectiveStockChange',
                    style: TossTextStyles.caption.copyWith(
                      color: changeColor,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: TossSpacing.space2),

            // Edit button - separate column on the right
            GestureDetector(
              onTap: () => _showEditDialog(context, ref, state),
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: isEdited
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: isEdited ? TossColors.primary : TossColors.gray300,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  size: TossSpacing.iconSM2,
                  color: isEdited ? TossColors.primary : TossColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
