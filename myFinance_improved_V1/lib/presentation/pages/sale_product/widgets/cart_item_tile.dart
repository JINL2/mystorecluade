import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../widgets/common/enhanced_quantity_selector.dart';
import '../models/sale_product_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          // Product Image/Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getProductColor(item.name),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: item.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Image.asset(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            _getProductInitial(item.name),
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      _getProductInitial(item.name),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: TossSpacing.space4),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  formatter.format(item.price.round()),
                  style: TossTextStyles.amount.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced Quantity Controls
          EnhancedQuantitySelector(
            quantity: item.quantity,
            maxQuantity: item.available,
            compactMode: false,
            width: 160,
            onQuantityChanged: (newQuantity) {
              if (newQuantity <= 0) {
                onRemove();
              } else {
                onQuantityChanged(newQuantity);
              }
            },
            semanticLabel: 'Quantity for ${item.name}',
            decrementSemanticLabel: 'Decrease ${item.name} quantity',
            incrementSemanticLabel: 'Increase ${item.name} quantity',
          ),
        ],
      ),
    );
  }

  Color _getProductColor(String name) {
    final colors = [
      TossColors.primary,
      TossColors.primary,
      TossColors.warning,
      TossColors.success,
      TossColors.error,
      TossColors.success,
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