import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../domain/entities/product.dart';

/// Product header section with image and basic info
class ProductHeaderSection extends StatelessWidget {
  final Product product;

  const ProductHeaderSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space6,
        TossSpacing.space4,
        TossSpacing.space5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          _buildProductImage(),
          const SizedBox(width: TossSpacing.space4),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SKU with copy button
                _buildSkuRow(context),
                const SizedBox(height: 6),
                // Product name
                Text(
                  product.name,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                // Quantity badge
                _buildQuantityBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.images.isEmpty) {
      return Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 26,
          color: TossColors.gray500,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
      child: Image.network(
        product.images.first,
        width: 128,
        height: 128,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 26,
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildSkuRow(BuildContext context) {
    return Row(
      children: [
        Text(
          product.sku,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: product.sku));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SKU copied to clipboard'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Icon(
            Icons.copy_outlined,
            size: 18,
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityBadge() {
    return Row(
      children: [
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: TossColors.primary,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          alignment: Alignment.center,
          child: Text(
            '${product.onHand}',
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.white,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'On-hand qty',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }
}
