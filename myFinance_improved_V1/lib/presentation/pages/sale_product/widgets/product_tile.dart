import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../inventory_management/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: quantity > 0 ? TossColors.primary : TossColors.gray100,
          width: quantity > 0 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Product Icon/Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getProductColor(product.name),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                _getProductInitial(product.name),
                style: TossTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product.sku,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.available}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.warning,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Customer ordered: 0',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatter.format(product.salePrice.round())}',
                  style: TossTextStyles.amount.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          if (quantity > 0) ...[
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.remove_circle_outline,
                color: TossColors.primary,
                size: 28,
              ),
            ),
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$quantity',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: Icon(
                Icons.add_circle_outline,
                color: TossColors.primary,
                size: 28,
              ),
            ),
          ] else
            IconButton(
              onPressed: onAdd,
              icon: Icon(
                Icons.add_circle_outline,
                color: TossColors.primary,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }

  Color _getProductColor(String name) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];
    
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  String _getProductInitial(String name) {
    if (name.isEmpty) return '?';
    
    // Check if it starts with a number
    if (RegExp(r'^\d').hasMatch(name)) {
      return '1';
    }
    
    // Return first character
    return name[0].toUpperCase();
  }
}