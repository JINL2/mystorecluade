import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/states/session_detail_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Product item widget for inventory list display
class InventoryProductItem extends StatelessWidget {
  final SearchProductResult product;
  final int quantity;
  final VoidCallback onTap;

  const InventoryProductItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.onTap,
  });

  bool get _hasCount => quantity > 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: Row(
          children: [
            // Product image
            CachedProductImage(
              imageUrl: product.imageUrl,
              size: 60,
              borderRadius: 8,
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (product.sku != null)
                    Text(
                      product.sku!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  if (product.barcode != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.barcode!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Quantity
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Text(
                _hasCount ? '$quantity' : '-',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _hasCount ? TossColors.primary : TossColors.gray400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
