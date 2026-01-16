import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_icon_button.dart';

/// Mode for stock change indicator calculation
enum StockChangeMode {
  /// Add quantity to previous value (for Stock In)
  add,

  /// Subtract quantity from previous value (for Move Stock)
  subtract,
}

/// Variant style for TossQuantityInput
enum _QuantityInputVariant {
  /// Compact horizontal layout for inline use
  compact,

  /// Full-width stepper layout for dialogs with optional stock indicator
  stepper,
}

/// Toss-style quantity input with increment/decrement buttons
///
/// A compact input component for numeric quantity selection with:
/// - [-] button to decrement (uses TossIconButton atom)
/// - Numeric display/input field
/// - [+] button to increment (uses TossIconButton atom)
/// - Configurable min/max values
/// - Haptic feedback
/// - Validation
///
/// Atomic Design: MOLECULE
/// Composed of:
/// - 2x TossIconButton (atoms) for +/- buttons
/// - 1x TextField (atom) for input
///
/// **Variants:**
///
/// 1. `TossQuantityInput()` - Compact horizontal layout for inline use
/// ```dart
/// TossQuantityInput(
///   value: 5,
///   onChanged: (newValue) => print('New quantity: $newValue'),
///   minValue: 0,
///   maxValue: 100,
/// )
/// ```
///
/// 2. `TossQuantityInput.stepper()` - Full-width layout for dialogs with stock indicator
/// ```dart
/// TossQuantityInput.stepper(
///   value: 5,
///   onChanged: (newValue) => print('New quantity: $newValue'),
///   previousValue: 10,
///   stockChangeMode: StockChangeMode.subtract,
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

  /// Custom icon color for buttons
  final Color? buttonIconColor;

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

  /// Internal variant type
  final _QuantityInputVariant _variant;

  /// Previous value for stock change indicator (stepper variant only)
  final int? previousValue;

  /// Stock change mode for indicator calculation (stepper variant only)
  final StockChangeMode stockChangeMode;

  /// Compact variant - horizontal layout for inline use
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
    this.buttonSize = 32,
    this.buttonIconColor,
    this.buttonBackgroundColor,
    this.inputBackgroundColor,
    this.textColor,
    this.allowManualInput = true,
    this.borderRadius,
  })  : _variant = _QuantityInputVariant.compact,
        previousValue = null,
        stockChangeMode = StockChangeMode.add;

  /// Stepper variant - full-width layout for dialogs with optional stock indicator
  ///
  /// Use this variant when you need:
  /// - A larger, more prominent quantity input (e.g., in dialogs)
  /// - Optional stock change indicator showing before → after values
  ///
  /// Example:
  /// ```dart
  /// TossQuantityInput.stepper(
  ///   value: quantity,
  ///   onChanged: (v) => setState(() => quantity = v),
  ///   previousValue: 10,  // Shows "10 → 15" when quantity is 5
  ///   stockChangeMode: StockChangeMode.add,
  /// )
  /// ```
  const TossQuantityInput.stepper({
    super.key,
    required this.value,
    this.onChanged,
    this.minValue = 0,
    this.maxValue = 999999,
    this.step = 1,
    this.enabled = true,
    this.previousValue,
    this.stockChangeMode = StockChangeMode.add,
    this.buttonIconColor,
    this.buttonBackgroundColor,
  })  : _variant = _QuantityInputVariant.stepper,
        width = null,
        inputWidth = 78,
        buttonSize = 36,
        inputBackgroundColor = null,
        textColor = null,
        allowManualInput = true,
        borderRadius = null;

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
    final newValue =
        (widget.value + widget.step).clamp(widget.minValue, widget.maxValue);
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      widget.onChanged?.call(newValue);
    }
  }

  void _decrement() {
    if (!widget.enabled) return;
    final newValue =
        (widget.value - widget.step).clamp(widget.minValue, widget.maxValue);
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      widget.onChanged?.call(newValue);
    }
  }

  // Default colors using design tokens
  Color get _buttonIconColor => widget.buttonIconColor ?? TossColors.darkGray;
  Color get _buttonBackgroundColor =>
      widget.buttonBackgroundColor ?? TossColors.lightGray;
  Color get _inputBackgroundColor =>
      widget.inputBackgroundColor ?? TossColors.white;
  Color get _textColor => widget.textColor ?? TossColors.charcoal;
  double get _borderRadius => widget.borderRadius ?? TossBorderRadius.md;

  @override
  Widget build(BuildContext context) {
    return widget._variant == _QuantityInputVariant.stepper
        ? _buildStepperVariant()
        : _buildCompactVariant();
  }

  /// Compact variant - horizontal row with fixed-width input
  Widget _buildCompactVariant() {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
        children: [
          // Decrement button - using TossIconButton atom
          TossIconButton.filled(
            icon: Icons.remove,
            onPressed: _decrement,
            backgroundColor: _buttonBackgroundColor,
            iconColor: _buttonIconColor,
            buttonSize: widget.buttonSize,
            borderRadius: _borderRadius,
          ),

          const SizedBox(width: TossSpacing.space2),

          // Input field
          _buildInputField(),

          const SizedBox(width: TossSpacing.space2),

          // Increment button - using TossIconButton atom
          TossIconButton.filled(
            icon: Icons.add,
            onPressed: _increment,
            backgroundColor: _buttonBackgroundColor,
            iconColor: _buttonIconColor,
            buttonSize: widget.buttonSize,
            borderRadius: _borderRadius,
          ),
        ],
      ),
    );
  }

  /// Stepper variant - full-width layout with optional stock indicator
  Widget _buildStepperVariant() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quantity input row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Minus button
            TossIconButton.filled(
              icon: Icons.remove,
              onPressed: _decrement,
              size: TossIconButtonSize.small,
              backgroundColor: _buttonBackgroundColor,
              iconColor: _buttonIconColor,
            ),
            // Quantity input - expanded
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _onStepperTextChanged,
              ),
            ),
            // Plus button
            TossIconButton.filled(
              icon: Icons.add,
              onPressed: _increment,
              size: TossIconButtonSize.small,
              backgroundColor: _buttonBackgroundColor,
              iconColor: _buttonIconColor,
            ),
          ],
        ),
        // Stock change indicator
        if (widget.previousValue != null) ...[
          SizedBox(height: TossSpacing.space3),
          _buildStockChangeIndicator(),
        ],
      ],
    );
  }

  /// Handle text changes for stepper variant (updates on every change)
  void _onStepperTextChanged(String value) {
    if (value.isEmpty) {
      widget.onChanged?.call(0);
    } else {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed >= widget.minValue) {
        final effectiveMax = widget.maxValue;
        if (parsed > effectiveMax) {
          _controller.text = '$effectiveMax';
          widget.onChanged?.call(effectiveMax);
        } else {
          widget.onChanged?.call(parsed);
        }
      }
    }
  }

  /// Stock change indicator showing before → after values
  Widget _buildStockChangeIndicator() {
    final newValue = widget.stockChangeMode == StockChangeMode.add
        ? widget.previousValue! + widget.value
        : widget.previousValue! - widget.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${widget.previousValue}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
        SizedBox(width: TossSpacing.space2),
        Icon(
          Icons.arrow_forward,
          size: TossSpacing.iconXS,
          color: TossColors.gray500,
        ),
        SizedBox(width: TossSpacing.space2),
        Text(
          '$newValue',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
      ],
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
          color: TossColors.white,
          width: 1,
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
                  color: _controller.text.isNotEmpty && _controller.text != '0'
                      ? _textColor
                      : TossColors.darkGray,
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
                  color: widget.value == 0 ? TossColors.darkGray : _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
