import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/cached_product_image.dart';
import '../../providers/states/session_detail_state.dart';

/// Search result card - inventory management style
class SearchResultCard extends StatelessWidget {
  final SearchProductResult product;
  final bool isSelected;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? TossColors.primary.withValues(alpha: 0.05)
            : TossColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Product Image
            _buildProductImage(),
            const SizedBox(width: TossSpacing.space3),

            // Product Info
            Expanded(child: _buildProductInfo()),

            // Selection indicator
            _buildSelectionIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return CachedProductImage(
      imageUrl: product.imageUrl,
      size: 56,
      borderRadius: 8,
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          style: TossTextStyles.bodyMedium.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        if (product.sku != null)
          Text(
            product.sku!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
            ),
          ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    if (isSelected) {
      return const Icon(
        Icons.check_circle,
        color: TossColors.primary,
        size: 24,
      );
    }
    return const Icon(
      Icons.add_circle_outline,
      color: TossColors.textTertiary,
      size: 24,
    );
  }
}
