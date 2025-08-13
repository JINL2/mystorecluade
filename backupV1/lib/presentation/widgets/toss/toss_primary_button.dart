import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';

/// Toss-style primary button with micro-interactions
class TossPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  
  const TossPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
          child: Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isDisabled ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDisabled 
                    ? TossColors.gray200 
                    : TossColors.primary,
                foregroundColor: _isDisabled 
                    ? TossColors.gray400 
                    : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
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
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
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