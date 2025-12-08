import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Adjustment section for shift details
///
/// Contains:
/// - Add bonus text field
class AdjustmentSection extends StatefulWidget {
  final TextEditingController bonusController;
  final ValueChanged<int> onBonusChanged;

  const AdjustmentSection({
    super.key,
    required this.bonusController,
    required this.onBonusChanged,
  });

  @override
  State<AdjustmentSection> createState() => _AdjustmentSectionState();
}

class _AdjustmentSectionState extends State<AdjustmentSection> {
  final FocusNode _bonusFocusNode = FocusNode();

  @override
  void dispose() {
    _bonusFocusNode.dispose();
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // Add bonus text field
        _AdjustmentTextField(
          label: 'Add bonus',
          controller: widget.bonusController,
          onChanged: widget.onBonusChanged,
          focusNode: _bonusFocusNode,
          onEditTap: () => _bonusFocusNode.requestFocus(),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            width: 100,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
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
          const SizedBox(width: 8),
          // Edit icon - tappable to focus the text field
          GestureDetector(
            onTap: onEditTap,
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
