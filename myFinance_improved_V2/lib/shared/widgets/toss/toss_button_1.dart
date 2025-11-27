import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Unified Toss button with different variants (Extended Version)
enum TossButton1Variant {
  primary,
  secondary,
  outlined,
  outlinedGray,
  textButton,
}

/// Extended Toss-style button with full customization support
/// Can be used anywhere with complete styling control
class TossButton1 extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final bool fullWidth;
  final TossButton1Variant variant;

  // 🆕 Customizable colors
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final Color? loadingIndicatorColor;

  // 🆕 Customizable dimensions
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? borderWidth;
  final double? fontSize;
  final FontWeight? fontWeight;

  // 🆕 Customizable loading indicator
  final double? loadingIndicatorSize;
  final double? loadingIndicatorStrokeWidth;

  // 🆕 Customizable behavior
  final int? debounceDurationMs;
  final bool enablePressAnimation;

  // 🆕 Custom text style
  final TextStyle? textStyle;

  const TossButton1({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.fullWidth = false,
    this.variant = TossButton1Variant.primary,
    // Color customization
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.loadingIndicatorColor,
    // Dimension customization
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.fontSize,
    this.fontWeight,
    // Loading indicator customization
    this.loadingIndicatorSize,
    this.loadingIndicatorStrokeWidth,
    // Behavior customization
    this.debounceDurationMs,
    this.enablePressAnimation = true,
    // Text style customization
    this.textStyle,
  });

  /// Factory constructor for primary button with optional customization
  factory TossButton1.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    EdgeInsets? padding,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    int? debounceDurationMs,
    bool enablePressAnimation = true,
  }) {
    return TossButton1(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButton1Variant.primary,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      padding: padding,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textStyle: textStyle,
      debounceDurationMs: debounceDurationMs,
      enablePressAnimation: enablePressAnimation,
    );
  }

  /// Factory constructor for secondary button with optional customization
  factory TossButton1.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    EdgeInsets? padding,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    int? debounceDurationMs,
    bool enablePressAnimation = true,
  }) {
    return TossButton1(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButton1Variant.secondary,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      padding: padding,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textStyle: textStyle,
      debounceDurationMs: debounceDurationMs,
      enablePressAnimation: enablePressAnimation,
    );
  }

  /// Factory constructor for outlined button with optional customization
  factory TossButton1.outlined({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
    Color? borderColor,
    Color? textColor,
    EdgeInsets? padding,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    int? debounceDurationMs,
    bool enablePressAnimation = true,
  }) {
    return TossButton1(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButton1Variant.outlined,
      borderColor: borderColor,
      textColor: textColor,
      padding: padding,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textStyle: textStyle,
      debounceDurationMs: debounceDurationMs,
      enablePressAnimation: enablePressAnimation,
    );
  }

  /// Factory constructor for outlined gray button (unselected state)
  factory TossButton1.outlinedGray({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
    Color? borderColor,
    Color? textColor,
    EdgeInsets? padding,
    double? borderRadius,
    double? fontSize,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    int? debounceDurationMs,
    bool enablePressAnimation = true,
  }) {
    return TossButton1(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButton1Variant.outlinedGray,
      borderColor: borderColor,
      textColor: textColor,
      padding: padding,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textStyle: textStyle,
      debounceDurationMs: debounceDurationMs,
      enablePressAnimation: enablePressAnimation,
    );
  }

  /// Factory constructor for text button (no background, no border)
  factory TossButton1.textButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Widget? leadingIcon,
    bool fullWidth = false,
    Color? textColor,
    EdgeInsets? padding,
    double? fontSize,
    FontWeight? fontWeight,
    TextStyle? textStyle,
    int? debounceDurationMs,
    bool enablePressAnimation = true,
  }) {
    return TossButton1(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      fullWidth: fullWidth,
      variant: TossButton1Variant.textButton,
      textColor: textColor,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textStyle: textStyle,
      debounceDurationMs: debounceDurationMs,
      enablePressAnimation: enablePressAnimation,
    );
  }

  @override
  State<TossButton1> createState() => _TossButton1State();
}

