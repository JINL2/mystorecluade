import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import 'subscription_models.dart';

/// Horizontal scrolling pricing cards for subscription plans
class PricingCards extends ConsumerWidget {
  final bool isAnnual;
  final int selectedPlanIndex;
  final bool isProPlan;
  final bool isBasicPlan;
  final ValueChanged<int> onPlanSelected;

  const PricingCards({
    super.key,
    required this.isAnnual,
    required this.selectedPlanIndex,
    required this.isProPlan,
    required this.isBasicPlan,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch subscription plans from database
    final plansAsync = ref.watch(subscriptionPlansProvider);

    return plansAsync.when(
      loading: () => const SizedBox(
        height: TossDimensions.pricingCardHeight,
        child: TossLoadingView(),
      ),
      error: (e, _) => _buildFallbackPricingCards(context),
      data: (dbPlans) {
        // Filter to only Basic and Pro plans
        final basicPlan = dbPlans.where((p) => p.planName == 'basic').firstOrNull;
        final proPlan = dbPlans.where((p) => p.planName == 'pro').firstOrNull;

        if (basicPlan == null || proPlan == null) {
          return _buildFallbackPricingCards(context);
        }

        final plans = [
          PlanData(
            name: basicPlan.displayName,
            monthlyPrice: basicPlan.priceMonthly.toInt(),
            annualPrice: basicPlan.annualPricePerMonth.round(),
            tagline: basicPlan.description,
            features: [
              '${basicPlan.maxStores ?? "Unlimited"} Stores',
              '${basicPlan.maxEmployees ?? "Unlimited"} Employees',
              basicPlan.hasUnlimitedAI ? 'Unlimited AI' : '${basicPlan.aiDailyLimit} AI/day',
            ],
            color: TossColors.emerald,
            isPopular: false,
          ),
          PlanData(
            name: proPlan.displayName,
            monthlyPrice: proPlan.priceMonthly.toInt(),
            annualPrice: proPlan.annualPricePerMonth.round(),
            tagline: 'Most Popular',
            features: [
              proPlan.hasUnlimitedStores ? 'Unlimited' : '${proPlan.maxStores} Stores',
              proPlan.hasUnlimitedEmployees ? 'Unlimited' : '${proPlan.maxEmployees} Employees',
              proPlan.hasUnlimitedAI ? 'Unlimited AI' : '${proPlan.aiDailyLimit} AI/day',
            ],
            color: TossColors.primary,
            isPopular: true,
          ),
        ];

        return _buildPricingCardsList(context, plans);
      },
    );
  }

  /// Fallback pricing cards when DB fetch fails
  Widget _buildFallbackPricingCards(BuildContext context) {
    final plans = [
      PlanData(
        name: 'Basic',
        monthlyPrice: 49,
        annualPrice: 29,
        tagline: 'For small teams',
        features: ['5 Stores', '10 Employees', '20 AI/day'],
        color: TossColors.emerald,
        isPopular: false,
      ),
      PlanData(
        name: 'Pro',
        monthlyPrice: 149,
        annualPrice: 89,
        tagline: 'Most Popular',
        features: ['Unlimited', 'Unlimited', 'Unlimited AI'],
        color: TossColors.primary,
        isPopular: true,
      ),
    ];
    return _buildPricingCardsList(context, plans);
  }

  Widget _buildPricingCardsList(BuildContext context, List<PlanData> plans) {
    return SizedBox(
      height: TossDimensions.pricingCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = selectedPlanIndex == index;
          // Check if this plan is the user's current active subscription
          final isCurrentPlan = (index == 0 && isBasicPlan) || (index == 1 && isProPlan);
          final price = isAnnual ? plan.annualPrice : plan.monthlyPrice;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onPlanSelected(index);
            },
            child: AnimatedContainer(
              duration: TossAnimations.normal,
              width: MediaQuery.of(context).size.width * 0.44,
              margin: EdgeInsets.only(
                right: index < plans.length - 1 ? TossSpacing.space3 : 0,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: isSelected ? plan.color : TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: isSelected ? plan.color : TossColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: plan.color.withValues(alpha: TossOpacity.strong),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Popular badge or Current badge
                  if (plan.isPopular && !isCurrentPlan)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? TossColors.white.withValues(alpha: TossOpacity.strong)
                            : plan.color.withValues(alpha: TossOpacity.light),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        '⭐ BEST VALUE',
                        style: TossTextStyles.small.copyWith(
                          color: isSelected ? TossColors.white : plan.color,
                          fontWeight: TossFontWeight.bold,
                        ),
                      ),
                    )
                  else if (isCurrentPlan)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? TossColors.white.withValues(alpha: TossOpacity.strong)
                            : TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.check,
                            size: TossSpacing.iconXXS,
                            color: isSelected ? TossColors.white : TossColors.gray600,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            'CURRENT',
                            style: TossTextStyles.small.copyWith(
                              color: isSelected ? TossColors.white : TossColors.gray600,
                              fontWeight: TossFontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: TossSpacing.space5 + TossSpacing.space0_5),

                  const Spacer(),

                  // Plan name
                  Text(
                    plan.name,
                    style: TossTextStyles.h3.copyWith(
                      color: isSelected ? TossColors.white : TossColors.gray900,
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space1),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$$price',
                        style: TossTextStyles.display.copyWith(
                          color: isSelected ? TossColors.white : plan.color,
                          fontWeight: TossFontWeight.extraBold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: TossSpacing.space1 + TossSpacing.space0_5),
                        child: Text(
                          '/mo',
                          style: TossTextStyles.caption.copyWith(
                            color: isSelected
                                ? TossColors.white.withValues(alpha: TossOpacity.secondaryOnDark)
                                : TossColors.gray500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isAnnual) ...[
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      'Billed annually',
                      style: TossTextStyles.small.copyWith(
                        color: isSelected
                            ? TossColors.white.withValues(alpha: TossOpacity.secondaryOnDark)
                            : TossColors.gray400,
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Features preview
                  ...plan.features.map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: TossSpacing.space1),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.check,
                              size: TossSpacing.iconXS,
                              color: isSelected
                                  ? TossColors.white.withValues(alpha: TossOpacity.textHigh)
                                  : TossColors.gray500,
                            ),
                            SizedBox(width: TossSpacing.space1 + TossSpacing.space0_5),
                            Text(
                              feature,
                              style: TossTextStyles.small.copyWith(
                                color: isSelected
                                    ? TossColors.white.withValues(alpha: TossOpacity.textHigh)
                                    : TossColors.gray600,
                                fontWeight: TossFontWeight.medium,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
