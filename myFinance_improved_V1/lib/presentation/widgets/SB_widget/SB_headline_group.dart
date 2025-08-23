import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

/// SB Headline Group Component
/// A reusable section headline component with consistent styling
/// Used for section headers like "Team Members", "Settings", etc.
class SBHeadlineGroup extends StatelessWidget {
  final String title;
  final Color? textColor;
  final EdgeInsets? padding;

  const SBHeadlineGroup({
    super.key,
    required this.title,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: padding ?? EdgeInsets.only(
        bottom: TossSpacing.space3,
      ),
      child: Text(
        title,
        style: TossTextStyles.h3.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor ?? TossColors.gray900,
        ),
      ),
    );
  }
}