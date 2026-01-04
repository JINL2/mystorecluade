import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../inventory_management/domain/entities/product.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/sales_product.dart';
import '../../providers/cart_provider.dart';
import '../../utils/currency_formatter.dart';
import '../common/product_image_widget.dart';

/// Selectable product tile widget - displays a product that can be added to cart
/// New UI design matching the provided mockup
class SelectableProductTile extends ConsumerStatefulWidget {
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
  ConsumerState<SelectableProductTile> createState() =>
      _SelectableProductTileState();
}

class _SelectableProductTileState extends ConsumerState<SelectableProductTile> {

  /// Navigate to product detail page
  void _navigateToProductDetail(BuildContext context) {
    HapticFeedback.lightImpact();

    // Convert SalesProduct to Product for inventory provider
    final product = _convertToInventoryProduct(widget.product);

    // Navigate to product detail with Product object via extra
    context.push(
      '/inventoryManagement/product/${widget.product.productId}',
      extra: product,
    );
  }

  /// Convert SalesProduct to inventory Product entity
  Product _convertToInventoryProduct(SalesProduct salesProduct) {
    return Product(
      id: salesProduct.productId,
      sku: salesProduct.sku,
      barcode: salesProduct.barcode.isNotEmpty ? salesProduct.barcode : null,
      name: salesProduct.productName,
      images: [
        if (salesProduct.images.mainImage != null) salesProduct.images.mainImage!,
        ...salesProduct.images.additionalImages,
      ],
      categoryName: salesProduct.category,
      brandName: salesProduct.brand,
      productType: salesProduct.productType,
      unit: salesProduct.unit ?? 'piece',
      costPrice: salesProduct.pricing.costPrice ?? 0,
      salePrice: salesProduct.pricing.sellingPrice ?? 0,
      minPrice: salesProduct.pricing.minPrice,
      onHand: salesProduct.totalStockSummary.totalQuantityOnHand,
      available: salesProduct.totalStockSummary.totalQuantityAvailable,
      reserved: salesProduct.totalStockSummary.totalQuantityReserved,
      minStock: salesProduct.stockSettings.minStock,
      maxStock: salesProduct.stockSettings.maxStock,
      reorderPoint: salesProduct.stockSettings.reorderPoint,
      reorderQuantity: salesProduct.stockSettings.reorderQuantity,
      weight: salesProduct.attributes.weightG,
      createdAt: salesProduct.status.createdAt,
      updatedAt: salesProduct.status.updatedAt,
      isActive: salesProduct.status.isActive,
    );
  }

  /// Show quantity number pad modal (integer only, no decimal)
  void _showQuantityNumberPad(BuildContext context) {
    HapticFeedback.lightImpact();
    TossCurrencyExchangeModal.show(
      context: context,
      title: 'Enter Quantity',
      initialValue: '${widget.cartItem.quantity}',
      allowDecimal: false, // Integer only - removes the "." button
      onConfirm: (value) {
        final qty = int.tryParse(value) ?? 0;
        if (qty > 0) {
          ref.read(cartNotifierProvider.notifier).updateQuantity(
            widget.cartItem.id,
            qty,
          );
        } else {
          ref.read(cartNotifierProvider.notifier).removeItem(widget.cartItem.id);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.cartItem.quantity > 0;
    final stockQuantity = widget.product.totalStockSummary.totalQuantityOnHand;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _navigateToProductDetail(context),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ProductImageWidget(
                imageUrl: widget.product.images.mainImage,
                size: 44,
                fallbackIcon: Icons.inventory_2,
              ),
              const SizedBox(width: TossSpacing.space4),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      widget.product.productName,
                      style: TossTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // SKU and Stock Badge Row
                    Row(
                      children: [
                        Text(
                          widget.product.sku,
                          style: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: TossColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildStockBadge(stockQuantity, isSelected),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Price Row with Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.currencySymbol}${CurrencyFormatter.currency.format(widget.product.pricing.sellingPrice?.round() ?? 0)}',
                          style: TossTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.primary,
                          ),
                        ),
                        isSelected ? _buildQuantityStepper() : _buildAddButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge(int stockQuantity, bool isSelected) {
    // Blue if stock > 0, gray if stock == 0, red "No Quantity" only when trying to sell with 0 stock
    final Color backgroundColor;
    final Color textColor;
    final String displayText;

    if (stockQuantity > 0) {
      backgroundColor = TossColors.primarySurface;
      textColor = TossColors.primary;
      displayText = '$stockQuantity';
    } else if (stockQuantity < 0) {
      backgroundColor = TossColors.errorLight;
      textColor = TossColors.error;
      displayText = '$stockQuantity';
    } else {
      // stockQuantity == 0
      if (isSelected) {
        // Trying to sell with 0 stock - show warning
        backgroundColor = TossColors.errorLight;
        textColor = TossColors.error;
        displayText = 'No Quantity';
      } else {
        // Just displaying stock - show "0" in blue (same style as positive stock)
        backgroundColor = TossColors.primarySurface;
        textColor = TossColors.primary;
        displayText = '0';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        displayText,
        style: TossTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildQuantityStepper() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              if (widget.cartItem.quantity > 1) {
                ref.read(cartNotifierProvider.notifier).updateQuantity(
                      widget.cartItem.id,
                      widget.cartItem.quantity - 1,
                    );
              } else {
                ref.read(cartNotifierProvider.notifier).removeItem(widget.cartItem.id);
              }
            },
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: 20,
                  color: TossColors.textPrimary,
                ),
              ),
            ),
          ),
          // Quantity input - tap to open number pad modal
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showQuantityNumberPad(context),
            child: Container(
              width: 52,
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${widget.cartItem.quantity}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          // Plus button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(cartNotifierProvider.notifier).updateQuantity(
                    widget.cartItem.id,
                    widget.cartItem.quantity + 1,
                  );
            },
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: TossColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(cartNotifierProvider.notifier).addItem(widget.product);
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 18,
            color: TossColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
