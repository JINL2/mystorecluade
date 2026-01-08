// Widget: Inventory Product Card
// Reusable product card for inventory list

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../sale_product/presentation/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';

class InventoryProductCard extends StatelessWidget {
  final Product product;
  final String currencySymbol;
  final VoidCallback? onTap;
  final VoidCallback? onTransferTap;

  const InventoryProductCard({
    super.key,
    required this.product,
    required this.currencySymbol,
    this.onTap,
    this.onTransferTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasQuantity = product.onHand > 0;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap ?? () {
          context.push('/inventoryManagement/product/${product.id}');
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2, horizontal: TossSpacing.space1),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Container(
                  width: TossDimensions.minTouchTarget,
                  height: TossDimensions.minTouchTarget,
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first,
                          width: TossDimensions.minTouchTarget,
                          height: TossDimensions.minTouchTarget,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: TossDimensions.minTouchTarget,
                              height: TossDimensions.minTouchTarget,
                              color: TossColors.gray50,
                              child: const Icon(
                                Icons.image,
                                size: TossSpacing.iconMD,
                                color: TossColors.gray500,
                              ),
                            );
                          },
                        )
                      : const Icon(
                          Icons.inventory_2,
                          size: TossSpacing.iconMD,
                          color: TossColors.gray500,
                        ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              // Product info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: TossSpacing.space2, top: TossSpacing.space0_5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        product.name,
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space0_5),
                      // SKU row with quantity pill
                      Row(
                        children: [
                          Text(
                            product.sku,
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: TossFontWeight.medium,
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.badgePaddingHorizontalXS),
                          _buildQuantityPill(product.onHand, hasQuantity),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space0_5),
                      // Price row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$currencySymbol${CurrencyFormatter.formatPrice(product.salePrice)}',
                            style: TossTextStyles.titleMedium.copyWith(
                              fontWeight: TossFontWeight.semibold,
                              color: TossColors.primary,
                            ),
                          ),
                          _buildTransferButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityPill(int quantity, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.badgePaddingHorizontalXS, vertical: TossSpacing.badgePaddingVerticalXS),
      decoration: BoxDecoration(
        color: isActive ? TossColors.primarySurface : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        '$quantity',
        style: TossTextStyles.bodySmall.copyWith(
          fontWeight: TossFontWeight.semibold,
          color: isActive ? TossColors.primary : TossColors.gray900,
        ),
      ),
    );
  }

  Widget _buildTransferButton() {
    return GestureDetector(
      onTap: onTransferTap,
      child: Container(
        width: TossDimensions.minTouchTarget,
        height: TossDimensions.minTouchTarget,
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: const Center(
          child: Icon(
            Icons.swap_horiz,
            size: TossSpacing.iconSM,
            color: TossColors.gray900,
          ),
        ),
      ),
    );
  }
}
