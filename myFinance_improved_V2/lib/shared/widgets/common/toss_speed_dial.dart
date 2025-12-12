import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_shadows.dart';
import '../../themes/toss_text_styles.dart';

/// A speed dial action item
class TossSpeedDialAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TossSpeedDialAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

/// Toss Design System - Speed Dial FAB
///
/// An expandable floating action button that shows multiple actions
/// with a dark overlay when expanded. Uses Overlay for full-screen coverage.
///
/// Example:
/// ```dart
/// TossSpeedDial(
///   actions: [
///     TossSpeedDialAction(
///       icon: Icons.add,
///       label: 'Add New Product',
///       onPressed: () => navigateToAddProduct(),
///     ),
///     TossSpeedDialAction(
///       icon: Icons.download,
///       label: 'Record Stock In',
///       onPressed: () => navigateToStockIn(),
///     ),
///   ],
/// )
/// ```
class TossSpeedDial extends StatefulWidget {
  const TossSpeedDial({
    super.key,
    required this.actions,
    this.backgroundColor,
    this.iconColor,
    this.size = 52,
    this.iconSize = 24,
    this.overlayOpacity = 0.5,
    this.enableHapticFeedback = true,
  });

  /// List of actions to show when expanded
  final List<TossSpeedDialAction> actions;

  /// Background color of the main button
  /// Defaults to TossColors.primary
  final Color? backgroundColor;

  /// Icon color of the main button
  /// Defaults to TossColors.white
  final Color? iconColor;

  /// Size of the main button (width and height)
  /// Defaults to 52
  final double size;

  /// Size of the icon
  /// Defaults to 24
  final double iconSize;

  /// Opacity of the dark overlay (0.0 - 1.0)
  /// Defaults to 0.5
  final double overlayOpacity;

  /// Whether to trigger haptic feedback
  /// Defaults to true
  final bool enableHapticFeedback;

  @override
  State<TossSpeedDial> createState() => _TossSpeedDialState();
}

class _TossSpeedDialState extends State<TossSpeedDial>
    with SingleTickerProviderStateMixin {
  final GlobalKey _fabKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    setState(() => _isOpen = true);
    _showOverlay();
    _controller.forward();
  }

  void _close() {
    _controller.reverse().then((_) {
      _removeOverlay();
      if (mounted) {
        setState(() => _isOpen = false);
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox? renderBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fabPosition = renderBox.localToGlobal(Offset.zero);
    final fabSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SpeedDialOverlay(
        fabPosition: fabPosition,
        fabSize: fabSize,
        actions: widget.actions,
        animation: _fadeAnimation,
        overlayOpacity: widget.overlayOpacity,
        onClose: _close,
        onActionTap: _handleActionTap,
        mainButtonSize: widget.size,
        mainButtonIconSize: widget.iconSize,
        mainButtonBackgroundColor: widget.backgroundColor ?? TossColors.primary,
        mainButtonIconColor: widget.iconColor ?? TossColors.white,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _handleActionTap(TossSpeedDialAction action) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    _close();
    // Delay action to allow close animation
    Future.delayed(const Duration(milliseconds: 100), action.onPressed);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        widget.backgroundColor ?? TossColors.primary;
    final effectiveIconColor = widget.iconColor ?? TossColors.white;

    return GestureDetector(
      key: _fabKey,
      onTap: _toggle,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: effectiveBackgroundColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            ...TossShadows.elevation1,
          ],
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                // Rotate 225 degrees (180 + 45 = pi + pi/4 radians) to transform + into X
                angle: _controller.value * 3.926991, // 225 degrees in radians
                child: child,
              );
            },
            child: Icon(
              Icons.add,
              size: widget.iconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Overlay widget for the speed dial
class _SpeedDialOverlay extends StatelessWidget {
  final Offset fabPosition;
  final Size fabSize;
  final List<TossSpeedDialAction> actions;
  final Animation<double> animation;
  final double overlayOpacity;
  final VoidCallback onClose;
  final void Function(TossSpeedDialAction) onActionTap;
  final double mainButtonSize;
  final double mainButtonIconSize;
  final Color mainButtonBackgroundColor;
  final Color mainButtonIconColor;

  const _SpeedDialOverlay({
    required this.fabPosition,
    required this.fabSize,
    required this.actions,
    required this.animation,
    required this.overlayOpacity,
    required this.onClose,
    required this.onActionTap,
    required this.mainButtonSize,
    required this.mainButtonIconSize,
    required this.mainButtonBackgroundColor,
    required this.mainButtonIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: Stack(
        children: [
          // Dark overlay
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return GestureDetector(
                onTap: onClose,
                child: Container(
                  color: Colors.black
                      .withValues(alpha: animation.value * overlayOpacity),
                ),
              );
            },
          ),

          // Action items positioned above the FAB
          ...List.generate(actions.length, (index) {
            final action = actions[index];
            // First item in list appears at the top
            final positionIndex = index;

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                // Stagger the animation for each item
                final staggerDelay = positionIndex * 0.08;
                final adjustedValue =
                    ((animation.value - staggerDelay) / (1.0 - staggerDelay))
                        .clamp(0.0, 1.0);
                final scaleValue = Curves.easeOutBack.transform(adjustedValue);
                // Clamp opacity to valid range (easeOutBack can overshoot)
                final opacityValue = adjustedValue.clamp(0.0, 1.0);

                // Calculate vertical offset from FAB
                // Items stack upward from FAB position
                final verticalOffset = (actions.length - index) * 62.0;

                return Positioned(
                  bottom: MediaQuery.of(context).size.height -
                      fabPosition.dy +
                      verticalOffset -
                      fabSize.height +
                      8,
                  right: MediaQuery.of(context).size.width -
                      fabPosition.dx -
                      fabSize.width,
                  child: Transform.scale(
                    scale: scaleValue.clamp(0.0, 1.5),
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: opacityValue,
                      child: child,
                    ),
                  ),
                );
              },
              child: _buildActionItem(action),
            );
          }),

          // Main FAB button with rotated + icon (rendered on top of overlay)
          Positioned(
            bottom: MediaQuery.of(context).size.height -
                fabPosition.dy -
                fabSize.height,
            right: MediaQuery.of(context).size.width -
                fabPosition.dx -
                fabSize.width,
            child: GestureDetector(
              onTap: onClose,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.rotate(
                    // Rotate 225 degrees (180 + 45 = pi + pi/4 radians) to transform + into X
                    angle: animation.value * 3.926991, // 225 degrees in radians
                    child: child,
                  );
                },
                child: Container(
                  width: mainButtonSize,
                  height: mainButtonSize,
                  decoration: BoxDecoration(
                    color: mainButtonBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: mainButtonBackgroundColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                      ...TossShadows.elevation1,
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: mainButtonIconSize,
                      color: mainButtonIconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(TossSpeedDialAction action) {
    return GestureDetector(
      onTap: () => onActionTap(action),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          boxShadow: TossShadows.elevation1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              action.icon,
              size: 18,
              color: TossColors.gray700,
            ),
            const SizedBox(width: 8),
            Text(
              action.label,
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
