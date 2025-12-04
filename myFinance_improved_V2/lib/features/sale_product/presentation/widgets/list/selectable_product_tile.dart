import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_list_tile.dart';
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
  final VoidCallback? onUnfocusSearch;

  const SelectableProductTile({
    super.key,
    required this.product,
    required this.cartItem,
    required this.currencySymbol,
    this.onUnfocusSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = cartItem.quantity > 0;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onUnfocusSearch?.call();

        if (cartItem.quantity == 0) {
          ref.read(cartProvider.notifier).addItem(product);
        } else {
          ref.read(cartProvider.notifier).updateQuantity(
                cartItem.id,
                cartItem.quantity + 1,
              );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.success.withValues(alpha: 0.05) : TossColors.transparent,
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

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    product.sku,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Price and Stock
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currencySymbol${CurrencyFormatter.currency.format(product.pricing.sellingPrice?.round() ?? 0)}',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Stock: ${product.totalStockSummary.totalQuantityOnHand}',
                  style: TossTextStyles.caption.copyWith(
                    color: StockColorHelper.getStockColor(
                      product.totalStockSummary.totalQuantityOnHand,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Selection Indicator
            if (isSelected) ...[
              const SizedBox(width: TossSpacing.space2),
              Container(
                padding: const EdgeInsets.all(TossSpacing.space1),
                decoration: const BoxDecoration(
                  color: TossColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: TossColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
