import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_opacity.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../domain/entities/cart_item.dart';
import '../../utils/currency_formatter.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Sticky cart dock at bottom of sale page
/// Expandable design - tap chevron to show/hide selected items
class CartSummaryBar extends StatefulWidget {
  final int itemCount;
  final double subtotal;
  final VoidCallback onCreateInvoice;
  final VoidCallback? onReset;
  final String currencySymbol;
  final List<CartItem> cartItems;
  /// Callback when cart item is tapped
  /// Parameters: productId, sku (for search functionality)
  final void Function(String productId, String sku)? onItemTap;

  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.onCreateInvoice,
    this.onReset,
    this.currencySymbol = '\$',
    this.cartItems = const [],
    this.onItemTap,
  });

  @override
  State<CartSummaryBar> createState() => _CartSummaryBarState();
}

class _CartSummaryBarState extends State<CartSummaryBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
        border: Border.all(color: TossColors.gray200, width: TossDimensions.dividerThickness),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: TossOpacity.hover),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Chevron toggle + Summary row (combined tap area)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Column(
                children: [
                  // Chevron
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: TossSpacing.space3,
                      bottom: TossSpacing.space1,
                    ),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      size: TossSpacing.iconMD,
                      color: TossColors.textSecondary,
                    ),
                  ),
                  // Summary row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sub-total',
                              style: TossTextStyles.titleMedium.copyWith(
                                fontWeight: TossFontWeight.semibold,
                                color: TossColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            // Circular item count badge - auto-resize for large numbers
                            Container(
                              constraints: const BoxConstraints(
                                minWidth: TossSpacing.iconLG,
                                minHeight: TossSpacing.iconLG,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.badgePaddingHorizontalXS,
                              ),
                              decoration: BoxDecoration(
                                shape: widget.itemCount > 99 ? BoxShape.rectangle : BoxShape.circle,
                                borderRadius: widget.itemCount > 99
                                    ? BorderRadius.circular(TossBorderRadius.lg + 2)
                                    : null,
                                border: Border.all(
                                  color: TossColors.primary,
                                  width: TossDimensions.dividerThicknessMedium,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.itemCount}',
                                  style: widget.itemCount > 99
                                      ? TossTextStyles.caption.copyWith(
                                          fontWeight: TossFontWeight.medium,
                                          color: TossColors.primary,
                                        )
                                      : TossTextStyles.body.copyWith(
                                          fontWeight: TossFontWeight.medium,
                                          color: TossColors.primary,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          CurrencyFormatter.formatPrice(widget.subtotal),
                          style: TossTextStyles.subtitle.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded cart items
            if (_isExpanded) ...[
              const SizedBox(height: TossSpacing.space3),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return _CartItemRow(
                      item: item,
                      currencySymbol: widget.currencySymbol,
                      onTap: widget.onItemTap != null
                          ? () => widget.onItemTap!(item.productId, item.sku)
                          : null,
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: TossSpacing.space3),
            // Create invoice button (with optional reset button)
            Padding(
              padding: const EdgeInsets.only(
                left: TossSpacing.paddingMD,
                right: TossSpacing.paddingMD,
                bottom: TossSpacing.paddingMD,
              ),
              child: Row(
                children: [
                  // Reset button (1/3 width) - only show when items are selected
                  if (widget.itemCount > 0 && widget.onReset != null) ...[
                    Expanded(
                      flex: 1,
                      child: TossButton.outlined(
                        text: 'Reset',
                        onPressed: widget.onReset,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                  ],
                  // Create invoice button (2/3 width when reset visible, full width otherwise)
                  Expanded(
                    flex: widget.itemCount > 0 && widget.onReset != null ? 2 : 1,
                    child: TossButton.primary(
                      text: 'Create invoice',
                      onPressed: widget.onCreateInvoice,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual cart item row with image
class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final String currencySymbol;
  final VoidCallback? onTap;

  const _CartItemRow({
    required this.item,
    required this.currencySymbol,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space2,
            horizontal: TossSpacing.space1,
          ),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: SizedBox(
                  width: TossSpacing.iconXXL,
                  height: TossSpacing.iconXXL,
                  child: item.image != null && item.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.image!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: TossColors.gray100,
                            child: const Icon(Icons.image, color: TossColors.gray400, size: TossSpacing.iconMD2),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: TossColors.gray100,
                            child: const Icon(Icons.image, color: TossColors.gray400, size: TossSpacing.iconMD2),
                          ),
                        )
                      : Container(
                          color: TossColors.gray100,
                          child: const Icon(Icons.image, color: TossColors.gray400, size: TossSpacing.iconMD2),
                        ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.semibold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      item.sku,
                      style: TossTextStyles.labelSmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              // Quantity × Price
              Text(
                '${item.quantity} × ${CurrencyFormatter.formatPrice(item.price)}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.medium,
                  color: TossColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
