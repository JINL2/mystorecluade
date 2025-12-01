import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../domain/entities/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../common/product_image_widget.dart';

/// Added items section widget - displays cart items with quantity controls
class AddedItemsSection extends ConsumerWidget {
  final List<CartItem> cartItems;
  final String currencySymbol;

  const AddedItemsSection({
    super.key,
    required this.cartItems,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmount = ref.read(cartProvider.notifier).subtotal;
    final totalItems = ref.read(cartProvider.notifier).totalItems;
    final formatter = NumberFormat('#,##0', 'en_US');

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(totalItems),

            const SizedBox(height: TossSpacing.space3),

            // Cart Items List
            ...cartItems.map((item) => _buildCartItemTile(ref, item, formatter)),

            // Total Section
            const SizedBox(height: TossSpacing.space3),
            _buildTotalSection(totalAmount, formatter),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int totalItems) {
    return Row(
      children: [
        const Icon(
          Icons.shopping_cart,
          color: TossColors.primary,
          size: TossSpacing.iconSM,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Added Items',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '$totalItems items',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemTile(WidgetRef ref, CartItem item, NumberFormat formatter) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product Image
          ProductImageWidget(
            imageUrl: item.image,
            size: 40,
            fallbackIcon: Icons.inventory_2,
          ),

          const SizedBox(width: TossSpacing.space3),

          // Product Info
          Expanded(
            child: _buildProductInfo(item, formatter),
          ),

          // Quantity Controls
          _buildQuantityControls(ref, item),

          // Remove Button
          const SizedBox(width: TossSpacing.space2),
          InkWell(
            onTap: () => ref.read(cartProvider.notifier).removeItem(item.id),
            child: const Icon(
              Icons.close,
              size: 20,
              color: TossColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(CartItem item, NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          item.sku,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Row(
          children: [
            Text(
              '$currencySymbol${formatter.format(item.price.round())}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' × ${item.quantity}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '$currencySymbol${formatter.format(item.subtotal.round())}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(WidgetRef ref, CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Decrease Button
          InkWell(
            onTap: item.quantity > 0
                ? () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1)
                : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.sm),
              bottomLeft: Radius.circular(TossBorderRadius.sm),
            ),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: Icon(
                Icons.remove,
                size: 16,
                color: item.quantity > 0 ? TossColors.primary : TossColors.gray400,
              ),
            ),
          ),

          // Quantity Display
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Increase Button
          InkWell(
            onTap: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(TossBorderRadius.sm),
              bottomRight: Radius.circular(TossBorderRadius.sm),
            ),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.add,
                size: 16,
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(double totalAmount, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          Text(
            '$currencySymbol${formatter.format(totalAmount.round())}',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
