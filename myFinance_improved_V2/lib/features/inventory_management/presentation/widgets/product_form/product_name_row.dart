import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Product name input row with required indicator
///
/// A specialized row for entering product names with required field styling.
class ProductNameRow extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;

  const ProductNameRow({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: TossSpacing.buttonHeightLG),
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label with required indicator
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Product name',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.medium,
                    color: TossColors.gray600,
                  ),
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: TossColors.error,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
              ],
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
                    style: TossTextStyles.body.copyWith(
                      fontWeight: TossFontWeight.regular,
                      color: TossColors.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: isFocused || controller.text.isNotEmpty
                          ? null
                          : 'Enter product name',
                      hintStyle: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.regular,
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
                const SizedBox(width: TossSpacing.badgePaddingHorizontalXS),
                const Icon(
                  Icons.chevron_right,
                  size: TossSpacing.iconSM,
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
