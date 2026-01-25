import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/core/services/revenuecat_service.dart';
import 'package:myfinance_improved/core/subscription/providers/subscription_state_notifier.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

import '../widgets/subscription/subscription_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Subscription Page - High-Converting Paywall Design
///
/// Based on best practices from top SaaS apps:
/// - Visual hierarchy with highlighted recommended plan
/// - Monthly/Annual toggle with savings badge
/// - Benefit-driven CTAs
/// - Social proof and trust signals
/// - Risk reduction with "Cancel anytime"
class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isAnnual = false;
  int _selectedPlanIndex = 1; // Default to Pro (recommended)

  // RevenueCat state
  bool _isLoadingPackages = true;
  bool _isPurchasing = false;
  List<Package> _packages = [];

  // Current subscription state from RevenueCat
  bool _hasActiveSubscription = false;
  bool _isProPlan = false;
  bool _isBasicPlan = false;
  String? _activeProductId;
  DateTime? _expirationDate;
  bool _willRenew = false;

  // Trial state
  bool _isOnTrial = false;
  int _trialDaysRemaining = 0;
  DateTime? _trialEndDate;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPackages();
      _loadSubscriptionStatus();
    });
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: TossAnimations.iconEmphasis,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 📦 RevenueCat Methods
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _loadPackages() async {
    debugPrint('📦 [SubscriptionPage] _loadPackages() called');
    try {
      setState(() => _isLoadingPackages = true);
      final packages = await RevenueCatService().getAvailablePackages();
      debugPrint('📦 [SubscriptionPage] Loaded ${packages.length} packages');
      if (mounted) {
        setState(() {
          _packages = packages;
          _isLoadingPackages = false;
        });
      }
    } catch (e) {
      debugPrint('📦 [SubscriptionPage] ❌ _loadPackages FAILED: $e');
      if (mounted) {
        setState(() => _isLoadingPackages = false);
      }
    }
  }

  EntitlementInfo? _findEntitlementByMatch(CustomerInfo customerInfo, String target) {
    try {
      final matchingKey = customerInfo.entitlements.active.keys.firstWhere(
        (key) => key.toLowerCase().contains(target.toLowerCase()),
      );
      return customerInfo.entitlements.active[matchingKey];
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadSubscriptionStatus() async {
    debugPrint('📊 [SubscriptionPage] _loadSubscriptionStatus() called');
    try {
      final customerInfo = await RevenueCatService().getCustomerInfo();
      debugPrint('📊 [SubscriptionPage] CustomerInfo received: ${customerInfo != null}');

      if (customerInfo != null && mounted) {
        debugPrint('📊 [SubscriptionPage] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
        final proEntitlement = _findEntitlementByMatch(customerInfo, 'pro');
        final basicEntitlement = _findEntitlementByMatch(customerInfo, 'basic');

        final hasPro = proEntitlement != null;
        final hasBasic = basicEntitlement != null;
        final hasAnySubscription = hasPro || hasBasic;
        final activeEntitlement = proEntitlement ?? basicEntitlement;

        debugPrint('📊 [SubscriptionPage] hasPro: $hasPro, hasBasic: $hasBasic');
        debugPrint('📊 [SubscriptionPage] hasAnySubscription: $hasAnySubscription');

        setState(() {
          _hasActiveSubscription = hasAnySubscription;
          _isProPlan = hasPro;
          _isBasicPlan = hasBasic && !hasPro;

          if (hasAnySubscription && activeEntitlement != null) {
            _activeProductId = activeEntitlement.productIdentifier;
            _expirationDate = activeEntitlement.expirationDate != null
                ? DateTime.parse(activeEntitlement.expirationDate!)
                : null;
            _willRenew = activeEntitlement.willRenew;

            // Extract trial information
            _isOnTrial = activeEntitlement.periodType == PeriodType.trial;
            if (_isOnTrial && _expirationDate != null) {
              _trialEndDate = _expirationDate;
              final now = DateTime.now();
              final difference = _trialEndDate!.difference(now).inDays;
              _trialDaysRemaining = difference > 0 ? difference : 0;
            } else {
              _trialEndDate = null;
              _trialDaysRemaining = 0;
            }

            debugPrint('📊 [SubscriptionPage] Active subscription details:');
            debugPrint('   - productId: $_activeProductId');
            debugPrint('   - expirationDate: $_expirationDate');
            debugPrint('   - willRenew: $_willRenew');
            debugPrint('   - isOnTrial: $_isOnTrial');
            debugPrint('   - trialDaysRemaining: $_trialDaysRemaining');

            if (_activeProductId?.contains('annual') == true ||
                _activeProductId?.contains('yearly') == true) {
              _isAnnual = true;
            } else {
              _isAnnual = false;
            }
            _selectedPlanIndex = hasPro ? 1 : 0;
          }
        });
        debugPrint('📊 [SubscriptionPage] State updated: isProPlan=$_isProPlan, isBasicPlan=$_isBasicPlan');
      }
    } catch (e) {
      debugPrint('📊 [SubscriptionPage] ❌ _loadSubscriptionStatus FAILED: $e');
      // Subscription status load failure is not critical
    }
  }

  String get _currentPlanName {
    if (_isProPlan) return 'Pro';
    if (_isBasicPlan) return 'Basic';
    return 'Free';
  }

  Future<void> _refreshSubscriptionState() async {
    debugPrint('🔄 [SubscriptionPage] _refreshSubscriptionState() called');
    await _loadSubscriptionStatus();

    // Invalidate providers to refresh UI
    ref.invalidate(subscriptionDetailsProvider);
    ref.invalidate(customerInfoProvider);

    // Force refresh SubscriptionStateNotifier (SSOT)
    final userId = ref.read(currentUserIdProvider);
    if (userId != null) {
      await ref.read(subscriptionStateNotifierProvider.notifier).forceRefresh(userId);
    }

    debugPrint('🔄 [SubscriptionPage] ✅ State refresh complete');
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🎯 Purchase Handlers
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _handleSubscribe() async {
    final planName = _selectedPlanIndex == 0 ? 'basic' : 'pro';
    final periodName = _isAnnual ? 'yearly' : 'monthly';
    final targetIdentifier = '$planName.$periodName';

    debugPrint('🛒 [SubscriptionPage] _handleSubscribe() called');
    debugPrint('🛒 [SubscriptionPage] Looking for: $targetIdentifier');
    debugPrint('🛒 [SubscriptionPage] Available packages: ${_packages.length}');

    Package? targetPackage;
    for (final package in _packages) {
      debugPrint('🛒 [SubscriptionPage] Checking package: ${package.identifier} (${package.storeProduct.identifier})');
      if (package.identifier == targetIdentifier) {
        targetPackage = package;
        debugPrint('🛒 [SubscriptionPage] ✅ Found exact match: ${package.identifier}');
        break;
      }
      final productId = package.storeProduct.identifier.toLowerCase();
      if (productId.contains(planName) &&
          ((_isAnnual && (productId.contains('annual') || productId.contains('yearly'))) ||
           (!_isAnnual && productId.contains('monthly')))) {
        targetPackage = package;
        debugPrint('🛒 [SubscriptionPage] ✅ Found partial match: ${package.identifier}');
        break;
      }
    }

    if (targetPackage == null) {
      debugPrint('🛒 [SubscriptionPage] ❌ No matching package found!');
      SubscriptionDialogs.showErrorDialog(
        context,
        message: 'No subscription package found. Please try again later.',
      );
      return;
    }
    debugPrint('🛒 [SubscriptionPage] Target package: ${targetPackage.identifier}');

    // Check if already subscribed
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isAlreadySubscribed = customerInfo.entitlements.active.entries.any((entry) {
        return entry.key.toLowerCase().contains(planName);
      });

      if (isAlreadySubscribed) {
        if (mounted) {
          TossToast.warning(
            context,
            'You already have an active $planName subscription. Use "Manage" to modify it.',
            action: SnackBarAction(
              label: 'Manage',
              textColor: TossColors.white,
              onPressed: _handleCancelSubscription,
            ),
          );
        }
        return;
      }
    } catch (_) {
      // Continue with purchase attempt
    }

    setState(() => _isPurchasing = true);
    debugPrint('🛒 [SubscriptionPage] Starting purchase...');

    try {
      final success = await RevenueCatService().purchasePackage(targetPackage);
      debugPrint('🛒 [SubscriptionPage] Purchase result: $success');

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          debugPrint('🛒 [SubscriptionPage] ✅ Purchase SUCCESS! Refreshing state...');
          await _refreshSubscriptionState();
          SubscriptionDialogs.showSuccessDialog(
            context,
            planName: planName,
            onDismiss: () {},
          );
        }
      }
    } on PurchasesErrorCode catch (e) {
      debugPrint('🛒 [SubscriptionPage] ❌ Purchase error: $e');
      if (mounted) {
        setState(() => _isPurchasing = false);
        if (e != PurchasesErrorCode.purchaseCancelledError) {
          SubscriptionDialogs.showErrorDialog(context, message: 'Purchase failed: ${e.name}');
        }
      }
    } catch (e) {
      debugPrint('🛒 [SubscriptionPage] ❌ Unexpected error: $e');
      if (mounted) {
        setState(() => _isPurchasing = false);
        SubscriptionDialogs.showErrorDialog(context, message: 'An unexpected error occurred. Please try again.');
      }
    }
  }

  Future<void> _handleRestorePurchases() async {
    debugPrint('🔄 [SubscriptionPage] _handleRestorePurchases() called');
    setState(() => _isPurchasing = true);

    try {
      final success = await RevenueCatService().restorePurchases();
      debugPrint('🔄 [SubscriptionPage] Restore result: $success');

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          debugPrint('🔄 [SubscriptionPage] ✅ Restore SUCCESS! Refreshing state...');
          await _refreshSubscriptionState();
          SubscriptionDialogs.showRestoreSuccessDialog(
            context,
            isProPlan: _isProPlan,
            currentPlanName: _currentPlanName,
          );
        } else {
          debugPrint('🔄 [SubscriptionPage] No purchases to restore');
          SubscriptionDialogs.showNoPurchasesDialog(context);
        }
      }
    } catch (e) {
      debugPrint('🔄 [SubscriptionPage] ❌ Restore FAILED: $e');
      if (mounted) {
        setState(() => _isPurchasing = false);
        SubscriptionDialogs.showErrorDialog(context, message: 'Failed to restore purchases. Please try again.');
      }
    }
  }

  Future<void> _handleCancelSubscription() async {
    if (_activeProductId == null) {
      SubscriptionDialogs.showErrorDialog(context, message: 'No active subscription found');
      return;
    }

    setState(() => _isPurchasing = true);

    try {
      Package? currentPackage;
      for (final package in _packages) {
        if (package.storeProduct.identifier == _activeProductId) {
          currentPackage = package;
          break;
        }
      }

      if (currentPackage != null) {
        try {
          await Purchases.purchasePackage(currentPackage);
        } catch (_) {}
      } else if (_packages.isNotEmpty) {
        try {
          await Purchases.purchasePackage(_packages.first);
        } catch (_) {}
      }

      await _syncAfterManagementSheet();
    } catch (e) {
      if (mounted) {
        SubscriptionDialogs.showErrorDialog(context, message: 'Failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _handleSyncToDatabase() async {
    debugPrint('🔄 [SubscriptionPage] _handleSyncToDatabase() called');
    setState(() => _isPurchasing = true);

    try {
      debugPrint('🔄 [SubscriptionPage] Invalidating customer info cache...');
      await Purchases.invalidateCustomerInfoCache();
      final customerInfo = await Purchases.getCustomerInfo();
      debugPrint('🔄 [SubscriptionPage] Customer info received');
      debugPrint('🔄 [SubscriptionPage] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
      final hasActiveEntitlements = customerInfo.entitlements.active.isNotEmpty;
      final userId = ref.read(currentUserIdProvider)!;

      if (hasActiveEntitlements) {
        final proEntitlement = _findEntitlementByMatch(customerInfo, 'pro');
        final basicEntitlement = _findEntitlementByMatch(customerInfo, 'basic');
        final activeEntitlement = proEntitlement ?? basicEntitlement;

        if (activeEntitlement != null) {
          final planType = proEntitlement != null ? 'pro' : 'basic';
          final willRenew = activeEntitlement.willRenew;
          final productId = activeEntitlement.productIdentifier;
          final expiresAt = activeEntitlement.expirationDate;
          final isTrial = activeEntitlement.periodType == PeriodType.trial;

          await RevenueCatService().syncSubscriptionToDatabase(
            userId: userId,
            planType: planType,
            productId: productId,
            expiresAt: expiresAt,
            isTrial: isTrial,
            willRenew: willRenew,
          );

          if (mounted) {
            if (willRenew) {
              TossToast.success(context, 'Synced: $planType (Auto-renew ON)');
            } else {
              TossToast.warning(context, 'Synced: $planType (Canceled, expires ${_formatShortDate(DateTime.parse(expiresAt!))})');
            }
          }
        }
      } else {
        await RevenueCatService().syncSubscriptionToDatabase(
          userId: userId,
          planType: 'free',
          productId: null,
          expiresAt: null,
          isTrial: false,
          willRenew: false,
        );

        if (mounted) {
          TossToast.success(context, 'Synced: Free plan');
        }
      }

      await _refreshSubscriptionState();
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Sync failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _syncAfterManagementSheet() async {
    final customerInfo = await Purchases.getCustomerInfo();
    final hasActiveEntitlements = customerInfo.entitlements.active.isNotEmpty;
    final userId = ref.read(currentUserIdProvider)!;

    if (hasActiveEntitlements) {
      final proEntitlement = _findEntitlementByMatch(customerInfo, 'pro');
      final basicEntitlement = _findEntitlementByMatch(customerInfo, 'basic');
      final activeEntitlement = proEntitlement ?? basicEntitlement;

      if (activeEntitlement != null) {
        final planType = proEntitlement != null ? 'pro' : 'basic';
        final willRenew = activeEntitlement.willRenew;
        final productId = activeEntitlement.productIdentifier;
        final expiresAt = activeEntitlement.expirationDate;
        final isTrial = activeEntitlement.periodType == PeriodType.trial;

        await RevenueCatService().syncSubscriptionToDatabase(
          userId: userId,
          planType: planType,
          productId: productId,
          expiresAt: expiresAt,
          isTrial: isTrial,
          willRenew: willRenew,
        );

        if (mounted) {
          if (willRenew) {
            TossToast.success(context, 'Subscription active (Auto-renew ON)');
          } else {
            TossToast.warning(context, 'Subscription canceled (expires ${_formatShortDate(DateTime.parse(expiresAt!))})');
          }
        }
      }
    } else {
      await RevenueCatService().syncSubscriptionToDatabase(
        userId: userId,
        planType: 'free',
        productId: null,
        expiresAt: null,
        isTrial: false,
        willRenew: false,
      );

      if (mounted) {
        TossToast.success(context, 'Synced: Now on Free plan');
      }
    }

    await _refreshSubscriptionState();
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Handle Offer Code redemption (iOS only)
  ///
  /// Presents Apple's native Offer Code redemption sheet.
  /// After successful redemption, refreshes subscription state.
  Future<void> _handleRedeemOfferCode() async {
    debugPrint('🎁 [SubscriptionPage] _handleRedeemOfferCode() called');
    setState(() => _isPurchasing = true);

    try {
      await RevenueCatService().presentCodeRedemptionSheet();
      debugPrint('🎁 [SubscriptionPage] ✅ Code redemption sheet presented');

      // Refresh subscription state after potential code redemption
      await _refreshSubscriptionState();

      if (mounted) {
        TossToast.success(context, 'Offer code applied successfully!');
      }
    } catch (e) {
      debugPrint('🎁 [SubscriptionPage] ❌ Offer code redemption failed: $e');
      if (mounted) {
        // Don't show error for user cancellation
        if (!e.toString().contains('cancel')) {
          SubscriptionDialogs.showErrorDialog(
            context,
            message: e.toString().contains('iOS')
                ? 'Offer codes are only available on iOS devices.'
                : 'Failed to redeem offer code. Please try again.',
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🎨 Build
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: TossSpacing.space2),

                        // Hero Section
                        SubscriptionHeroSection(
                          isProPlan: _isProPlan,
                          isBasicPlan: _isBasicPlan,
                          hasActiveSubscription: _hasActiveSubscription,
                          expirationDate: _expirationDate,
                          willRenew: _willRenew,
                        ),

                        const SizedBox(height: TossSpacing.space6),

                        // Monthly/Annual Toggle
                        PricingToggle(
                          isAnnual: _isAnnual,
                          onToggle: (value) => setState(() => _isAnnual = value),
                        ),

                        const SizedBox(height: TossSpacing.space5),

                        // Pricing Cards
                        PricingCards(
                          isAnnual: _isAnnual,
                          selectedPlanIndex: _selectedPlanIndex,
                          isProPlan: _isProPlan,
                          isBasicPlan: _isBasicPlan,
                          onPlanSelected: (index) => setState(() => _selectedPlanIndex = index),
                        ),

                        const SizedBox(height: TossSpacing.space6),

                        // CTA Button
                        SubscriptionCtaButton(
                          isAnnual: _isAnnual,
                          selectedPlanIndex: _selectedPlanIndex,
                          hasActiveSubscription: _hasActiveSubscription,
                          isProPlan: _isProPlan,
                          isBasicPlan: _isBasicPlan,
                          expirationDate: _expirationDate,
                          willRenew: _willRenew,
                          isPurchasing: _isPurchasing,
                          isLoadingPackages: _isLoadingPackages,
                          onSubscribe: _handleSubscribe,
                          onRestorePurchases: _handleRestorePurchases,
                          onManageSubscription: _handleCancelSubscription,
                          onSyncToDatabase: _handleSyncToDatabase,
                          onRedeemOfferCode: _handleRedeemOfferCode,
                          // Trial info
                          isOnTrial: _isOnTrial,
                          trialDaysRemaining: _trialDaysRemaining,
                          trialEndDate: _trialEndDate,
                        ),

                        const SizedBox(height: TossSpacing.space4),

                        // Trust Signals
                        const TrustSignals(),

                        const SizedBox(height: TossSpacing.space6),

                        // Feature Comparison
                        const FeatureComparison(),

                        const SizedBox(height: TossSpacing.space8),

                        // Social Proof
                        const SocialProof(),

                        const SizedBox(height: TossSpacing.space12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/my-page');
              }
            },
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
              ),
              child: Icon(Icons.close, size: TossSpacing.iconSM, color: TossColors.gray700),
            ),
          ),
          const Spacer(),
          SizedBox(width: TossDimensions.closeButtonOffset),
        ],
      ),
    );
  }
}
