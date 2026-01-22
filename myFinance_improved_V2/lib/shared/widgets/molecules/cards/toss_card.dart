import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/layout/sb_card_container.dart';

/// Toss-style card with micro-interactions
///
/// Uses [SBCardContainer] as the base container atom.
class TossCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final bool showBorder;

  const TossCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius = TossBorderRadius.lg,
    this.showBorder = true,
  });

  @override
  State<TossCard> createState() => _TossCardState();
}

class _TossCardState extends State<TossCard>
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

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TossAnimations.standard,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: SBCardContainer(
            padding: widget.padding ?? const EdgeInsets.all(TossSpacing.space5),
            backgroundColor: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            borderColor: widget.showBorder ? null : Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}