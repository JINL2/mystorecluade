import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';

/// Product image widget with fallback support
///
/// Displays product image with error handling and fallback icon.
/// Used in both product list and cart views.
class ProductImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final IconData fallbackIcon;

  const ProductImageWidget({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.fallbackIcon = Icons.inventory_2,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        ),
      );
    }

    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TossColors.gray200,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Icon(
        fallbackIcon,
        color: TossColors.gray400,
        size: size * 0.5,
      ),
    );
  }
}
