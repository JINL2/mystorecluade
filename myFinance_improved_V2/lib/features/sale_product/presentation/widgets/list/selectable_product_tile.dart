import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/sales_product.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/stock_color_helper.dart';
import '../common/product_image_widget.dart';

/// Selectable product tile widget - displays a product that can be added to cart
class SelectableProductTile extends ConsumerWidget {
  final SalesProduct product;
  final CartItem cartItem;
  final String currencySymbol;

  const SelectableProductTile({
    super.key,
    required this.product,
    required this.cartItem,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = cartItem.quantity > 0;
    final stockQuantity = product.totalStockSummary.totalQuantityOnHand;
    final stockColor = StockColorHelper.getStockColor(stockQuantity);

    return GestureDetector(
      onTap: isSelected
          ? null
          : () {
              HapticFeedback.lightImpact();
              ref.read(cartProvider.notifier).addItem(product);
            },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: TossColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
          borderRadius: isSelected ? BorderRadius.circular(TossBorderRadius.sm) : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Product Image
            ProductImageWidget(
              imageUrl: product.images.mainImage,
              size: 48,
              fallbackIcon: Icons.inventory_2,
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product Info (Name, SKU, Stock)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name - 1 line with ellipsis
                  Text(
                    product.productName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // SKU and Stock in same row
                  Row(
                    children: [
                      // SKU
                      Text(
                        product.sku,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      // Stock badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: stockColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          '$stockQuantity',
                          style: TossTextStyles.caption.copyWith(
                            color: stockColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Price
                  Text(
                    '$currencySymbol${CurrencyFormatter.currency.format(product.pricing.sellingPrice?.round() ?? 0)}',
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Control (shown when selected) or empty space
            if (isSelected) ...[
              const SizedBox(width: TossSpacing.space2),
              _buildQuantityControl(ref),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () {
              HapticFeedback.lightImpact();
              if (cartItem.quantity > 1) {
                ref.read(cartProvider.notifier).updateQuantity(
                      cartItem.id,
                      cartItem.quantity - 1,
                    );
              } else {
                ref.read(cartProvider.notifier).removeItem(cartItem.id);
              }
            },
          ),
          // Quantity display
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Text(
              '${cartItem.quantity}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Plus button
          _buildQuantityButton(
            icon: Icons.add,
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(cartProvider.notifier).updateQuantity(
                    cartItem.id,
                    cartItem.quantity + 1,
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space2),
        child: Icon(
          icon,
          size: 18,
          color: TossColors.gray700,
        ),
      ),
    );
  }
}
