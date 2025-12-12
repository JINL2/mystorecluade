import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/cached_product_image.dart';
import '../../providers/states/session_detail_state.dart';
import 'quantity_controls.dart';

/// Session item card widget - inventory management style with dual quantity inputs
class SessionItemCard extends StatelessWidget {
  final SelectedProduct item;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onQuantityRejectedChanged;
  final VoidCallback onDelete;

  const SessionItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onQuantityRejectedChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Top Row: Image, Product Info, Delete Button
          _buildTopRow(),
          const SizedBox(height: TossSpacing.space3),
          // Bottom Row: Quantity Controls
          _buildQuantityControls(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        _buildProductImage(),
        const SizedBox(width: TossSpacing.space3),

        // Product Info
        Expanded(child: _buildProductInfo()),

        // Delete Button
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildProductImage() {
    return CachedProductImage(
      imageUrl: item.imageUrl,
      size: 56,
      borderRadius: 8,
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.productName,
          style: TossTextStyles.bodyMedium.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        if (item.sku != null)
          Text(
            item.sku!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: onDelete,
      icon: const Icon(
        Icons.close,
        color: TossColors.textTertiary,
        size: 20,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        // Good Quantity
        Expanded(
          child: QuantityRow(
            label: 'Good',
            quantity: item.quantity,
            color: TossColors.primary,
            onDecrement: item.quantity > 0
                ? () => onQuantityChanged(item.quantity - 1)
                : null,
            onIncrement: () => onQuantityChanged(item.quantity + 1),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        // Rejected Quantity
        Expanded(
          child: QuantityRow(
            label: 'Rejected',
            quantity: item.quantityRejected,
            color: TossColors.error,
            onDecrement: item.quantityRejected > 0
                ? () => onQuantityRejectedChanged(item.quantityRejected - 1)
                : null,
            onIncrement: () =>
                onQuantityRejectedChanged(item.quantityRejected + 1),
          ),
        ),
      ],
    );
  }
}
