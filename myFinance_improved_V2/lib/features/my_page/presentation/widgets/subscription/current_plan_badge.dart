import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

/// Badge showing the user's current subscription plan status
class CurrentPlanBadge extends StatelessWidget {
  final bool isProPlan;
  final bool isBasicPlan;
  final bool hasActiveSubscription;
  final DateTime? expirationDate;
  final bool willRenew;

  const CurrentPlanBadge({
    super.key,
    required this.isProPlan,
    required this.isBasicPlan,
    required this.hasActiveSubscription,
    this.expirationDate,
    required this.willRenew,
  });

  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Determine current plan text and colors
    String planText;
    Color bgColor;
    Color textColor;
    IconData icon;

    if (isProPlan) {
      planText = 'Pro Plan';
      bgColor = TossColors.primary.withValues(alpha: TossOpacity.light);
      textColor = TossColors.primary;
      icon = LucideIcons.crown;
    } else if (isBasicPlan) {
      planText = 'Basic Plan';
      bgColor = TossColors.emerald.withValues(alpha: TossOpacity.light);
      textColor = TossColors.emerald;
      icon = LucideIcons.checkCircle;
    } else {
      planText = 'Free Plan';
      bgColor = TossColors.gray100;
      textColor = TossColors.gray600;
      icon = LucideIcons.user;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space2_5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
        border: Border.all(
          color: textColor.withValues(alpha: TossOpacity.hover),
          width: TossDimensions.dividerThickness,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TossSpacing.iconSM2, color: textColor),
          SizedBox(width: TossSpacing.space2),
          Text(
            'Current: $planText',
            style: TossTextStyles.body.copyWith(
              color: textColor,
              fontWeight: TossFontWeight.semibold,
            ),
          ),
          if (hasActiveSubscription && expirationDate != null) ...[
            SizedBox(width: TossSpacing.space2),
            Container(
              width: TossSpacing.space1,
              height: TossSpacing.space1,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: TossOpacity.medium),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              willRenew
                  ? 'Renews ${_formatShortDate(expirationDate!)}'
                  : 'Expires ${_formatShortDate(expirationDate!)}',
              style: TossTextStyles.small.copyWith(
                color: textColor.withValues(alpha: TossOpacity.textHigh),
                fontWeight: TossFontWeight.medium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
