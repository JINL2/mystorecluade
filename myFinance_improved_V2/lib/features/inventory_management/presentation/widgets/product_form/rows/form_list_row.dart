import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../help_badge.dart';

/// A reusable list row widget for product forms
///
/// Used in both AddProductPage and EditProductPage for consistent styling.
/// Displays a label with optional help badge and a value/placeholder with optional chevron.
class FormListRow extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final bool showChevron;
  final bool showHelpBadge;
  final bool isValueActive;
  final bool isRequired;
  final VoidCallback? onTap;
  final VoidCallback? onHelpTap;

  const FormListRow({
    super.key,
    required this.label,
    this.value,
    required this.placeholder,
    this.showChevron = false,
    this.showHelpBadge = false,
    this.isValueActive = false,
    this.isRequired = false,
    this.onTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray600,
                        ),
                      ),
                      if (isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: TossColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showHelpBadge) ...[
                  const SizedBox(width: 8),
                  HelpBadge(onTap: onHelpTap),
                ],
              ],
            ),
            // Value and chevron
            Row(
              children: [
                Text(
                  hasValue ? value! : placeholder,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: hasValue && isValueActive
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: hasValue && isValueActive
                        ? TossColors.gray900
                        : TossColors.gray500,
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: TossColors.gray500,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
