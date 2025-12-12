import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';

/// Product image widget with fallback support
///
/// Displays product image with caching, error handling and fallback icon.
/// Used in both product list and cart views.
///
/// Features:
/// - Memory caching (instant load for viewed images)
/// - Disk caching (faster reload on app restart)
/// - Placeholder during load
/// - Error fallback icon
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
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          memCacheWidth: (size * 2).toInt(),
          memCacheHeight: (size * 2).toInt(),
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildFallback(),
          fadeInDuration: const Duration(milliseconds: 150),
          fadeOutDuration: const Duration(milliseconds: 150),
        ),
      );
    }

    return _buildFallback();
  }

  Widget _buildPlaceholder() {
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
