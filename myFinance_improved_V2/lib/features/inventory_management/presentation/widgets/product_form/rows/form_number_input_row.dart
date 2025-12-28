import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// A reusable number input row widget for product forms
///
/// Used for numeric inputs like quantity in AddProductPage and EditProductPage.
class FormNumberInputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final bool allowDecimal;

  const FormNumberInputRow({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    this.allowDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([focusNode, controller]),
      builder: (context, _) {
        final bool isFocused = focusNode.hasFocus;
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
              // TextField and chevron
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: allowDecimal,
                        ),
                        inputFormatters: allowDecimal
                            ? [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ]
                            : [FilteringTextInputFormatter.digitsOnly],
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
      },
    );
  }
}
