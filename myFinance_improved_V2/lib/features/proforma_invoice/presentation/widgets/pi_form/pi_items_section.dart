import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'pi_item_form_card.dart';

/// Items section widget for PI form
class PIItemsSection extends StatelessWidget {
  final List<PIItemFormData> items;
  final String currencyCode;
  final String? errorText;
  final VoidCallback onAddItem;
  final void Function(int index) onEditItem;
  final void Function(int index) onDeleteItem;

  const PIItemsSection({
    super.key,
    required this.items,
    required this.currencyCode,
    this.errorText,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Items',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasError ? TossColors.error : TossColors.gray500,
                  ),
                ),
                Text(
                  ' *',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.error,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${items.length}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: onAddItem,
              icon: const Icon(Icons.add_circle_outline, size: 24),
              tooltip: 'Add Items',
              color: TossColors.primary,
            ),
          ],
        ),
        if (hasError) ...[
          Text(
            errorText!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
          ),
          const SizedBox(height: TossSpacing.space1),
        ],
        const SizedBox(height: TossSpacing.space2),

        if (items.isEmpty)
          _buildEmptyState()
        else ...[
          ...items.asMap().entries.map((entry) => PIItemFormCard(
                item: entry.value,
                index: entry.key,
                currencyCode: currencyCode,
                onEdit: () => onEditItem(entry.key),
                onDelete: () => onDeleteItem(entry.key),
              )),
          const SizedBox(height: TossSpacing.space3),
          _buildTotalRow(total),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: onAddItem,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.gray200, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.add_circle_outline, size: 40, color: TossColors.primary),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Tap to add items',
                style: TossTextStyles.bodyMedium.copyWith(color: TossColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(double total) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: TossTextStyles.bodyLarge),
          Text(
            '$currencyCode ${NumberFormat('#,##0.00').format(total)}',
            style: TossTextStyles.h4,
          ),
        ],
      ),
    );
  }
}
