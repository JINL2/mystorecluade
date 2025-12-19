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
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '${widget.cartItem.quantity}';
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(SelectableProductTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when quantity changes externally (from +/- buttons)
    if (!_isEditing && widget.cartItem.quantity != oldWidget.cartItem.quantity) {
      _quantityController.text = '${widget.cartItem.quantity}';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() => _isEditing = true);
      // Select all text when focused
      _quantityController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _quantityController.text.length,
      );
    } else {
      setState(() => _isEditing = false);
      _applyQuantity();
    }
  }

  void _applyQuantity() {
    final qty = int.tryParse(_quantityController.text) ?? 0;
    if (qty > 0) {
      ref.read(cartProvider.notifier).updateQuantity(widget.cartItem.id, qty);
    } else {
      ref.read(cartProvider.notifier).removeItem(widget.cartItem.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.cartItem.quantity > 0;
    final stockQuantity = widget.product.totalStockSummary.totalQuantityOnHand;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        if (isSelected) {
          // Already in cart - increase quantity
          ref.read(cartProvider.notifier).updateQuantity(
                widget.cartItem.id,
                widget.cartItem.quantity + 1,
              );
        } else {
          // Not in cart - add item
          ref.read(cartProvider.notifier).addItem(widget.product);
        }
      },
      child: Container(
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
    );
  }

  Widget _buildStockBadge(int stockQuantity, bool isSelected) {
    // Blue if stock > 0, gray if stock == 0, red if stock < 0
    final Color backgroundColor;
    final Color textColor;

    if (stockQuantity > 0) {
      backgroundColor = TossColors.primarySurface;
      textColor = TossColors.primary;
    } else if (stockQuantity < 0) {
      backgroundColor = TossColors.errorLight;
      textColor = TossColors.error;
    } else {
      backgroundColor = TossColors.gray50;
      textColor = TossColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$stockQuantity',
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
                ref.read(cartProvider.notifier).updateQuantity(
                      widget.cartItem.id,
                      widget.cartItem.quantity - 1,
                    );
              } else {
                ref.read(cartProvider.notifier).removeItem(widget.cartItem.id);
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
          // Quantity input - inline editable TextField
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _focusNode.requestFocus();
            },
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
                child: EditableText(
                  controller: _quantityController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                  cursorColor: TossColors.primary,
                  backgroundCursorColor: TossColors.gray200,
                  onSubmitted: (_) {
                    _focusNode.unfocus();
                  },
                ),
              ),
            ),
          ),
          // Plus button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(cartProvider.notifier).updateQuantity(
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
        ref.read(cartProvider.notifier).addItem(widget.product);
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
