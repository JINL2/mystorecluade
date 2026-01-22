import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/index.dart';

/// Hero section displaying estimated salary with growth indicator
class HeroSalaryDisplay extends StatelessWidget {
  final String title;
  final String amount;
  final String growthText;
  final bool isPositiveGrowth;
  final VoidCallback? onTitleTap;

  const HeroSalaryDisplay({
    super.key,
    this.title = 'Estimated Salary This Month',
    required this.amount,
    required this.growthText,
    this.isPositiveGrowth = true,
    this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with dropdown (same style as Revenue card)
        GestureDetector(
          onTap: onTitleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TossTextStyles.captionBold,
              ),
              SizedBox(width: TossSpacing.space1),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: TossSpacing.iconSM,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),

        SizedBox(height: TossSpacing.space3),

        // Large amount display
        Text(
          amount,
          style: TossTextStyles.h1,
        ),

        SizedBox(height: TossSpacing.space2 + TossSpacing.space1 / 2),

        // Growth indicator
        Row(
          children: [
            Icon(
              isPositiveGrowth ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
              size: TossSpacing.iconXS,
              color: isPositiveGrowth ? TossColors.primary : TossColors.loss,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              growthText,
              style: isPositiveGrowth
                  ? TossTextStyles.captionPrimary
                  : TossTextStyles.captionError,
            ),
          ],
        ),
      ],
    );
  }
}