class _TossButton1State extends State<TossButton1>
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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: TossAnimations.standard,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return widget.disabledBackgroundColor ?? TossColors.gray100;
    }

    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    switch (widget.variant) {
      case TossButton1Variant.primary:
        return TossColors.primary;
      case TossButton1Variant.secondary:
        return TossColors.gray100;
      case TossButton1Variant.outlined:
      case TossButton1Variant.outlinedGray:
      case TossButton1Variant.textButton:
        return TossColors.transparent;
    }
  }

  Color _getTextColor() {
    if (!widget.isEnabled) {
      return widget.disabledTextColor ?? TossColors.gray600;
    }

    if (widget.textColor != null) {
      return widget.textColor!;
    }

    switch (widget.variant) {
      case TossButton1Variant.primary:
        return TossColors.white;
      case TossButton1Variant.secondary:
        return TossColors.gray900;
      case TossButton1Variant.outlined:
      case TossButton1Variant.textButton:
        return TossColors.primary;
      case TossButton1Variant.outlinedGray:
        return TossColors.gray600;
    }
  }

  Color _getBorderColor() {
    if (widget.borderColor != null) {
      return widget.borderColor!;
    }

    switch (widget.variant) {
      case TossButton1Variant.outlined:
        return TossColors.primary;
      case TossButton1Variant.outlinedGray:
        return TossColors.gray300;
      case TossButton1Variant.primary:
      case TossButton1Variant.secondary:
      case TossButton1Variant.textButton:
        return TossColors.transparent;
    }
  }

  /// Get adjusted padding to compensate for border (inset border effect)
  /// For outlined buttons, reduce padding by border width to maintain same total size
  EdgeInsets _getAdjustedPadding() {
    final basePadding = widget.padding ??
        const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        );

    // Check if button has a visible border
    final borderColor = _getBorderColor();
    final borderWidth = widget.borderWidth ??
        (borderColor != TossColors.transparent ? 1.0 : 0.0);

    // If no border, return original padding
    if (borderWidth == 0) {
      return basePadding;
    }

    // Reduce padding by border width to create inset border effect
    return EdgeInsets.symmetric(
      horizontal: basePadding.horizontal / 2 - borderWidth,
      vertical: basePadding.vertical / 2 - borderWidth,
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressAnimation &&
        widget.isEnabled &&
        !widget.isLoading &&
        !_isProcessing) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation &&
        widget.isEnabled &&
        !widget.isLoading &&
        !_isProcessing) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation &&
        widget.isEnabled &&
        !widget.isLoading &&
        !_isProcessing) {
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

    // Reset processing state after a safe delay
    final debounceDuration = widget.debounceDurationMs ?? 300;
    _debounceTimer = Timer(Duration(milliseconds: debounceDuration), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: widget.isEnabled && !widget.isLoading && !_isProcessing
              ? _handleTap
              : null,
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? TossBorderRadius.md,
          ),
          child: Container(
            padding: _getAdjustedPadding(),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? TossBorderRadius.md,
              ),
              border: Border.all(
                color: _getBorderColor(),
                width: widget.borderWidth ??
                    (_getBorderColor() != TossColors.transparent ? 1 : 0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: widget.loadingIndicatorSize ?? 16,
                    height: widget.loadingIndicatorSize ?? 16,
                    child: CircularProgressIndicator(
                      strokeWidth: widget.loadingIndicatorStrokeWidth ?? 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.loadingIndicatorColor ?? _getTextColor(),
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
                    style: widget.textStyle ??
                        TossTextStyles.body.copyWith(
                          color: _getTextColor(),
                          fontWeight: widget.fontWeight ?? FontWeight.w600,
                          fontSize: widget.fontSize,
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
    );

    if (!widget.enablePressAnimation) {
      return content;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: content,
          ),
        );
      },
    );
  }
}
