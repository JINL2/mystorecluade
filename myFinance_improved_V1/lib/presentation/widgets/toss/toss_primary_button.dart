import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';

/// Toss-style primary button with micro-interactions
class TossPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final bool fullWidth;
  
  const TossPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.fullWidth = false,
  });
  
  @override
  State<TossPrimaryButton> createState() => _TossPrimaryButtonState();
}

class _TossPrimaryButtonState extends State<TossPrimaryButton> 
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
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TossAnimations.standard,
    ));
  }
  
  bool get _isDisabled => !widget.isEnabled || widget.isLoading;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: !_isDisabled ? (_) => _controller.forward() : null,
      onTapUp: !_isDisabled ? (_) => _controller.reverse() : null,
      onTapCancel: !_isDisabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: _isDisabled ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDisabled 
                  ? TossColors.gray200 
                  : TossColors.primary,
              foregroundColor: _isDisabled 
                  ? TossColors.gray400 
                  : TossColors.textInverse,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              minimumSize: widget.fullWidth 
                  ? const Size(double.infinity, 56)
                  : const Size(0, 56),
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          TossColors.textInverse.withValues(alpha: 0.8),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.leadingIcon != null) ...[
                          widget.leadingIcon!,
                          SizedBox(width: TossSpacing.space2),
                        ],
                        Text(
                          widget.text,
                          style: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _isDisabled 
                                ? TossColors.gray400 
                                : TossColors.textInverse,
                          ),
                        ),
                      ],
                    ),
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