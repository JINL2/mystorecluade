import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_list_tile.dart';
import '../../../domain/entities/cart_item.dart';
import '../common/product_image_widget.dart';

/// Cart item tile widget
///
/// Displays individual cart item with quantity controls.
/// Allows users to increase/decrease quantity or remove item.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final String currencySymbol;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    this.currencySymbol = '₩',
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return TossListTile(
      leading: ProductImageWidget(
        imageUrl: item.image,
        size: 48,
        fallbackIcon: Icons.inventory_2,
      ),
      title: item.name,
      subtitle: '$currencySymbol${formatter.format(item.price.round())} × ${item.quantity}',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => onQuantityChanged(item.quantity - 1),
          ),
          Text(
            '${item.quantity}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: item.quantity < item.available
                ? () => onQuantityChanged(item.quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
