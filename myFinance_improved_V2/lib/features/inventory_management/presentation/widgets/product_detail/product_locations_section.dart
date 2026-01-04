import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../domain/entities/product.dart';
import '../move_stock_dialog.dart';
import 'store_row_item.dart';

/// Locations section showing store list with stock information
/// Optimized with entrance animations and animated toggle
class ProductLocationsSection extends StatefulWidget {
  final Product product;
  final List<StoreLocation> stores;
  final bool hasStockFilter;
  final bool isLoading;
  final int animationDelay;
  final ValueChanged<bool> onFilterChanged;
  final void Function(StoreLocation store) onStoreTap;

  const ProductLocationsSection({
    super.key,
    required this.product,
    required this.stores,
    required this.hasStockFilter,
    required this.isLoading,
    required this.onFilterChanged,
    required this.onStoreTap,
    this.animationDelay = 200,
  });

  @override
  State<ProductLocationsSection> createState() =>
      _ProductLocationsSectionState();
}

class _ProductLocationsSectionState extends State<ProductLocationsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: TossAnimations.enter),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: TossAnimations.enter),
    );

    // Start header animation
    Future.delayed(
      Duration(milliseconds: widget.animationDelay),
      () {
        if (mounted) _headerController.forward();
      },
    );
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter stores based on toggle
    final filteredStores = widget.hasStockFilter
        ? widget.stores.where((s) => s.stock > 0).toList()
        : widget.stores;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            children: [
              // Section header - "Move Stock" with toggle
              _buildAnimatedSectionHeader(),
              // Loading indicator or store rows
              if (widget.isLoading)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  child: Center(
                    child: TossLoadingView.inline(size: 24),
                  ),
                )
              else
                ...filteredStores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final store = entry.value;
                  // Staggered delay: header delay + 50ms per item
                  final itemDelay =
                      widget.animationDelay + 100 + (index * 40);
                  return StoreRowItem(
                    store: store,
                    onTap: () => widget.onStoreTap(store),
                    animationDelay: itemDelay,
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildAnimatedSectionHeader() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) => FadeTransition(
        opacity: _headerFadeAnimation,
        child: SlideTransition(
          position: _headerSlideAnimation,
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: TossSpacing.space6,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Move Stock',
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
            ),
            // Has stock toggle
            Row(
              children: [
                Text(
                  'Has stock',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                _AnimatedToggle(
                  isOn: widget.hasStockFilter,
                  onChanged: widget.onFilterChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated toggle switch with smooth transition
class _AnimatedToggle extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const _AnimatedToggle({
    required this.isOn,
    required this.onChanged,
  });

  @override
  State<_AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<_AnimatedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: TossAnimations.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onChanged(!widget.isOn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: TossAnimations.fast,
          curve: TossAnimations.standard,
          width: 34,
          height: 20,
          decoration: BoxDecoration(
            color: widget.isOn ? TossColors.primary : TossColors.gray200,
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.all(2),
          child: AnimatedAlign(
            duration: TossAnimations.fast,
            curve: TossAnimations.standard,
            alignment:
                widget.isOn ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: TossColors.white,
                shape: BoxShape.circle,
                boxShadow: _isPressed
                    ? null
                    : [
                        BoxShadow(
                          color: TossColors.gray900.withValues(alpha: 0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
