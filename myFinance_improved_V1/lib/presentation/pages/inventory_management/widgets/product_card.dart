import 'package:flutter/material.dart';
import '../../../../core/themes/index.dart';
import '../models/product_model.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductCard({
    Key? key,
    required this.product,
    this.isSelected = false,
    this.isSelectionMode = false,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: isSelected ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            side: isSelected
                ? BorderSide(color: TossColors.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: TossSpacing.space24 + TossSpacing.space6,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: product.images.isNotEmpty
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.images.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPlaceholder(),
                                ),
                              )
                            : _buildPlaceholder(),
                      ),
                      // Stock Status Badge
                      Positioned(
                        top: TossSpacing.space2,
                        right: TossSpacing.space2,
                        child: _buildStockBadge(),
                      ),
                    ],
                  ),
                ),
                
                // Product Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(TossSpacing.paddingSM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              product.sku,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatCurrency(product.salePrice),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${product.onHand} units',
                                  style: TossTextStyles.body.copyWith(
                                    color: _getStockColor(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (product.location != null)
                                  Text(
                                    product.location!,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray600,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
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
        
        // Selection Checkbox
        if (isSelectionMode)
          Positioned(
            top: TossSpacing.space2,
            left: TossSpacing.space2,
            child: Container(
              decoration: BoxDecoration(
                color: TossColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                shape: const CircleBorder(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray500[200],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Icon(
        Icons.inventory_2,
        size: TossSpacing.iconLG + TossSpacing.space4,
        color: TossColors.gray400,
      ),
    );
  }

  Widget _buildStockBadge() {
    final status = product.stockStatus;
    Color color;
    String text;
    
    switch (status) {
      case StockStatus.critical:
        color = TossColors.error;
        text = 'Critical';
        break;
      case StockStatus.low:
        color = TossColors.warning;
        text = 'Low';
        break;
      case StockStatus.optimal:
        color = TossColors.success;
        text = 'OK';
        break;
      case StockStatus.excess:
        color = TossColors.primary;
        text = 'Excess';
        break;
    }
    
    if (product.onHand == 0) {
      color = TossColors.error;
      text = 'Out';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Text(
        text,
        style: TossTextStyles.body.copyWith(
          color: TossColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _getStockColor() {
    switch (product.stockStatus) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.optimal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.primary;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₩${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₩${(value / 1000).toStringAsFixed(0)}K';
    }
    return '₩${value.toStringAsFixed(0)}';
  }
}

class ProductListTile extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductListTile({
    Key? key,
    required this.product,
    this.isSelected = false,
    this.isSelectionMode = false,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        side: isSelected
            ? BorderSide(color: TossColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: isSelectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
              )
            : Container(
                width: TossSpacing.iconXL + TossSpacing.space5,
                height: TossSpacing.iconXL + TossSpacing.space5,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: product.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        child: Image.network(
                          product.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.inventory_2, color: TossColors.gray400),
                        ),
                      )
                    : Icon(Icons.inventory_2, color: TossColors.gray400),
              ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${product.sku}'),
            Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  size: TossSpacing.iconXS,
                  color: _getStockColor(),
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  '${product.onHand} units',
                  style: TossTextStyles.body.copyWith(
                    color: _getStockColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (product.location != null) ...[
                  const SizedBox(width: TossSpacing.space2),
                  Icon(Icons.location_on, size: TossSpacing.iconXS, color: TossColors.gray600),
                  const SizedBox(width: TossSpacing.space0 + 2),
                  Text(
                    product.location!,
                    style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatCurrency(product.salePrice),
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              'Value: ${_formatCurrency(product.inventoryValue)}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStockColor() {
    if (product.onHand == 0) return TossColors.error;
    switch (product.stockStatus) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.optimal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.primary;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₩${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₩${(value / 1000).toStringAsFixed(0)}K';
    }
    return '₩${value.toStringAsFixed(0)}';
  }
}