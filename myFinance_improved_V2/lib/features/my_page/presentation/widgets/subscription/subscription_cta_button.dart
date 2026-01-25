import 'dart:io';

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
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
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
  final VoidCallback? onRedeemOfferCode;

  // Trial-specific properties
  final bool isOnTrial;
  final int trialDaysRemaining;
  final DateTime? trialEndDate;

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
    this.onRedeemOfferCode,
    // Trial defaults
    this.isOnTrial = false,
    this.trialDaysRemaining = 0,
    this.trialEndDate,
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
      buttonColor = TossColors.primary;
      showGradient = true;
    } else if (_isDowngrade) {
      canPurchase = false;
      buttonText = 'Manage in Settings';
      buttonColor = TossColors.gray300;
      showGradient = false;
    } else {
      canPurchase = true;
      buttonText = 'Start 7-Day Free Trial';
      buttonColor = selectedPlanIndex == 1 ? TossColors.primary : TossColors.emerald;
      showGradient = true;
    }

    // Banner color based on current plan
    final Color bannerColor = isProPlan
        ? TossColors.primary
        : TossColors.emerald;

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
                color: isOnTrial
                    ? TossColors.info.withValues(alpha: TossOpacity.light)
                    : bannerColor.withValues(alpha: TossOpacity.light),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: isOnTrial
                      ? TossColors.info.withValues(alpha: TossOpacity.strong)
                      : bannerColor.withValues(alpha: TossOpacity.strong),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isOnTrial
                        ? LucideIcons.gift
                        : (isProPlan ? LucideIcons.crown : LucideIcons.checkCircle),
                    color: isOnTrial ? TossColors.info : bannerColor,
                    size: TossSpacing.iconSM,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOnTrial
                              ? 'You\'re on a $_currentPlanName trial!'
                              : 'You\'re a $_currentPlanName subscriber!',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: isOnTrial ? TossColors.info : bannerColor,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1 / 2),
                        if (isOnTrial) ...[
                          Row(
                            children: [
                              Icon(
                                LucideIcons.clock,
                                size: TossSpacing.iconXS,
                                color: trialDaysRemaining <= 3
                                    ? TossColors.warning
                                    : TossColors.gray600,
                              ),
                              SizedBox(width: TossSpacing.space1),
                              Text(
                                trialDaysRemaining > 0
                                    ? '$trialDaysRemaining days remaining'
                                    : 'Trial ends today',
                                style: TossTextStyles.small.copyWith(
                                  color: trialDaysRemaining <= 3
                                      ? TossColors.warning
                                      : TossColors.gray600,
                                  fontWeight: trialDaysRemaining <= 3
                                      ? TossFontWeight.semibold
                                      : TossFontWeight.regular,
                                ),
                              ),
                            ],
                          ),
                        ] else if (expirationDate != null) ...[
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
                  // Trial badge
                  if (isOnTrial)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: trialDaysRemaining <= 3
                            ? TossColors.warning.withValues(alpha: TossOpacity.medium)
                            : TossColors.info.withValues(alpha: TossOpacity.medium),
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Text(
                        'TRIAL',
                        style: TossTextStyles.small.copyWith(
                          color: trialDaysRemaining <= 3
                              ? TossColors.warning
                              : TossColors.info,
                          fontWeight: TossFontWeight.bold,
                          fontSize: 10,
                        ),
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
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4 + 2),
              decoration: BoxDecoration(
                gradient: (showGradient && !isPurchasing)
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: selectedPlanIndex == 1
                            ? [TossColors.primary, TossColors.violet]
                            : [TossColors.emerald, TossColors.emeraldDark],
                      )
                    : null,
                color: (!showGradient || isPurchasing) ? buttonColor : null,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                boxShadow: (showGradient && !isPurchasing)
                    ? [
                        BoxShadow(
                          color: buttonColor.withValues(alpha: TossOpacity.medium),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isPurchasing
                    ? TossLoadingView.inline(
                        size: TossSpacing.iconMD2,
                        color: TossColors.gray500,
                      )
                    : Text(
                        buttonText,
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: canPurchase ? TossColors.white : TossColors.gray500,
                          fontWeight: TossFontWeight.bold,
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
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
              child: Text(
                'Restore previous purchases',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: TossFontWeight.medium,
                ),
              ),
            ),
          ),

          // Offer Code link (iOS only)
          if (Platform.isIOS && onRedeemOfferCode != null)
            GestureDetector(
              onTap: isPurchasing
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      onRedeemOfferCode!();
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Text(
                  'Have an Offer Code?',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: TossFontWeight.medium,
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
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2, horizontal: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.info.withValues(alpha: TossOpacity.light),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.info.withValues(alpha: TossOpacity.strong),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.refreshCw,
                          size: TossSpacing.iconXS,
                          color: TossColors.info,
                        ),
                        SizedBox(width: TossSpacing.space1_5),
                        Text(
                          '🔄 Sync DB',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.info,
                            fontWeight: TossFontWeight.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                // Cancel Button
                GestureDetector(
                  onTap: isPurchasing
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          onManageSubscription();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2, horizontal: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.error.withValues(alpha: TossOpacity.light),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      border: Border.all(
                        color: TossColors.error.withValues(alpha: TossOpacity.strong),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.settings,
                          size: TossSpacing.iconXS,
                          color: TossColors.error,
                        ),
                        SizedBox(width: TossSpacing.space1_5),
                        Text(
                          '⚙️ Manage',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.error,
                            fontWeight: TossFontWeight.medium,
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
