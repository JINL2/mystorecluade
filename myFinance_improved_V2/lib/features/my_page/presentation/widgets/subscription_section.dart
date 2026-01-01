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
                  ? TossColors.gray900.withValues(alpha: 0.04)
                  : _getPrimaryColor(planType).withValues(alpha: 0.3),
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
            size: 120,
            color: TossColors.primary.withValues(alpha: 0.05),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TossColors.primary.withValues(alpha: 0.1),
                          TossColors.info.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: const Icon(
                      LucideIcons.crown,
                      color: TossColors.primary,
                      size: 24,
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            SubscriptionBadge.fromPlanType('free', compact: true),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Free Plan',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: TossColors.textTertiary,
                    size: 24,
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space4),

              // Divider
              Container(
                height: 1,
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
                padding: const EdgeInsets.symmetric(
                  vertical: TossSpacing.space3 + 2,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      TossColors.primary,
                      Color(0xFF6366F1), // Indigo
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.rocket,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Upgrade to Pro',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
          right: -30,
          top: -30,
          child: Icon(
            LucideIcons.crown,
            size: 150,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          left: -20,
          bottom: -20,
          child: Icon(
            LucideIcons.sparkles,
            size: 100,
            color: Colors.white.withValues(alpha: 0.08),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isPro ? LucideIcons.crown : LucideIcons.star,
                      color: Colors.white,
                      size: 24,
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
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$planName Plan',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Active',
                          style: TossTextStyles.small.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 24,
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
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
                  fontWeight: FontWeight.w700,
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
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TossTextStyles.small.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
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
          const Color(0xFF3B82F6), // Blue
          const Color(0xFF8B5CF6), // Purple
        ];
      case 'basic':
        return [
          const Color(0xFF10B981), // Emerald
          const Color(0xFF059669), // Green
        ];
      default:
        return [TossColors.gray100, TossColors.gray200];
    }
  }

  Color _getPrimaryColor(String planType) {
    switch (planType.toLowerCase()) {
      case 'pro':
        return const Color(0xFF3B82F6);
      case 'basic':
        return const Color(0xFF10B981);
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
            color: TossColors.gray900.withValues(alpha: 0.04),
            blurRadius: 8,
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
                width: 48,
                height: 48,
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
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 20,
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
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: TossColors.gray400,
                  ),
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
