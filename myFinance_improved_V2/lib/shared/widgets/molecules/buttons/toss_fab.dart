import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Action item for TossFAB expandable mode
class TossFABAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const TossFABAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

/// Toss-style Floating Action Button
class TossFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final List<TossFABAction>? actions;
  final double overlayOpacity;
  final bool enableHapticFeedback;

  const TossFAB({
    super.key,
    this.icon = Icons.add,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 52,
    this.iconSize = 24,
    this.actions,
    this.overlayOpacity = 0.5,
    this.enableHapticFeedback = true,
  });

  /// Creates an expandable FAB with multiple actions
  factory TossFAB.expandable({
    Key? key,
    required List<TossFABAction> actions,
    Color? backgroundColor,
    Color? iconColor,
    double size = 52,
    double iconSize = 24,
    double overlayOpacity = 0.5,
    bool enableHapticFeedback = true,
  }) {
    return TossFAB(
      key: key,
      actions: actions,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      size: size,
      iconSize: iconSize,
      overlayOpacity: overlayOpacity,
      enableHapticFeedback: enableHapticFeedback,
    );
  }

  @override
  State<TossFAB> createState() => _TossFABState();
}

class _TossFABState extends State<TossFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? TossColors.primary;
    final fgColor = widget.iconColor ?? TossColors.white;

    // Simple FAB without actions
    if (widget.actions == null || widget.actions!.isEmpty) {
      return FloatingActionButton(
        heroTag: 'toss_fab_simple_${widget.hashCode}',
        onPressed: widget.onPressed,
        backgroundColor: bgColor,
        child: Icon(widget.icon, color: fgColor, size: widget.iconSize),
      );
    }

    // Expandable FAB with actions
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Invisible touch area to close menu (no overlay color)
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        // Action buttons
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...widget.actions!.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return AnimatedOpacity(
                opacity: _isExpanded ? 1.0 : 0.0,
                duration: TossAnimations.quick + Duration(milliseconds: index * 50),
                child: AnimatedSlide(
                  offset: _isExpanded ? Offset.zero : const Offset(0, 0.5),
                  duration: TossAnimations.quick + Duration(milliseconds: index * 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.white,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.shadow, // 4% black
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            action.label,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton.small(
                          heroTag: 'fab_action_$index',
                          onPressed: () {
                            _toggle();
                            action.onPressed();
                          },
                          backgroundColor: bgColor,
                          child: Icon(action.icon, color: fgColor, size: TossSpacing.iconSM),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            // Main FAB
            FloatingActionButton(
              heroTag: 'toss_fab_main_${widget.hashCode}',
              onPressed: _toggle,
              backgroundColor: bgColor,
              child: AnimatedRotation(
                turns: _isExpanded ? 0.125 : 0,
                duration: TossAnimations.normal,
                child: Icon(Icons.add, color: fgColor, size: widget.iconSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
