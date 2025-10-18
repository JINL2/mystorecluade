import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Safe version of TossCard that prevents memory leaks
/// 
/// This version:
/// - Uses StatelessWidget by default (no animations)
/// - Only creates animations when explicitly needed
/// - Perfect for lists and database operations
class TossCardSafe extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final bool enableAnimation;
  
  const TossCardSafe({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius = TossBorderRadius.lg,
    this.enableAnimation = false, // Disabled by default for safety
  });
  
  @override
  Widget build(BuildContext context) {
    // For database-critical operations, NEVER use animations
    if (!enableAnimation || onTap == null) {
      return _buildStaticCard();
    }
    
    // Only use animated version when explicitly enabled AND has onTap
    return _TossCardAnimated(
      onTap: onTap,
      padding: padding,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      child: child,
    );
  }
  
  Widget _buildStaticCard() {
    final card = Container(
      padding: padding ?? EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: TossShadows.card,
      ),
      child: child,
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }
    
    return card;
  }
  
  /// Factory constructor for list items (guaranteed no animation)
  factory TossCardSafe.listItem({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets? padding,
  }) {
    return TossCardSafe(
      key: key,
      child: child,
      onTap: onTap,
      padding: padding,
      enableAnimation: false, // Never animate in lists
    );
  }
  
  /// Factory constructor for forms (guaranteed no animation, preserves state)
  factory TossCardSafe.form({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
  }) {
    return TossCardSafe(
      key: key,
      child: child,
      padding: padding,
      backgroundColor: backgroundColor,
      enableAnimation: false, // Never animate forms
      onTap: null, // Forms shouldn't be tappable cards
    );
  }
}

/// Private animated version - only created when absolutely necessary
class _TossCardAnimated extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double borderRadius;
  
  const _TossCardAnimated({
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius = TossBorderRadius.lg,
  });
  
  @override
  State<_TossCardAnimated> createState() => _TossCardAnimatedState();
}

class _TossCardAnimatedState extends State<_TossCardAnimated> 
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    // Only create animation if we have onTap
    if (widget.onTap != null) {
      _controller = AnimationController(
        duration: TossAnimations.quick,
        vsync: this,
      );
      
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 0.98,
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: TossAnimations.standard,
      ));
    }
  }
  
  @override
  void dispose() {
    _controller?.dispose(); // Safe disposal
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: widget.padding ?? EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TossColors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: TossShadows.card,
      ),
      child: widget.child,
    );
    
    if (_controller != null && _scaleAnimation != null) {
      return GestureDetector(
        onTapDown: (_) => _controller!.forward(),
        onTapUp: (_) => _controller!.reverse(),
        onTapCancel: () => _controller!.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation!.value,
            child: card,
          ),
        ),
      );
    }
    
    // Fallback to simple InkWell if animation setup failed
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: card,
    );
  }
}