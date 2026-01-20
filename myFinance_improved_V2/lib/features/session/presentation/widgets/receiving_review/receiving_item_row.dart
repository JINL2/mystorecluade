import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/session_review_provider.dart';
import '../../providers/states/session_review_state.dart';
import 'receiving_edit_quantity_dialog.dart';
import 'receiving_item_detail_sheet.dart';

/// Receiving item row - table format
class ReceivingItemRow extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const ReceivingItemRow({
    super.key,
    required this.item,
    required this.params,
  });

  void _showDetailBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => ReceivingItemDetailSheet(
        item: item,
        params: params,
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, SessionReviewState state) {
    final currentQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => ReceivingEditQuantityDialog(
        item: item,
        currentQuantity: currentQuantity,
        onSave: (newQuantity) {
          ref.read(sessionReviewNotifierProvider(params).notifier).updateQuantity(
                item.productId,
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
    final isEdited = state.isEdited(item.productId);
    final effectiveQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    // Calculate status colors using effective quantities
    final shipped = item.previousStock;
    final received = effectiveQuantity;
    final rejected = item.totalRejected;
    final accepted = received - rejected;

    // Determine row status color
    Color? receivedColor;
    Color? acceptedColor;

    if (accepted > shipped) {
      // Over received - blue
      receivedColor = TossColors.primary;
      acceptedColor = TossColors.primary;
    } else if (accepted < shipped && rejected == 0) {
      // Under received - red
      receivedColor = TossColors.loss;
      acceptedColor = TossColors.loss;
    } else if (accepted == shipped && rejected == 0) {
      // Fully matched - green
      acceptedColor = TossColors.success;
    }

    return InkWell(
      onTap: () => _showDetailBottomSheet(context, ref),
      child: Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      child: Row(
        children: [
          // Product info (with image)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Product image
                Container(
                  width: TossSpacing.inputHeightMD,
                  height: TossSpacing.inputHeightMD,
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
                                size: TossSpacing.iconMD,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.inventory_2_outlined,
                          color: TossColors.textTertiary,
                          size: TossSpacing.iconMD,
                        ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Product name and SKU
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: TossFontWeight.semibold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.effectiveSku != null) ...[
                        const SizedBox(height: TossSpacing.space1),
                        Text(
                          item.effectiveSku!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Number columns - match header layout
          _buildDataCell('$shipped', TossColors.textSecondary, false),
          // Received column - show edited state
          SizedBox(
            width: TossSpacing.inputHeightLG + 4,
            child: Text(
              '$received',
              style: TossTextStyles.body.copyWith(
                color: isEdited
                    ? TossColors.primary
                    : (receivedColor ?? TossColors.textPrimary),
                fontWeight: (isEdited || receivedColor != null)
                    ? TossFontWeight.semibold
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildDataCell('$accepted', acceptedColor ?? TossColors.textPrimary, acceptedColor != null),
          _buildDataCell('$rejected', rejected > 0 ? TossColors.loss : TossColors.textSecondary, rejected > 0),
          // Edit button
          GestureDetector(
            onTap: () => _showEditDialog(context, ref, state),
            child: Container(
              width: TossSpacing.iconLG2,
              height: TossSpacing.iconLG2,
              margin: const EdgeInsets.only(left: TossSpacing.space2),
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
                size: TossSpacing.iconXS,
                color: isEdited ? TossColors.primary : TossColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDataCell(String text, Color color, bool isBold) {
    return SizedBox(
      width: TossSpacing.inputHeightLG + 4,
      child: Text(
        text,
        style: TossTextStyles.body.copyWith(
          color: color,
          fontWeight: isBold ? TossFontWeight.semibold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
