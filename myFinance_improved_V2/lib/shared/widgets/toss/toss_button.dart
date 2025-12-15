import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Unified Toss button with different variants
enum TossButtonVariant {
  primary,
  secondary,
}

/// Unified Toss-style button supporting all button variants
class TossButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final bool fullWidth;
  final TossButtonVariant variant;
  
  const TossButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.fullWidth = false,
    this.variant = TossButtonVariant.primary,
  });

  /// Factory constructors for backward compatibility
  factory TossButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
  }) {
    return TossButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButtonVariant.primary,
    );
  }

  factory TossButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
  }) {
    return TossButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButtonVariant.secondary,
    );
  }

  
  @override
  State<TossButton> createState() => _TossButtonState();
}

class _TossButtonState extends State<TossButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  // Button-level protection against rapid taps
  bool _isProcessing = false;
  Timer? _debounceTimer;
  
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
    ),);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return TossColors.gray200;
    }
    
    switch (widget.variant) {
      case TossButtonVariant.primary:
        return TossColors.primary;
      case TossButtonVariant.secondary:
        return TossColors.gray100;
    }
  }

  Color _getTextColor() {
    if (!widget.isEnabled) {
      return TossColors.gray400;
    }
    
    switch (widget.variant) {
      case TossButtonVariant.primary:
        return TossColors.white;
      case TossButtonVariant.secondary:
        return TossColors.gray900;
    }
  }

  Color _getBorderColor() {
    // No borders needed for primary and secondary variants
    return TossColors.transparent;
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading && !_isProcessing) {
      _controller.forward();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled && !widget.isLoading && !_isProcessing) {
      _controller.reverse();
    }
  }
  
  void _handleTapCancel() {
    if (widget.isEnabled && !widget.isLoading && !_isProcessing) {
      _controller.reverse();
    }
  }
  
  void _handleTap() {
    // Prevent rapid button taps with debouncing for critical operations
    if (_isProcessing || !widget.isEnabled || widget.isLoading) return;
    
    // Set processing state immediately
    if (mounted) {
      setState(() => _isProcessing = true);
    }
    
    // Cancel any existing timer
    _debounceTimer?.cancel();
    
    // Execute the callback
    widget.onPressed?.call();
    
    // Reset processing state after a safe delay (300ms for critical operations like journal entries)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.isEnabled && !widget.isLoading && !_isProcessing
                ? _handleTap
                : null,
            child: SizedBox(
              width: widget.fullWidth ? double.infinity : null,
              child: Material(
                color: TossColors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: _getBorderColor() != TossColors.transparent ? 1 : 0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLoading) ...[
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getTextColor(),
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                      ] else if (widget.leadingIcon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: _getTextColor(),
                            size: 16,
                          ),
                          child: widget.leadingIcon!,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                      ],
                      Flexible(
                        child: Text(
                          widget.text,
                          style: TossTextStyles.body.copyWith(
                            color: _getTextColor(),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Compatibility aliases for easy migration (only used variants)
typedef TossPrimaryButton = TossButton;
typedef TossSecondaryButton = TossButton;