import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Bonus section with input field for manager to set bonus amount
class BonusSection extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<int> onBonusChanged;

  const BonusSection({
    super.key,
    required this.controller,
    required this.onBonusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonus for this shift (₫)',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            // Show "0" when field is empty
            if (controller.text.isEmpty)
              Positioned.fill(
                child: Center(
                  child: IgnorePointer(
                    child: Text(
                      '0',
                      style: TossTextStyles.h2.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray100, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray100, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray100, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isDense: true,
              ),
              onChanged: (value) {
                final amount = int.tryParse(value.replaceAll(',', '')) ?? 0;
                onBonusChanged(amount);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Optional one-time bonus approved by manager.',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }
}
