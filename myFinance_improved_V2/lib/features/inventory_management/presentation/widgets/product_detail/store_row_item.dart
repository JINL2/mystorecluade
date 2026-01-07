import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../move_stock_dialog.dart';

/// Individual store row item for the locations section
/// Optimized with entrance animation and tap feedback
class StoreRowItem extends StatefulWidget {
  final StoreLocation store;
  final VoidCallback onTap;
  final int animationDelay;

  const StoreRowItem({
    super.key,
    required this.store,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  State<StoreRowItem> createState() => _StoreRowItemState();
}

class _StoreRowItemState extends State<StoreRowItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.enter),
    );

    // Start animation with staggered delay
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

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.selectionClick();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: child,
        ),
      ),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: TossAnimations.quick,
          curve: TossAnimations.standard,
          constraints: const BoxConstraints(minHeight: TossDimensions.minRowHeight),
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: _isPressed ? TossColors.gray50 : TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - store icon and name
              Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: TossAnimations.quick,
                      transform: Matrix4.identity()
                        ..scale(_isPressed ? 0.95 : 1.0),
                      transformAlignment: Alignment.center,
                      child: const Icon(
                        Icons.store_outlined,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    // Store name with "This store" badge
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.store.name,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: TossFontWeight.medium,
                                color: TossColors.gray900,
                              ),
                            ),
                            if (widget.store.isCurrentStore)
                              TextSpan(
                                text: ' · This store',
                                style: TossTextStyles.bodySmall.copyWith(
                                  fontWeight: TossFontWeight.regular,
                                  color: TossColors.gray600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side - stock badge and chevron
              Row(
                children: [
                  _StockBadge(stock: widget.store.stock),
                  const SizedBox(width: TossSpacing.space2),
                  AnimatedContainer(
                    duration: TossAnimations.quick,
                    transform: Matrix4.identity()
                      ..translate(_isPressed ? 2.0 : 0.0, 0.0),
                    child: const Icon(
                      Icons.chevron_right,
                      size: TossSpacing.iconSM,
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated stock badge with color transition
class _StockBadge extends StatelessWidget {
  final int stock;

  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final hasStock = stock > 0;

    return AnimatedContainer(
      duration: TossAnimations.fast,
      curve: TossAnimations.standard,
      height: TossSpacing.iconLG,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2_5),
      decoration: BoxDecoration(
        color: hasStock ? TossColors.primarySurface : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        '$stock',
        style: TossTextStyles.body.copyWith(
          fontWeight: TossFontWeight.semibold,
          color: hasStock ? TossColors.primary : TossColors.gray400,
        ),
      ),
    );
  }
}
