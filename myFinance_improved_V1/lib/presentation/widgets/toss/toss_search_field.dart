import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_animations.dart';

class TossSearchField extends StatefulWidget {
  const TossSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.debounceDelay = TossAnimations.slow,
    this.prefixIcon,
    this.suffixIcon,
    this.onClear,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final Duration debounceDelay;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onClear;

  @override
  State<TossSearchField> createState() => _TossSearchFieldState();
}

class _TossSearchFieldState extends State<TossSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounceTimer;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final showClear = _controller.text.isNotEmpty;
    if (showClear != _showClearButton) {
      setState(() {
        _showClearButton = showClear;
      });
    }

    if (widget.onChanged != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDelay, () {
        widget.onChanged!(_controller.text);
      });
    }
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;
    final Color backgroundColor = isFocused ? TossColors.surface : TossColors.gray50;
    
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        onSubmitted: widget.onSubmitted,
        style: TossTextStyles.body,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: isFocused ? TossColors.textSecondary : TossColors.textTertiary,
                  size: 20,
                )
              : null,
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: TossColors.textTertiary,
                    size: 20,
                  ),
                  onPressed: _handleClear,
                )
              : widget.suffixIcon,
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(
              color: isFocused ? TossColors.primary : TossColors.borderLight,
              width: isFocused ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(
              color: TossColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: const BorderSide(
              color: TossColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: const BorderSide(
              color: TossColors.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            borderSide: BorderSide(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
        ),
      ),
    );
  }
}