// Widget: Toss Quantity Stepper
// Reusable quantity input with +/- buttons

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Mode for stock change indicator calculation
enum StockChangeMode {
  /// Add quantity to previous value (for Stock In)
  add,

  /// Subtract quantity from previous value (for Move Stock)
  subtract,
}

/// A reusable quantity stepper widget with +/- buttons
class TossQuantityStepper extends StatefulWidget {
  final int initialValue;
  final int? maxValue;
  final int minValue;
  final ValueChanged<int> onChanged;
  final int? previousValue;
  final StockChangeMode stockChangeMode;

  const TossQuantityStepper({
    super.key,
    this.initialValue = 0,
    this.maxValue,
    this.minValue = 0,
    required this.onChanged,
    this.previousValue,
    this.stockChangeMode = StockChangeMode.add,
  });

  @override
  State<TossQuantityStepper> createState() => TossQuantityStepperState();
}

class TossQuantityStepperState extends State<TossQuantityStepper> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
    _controller = TextEditingController(text: '$_quantity');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(TossQuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset when maxValue or previousValue changes (e.g., store changed)
    if (widget.maxValue != oldWidget.maxValue ||
        widget.previousValue != oldWidget.previousValue) {
      _quantity = widget.initialValue;
      _controller.text = '$_quantity';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Reset the stepper to initial value
  void reset() {
    setState(() {
      _quantity = widget.initialValue;
      _controller.text = '$_quantity';
    });
    widget.onChanged(_quantity);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _quantity == 0) {
      // Clear the "0" when focused and quantity is 0
      _controller.clear();
    } else if (!_focusNode.hasFocus && _controller.text.isEmpty) {
      // Restore "0" if field is empty when losing focus
      _controller.text = '0';
      setState(() {
        _quantity = 0;
      });
      widget.onChanged(_quantity);
    }
  }

  void _increment() {
    // Ensure maxValue is at least minValue (handle negative stock edge case)
    final effectiveMax = widget.maxValue != null && widget.maxValue! >= widget.minValue
        ? widget.maxValue!
        : null;

    if (effectiveMax == null || _quantity < effectiveMax) {
      setState(() {
        _quantity++;
        _controller.text = '$_quantity';
      });
      widget.onChanged(_quantity);
    }
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
        _controller.text = '$_quantity';
      });
      widget.onChanged(_quantity);
    }
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _quantity = 0;
      });
      widget.onChanged(_quantity);
    } else {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed >= widget.minValue) {
        // Ensure maxValue is at least minValue (handle negative stock edge case)
        final effectiveMax = widget.maxValue != null && widget.maxValue! >= widget.minValue
            ? widget.maxValue!
            : null;

        setState(() {
          if (effectiveMax != null && parsed > effectiveMax) {
            _quantity = effectiveMax;
            _controller.text = '$_quantity';
          } else {
            _quantity = parsed;
          }
        });
        widget.onChanged(_quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quantity input row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Minus button
            _buildQuantityButton(
              icon: Icons.remove,
              onTap: _decrement,
            ),
            // Quantity input
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _onTextChanged,
              ),
            ),
            // Plus button
            _buildQuantityButton(
              icon: Icons.add,
              onTap: _increment,
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: TossSpacing.iconXXL,
        height: TossSpacing.iconXXL,
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
          border: Border.all(
            color: TossColors.primary,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: TossSpacing.iconLG,
          color: TossColors.primary,
        ),
      ),
    );
  }

  Widget _buildStockChangeIndicator() {
    final newValue = widget.stockChangeMode == StockChangeMode.add
        ? widget.previousValue! + _quantity
        : widget.previousValue! - _quantity;

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
}
