import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Item Form Data class for PI form
class PIItemFormData {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final String? countryOfOrigin;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double discountPercent;

  PIItemFormData({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    this.countryOfOrigin,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.discountPercent = 0,
  });

  double get lineTotal => quantity * unitPrice * (1 - discountPercent / 100);
}

/// Item Form Card widget
class PIItemFormCard extends StatelessWidget {
  final PIItemFormData item;
  final int index;
  final String currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PIItemFormCard({
    super.key,
    required this.item,
    required this.index,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.description,
                  style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 18, color: TossColors.gray500),
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(TossSpacing.space1),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 18, color: TossColors.error),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(TossSpacing.space1),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat('#,##0.##').format(item.quantity)} ${item.unit} × $currencyCode ${NumberFormat('#,##0.00').format(item.unitPrice)}',
                style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
              ),
              Text(
                '$currencyCode ${NumberFormat('#,##0.00').format(item.lineTotal)}',
                style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
