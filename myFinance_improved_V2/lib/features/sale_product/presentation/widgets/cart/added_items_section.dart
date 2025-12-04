import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../domain/entities/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';
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
            ...cartItems.map((item) => _buildCartItemTile(ref, item)),

            // Total Section
            const SizedBox(height: TossSpacing.space3),
            _buildTotalSection(totalAmount),
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
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Text(
            '$totalItems items',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemTile(WidgetRef ref, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Product Image
          ProductImageWidget(
            imageUrl: item.image,
            size: 48,
            fallbackIcon: Icons.inventory_2,
          ),

          const SizedBox(width: TossSpacing.space3),

          // Product Info
          Expanded(
            child: _buildProductInfo(item),
          ),

          const SizedBox(width: TossSpacing.space3),

          // Quantity Controls
          _buildQuantityControls(ref, item),

          // Remove Button
          const SizedBox(width: TossSpacing.space3),
          InkWell(
            onTap: () => ref.read(cartProvider.notifier).removeItem(item.id),
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space1),
              child: const Icon(
                Icons.close_rounded,
                size: TossSpacing.iconSM,
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.name,
          style: TossTextStyles.bodyLarge.copyWith(
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
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Text(
              '$currencySymbol${CurrencyFormatter.currency.format(item.price.round())}',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' × ${item.quantity}',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              '= $currencySymbol${CurrencyFormatter.currency.format(item.subtotal.round())}',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w700,
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
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          InkWell(
            onTap: item.quantity > 1
                ? () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1)
                : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.md),
              bottomLeft: Radius.circular(TossBorderRadius.md),
            ),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: Icon(
                Icons.remove_rounded,
                size: TossSpacing.iconSM,
                color: item.quantity > 1 ? TossColors.gray700 : TossColors.gray400,
              ),
            ),
          ),

          // Quantity Display
          Container(
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space2,
            ),
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
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Increase Button
          InkWell(
            onTap: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(TossBorderRadius.md),
              bottomRight: Radius.circular(TossBorderRadius.md),
            ),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.add_rounded,
                size: TossSpacing.iconSM,
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Subtotal',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          Text(
            '$currencySymbol${CurrencyFormatter.currency.format(totalAmount.round())}',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
