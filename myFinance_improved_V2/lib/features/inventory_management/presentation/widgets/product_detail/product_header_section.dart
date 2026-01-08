import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/widgets/atoms/display/cached_product_image.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../domain/entities/product.dart';

/// Product header section with image and basic info
/// Optimized with entrance animations and micro-interactions
class ProductHeaderSection extends StatefulWidget {
  final Product product;
  final int animationDelay;

  const ProductHeaderSection({
    super.key,
    required this.product,
    this.animationDelay = 0,
  });

  @override
  State<ProductHeaderSection> createState() => _ProductHeaderSectionState();
}

class _ProductHeaderSectionState extends State<ProductHeaderSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    // Start animation with delay
    Future.delayed(
      Duration(milliseconds: widget.animationDelay),
      () {
        if (mounted) _controller.forward();
      },
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
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          TossSpacing.space4,
          TossSpacing.space6,
          TossSpacing.space4,
          TossSpacing.space5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with hero animation potential
            _buildProductImage(),
            const SizedBox(width: TossSpacing.space4),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SKU with copy button
                  _buildSkuRow(context),
                  const SizedBox(height: TossSpacing.space1_5),
                  // Product name
                  Text(
                    widget.product.name,
                    style: TossTextStyles.subtitle.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  // Quantity badge with pulse animation
                  _QuantityBadge(quantity: widget.product.onHand),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'product_image_${widget.product.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        child: widget.product.images.isEmpty
            ? Container(
                width: TossDimensions.productImageLarge,
                height: TossDimensions.productImageLarge,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: TossSpacing.iconMD2,
                  color: TossColors.gray500,
                ),
              )
            : CachedProductImage(
                imageUrl: widget.product.images.first,
                width: TossDimensions.productImageLarge,
                height: TossDimensions.productImageLarge,
                borderRadius: TossBorderRadius.xxxl,
              ),
      ),
    );
  }

  Widget _buildSkuRow(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            widget.product.sku,
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.medium,
              color: TossColors.gray600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: TossSpacing.space1_5),
        _CopyButton(
          text: widget.product.sku,
          onCopied: () {
            TossToast.success(context, 'SKU copied to clipboard');
          },
        ),
      ],
    );
  }
}

/// Animated copy button with tap feedback
class _CopyButton extends StatefulWidget {
  final String text;
  final VoidCallback onCopied;

  const _CopyButton({
    required this.text,
    required this.onCopied,
  });

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showCheck = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    HapticFeedback.lightImpact();
    await _controller.forward();
    await _controller.reverse();

    Clipboard.setData(ClipboardData(text: widget.text));

    setState(() => _showCheck = true);
    widget.onCopied();

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _showCheck = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedSwitcher(
            duration: TossAnimations.fast,
            child: Icon(
              _showCheck ? Icons.check : Icons.copy_outlined,
              key: ValueKey(_showCheck),
              size: TossSpacing.iconSM,
              color: _showCheck ? TossColors.success : TossColors.gray500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Quantity badge with subtle entrance animation
class _QuantityBadge extends StatefulWidget {
  final int quantity;

  const _QuantityBadge({required this.quantity});

  @override
  State<_QuantityBadge> createState() => _QuantityBadgeState();
}

class _QuantityBadgeState extends State<_QuantityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    // Delayed start for stagger effect
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: _scaleAnimation.value,
          child: child,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: TossSpacing.iconLG2,
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.quantity}',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: TossFontWeight.semibold,
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
      ),
    );
  }
}
