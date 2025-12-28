import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

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
        height: 260,
        child: Center(child: CircularProgressIndicator()),
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
            color: const Color(0xFF10B981),
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
            color: const Color(0xFF3B82F6),
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
        color: const Color(0xFF10B981),
        isPopular: false,
      ),
      PlanData(
        name: 'Pro',
        monthlyPrice: 149,
        annualPrice: 89,
        tagline: 'Most Popular',
        features: ['Unlimited', 'Unlimited', 'Unlimited AI'],
        color: const Color(0xFF3B82F6),
        isPopular: true,
      ),
    ];
    return _buildPricingCardsList(context, plans);
  }

  Widget _buildPricingCardsList(BuildContext context, List<PlanData> plans) {
    return SizedBox(
      height: 260,
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
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * 0.44,
              margin: EdgeInsets.only(
                right: index < plans.length - 1 ? TossSpacing.space3 : 0,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: isSelected ? plan.color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? plan.color : TossColors.gray200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: plan.color.withValues(alpha: 0.3),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : plan.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '⭐ BEST VALUE',
                        style: TossTextStyles.small.copyWith(
                          color: isSelected ? Colors.white : plan.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  else if (isCurrentPlan)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : TossColors.gray100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.check,
                            size: 10,
                            color: isSelected ? Colors.white : TossColors.gray600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'CURRENT',
                            style: TossTextStyles.small.copyWith(
                              color: isSelected ? Colors.white : TossColors.gray600,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 22),

                  const Spacer(),

                  // Plan name
                  Text(
                    plan.name,
                    style: TossTextStyles.h3.copyWith(
                      color: isSelected ? Colors.white : TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$$price',
                        style: TossTextStyles.h1.copyWith(
                          fontSize: 36,
                          color: isSelected ? Colors.white : plan.color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '/mo',
                          style: TossTextStyles.caption.copyWith(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.7)
                                : TossColors.gray500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isAnnual) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Billed annually',
                      style: TossTextStyles.small.copyWith(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.7)
                            : TossColors.gray400,
                        fontSize: 11,
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Features preview
                  ...plan.features.map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.check,
                              size: 14,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : TossColors.gray500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              feature,
                              style: TossTextStyles.small.copyWith(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : TossColors.gray600,
                                fontWeight: FontWeight.w500,
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
