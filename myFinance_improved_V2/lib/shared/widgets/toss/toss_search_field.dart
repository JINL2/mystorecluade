import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;

    final showClear = _controller.text.isNotEmpty;
    if (showClear != _showClearButton) {
      setState(() {
        _showClearButton = showClear;
      });
    }

    final onChanged = widget.onChanged;
    if (onChanged != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDelay, () {
        if (mounted) {
          onChanged(_controller.text);
        }
      });
    }
  }

  void _onFocusChanged() {
    if (!mounted) return;
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

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      onSubmitted: widget.onSubmitted,
      style: TossTextStyles.bodyLarge.copyWith(
        color: TossColors.gray900,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TossTextStyles.bodyLarge.copyWith(
          color: TossColors.gray500,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: isFocused ? TossColors.primary : TossColors.gray500,
                size: TossSpacing.iconSM,
              )
            : Icon(
                Icons.search_rounded,
                color: isFocused ? TossColors.primary : TossColors.gray500,
                size: TossSpacing.iconSM,
              ),
        suffixIcon: _showClearButton
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: TossColors.gray500,
                  size: TossSpacing.iconSM,
                ),
                onPressed: _handleClear,
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: TossColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: const BorderSide(
            color: TossColors.gray300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: const BorderSide(
            color: TossColors.gray300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          borderSide: const BorderSide(
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
          borderSide: const BorderSide(
            color: TossColors.gray300,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
      ),
    );
  }
}