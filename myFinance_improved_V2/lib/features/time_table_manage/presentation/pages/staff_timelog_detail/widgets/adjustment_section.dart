import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/index.dart';

/// Adjustment section for shift details
///
/// Contains:
/// - Add bonus text field
/// - Deduct text field
class AdjustmentSection extends StatefulWidget {
  final TextEditingController bonusController;
  final TextEditingController deductController;
  final ValueChanged<int> onBonusChanged;
  final ValueChanged<int> onDeductChanged;

  const AdjustmentSection({
    super.key,
    required this.bonusController,
    required this.deductController,
    required this.onBonusChanged,
    required this.onDeductChanged,
  });

  @override
  State<AdjustmentSection> createState() => _AdjustmentSectionState();
}

class _AdjustmentSectionState extends State<AdjustmentSection> {
  final FocusNode _bonusFocusNode = FocusNode();
  final FocusNode _deductFocusNode = FocusNode();

  @override
  void dispose() {
    _bonusFocusNode.dispose();
    _deductFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Adjustment for this shift',
          style: TossTextStyles.h4.copyWith(
            color: TossColors.gray900,
            fontWeight: TossFontWeight.bold,
          ),
        ),
        SizedBox(height: TossSpacing.space4),

        // Add bonus text field
        _AdjustmentTextField(
          label: 'Add bonus',
          controller: widget.bonusController,
          onChanged: widget.onBonusChanged,
          focusNode: _bonusFocusNode,
          onEditTap: () => _bonusFocusNode.requestFocus(),
        ),

        // Deduct text field
        _AdjustmentTextField(
          label: 'Deduct',
          controller: widget.deductController,
          onChanged: widget.onDeductChanged,
          focusNode: _deductFocusNode,
          onEditTap: () => _deductFocusNode.requestFocus(),
        ),
      ],
    );
  }
}

/// Inline text field for Add bonus
class _AdjustmentTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onEditTap;

  const _AdjustmentTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          // Label
          Expanded(
            child: Text(
              label,
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
          // Text field with underline
          SizedBox(
            width: TossDimensions.inputLabelWidth,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: TossFontWeight.medium,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) return newValue;
                  final number = int.tryParse(newValue.text.replaceAll(',', ''));
                  if (number == null) return oldValue;
                  final formatted = NumberFormat('#,###').format(number);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }),
              ],
              decoration: const InputDecoration(
                hintText: '______',
                hintStyle: TextStyle(
                  color: TossColors.gray300,
                  letterSpacing: 2,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: (value) {
                final amount = int.tryParse(value.replaceAll(',', '')) ?? 0;
                onChanged(amount);
              },
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          // Edit icon - tappable to focus the text field
          GestureDetector(
            onTap: onEditTap,
            child: Icon(
              Icons.edit_outlined,
              size: TossSpacing.iconMD,
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
