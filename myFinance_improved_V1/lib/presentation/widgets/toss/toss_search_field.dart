import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';

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
    this.debounceDelay = const Duration(milliseconds: 300),
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
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: _focusNode.hasFocus ? TossColors.primary : TossColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null)
            Padding(
              padding: EdgeInsets.only(left: TossSpacing.space3),
              child: Icon(
                widget.prefixIcon,
                size: 20,
                color: TossColors.gray400,
              ),
            ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onSubmitted: widget.onSubmitted,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.prefixIcon != null ? TossSpacing.space2 : TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ),
          if (_showClearButton)
            GestureDetector(
              onTap: _handleClear,
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                child: Icon(
                  Icons.clear,
                  size: 20,
                  color: TossColors.gray400,
                ),
              ),
            ),
          if (widget.suffixIcon != null && !_showClearButton)
            Padding(
              padding: EdgeInsets.only(right: TossSpacing.space3),
              child: widget.suffixIcon,
            ),
        ],
      ),
    );
  }
}