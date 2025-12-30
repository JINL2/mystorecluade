import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Toss-style quantity input with increment/decrement buttons
///
/// A compact input component for numeric quantity selection with:
/// - [-] button to decrement
/// - Numeric display/input field
/// - [+] button to increment
/// - Configurable min/max values
/// - Haptic feedback
/// - Validation
///
/// Usage:
/// ```dart
/// TossQuantityInput(
///   value: 5,
///   onChanged: (newValue) => print('New quantity: $newValue'),
///   minValue: 0,
///   maxValue: 100,
/// )
/// ```
class TossQuantityInput extends StatefulWidget {
  /// Current quantity value
  final int value;

  /// Callback when value changes
  final ValueChanged<int>? onChanged;

  /// Minimum allowed value (default: 0)
  final int minValue;

  /// Maximum allowed value (default: 999)
  final int maxValue;

  /// Step size for increment/decrement (default: 1)
  final int step;

  /// Whether the input is enabled
  final bool enabled;

  /// Width of the entire component
  final double? width;

  /// Width of the center input field
  final double inputWidth;

  /// Size of the +/- buttons
  final double buttonSize;

  /// Custom button color
  final Color? buttonColor;

  /// Custom button background color
  final Color? buttonBackgroundColor;

  /// Custom input background color
  final Color? inputBackgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Whether to allow manual text input (default: true)
  final bool allowManualInput;

  /// Border radius for buttons and input
  final double? borderRadius;

  const TossQuantityInput({
    super.key,
    required this.value,
    this.onChanged,
    this.minValue = 0,
    this.maxValue = 999,
    this.step = 1,
    this.enabled = true,
    this.width,
    this.inputWidth = 78,
    this.buttonSize = 40,
    this.buttonColor,
    this.buttonBackgroundColor,
    this.inputBackgroundColor,
    this.textColor,
    this.allowManualInput = true,
    this.borderRadius,
  });

  @override
  State<TossQuantityInput> createState() => _TossQuantityInputState();
}

class _TossQuantityInputState extends State<TossQuantityInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _controller.addListener(_onTextChange);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  void didUpdateWidget(TossQuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Clear "0" when focused so user can type directly
      if (_controller.text == '0' || widget.value == 0) {
        _controller.clear();
        _controller.selection = const TextSelection.collapsed(offset: 0);
      }
    } else {
      // Validate on focus lost
      _validateAndUpdate(_controller.text);
    }
  }

  void _validateAndUpdate(String text) {
    // Empty text means 0
    if (text.isEmpty) {
      _controller.text = '0';
      if (widget.value != 0) {
        widget.onChanged?.call(0);
      }
      return;
    }

    final parsedValue = int.tryParse(text);
    if (parsedValue == null) {
      // Invalid input, reset to current value
      _controller.text = widget.value.toString();
      return;
    }

    // Clamp value within min/max range
    final clampedValue = parsedValue.clamp(widget.minValue, widget.maxValue);
    _controller.text = clampedValue.toString();

    if (clampedValue != widget.value) {
      widget.onChanged?.call(clampedValue);
    }
  }

  void _increment() {
    if (!widget.enabled) return;
    final newValue = (widget.value + widget.step).clamp(widget.minValue, widget.maxValue);
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      widget.onChanged?.call(newValue);
    }
  }

  void _decrement() {
    if (!widget.enabled) return;
    final newValue = (widget.value - widget.step).clamp(widget.minValue, widget.maxValue);
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      widget.onChanged?.call(newValue);
    }
  }

  Color get _buttonColor => widget.buttonColor ?? TossColors.gray700;
  Color get _buttonBackgroundColor => widget.buttonBackgroundColor ?? TossColors.gray100;
  Color get _inputBackgroundColor => widget.inputBackgroundColor ?? TossColors.white;
  Color get _textColor => widget.textColor ?? TossColors.gray900;
  double get _borderRadius => widget.borderRadius ?? TossBorderRadius.md;

  @override
  Widget build(BuildContext context) {
    final canDecrement = widget.enabled && widget.value > widget.minValue;
    final canIncrement = widget.enabled && widget.value < widget.maxValue;

    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
        children: [
          // Decrement button
          _buildButton(
            icon: Icons.remove,
            onPressed: canDecrement ? _decrement : null,
            enabled: canDecrement,
          ),

          const SizedBox(width: TossSpacing.space2),

          // Input field
          _buildInputField(),

          const SizedBox(width: TossSpacing.space2),

          // Increment button
          _buildButton(
            icon: Icons.add,
            onPressed: canIncrement ? _increment : null,
            enabled: canIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          width: widget.buttonSize,
          height: widget.buttonSize,
          decoration: BoxDecoration(
            color: enabled ? _buttonBackgroundColor : TossColors.gray50,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: enabled ? TossColors.gray200 : TossColors.gray100,
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: enabled ? _buttonColor : TossColors.gray400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      width: widget.inputWidth,
      height: widget.buttonSize,
      decoration: BoxDecoration(
        color: _inputBackgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: _focusNode.hasFocus ? TossColors.primary : TossColors.gray200,
          width: _focusNode.hasFocus ? 1.5 : 1,
        ),
      ),
      child: widget.allowManualInput
          ? Center(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TossTextStyles.body.copyWith(
                  color: _controller.text.isNotEmpty && _controller.text != '0' ? _textColor : TossColors.gray400,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onSubmitted: (value) {
                  _validateAndUpdate(value);
                  _focusNode.unfocus();
                },
              ),
            )
          : Center(
              child: Text(
                widget.value.toString(),
                style: TossTextStyles.body.copyWith(
                  color: widget.value == 0 ? TossColors.gray400 : _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
