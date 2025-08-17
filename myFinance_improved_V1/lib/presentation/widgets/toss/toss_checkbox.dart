import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Toss-style checkbox component
/// Clean, minimal design following Toss design patterns
class TossCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? label;
  final bool enabled;
  final double size;
  final Color? activeColor;
  final Color? checkColor;
  final EdgeInsetsGeometry? padding;

  const TossCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
    this.size = 20,
    this.activeColor,
    this.checkColor,
    this.padding,
  });

  @override
  State<TossCheckbox> createState() => _TossCheckboxState();
}

class _TossCheckboxState extends State<TossCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.quick,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.emphasis,
      reverseCurve: TossAnimations.exit,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.enter,
      reverseCurve: TossAnimations.exit,
    ));
  }

  @override
  void didUpdateWidget(TossCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? TossColors.primary;
    final checkColor = widget.checkColor ?? TossColors.white;
    final disabledColor = TossColors.gray400;
    
    return GestureDetector(
      onTap: _handleTap,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox container
            AnimatedContainer(
              duration: TossAnimations.normal,
              curve: TossAnimations.standard,
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.value
                    ? (widget.enabled ? activeColor : disabledColor)
                    : TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: widget.value
                    ? null
                    : Border.all(
                        color: widget.enabled
                            ? TossColors.gray300
                            : TossColors.gray200,
                        width: 1.5,
                      ),
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Icon(
                          Icons.check,
                          size: widget.size * 0.65,
                          color: checkColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Label (if provided)
            if (widget.label != null) ...[
              SizedBox(width: TossSpacing.space3),
              Flexible(
                child: DefaultTextStyle(
                  style: TossTextStyles.body.copyWith(
                    color: widget.enabled
                        ? TossColors.gray900
                        : TossColors.gray500,
                  ),
                  child: widget.label!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// List tile with integrated checkbox for selection lists
class TossCheckboxListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? activeColor;
  final Color? tileColor;
  final Color? selectedTileColor;
  final ShapeBorder? shape;
  final bool selected;

  const TossCheckboxListTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.contentPadding,
    this.activeColor,
    this.tileColor,
    this.selectedTileColor,
    this.shape,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? TossColors.primary;
    final effectiveTileColor = tileColor ?? TossColors.white;
    final effectiveSelectedTileColor = selectedTileColor ?? 
        effectiveActiveColor.withOpacity(0.05);
    
    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: shape != null ? null : BorderRadius.circular(TossBorderRadius.md),
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        padding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: (selected || value) ? effectiveSelectedTileColor : effectiveTileColor,
          borderRadius: shape != null ? null : BorderRadius.circular(TossBorderRadius.md),
          border: shape != null ? null : Border.all(
            color: value ? effectiveActiveColor : TossColors.gray200,
            width: value ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            TossCheckbox(
              value: value,
              onChanged: enabled ? onChanged : null,
              enabled: enabled,
              activeColor: effectiveActiveColor,
            ),
            
            // Leading widget (if provided)
            if (leading != null) ...[
              SizedBox(width: TossSpacing.space3),
              leading!,
            ],
            
            // Title and subtitle
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: TossTextStyles.body.copyWith(
                      color: enabled ? TossColors.gray900 : TossColors.gray500,
                      fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: TossSpacing.space1),
                    DefaultTextStyle(
                      style: TossTextStyles.bodySmall.copyWith(
                        color: enabled ? TossColors.gray600 : TossColors.gray400,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            
            // Trailing widget (if provided)
            if (trailing != null) ...[
              SizedBox(width: TossSpacing.space3),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}