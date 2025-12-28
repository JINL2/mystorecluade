import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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
      bgColor = const Color(0xFF3B82F6).withValues(alpha: 0.1);
      textColor = const Color(0xFF3B82F6);
      icon = LucideIcons.crown;
    } else if (isBasicPlan) {
      planText = 'Basic Plan';
      bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
      textColor = const Color(0xFF10B981);
      icon = LucideIcons.checkCircle;
    } else {
      planText = 'Free Plan';
      bgColor = TossColors.gray100;
      textColor = TossColors.gray600;
      icon = LucideIcons.user;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: textColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 8),
          Text(
            'Current: $planText',
            style: TossTextStyles.body.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (hasActiveSubscription && expirationDate != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              willRenew
                  ? 'Renews ${_formatShortDate(expirationDate!)}'
                  : 'Expires ${_formatShortDate(expirationDate!)}',
              style: TossTextStyles.small.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
