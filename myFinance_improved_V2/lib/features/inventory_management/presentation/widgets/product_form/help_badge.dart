import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// A small help badge widget with a question mark
///
/// Displays a circular badge with "?" that can be tapped to show help information.
class HelpBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const HelpBadge({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: TossDimensions.badgeHeight,
        height: TossDimensions.badgeHeight,
        decoration: const BoxDecoration(
          color: TossColors.gray100,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: TossTextStyles.caption.copyWith(
            fontWeight: TossFontWeight.medium,
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }
}
