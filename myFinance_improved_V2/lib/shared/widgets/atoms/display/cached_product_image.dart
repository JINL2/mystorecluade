import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_skeleton.dart';

/// Cached Product Image
///
/// High-performance reusable widget for displaying product images with:
/// - Memory caching (instant load for viewed images)
/// - Disk caching (faster reload on app restart)
/// - Placeholder during load
/// - Error fallback icon
/// - Optional shimmer effect
class CachedProductImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const CachedProductImage({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.width,
    this.height,
    this.borderRadius = TossBorderRadius.md,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? size;
    final effectiveHeight = height ?? size;

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.gray100,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                width: effectiveWidth,
                height: effectiveHeight,
                memCacheWidth: (effectiveWidth * 2).toInt(),
                memCacheHeight: (effectiveHeight * 2).toInt(),
                placeholder: (context, url) =>
                    placeholder ?? _buildDefaultPlaceholder(),
                errorWidget: (context, url, error) =>
                    errorWidget ?? _buildDefaultError(),
                fadeInDuration: const Duration(milliseconds: 150),
                fadeOutDuration: const Duration(milliseconds: 150),
              )
            : errorWidget ?? _buildDefaultError(),
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      color: TossColors.gray100,
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

  Widget _buildDefaultError() {
    return Container(
      color: TossColors.gray100,
      child: Center(
        child: Icon(
          Icons.inventory_2_outlined,
          color: TossColors.gray400,
          size: TossSpacing.iconMD,
        ),
      ),
    );
  }
}

/// Product Image with shimmer loading effect
class CachedProductImageWithShimmer extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const CachedProductImageWithShimmer({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.width,
    this.height,
    this.borderRadius = TossBorderRadius.md,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedProductImage(
      imageUrl: imageUrl,
      size: size,
      width: width,
      height: height,
      borderRadius: borderRadius,
      fit: fit,
      placeholder: TossSkeleton(
        width: width ?? size,
        height: height ?? size,
        borderRadius: borderRadius,
      ),
    );
  }
}
