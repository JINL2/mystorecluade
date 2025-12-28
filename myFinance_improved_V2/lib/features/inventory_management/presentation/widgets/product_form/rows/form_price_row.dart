import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Currency input formatter that adds comma separators
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with commas
    final formatted = _formatWithCommas(digitsOnly);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatWithCommas(String value) {
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

/// A reusable price input row widget for product forms
///
/// Used for price inputs in AddProductPage and EditProductPage.
/// Automatically formats numbers with comma separators.
class FormPriceRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String placeholder;
  final String currencySymbol;

  const FormPriceRow({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.placeholder,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = controller.text.isNotEmpty;

    return Container(
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
          // TextField, currency suffix and chevron
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: isFocused || hasValue ? null : placeholder,
                      hintStyle: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w400,
                        color: TossColors.gray500,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                // Currency suffix
                if (hasValue) ...[
                  Text(
                    currencySymbol,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
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
    );
  }
}
