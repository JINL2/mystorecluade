import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// CTA Button section with subscription info banner and action buttons
class SubscriptionCtaButton extends ConsumerWidget {
  final bool isAnnual;
  final int selectedPlanIndex;
  final bool hasActiveSubscription;
  final bool isProPlan;
  final bool isBasicPlan;
  final DateTime? expirationDate;
  final bool willRenew;
  final bool isPurchasing;
  final bool isLoadingPackages;
  final VoidCallback onSubscribe;
  final VoidCallback onRestorePurchases;
  final VoidCallback onManageSubscription;
  final VoidCallback onSyncToDatabase;

  const SubscriptionCtaButton({
    super.key,
    required this.isAnnual,
    required this.selectedPlanIndex,
    required this.hasActiveSubscription,
    required this.isProPlan,
    required this.isBasicPlan,
    this.expirationDate,
    required this.willRenew,
    required this.isPurchasing,
    required this.isLoadingPackages,
    required this.onSubscribe,
    required this.onRestorePurchases,
    required this.onManageSubscription,
    required this.onSyncToDatabase,
  });

  String get _currentPlanName {
    if (isProPlan) return 'Pro';
    if (isBasicPlan) return 'Basic';
    return 'Free';
  }

  bool get _isSelectedPlanSameAsCurrent {
    if (!hasActiveSubscription) return false;
    if (selectedPlanIndex == 0 && isBasicPlan) return true;
    if (selectedPlanIndex == 1 && isProPlan) return true;
    return false;
  }

  bool get _isUpgrade {
    if (!hasActiveSubscription) return false;
    return isBasicPlan && selectedPlanIndex == 1;
  }

  bool get _isDowngrade {
    if (!hasActiveSubscription) return false;
    return isProPlan && selectedPlanIndex == 0;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get prices from database (with fallback)
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final plans = plansAsync.valueOrNull ?? [];
    final basicPlan = plans.where((p) => p.planName == 'basic').firstOrNull;
    final proPlan = plans.where((p) => p.planName == 'pro').firstOrNull;

    final int price;
    if (isAnnual) {
      price = selectedPlanIndex == 0
          ? (basicPlan?.annualPricePerMonth.round() ?? 29)
          : (proPlan?.annualPricePerMonth.round() ?? 89);
    } else {
      price = selectedPlanIndex == 0
          ? (basicPlan?.priceMonthly.toInt() ?? 49)
          : (proPlan?.priceMonthly.toInt() ?? 149);
    }

    // Determine button state and text
    final bool canPurchase;
    final String buttonText;
    final Color buttonColor;
    final bool showGradient;

    if (_isSelectedPlanSameAsCurrent) {
      canPurchase = false;
      buttonText = willRenew ? 'Current Plan ✓' : 'Expires ${_formatShortDate(expirationDate!)}';
      buttonColor = TossColors.gray200;
      showGradient = false;
    } else if (_isUpgrade) {
      canPurchase = true;
      buttonText = 'Upgrade to Pro';
      buttonColor = const Color(0xFF3B82F6);
      showGradient = true;
    } else if (_isDowngrade) {
      canPurchase = false;
      buttonText = 'Manage in Settings';
      buttonColor = TossColors.gray300;
      showGradient = false;
    } else {
      canPurchase = true;
      buttonText = 'Start 7-Day Free Trial';
      buttonColor = selectedPlanIndex == 1 ? const Color(0xFF3B82F6) : const Color(0xFF10B981);
      showGradient = true;
    }

    // Banner color based on current plan
    final Color bannerColor = isProPlan
        ? const Color(0xFF3B82F6)
        : const Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Subscription info banner (if already subscribed)
          if (hasActiveSubscription) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              margin: const EdgeInsets.only(bottom: TossSpacing.space3),
              decoration: BoxDecoration(
                color: bannerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: bannerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isProPlan ? LucideIcons.crown : LucideIcons.checkCircle,
                    color: bannerColor,
                    size: 20,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re a $_currentPlanName subscriber!',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: bannerColor,
                          ),
                        ),
                        if (expirationDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            willRenew
                                ? 'Renews on ${_formatDate(expirationDate!)}'
                                : 'Expires on ${_formatDate(expirationDate!)}',
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Main CTA
          GestureDetector(
            onTap: (!canPurchase || isPurchasing || isLoadingPackages)
                ? (_isDowngrade ? onManageSubscription : null)
                : () {
                    HapticFeedback.mediumImpact();
                    onSubscribe();
                  },
            child: AnimatedContainer(
              duration: TossAnimations.normal,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: (showGradient && !isPurchasing)
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: selectedPlanIndex == 1
                            ? [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)]
                            : [const Color(0xFF10B981), const Color(0xFF059669)],
                      )
                    : null,
                color: (!showGradient || isPurchasing) ? buttonColor : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: (showGradient && !isPurchasing)
                    ? [
                        BoxShadow(
                          color: buttonColor.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isPurchasing
                    ? TossLoadingView.inline(
                        size: 24,
                        color: TossColors.gray500,
                      )
                    : Text(
                        buttonText,
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: canPurchase ? TossColors.white : TossColors.gray500,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Price reminder (only for new subscriptions or upgrades)
          if (canPurchase && !isPurchasing)
            Text(
              hasActiveSubscription
                  ? 'Prorated amount will be charged'
                  : 'Then \$$price/month${isAnnual ? ' (billed annually)' : ''}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),

          const SizedBox(height: TossSpacing.space2),

          // Restore purchases link
          GestureDetector(
            onTap: isPurchasing
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    onRestorePurchases();
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Restore previous purchases',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // DEBUG buttons (DEBUG only)
          if (kDebugMode && hasActiveSubscription) ...[
            const SizedBox(height: TossSpacing.space2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sync Button
                GestureDetector(
                  onTap: isPurchasing
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onSyncToDatabase();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: TossColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.info.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.refreshCw,
                          size: 14,
                          color: TossColors.info,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '🔄 Sync DB',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.info,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Cancel Button
                GestureDetector(
                  onTap: isPurchasing
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onManageSubscription();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: TossColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.settings,
                          size: 14,
                          color: TossColors.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '⚙️ Manage',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
