import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Filter tab widget for session review
class ReviewFilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;

  const ReviewFilterTab({
    super.key,
    required this.label,
    required this.isActive,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? TossColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        margin: const EdgeInsets.only(right: TossSpacing.space2),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : TossColors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(
            color: isActive ? activeColor : TossColors.gray200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isActive ? activeColor : TossColors.textSecondary,
            fontWeight: isActive ? TossFontWeight.semibold : TossFontWeight.regular,
          ),
        ),
      ),
    );
  }
}
