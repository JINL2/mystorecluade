import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/app/providers/app_state.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Subscription Section Widget for My Page
///
/// Shows current plan with enticing upgrade CTA.
/// Design inspired by Spotify, Netflix, and modern SaaS apps.
///
/// ⚠️ IMPORTANT: This widget uses RevenueCat's actual subscription status
/// via subscriptionProvider, NOT the database planType from AppState.
/// This ensures UI accurately reflects the real subscription state.
class SubscriptionSection extends ConsumerWidget {
  final VoidCallback? onTap;

  const SubscriptionSection({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    // ✅ Use RevenueCat subscription status (source of truth)
    final proStatusAsync = ref.watch(proStatusProvider);

    // Handle loading state - show skeleton while fetching
    if (proStatusAsync.isLoading) {
      return _buildLoadingCard(context);
    }

    final isPro = proStatusAsync.valueOrNull ?? false;
    final planType = isPro ? 'pro' : 'free';
    final isFreePlan = !isPro;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) {
          onTap!();
        } else {
          context.push('/subscription');
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          gradient: isFreePlan
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(planType),
                ),
          color: isFreePlan ? TossColors.white : null,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: [
            BoxShadow(
              color: isFreePlan
                  ? TossColors.gray900.withValues(alpha: TossOpacity.subtle)
                  : _getPrimaryColor(planType).withValues(alpha: TossOpacity.strong),
              blurRadius: isFreePlan ? 8 : 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isFreePlan
            ? _buildFreeCard(context, appState)
            : _buildPremiumCard(context, appState, planType),
      ),
    );
  }

