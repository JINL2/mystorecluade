import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'help_badge.dart';

/// A section header widget for product forms
///
/// Displays a title with optional help badge and action button.
/// Used to introduce sections like "Attributes", "Pricing", "Inventory".
class FormSectionHeader extends StatelessWidget {
  final String title;
  final bool showHelpBadge;
  final String? actionText;
  final VoidCallback? onActionTap;
  final VoidCallback? onHelpTap;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.showHelpBadge = false,
    this.actionText,
    this.onActionTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              if (showHelpBadge) ...[
                const SizedBox(width: 8),
                HelpBadge(onTap: onHelpTap),
              ],
            ],
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
