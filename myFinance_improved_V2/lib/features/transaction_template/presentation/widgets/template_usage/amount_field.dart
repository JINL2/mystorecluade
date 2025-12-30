/// Amount Field - Amount input with calculator button
///
/// Purpose: Amount input field with thousand separator formatting
/// Optionally shows exchange rate calculator button for multi-currency companies
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/shared/utils/thousand_separator_formatter.dart';

/// Amount input field with optional calculator button
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool showCalculatorButton;
  final VoidCallback? onCalculatorPressed;
  final ValueChanged<String>? onChanged;

  const AmountField({
    super.key,
    required this.controller,
    this.errorText,
    this.showCalculatorButton = false,
    this.onCalculatorPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TossTextField(
                controller: controller,
                label: 'Amount',
                isRequired: true,
                hintText: 'Enter amount (e.g., 1,000,000)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ThousandSeparatorInputFormatter(),
                ],
                onChanged: onChanged,
              ),
            ),
            if (showCalculatorButton) ...[
              const SizedBox(width: TossSpacing.space2),
              Container(
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: onCalculatorPressed,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      child: const Icon(
                        Icons.calculate_outlined,
                        color: TossColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: TossSpacing.space1),
          Text(
            errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
