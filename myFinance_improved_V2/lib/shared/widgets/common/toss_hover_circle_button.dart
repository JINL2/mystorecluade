import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/toss_colors.dart';
import '../../themes/toss_shadows.dart';

/// Toss Design System - Hover Circle Button (FAB-style)
///
/// A circular floating action button with hover/press animation.
/// Commonly used for primary actions like "Add" buttons.
///
/// Example:
/// ```dart
/// TossHoverCircleButton(
///   icon: Icons.add,
///   onPressed: () => navigateToAddPage(),
/// )
/// ```
class TossHoverCircleButton extends StatefulWidget {
  const TossHoverCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 52,
    this.iconSize = 24,
    this.elevation = 10,
    this.tooltip,
    this.enableHapticFeedback = true,
  });

  /// The icon to display
  final IconData icon;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Background color of the button
  /// Defaults to TossColors.primary
  final Color? backgroundColor;

  /// Icon color
  /// Defaults to TossColors.white
  final Color? iconColor;

  /// Size of the button (width and height)
  /// Defaults to 52
  final double size;

  /// Size of the icon
  /// Defaults to 24
  final double iconSize;

  /// Elevation/shadow blur radius
  /// Defaults to 10
  final double elevation;

  /// Tooltip text for accessibility
  final String? tooltip;

  /// Whether to trigger haptic feedback on press
  /// Defaults to true
  final bool enableHapticFeedback;

  /// Factory constructor for add button (most common use case)
  factory TossHoverCircleButton.add({
    Key? key,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double size = 52,
    String? tooltip,
  }) {
    return TossHoverCircleButton(
      key: key,
      icon: Icons.add,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      tooltip: tooltip ?? 'Add',
    );
  }

  /// Factory constructor for edit button
  factory TossHoverCircleButton.edit({
    Key? key,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double size = 52,
    String? tooltip,
  }) {
    return TossHoverCircleButton(
      key: key,
      icon: Icons.edit,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      tooltip: tooltip ?? 'Edit',
    );
  }

  /// Factory constructor for chat/message button
  factory TossHoverCircleButton.chat({
    Key? key,
    required VoidCallback onPressed,
    Color? backgroundColor,
    double size = 52,
    String? tooltip,
  }) {
    return TossHoverCircleButton(
      key: key,
      icon: Icons.chat_bubble_outline,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      size: size,
      tooltip: tooltip ?? 'Chat',
    );
  }

  @override
  State<TossHoverCircleButton> createState() => _TossHoverCircleButtonState();
}

class _TossHoverCircleButtonState extends State<TossHoverCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.backgroundColor ?? TossColors.primary;
    final effectiveIconColor = widget.iconColor ?? TossColors.white;

    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: effectiveBackgroundColor.withValues(alpha: 0.3),
                blurRadius: widget.elevation,
                offset: const Offset(0, 4),
              ),
              ...TossShadows.elevation1,
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
