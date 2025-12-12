import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';

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
      child: const Center(
        child: Icon(
          Icons.inventory_2_outlined,
          color: TossColors.gray400,
          size: 24,
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
      placeholder: _ShimmerPlaceholder(
        width: width ?? size,
        height: height ?? size,
        borderRadius: borderRadius,
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerPlaceholder({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                TossColors.gray100,
                TossColors.gray200,
                TossColors.gray100,
              ],
            ),
          ),
        );
      },
    );
  }
}
