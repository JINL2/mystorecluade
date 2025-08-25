import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

/// Minimalist number input field with clean background-only styling
class TossNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextAlign textAlign;
  final double? height;
  final bool showBorder;
  final bool enabled;
  final FocusNode? focusNode;
  final String? prefix;
  final String? suffix;

  const TossNumberInput({
    super.key,
    required this.controller,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.textAlign = TextAlign.center,
    this.height = 48,
    this.showBorder = false,
    this.enabled = true,
    this.focusNode,
    this.prefix,
    this.suffix,
  });

  @override
  State<TossNumberInput> createState() => _TossNumberInputState();
}

class _TossNumberInputState extends State<TossNumberInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.height,
      decoration: BoxDecoration(
        color: !widget.enabled 
            ? TossColors.gray100
            : _isFocused 
                ? TossColors.primary.withOpacity(0.05)
                : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          if (widget.prefix != null)
            Padding(
              padding: const EdgeInsets.only(left: TossSpacing.space3),
              child: Text(
                widget.prefix!,
                style: TossTextStyles.body.copyWith(
                  color: _isFocused ? TossColors.primary : TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: widget.inputFormatters ??
                  [FilteringTextInputFormatter.digitsOnly],
              textAlign: widget.textAlign,
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: _isFocused ? TossColors.primary : TossColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? '0',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (widget.suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: Text(
                widget.suffix!,
                style: TossTextStyles.body.copyWith(
                  color: _isFocused ? TossColors.primary : TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}