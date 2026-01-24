import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// PO Item Form Data class
class POItemFormData {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final double quantity;
  final String unit;
  final double unitPrice;

  POItemFormData({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

/// Items section for PO form
class POItemsSection extends StatelessWidget {
  final List<POItemFormData> items;
  final String currencyCode;
  final String? errorText;
  final VoidCallback onAddItem;
  final void Function(int index) onEditItem;
  final void Function(int index) onDeleteItem;

  const POItemsSection({
    super.key,
    required this.items,
    required this.currencyCode,
    this.errorText,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  double get totalAmount {
    double total = 0;
    for (final item in items) {
      total += item.quantity * item.unitPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Items',
                  style: TossTextStyles.h4.copyWith(color: TossColors.gray900),
                ),
                SizedBox(width: TossSpacing.space1 / 2),
                Text(
                  '*',
                  style: TossTextStyles.h4.copyWith(color: TossColors.error),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Total: $currencyCode ${NumberFormat('#,##0.00').format(totalAmount)}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.plusCircle, color: TossColors.primary),
                  onPressed: onAddItem,
                ),
              ],
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            errorText!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
        ],
        const SizedBox(height: TossSpacing.space2),
        if (items.isEmpty)
          _buildEmptyPlaceholder()
        else
          ...List.generate(items.length, (index) {
            final item = items[index];
            return POItemCard(
              item: item,
              index: index,
              currencyCode: currencyCode,
              onEdit: () => onEditItem(index),
              onDelete: () => onDeleteItem(index),
            );
          }),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return GestureDetector(
      onTap: onAddItem,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: errorText != null ? TossColors.error : TossColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plusCircle, color: TossColors.primary, size: TossSpacing.iconMD),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Add items',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

/// PO Item Card Widget
class POItemCard extends StatelessWidget {
  final POItemFormData item;
  final int index;
  final String currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const POItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: TossSpacing.space7,
                  height: TossSpacing.space7,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    item.description,
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.pencil, size: TossSpacing.iconMD),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: TossSpacing.space2),
                IconButton(
                  icon: Icon(LucideIcons.trash2, size: TossSpacing.iconMD, color: TossColors.error),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              children: [
                if (item.sku != null && item.sku!.isNotEmpty) _buildChip('SKU: ${item.sku}'),
                if (item.hsCode != null && item.hsCode!.isNotEmpty) _buildChip('HS: ${item.hsCode}'),
              ],
            ),
            const SizedBox(height: TossSpacing.space2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit} × $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                  style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
                ),
                Text(
                  '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                  style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1 / 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
      ),
    );
  }
}
