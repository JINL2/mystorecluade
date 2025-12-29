import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/cart_item.dart';

/// Sticky cart dock at bottom of sale page
/// Expandable design - tap chevron to show/hide selected items
class CartSummaryBar extends StatefulWidget {
  final int itemCount;
  final double subtotal;
  final VoidCallback onCreateInvoice;
  final String currencySymbol;
  final List<CartItem> cartItems;
  final void Function(String productId)? onItemTap;

  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.onCreateInvoice,
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
    final formatter = NumberFormat('#,###');

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.bottomSheet),
          topRight: Radius.circular(TossBorderRadius.bottomSheet),
        ),
        border: Border.all(color: TossColors.gray200, width: 1),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.08),
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
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      size: 20,
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
                                fontWeight: FontWeight.w600,
                                color: TossColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Circular item count badge
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: TossColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.itemCount}',
                                  style: TossTextStyles.titleMedium.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: TossColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatter.format(widget.subtotal.round()),
                          style: TossTextStyles.bodyMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
              const SizedBox(height: 12),
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
                          ? () => widget.onItemTap!(item.productId)
                          : null,
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Create invoice button
            Padding(
              padding: const EdgeInsets.only(
                left: TossSpacing.paddingMD,
                right: TossSpacing.paddingMD,
                bottom: TossSpacing.paddingMD,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onCreateInvoice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Create invoice',
                    style: TossTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
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
    final formatter = NumberFormat('#,###');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: item.image != null && item.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.image!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: TossColors.gray100,
                            child: const Icon(Icons.image, color: TossColors.gray400, size: 24),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: TossColors.gray100,
                            child: const Icon(Icons.image, color: TossColors.gray400, size: 24),
                          ),
                        )
                      : Container(
                          color: TossColors.gray100,
                          child: const Icon(Icons.image, color: TossColors.gray400, size: 24),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.sku,
                      style: TossTextStyles.labelSmall.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Quantity × Price
              Text(
                '${item.quantity} × ${formatter.format(item.price.round())}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
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
