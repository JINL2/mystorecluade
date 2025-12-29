import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Rejected quantity stepper with red styling
class RejectedQuantityStepper extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final ValueChanged<int> onChanged;

  const RejectedQuantityStepper({
    super.key,
    this.initialValue = 0,
    this.minValue = 0,
    required this.onChanged,
  });

  @override
  State<RejectedQuantityStepper> createState() => _RejectedQuantityStepperState();
}

class _RejectedQuantityStepperState extends State<RejectedQuantityStepper> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
    _controller = TextEditingController(text: '-$_quantity');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _quantity == 0) {
      _controller.text = '-';
    } else if (!_focusNode.hasFocus) {
      _controller.text = '-$_quantity';
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
      _controller.text = '-$_quantity';
    });
    widget.onChanged(_quantity);
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
        _controller.text = '-$_quantity';
      });
      widget.onChanged(_quantity);
    }
  }

  void _onTextChanged(String value) {
    final cleanValue = value.replaceAll('-', '');
    if (cleanValue.isEmpty) {
      setState(() {
        _quantity = 0;
      });
      widget.onChanged(_quantity);
    } else {
      final parsed = int.tryParse(cleanValue);
      if (parsed != null && parsed >= widget.minValue) {
        setState(() {
          _quantity = parsed;
        });
        widget.onChanged(_quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: TossColors.loss,
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
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TossColors.loss,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 24,
          color: TossColors.loss,
        ),
      ),
    );
  }
}
