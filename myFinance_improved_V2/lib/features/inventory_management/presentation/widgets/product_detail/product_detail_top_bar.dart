import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/product.dart';
import '../../pages/product_transactions_page.dart';

/// Top navigation bar for product detail page
/// Optimized with TossAnimations for smooth micro-interactions
class ProductDetailTopBar extends StatelessWidget {
  final Product product;
  final VoidCallback onMoreOptions;

  const ProductDetailTopBar({
    super.key,
    required this.product,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          // Back button with tap animation
          _AnimatedIconButton(
            icon: Icons.arrow_back,
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).maybePop();
            },
          ),
          const SizedBox(width: TossSpacing.space2),
          // SKU title - expandable
          Expanded(
            child: Text(
              product.sku,
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Action buttons with animations
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedIconButton(
                icon: Icons.edit_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/inventoryManagement/editProduct/${product.id}');
                },
              ),
              _AnimatedIconButton(
                icon: Icons.history,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => ProductTransactionsPage(product: product),
                    ),
                  );
                },
              ),
              _AnimatedIconButton(
                icon: Icons.more_vert,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onMoreOptions();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Animated icon button with scale effect on tap
class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _AnimatedIconButton({
    required this.icon,
    required this.onTap,
    this.size = 22,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: widget.size,
              color: TossColors.gray900,
            ),
          ),
        ),
      ),
    );
  }
}
