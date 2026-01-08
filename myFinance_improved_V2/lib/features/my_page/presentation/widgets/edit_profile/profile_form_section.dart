import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Reusable form section container with header
class ProfileFormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const ProfileFormSection({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Section Header
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: TossDimensions.dividerThickness,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    title,
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
            // Form content
            Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
