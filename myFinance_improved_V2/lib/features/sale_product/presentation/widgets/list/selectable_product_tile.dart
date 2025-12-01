import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/sales_product.dart';
import '../../providers/cart_provider.dart';
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
    final formatter = NumberFormat('#,##0', 'en_US');

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? TossColors.success.withValues(alpha: 0.1) : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: TossColors.success,
                width: 1.5,
              )
            : null,
        borderRadius: isSelected ? BorderRadius.circular(TossBorderRadius.sm) : null,
      ),
      child: TossListTile(
        title: product.productName,
        subtitle: product.sku,
        showDivider: false,
        leading: ProductImageWidget(
          imageUrl: product.images.mainImage,
          size: 48,
          fallbackIcon: Icons.inventory_2,
        ),
        trailing: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price
              Text(
                '$currencySymbol${formatter.format(product.pricing.sellingPrice?.round() ?? 0)}',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              // Stock info
              Text(
                'Stock: ${product.totalStockSummary.totalQuantityOnHand}',
                style: TossTextStyles.caption.copyWith(
                  color: _getStockColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
      ),
    );
  }

  Color _getStockColor() {
    final stock = product.totalStockSummary.totalQuantityOnHand;
    if (stock == 0) return TossColors.error;
    if (stock <= 5) return TossColors.warning;
    if (stock <= 20) return TossColors.info;
    return TossColors.success;
  }
}
