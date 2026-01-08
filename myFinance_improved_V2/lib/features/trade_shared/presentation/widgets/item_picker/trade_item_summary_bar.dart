import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/trade_item.dart';

/// Summary bar showing selected items and total
class TradeItemSummaryBar extends StatefulWidget {
  final List<TradeItem> items;
  final String currencySymbol;
  final VoidCallback onConfirm;
  final String confirmButtonText;

  const TradeItemSummaryBar({
    super.key,
    required this.items,
    required this.currencySymbol,
    required this.onConfirm,
    this.confirmButtonText = 'Confirm Selection',
  });

  @override
  State<TradeItemSummaryBar> createState() => _TradeItemSummaryBarState();
}

class _TradeItemSummaryBarState extends State<TradeItemSummaryBar> {
  bool _isExpanded = false;

  double get _totalAmount => widget.items.fold(0.0, (sum, item) => sum + item.totalAmount);
  int get _itemCount => widget.items.length;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(TossBorderRadius.lg)),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expandable items list
            if (_isExpanded) _buildExpandedList(),
            // Summary row
            _buildSummaryRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Expand/collapse button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: TossColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Item count and total
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_itemCount item${_itemCount > 1 ? 's' : ''} selected',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                Text(
                  '${widget.currencySymbol}${_formatPrice(_totalAmount)}',
                  style: TossTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Confirm button - wrapped in a container with fixed constraints
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onConfirm();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Text(
                widget.confirmButtonText,
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedList() {
    final maxHeight = MediaQuery.of(context).size.height * 0.35;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        itemCount: widget.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: TossColors.gray100),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return _buildItemRow(item);
        },
      ),
    );
  }

  Widget _buildItemRow(TradeItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          // Product image
          _buildProductImage(item.productImage),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_formatQuantity(item.quantity)} x ${widget.currencySymbol}${_formatPrice(item.unitPrice)}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Subtotal
          Text(
            '${widget.currencySymbol}${_formatPrice(item.totalAmount)}',
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    const size = 32.0;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(size),
          errorWidget: (context, url, error) => _buildFallback(size),
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
      return '${(price / 1000000).toStringAsFixed(2)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    }
    return price.toStringAsFixed(price == price.truncateToDouble() ? 0 : 2);
  }

  String _formatQuantity(double qty) {
    return qty == qty.truncateToDouble() ? qty.toInt().toString() : qty.toStringAsFixed(2);
  }
}
