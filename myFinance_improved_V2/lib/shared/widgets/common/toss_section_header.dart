import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

/// Section header widget with consistent styling
class TossSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Widget? trailing;
  final EdgeInsets? padding;

  const TossSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.fontWeight,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? TossColors.primary,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space2),
          ],
          Expanded(
            child: Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: textColor ?? TossColors.gray900,
                fontWeight: fontWeight ?? FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}