import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Toss-style list tile with smooth animations and clean design
class TossListTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final bool showDivider;
  final bool animateOnTap;
  
  const TossListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.backgroundColor,
    this.contentPadding,
    this.showDivider = true,
    this.animateOnTap = true,
  });
  
  @override
  State<TossListTile> createState() => _TossListTileState();
}

class _TossListTileState extends State<TossListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TossAnimations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TossAnimations.standard,
    ));
    
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? TossColors.transparent,
      end: TossColors.gray50,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TossAnimations.standard,
    ));
  }
  
  void _handleTapDown(TapDownDetails details) {
    if (widget.animateOnTap && widget.enabled) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    if (widget.animateOnTap && widget.enabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }
  
  void _handleTapCancel() {
    if (widget.animateOnTap && widget.enabled) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: isDisabled ? null : widget.onTap,
      onLongPress: isDisabled ? null : widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.selected
                    ? TossColors.primary.withValues(alpha: 0.08)
                    : _colorAnimation.value,
                border: widget.showDivider
                    ? Border(
                        bottom: BorderSide(
                          color: TossColors.border,
                          width: 0.5,
                        ),
                      )
                    : null,
              ),
              child: Padding(
                padding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      AnimatedOpacity(
                        opacity: isDisabled ? 0.5 : 1.0,
                        duration: TossAnimations.normal,
                        child: widget.leading!,
                      ),
                      SizedBox(width: TossSpacing.space3),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TODO: Review AnimatedDefaultTextStyle for TossTextStyles usage
AnimatedDefaultTextStyle(
                            style: TossTextStyles.body.copyWith(
                              color: isDisabled
                                  ? TossColors.gray400
                                  : widget.selected
                                      ? TossColors.primary
                                      : TossColors.gray900,
                              fontWeight: widget.selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            duration: TossAnimations.normal,
                            child: Text(widget.title),
                          ),
                          if (widget.subtitle != null) ...[
                            SizedBox(height: TossSpacing.space1),
                            // TODO: Review AnimatedDefaultTextStyle for TossTextStyles usage
AnimatedDefaultTextStyle(
                              style: TossTextStyles.bodySmall.copyWith(
                                color: isDisabled
                                    ? TossColors.gray300
                                    : TossColors.gray500,
                              ),
                              duration: TossAnimations.normal,
                              child: Text(widget.subtitle!),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[
                      SizedBox(width: TossSpacing.space3),
                      AnimatedOpacity(
                        opacity: isDisabled ? 0.5 : 1.0,
                        duration: TossAnimations.normal,
                        child: widget.trailing!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}