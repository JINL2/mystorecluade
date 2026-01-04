import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'section_title.dart';

/// Amount input section with optional exchange rate calculator button
///
/// Provides a tappable amount field that opens a numberpad modal,
/// and optionally shows a calculator button for multi-currency support.
class AmountInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasMultipleCurrencies;
  final VoidCallback onAmountTap;
  final VoidCallback onCalculatorTap;

  const AmountInputSection({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasMultipleCurrencies,
    required this.onAmountTap,
    required this.onCalculatorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Amount *'),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onAmountTap,
                child: AbsorbPointer(
                  child: TossEnhancedTextField(
                    controller: controller,
                    hintText: 'Enter amount',
                    keyboardType: TextInputType.none,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.next,
                    showKeyboardToolbar: true,
                    keyboardDoneText: 'Next',
                    enableTapDismiss: false,
                  ),
                ),
              ),
            ),
            if (hasMultipleCurrencies) ...[
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
                    onTap: onCalculatorTap,
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
      ],
    );
  }

  /// Helper to format amount with thousand separators
  static String formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return formatter.format(amount);
  }

  /// Helper to parse formatted amount string to double
  static double? parseAmount(String text) {
    return double.tryParse(text.replaceAll(',', ''));
  }
}
