import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';

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
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Large amount display
        Text(
          amount,
          style: TossTextStyles.display.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 10),

        // Growth indicator
        Row(
          children: [
            Icon(
              isPositiveGrowth ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
              size: 16,
              color: isPositiveGrowth ? TossColors.primary : TossColors.loss,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              growthText,
              style: TossTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPositiveGrowth ? TossColors.primary : TossColors.loss,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
