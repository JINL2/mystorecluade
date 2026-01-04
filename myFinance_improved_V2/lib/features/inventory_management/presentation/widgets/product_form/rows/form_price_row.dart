import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// A reusable price input row widget for product forms
///
/// Used for price inputs in AddProductPage and EditProductPage.
/// Opens a custom numberpad modal for iOS-friendly decimal input.
class FormPriceRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final String currencySymbol;

  // Legacy parameters - kept for backward compatibility but no longer used
  // ignore: unused_field
  final FocusNode? focusNode;
  // ignore: unused_field
  final bool? isFocused;

  const FormPriceRow({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.currencySymbol,
    this.focusNode, // Optional - no longer used with numberpad modal
    this.isFocused, // Optional - no longer used with numberpad modal
  });

  void _showNumberpadModal(BuildContext context) {
    TossCurrencyExchangeModal.show(
      context: context,
      title: label,
      initialValue: controller.text.isEmpty
          ? null
          : controller.text.replaceAll(',', ''),
      allowDecimal: true,
      maxDecimalPlaces: 2,
      onConfirm: (result) {
        final formatter = NumberFormat('#,##0.##', 'en_US');
        final numericValue = double.tryParse(result) ?? 0;
        if (numericValue > 0) {
          controller.text = formatter.format(numericValue);
        } else {
          controller.text = '';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to listen for controller changes
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final bool hasValue = value.text.isNotEmpty;

        return GestureDetector(
          onTap: () => _showNumberpadModal(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                // Value display and chevron
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Display value or placeholder
                      Flexible(
                        child: Text(
                          hasValue ? value.text : placeholder,
                          textAlign: TextAlign.right,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w400,
                            color: hasValue ? TossColors.gray900 : TossColors.gray500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: TossColors.gray500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