  /// Free plan card - enticing upgrade design
  Widget _buildFreeCard(BuildContext context, AppState appState) {
    return Stack(
      children: [
        // Subtle background pattern
        Positioned(
          right: -20,
          top: -20,
          child: Icon(
            LucideIcons.sparkles,
            size: TossDimensions.avatarHero,
            color: TossColors.primary.withValues(alpha: TossOpacity.subtle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Plan icon
                  Container(
                    width: TossSpacing.space12,
                    height: TossSpacing.space12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TossColors.primary.withValues(alpha: TossOpacity.light),
                          TossColors.info.withValues(alpha: TossOpacity.light),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Icon(
                      LucideIcons.crown,
                      color: TossColors.primary,
                      size: TossSpacing.iconMD2,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Current Plan',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                                fontWeight: TossFontWeight.medium,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            SubscriptionBadge.fromPlanType('free', compact: true),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space0_5),
                        Text(
                          'Free Plan',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: TossFontWeight.bold,
                            color: TossColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: TossColors.textTertiary,
                    size: TossSpacing.iconMD2,
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space4),

              // Divider
              Container(
                height: TossDimensions.dividerThickness,
                color: TossColors.gray100,
              ),

              const SizedBox(height: TossSpacing.space4),

              // Usage limits
              _buildUsageRow(
                icon: LucideIcons.store,
                label: 'Stores',
                current: '1',
                limit: '/${appState.maxStores}',
                color: TossColors.primary,
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildUsageRow(
                icon: LucideIcons.users,
                label: 'Employees',
                current: '3',
                limit: '/${appState.maxEmployees}',
                color: TossColors.info,
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildUsageRow(
                icon: LucideIcons.sparkles,
                label: 'AI Reports',
                current: '0',
                limit: '/${appState.aiDailyLimit}/day',
                color: TossColors.warning,
              ),

              const SizedBox(height: TossSpacing.space5),

              // Upgrade CTA
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: TossSpacing.space3 + TossSpacing.space0_5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      TossColors.primary,
                      TossColors.purpleDark, // Indigo
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.primary.withValues(alpha: TossOpacity.heavy),
                      blurRadius: TossSpacing.space2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.rocket,
                      color: TossColors.white,
                      size: TossSpacing.iconSM,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Upgrade to Pro',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.white,
                        fontWeight: TossFontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Premium plan card - celebration design
  Widget _buildPremiumCard(BuildContext context, AppState appState, String planType) {
    final isPro = planType.toLowerCase() == 'pro';
    final planName = isPro ? 'Pro' : 'Basic';

    return Stack(
      children: [
        // Decorative elements
        Positioned(
          right: -TossSpacing.space8,
          top: -TossSpacing.space8,
          child: Icon(
            LucideIcons.crown,
            size: TossDimensions.decorativeIconLG,
            color: TossColors.white.withValues(alpha: TossOpacity.light),
          ),
        ),
        Positioned(
          left: -TossSpacing.space5,
          bottom: -TossSpacing.space5,
          child: Icon(
            LucideIcons.sparkles,
            size: TossDimensions.decorativeIconMD,
            color: TossColors.white.withValues(alpha: TossOpacity.hover),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Plan icon with glow
                  Container(
                    width: TossSpacing.space12,
                    height: TossSpacing.space12,
                    decoration: BoxDecoration(
                      color: TossColors.white.withValues(alpha: TossOpacity.strong),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: TossColors.white.withValues(alpha: TossOpacity.heavy),
                        width: TossDimensions.dividerThickness,
                      ),
                    ),
                    child: Icon(
                      isPro ? LucideIcons.crown : LucideIcons.star,
                      color: TossColors.white,
                      size: TossSpacing.iconMD2,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.white.withValues(alpha: TossOpacity.modalBackdrop),
                            fontWeight: TossFontWeight.medium,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space0_5),
                        Text(
                          '$planName Plan',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: TossFontWeight.bold,
                            color: TossColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.white.withValues(alpha: TossOpacity.strong),
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      border: Border.all(
                        color: TossColors.white.withValues(alpha: TossOpacity.heavy),
                        width: TossDimensions.dividerThickness,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.check,
                          color: TossColors.white,
                          size: TossSpacing.iconXS,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          'Active',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.white,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space5),

              // Features row
              Row(
                children: [
                  _buildFeatureChip(
                    icon: LucideIcons.store,
                    label: isPro ? 'Unlimited' : '${appState.maxStores} Stores',
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFeatureChip(
                    icon: LucideIcons.users,
                    label: isPro ? 'Unlimited' : '${appState.maxEmployees} Staff',
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  _buildFeatureChip(
                    icon: LucideIcons.sparkles,
                    label: isPro ? 'Unlimited AI' : '${appState.aiDailyLimit}/day',
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space4),

              // Manage subscription link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manage subscription',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.white.withValues(alpha: TossOpacity.textHigh),
                      fontWeight: TossFontWeight.medium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: TossColors.white.withValues(alpha: TossOpacity.modalBackdrop),
                    size: TossSpacing.iconMD2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUsageRow({
    required IconData icon,
    required String label,
    required String current,
    required String limit,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: TossSpacing.space8,
          height: TossSpacing.space8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: TossOpacity.light),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            icon,
            color: color,
            size: TossSpacing.iconSM2,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: current,
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              TextSpan(
                text: limit,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.white.withValues(alpha: TossOpacity.medium),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: TossColors.white,
              size: TossSpacing.iconSM,
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              label,
              style: TossTextStyles.small.copyWith(
                color: TossColors.white,
                fontWeight: TossFontWeight.semibold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String planType) {
    switch (planType.toLowerCase()) {
      case 'pro':
        return [
          TossColors.primary, // Blue
          TossColors.violet, // Purple
        ];
      case 'basic':
        return [
          TossColors.emerald, // Emerald
          TossColors.emeraldDark, // Green
        ];
      default:
        return [TossColors.gray100, TossColors.gray200];
    }
  }

  Color _getPrimaryColor(String planType) {
    switch (planType.toLowerCase()) {
      case 'pro':
        return TossColors.primary;
      case 'basic':
        return TossColors.emerald;
      default:
        return TossColors.gray500;
    }
  }

  /// Loading card shown while fetching subscription status from RevenueCat
  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withValues(alpha: TossOpacity.subtle),
            blurRadius: TossSpacing.space2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            children: [
              // Icon placeholder
              Container(
                width: TossSpacing.space12,
                height: TossSpacing.space12,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: TossSpacing.space20,
                      height: TossSpacing.space3,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Container(
                      width: TossSpacing.space20 + TossSpacing.space10,
                      height: TossSpacing.space5,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          // Loading indicator
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TossLoadingView.inline(
                  size: TossSpacing.iconSM2,
                  color: TossColors.gray400,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Checking subscription...',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
