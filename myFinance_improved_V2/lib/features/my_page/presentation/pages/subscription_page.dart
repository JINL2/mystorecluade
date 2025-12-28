import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/core/services/revenuecat_service.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

import '../widgets/subscription/subscription_widgets.dart';

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
      duration: const Duration(milliseconds: 800),
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
    try {
      setState(() => _isLoadingPackages = true);
      final packages = await RevenueCatService().getAvailablePackages();
      if (mounted) {
        setState(() {
          _packages = packages;
          _isLoadingPackages = false;
        });
      }
    } catch (_) {
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
    try {
      final customerInfo = await RevenueCatService().getCustomerInfo();

      if (customerInfo != null && mounted) {
        final proEntitlement = _findEntitlementByMatch(customerInfo, 'pro');
        final basicEntitlement = _findEntitlementByMatch(customerInfo, 'basic');

        final hasPro = proEntitlement != null;
        final hasBasic = basicEntitlement != null;
        final hasAnySubscription = hasPro || hasBasic;
        final activeEntitlement = proEntitlement ?? basicEntitlement;

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

            if (_activeProductId?.contains('annual') == true ||
                _activeProductId?.contains('yearly') == true) {
              _isAnnual = true;
            } else {
              _isAnnual = false;
            }
            _selectedPlanIndex = hasPro ? 1 : 0;
          }
        });
      }
    } catch (_) {
      // Subscription status load failure is not critical
    }
  }

  String get _currentPlanName {
    if (_isProPlan) return 'Pro';
    if (_isBasicPlan) return 'Basic';
    return 'Free';
  }

  Future<void> _refreshSubscriptionState() async {
    await _loadSubscriptionStatus();
    ref.invalidate(proStatusProvider);
    ref.invalidate(subscriptionNotifierProvider);
    ref.invalidate(customerInfoProvider);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🎯 Purchase Handlers
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Future<void> _handleSubscribe() async {
    final planName = _selectedPlanIndex == 0 ? 'basic' : 'pro';
    final periodName = _isAnnual ? 'yearly' : 'monthly';
    final targetIdentifier = '$planName.$periodName';

    Package? targetPackage;
    for (final package in _packages) {
      if (package.identifier == targetIdentifier) {
        targetPackage = package;
        break;
      }
      final productId = package.storeProduct.identifier.toLowerCase();
      if (productId.contains(planName) &&
          ((_isAnnual && (productId.contains('annual') || productId.contains('yearly'))) ||
           (!_isAnnual && productId.contains('monthly')))) {
        targetPackage = package;
        break;
      }
    }

    if (targetPackage == null) {
      SubscriptionDialogs.showErrorDialog(
        context,
        message: 'No subscription package found. Please try again later.',
      );
      return;
    }

    // Check if already subscribed
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isAlreadySubscribed = customerInfo.entitlements.active.entries.any((entry) {
        return entry.key.toLowerCase().contains(planName);
      });

      if (isAlreadySubscribed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You already have an active $planName subscription. Use "Manage" to modify it.'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Manage',
                textColor: Colors.white,
                onPressed: _handleCancelSubscription,
              ),
            ),
          );
        }
        return;
      }
    } catch (_) {
      // Continue with purchase attempt
    }

    setState(() => _isPurchasing = true);

    try {
      final success = await RevenueCatService().purchasePackage(targetPackage);

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          await _refreshSubscriptionState();
          SubscriptionDialogs.showSuccessDialog(
            context,
            planName: planName,
            onDismiss: () {},
          );
        }
      }
    } on PurchasesErrorCode catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        if (e != PurchasesErrorCode.purchaseCancelledError) {
          SubscriptionDialogs.showErrorDialog(context, message: 'Purchase failed: ${e.name}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        SubscriptionDialogs.showErrorDialog(context, message: 'An unexpected error occurred. Please try again.');
      }
    }
  }

  Future<void> _handleRestorePurchases() async {
    setState(() => _isPurchasing = true);

    try {
      final success = await RevenueCatService().restorePurchases();

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          await _refreshSubscriptionState();
          SubscriptionDialogs.showRestoreSuccessDialog(
            context,
            isProPlan: _isProPlan,
            currentPlanName: _currentPlanName,
          );
        } else {
          SubscriptionDialogs.showNoPurchasesDialog(context);
        }
      }
    } catch (e) {
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
    setState(() => _isPurchasing = true);

    try {
      await Purchases.invalidateCustomerInfoCache();
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(willRenew
                    ? '✅ Synced: $planType (Auto-renew ON)'
                    : '⚠️ Synced: $planType (Canceled, expires ${_formatShortDate(DateTime.parse(expiresAt!))})'),
                backgroundColor: willRenew ? Colors.green : Colors.orange,
              ),
            );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Synced: Free plan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      await _refreshSubscriptionState();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(willRenew
                  ? '✅ Subscription active (Auto-renew ON)'
                  : '⚠️ Subscription canceled (expires ${_formatShortDate(DateTime.parse(expiresAt!))})'),
              backgroundColor: willRenew ? Colors.green : Colors.orange,
            ),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Synced: Now on Free plan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    await _refreshSubscriptionState();
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // 🎨 Build
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close, size: 20, color: TossColors.gray700),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}
