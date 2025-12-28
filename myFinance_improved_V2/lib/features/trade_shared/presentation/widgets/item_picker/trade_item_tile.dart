import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/keyboard/toss_numberpad_modal.dart';
import '../../../domain/entities/trade_item.dart';

/// Trade item tile widget - displays a product that can be selected for trade documents
class TradeItemTile extends StatefulWidget {
  final TradeItem item;
  final String currencySymbol;
  final VoidCallback? onTap;
  final ValueChanged<double>? onQuantityChanged;
  final VoidCallback? onRemove;
  final bool showQuantityStepper;

  const TradeItemTile({
    super.key,
    required this.item,
    required this.currencySymbol,
    this.onTap,
    this.onQuantityChanged,
    this.onRemove,
    this.showQuantityStepper = true,
  });

  @override
  State<TradeItemTile> createState() => _TradeItemTileState();
}

class _TradeItemTileState extends State<TradeItemTile> {
  String _formatQuantity(double qty) {
    return qty == qty.truncateToDouble() ? qty.toInt().toString() : qty.toStringAsFixed(2);
  }

  void _showQuantityModal() {
    HapticFeedback.lightImpact();
    TossNumberpadModal.show(
      context: context,
      title: 'Enter Quantity',
      initialValue: _formatQuantity(widget.item.quantity),
      allowDecimal: true,
      maxDecimalPlaces: 2,
      onConfirm: (value) {
        final qty = double.tryParse(value) ?? 0;
        if (qty > 0 && widget.onQuantityChanged != null) {
          widget.onQuantityChanged!(qty);
        } else if (qty <= 0 && widget.onRemove != null) {
          widget.onRemove!();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.item.quantity > 0;
    final stockQuantity = widget.item.stockQuantity ?? 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(),
            const SizedBox(width: TossSpacing.space4),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.item.displayName,
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
                      if (widget.item.sku != null) ...[
                        Text(
                          widget.item.sku!,
                          style: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: TossColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      if (widget.item.stockQuantity != null)
                        _buildStockBadge(stockQuantity, isSelected),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Price Row with Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.currencySymbol}${_formatPrice(widget.item.unitPrice)}',
                        style: TossTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.primary,
                        ),
                      ),
                      if (widget.showQuantityStepper)
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

  Widget _buildProductImage() {
    final imageUrl = widget.item.productImage;
    const size = 44.0;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          memCacheWidth: (size * 2).toInt(),
          memCacheHeight: (size * 2).toInt(),
          placeholder: (context, url) => _buildPlaceholder(size),
          errorWidget: (context, url, error) => _buildFallback(size),
          fadeInDuration: const Duration(milliseconds: 150),
          fadeOutDuration: const Duration(milliseconds: 150),
        ),
      );
    }

    return _buildFallback(size);
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray300),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TossColors.gray200,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Icon(
        Icons.inventory_2,
        color: TossColors.gray400,
        size: size * 0.5,
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(price == price.truncateToDouble() ? 0 : 2);
  }

  Widget _buildStockBadge(int stockQuantity, bool isSelected) {
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
              if (widget.item.quantity > 1) {
                widget.onQuantityChanged?.call(widget.item.quantity - 1);
              } else {
                widget.onRemove?.call();
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
          // Quantity input - tap to open numberpad modal
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showQuantityModal(),
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
                  _formatQuantity(widget.item.quantity),
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
              widget.onQuantityChanged?.call(widget.item.quantity + 1);
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
        widget.onTap?.call();
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
