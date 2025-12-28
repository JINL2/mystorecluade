import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import 'current_plan_badge.dart';

/// Hero section with app icon, headline, and value proposition
class SubscriptionHeroSection extends StatelessWidget {
  final bool isProPlan;
  final bool isBasicPlan;
  final bool hasActiveSubscription;
  final DateTime? expirationDate;
  final bool willRenew;

  const SubscriptionHeroSection({
    super.key,
    required this.isProPlan,
    required this.isBasicPlan,
    required this.hasActiveSubscription,
    this.expirationDate,
    required this.willRenew,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Current Plan Badge
          CurrentPlanBadge(
            isProPlan: isProPlan,
            isBasicPlan: isBasicPlan,
            hasActiveSubscription: hasActiveSubscription,
            expirationDate: expirationDate,
            willRenew: willRenew,
          ),

          const SizedBox(height: TossSpacing.space4),

          // App icon with shadow
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/app icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Headline - Benefit focused
          Text(
            'Unlock Your Full\nBusiness Potential',
            textAlign: TextAlign.center,
            style: TossTextStyles.h1.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: TossColors.gray900,
              height: 1.2,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Subheadline
          Text(
            'Join 10,000+ businesses managing their\nfinances smarter with Pro',
            textAlign: TextAlign.center,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
