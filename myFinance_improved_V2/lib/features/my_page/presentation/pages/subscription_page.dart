import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:myfinance_improved/core/services/revenuecat_service.dart';
import 'package:myfinance_improved/features/my_page/presentation/providers/subscription_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';

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

  bool _isAnnual = false; // Default to monthly for testing
  int _selectedPlanIndex = 1; // Default to Pro (recommended)

  // RevenueCat state
  bool _isLoadingPackages = true;
  bool _isPurchasing = false;
  List<Package> _packages = [];
  String? _errorMessage;

  // Current subscription state from RevenueCat
  bool _isProSubscriber = false;
  String? _activeProductId;
  DateTime? _expirationDate;
  bool _willRenew = false;

  @override
  void initState() {
    super.initState();
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

    // Load RevenueCat packages and subscription status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPackages();
      _loadSubscriptionStatus();
    });
  }

  Future<void> _loadPackages() async {
    try {
      setState(() {
        _isLoadingPackages = true;
        _errorMessage = null;
      });

      final packages = await RevenueCatService().getAvailablePackages();

      // Debug: Log loaded packages
      debugPrint('📦 Loaded ${packages.length} packages:');
      for (final p in packages) {
        debugPrint('  - ${p.packageType.name}: ${p.storeProduct.identifier}');
      }

      if (mounted) {
        setState(() {
          _packages = packages;
          _isLoadingPackages = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load packages: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load subscription options';
          _isLoadingPackages = false;
        });
      }
    }
  }

  /// Helper: Find entitlement by partial key match
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

  /// Load current subscription status from RevenueCat
  Future<void> _loadSubscriptionStatus() async {
    try {
      final customerInfo = await RevenueCatService().getCustomerInfo();

      if (customerInfo != null && mounted) {
        // Check for entitlements containing 'basic' or 'pro' (partial match)
        // RevenueCat entitlement keys may be like 'storebase.pro.monthly'
        final proEntitlement = _findEntitlementByMatch(customerInfo, 'pro');
        final basicEntitlement = _findEntitlementByMatch(customerInfo, 'basic');

        final hasPro = proEntitlement != null;
        final hasBasic = basicEntitlement != null;
        final hasAnySubscription = hasPro || hasBasic;

        debugPrint('📊 Subscription Status:');
        debugPrint('  - Has Pro: $hasPro');
        debugPrint('  - Has Basic: $hasBasic');
        debugPrint('  - Active Entitlements: ${customerInfo.entitlements.active.keys}');

        // Get active entitlement (pro takes priority)
        final activeEntitlement = proEntitlement ?? basicEntitlement;

        if (activeEntitlement != null) {
          debugPrint('  - Product ID: ${activeEntitlement.productIdentifier}');
          debugPrint('  - Expires: ${activeEntitlement.expirationDate}');
          debugPrint('  - Will Renew: ${activeEntitlement.willRenew}');
        }

        setState(() {
          _isProSubscriber = hasAnySubscription;
          if (hasAnySubscription && activeEntitlement != null) {
            _activeProductId = activeEntitlement.productIdentifier;
            _expirationDate = activeEntitlement.expirationDate != null
                ? DateTime.parse(activeEntitlement.expirationDate!)
                : null;
            _willRenew = activeEntitlement.willRenew;

            // Auto-select the current plan based on entitlement
            if (_activeProductId?.contains('annual') == true ||
                _activeProductId?.contains('yearly') == true) {
              _isAnnual = true;
            }
            // Set selected plan index based on entitlement
            _selectedPlanIndex = hasPro ? 1 : 0; // 1 = Pro, 0 = Basic
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load subscription status: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

                        // Hero Section with Value Proposition
                        _buildHeroSection(),

                        const SizedBox(height: TossSpacing.space6),

                        // Monthly/Annual Toggle
                        _buildPricingToggle(),

                        const SizedBox(height: TossSpacing.space5),

                        // Pricing Cards (Horizontal scroll)
                        _buildPricingCards(),

                        const SizedBox(height: TossSpacing.space6),

                        // CTA Button
                        _buildCTAButton(),

                        const SizedBox(height: TossSpacing.space4),

                        // Trust Signals
                        _buildTrustSignals(),

                        const SizedBox(height: TossSpacing.space6),

                        // Feature Comparison
                        _buildFeatureComparison(),

                        const SizedBox(height: TossSpacing.space8),

                        // Social Proof
                        _buildSocialProof(),

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
          const SizedBox(width: 36), // Balance for close button
        ],
      ),
    );
  }

  /// Build current plan badge showing user's subscription status
  Widget _buildCurrentPlanBadge() {
    // Determine current plan text and colors
    String planText;
    Color bgColor;
    Color textColor;
    IconData icon;

    if (_isProSubscriber) {
      // Check if it's Pro or Basic based on activeProductId
      final isProPlan = _activeProductId?.contains('pro') == true;
      if (isProPlan) {
        planText = 'Pro Plan';
        bgColor = const Color(0xFF3B82F6).withValues(alpha: 0.1);
        textColor = const Color(0xFF3B82F6);
        icon = LucideIcons.crown;
      } else {
        planText = 'Basic Plan';
        bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        textColor = const Color(0xFF10B981);
        icon = LucideIcons.checkCircle;
      }
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
          if (_isProSubscriber && _expirationDate != null) ...[
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
              _willRenew ? 'Renews ${_formatShortDate(_expirationDate!)}' : 'Expires ${_formatShortDate(_expirationDate!)}',
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

  /// Format date in short format (e.g., "Jan 15")
  String _formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Current Plan Badge
          _buildCurrentPlanBadge(),

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

  Widget _buildPricingToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _isAnnual = false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isAnnual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !_isAnnual
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Monthly',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: !_isAnnual ? FontWeight.w700 : FontWeight.w500,
                      color: !_isAnnual ? TossColors.gray900 : TossColors.gray500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _isAnnual = true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isAnnual ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _isAnnual
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Annual',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: _isAnnual ? FontWeight.w700 : FontWeight.w500,
                        color: _isAnnual ? TossColors.gray900 : TossColors.gray500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Savings badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-40%',
                        style: TossTextStyles.small.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCards() {
    // Watch subscription plans from database
    final plansAsync = ref.watch(subscriptionPlansProvider);

    return plansAsync.when(
      loading: () => const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _buildFallbackPricingCards(),
      data: (dbPlans) {
        // Filter to only Basic and Pro plans
        final basicPlan = dbPlans.where((p) => p.planName == 'basic').firstOrNull;
        final proPlan = dbPlans.where((p) => p.planName == 'pro').firstOrNull;

        if (basicPlan == null || proPlan == null) {
          return _buildFallbackPricingCards();
        }

        final plans = [
          _PlanData(
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
          _PlanData(
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

        return _buildPricingCardsList(plans);
      },
    );
  }

  /// Fallback pricing cards when DB fetch fails
  Widget _buildFallbackPricingCards() {
    final plans = [
      _PlanData(
        name: 'Basic',
        monthlyPrice: 49,
        annualPrice: 29,
        tagline: 'For small teams',
        features: ['5 Stores', '10 Employees', '20 AI/day'],
        color: const Color(0xFF10B981),
        isPopular: false,
      ),
      _PlanData(
        name: 'Pro',
        monthlyPrice: 149,
        annualPrice: 89,
        tagline: 'Most Popular',
        features: ['Unlimited', 'Unlimited', 'Unlimited AI'],
        color: const Color(0xFF3B82F6),
        isPopular: true,
      ),
    ];
    return _buildPricingCardsList(plans);
  }

  Widget _buildPricingCardsList(List<_PlanData> plans) {

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = _selectedPlanIndex == index;
          // Check if this plan is the user's current active subscription
          final isCurrentPlan = index == 1 && _isProSubscriber; // Pro is index 1
          final price = _isAnnual ? plan.annualPrice : plan.monthlyPrice;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedPlanIndex = index);
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

                  if (_isAnnual) ...[
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

  Widget _buildCTAButton() {
    // Check if user is already subscribed to Pro
    final isAlreadySubscribed = _isProSubscriber && _selectedPlanIndex == 1;

    // Get prices from database (with fallback)
    final plansAsync = ref.watch(subscriptionPlansProvider);
    final plans = plansAsync.valueOrNull ?? [];
    final basicPlan = plans.where((p) => p.planName == 'basic').firstOrNull;
    final proPlan = plans.where((p) => p.planName == 'pro').firstOrNull;

    final int price;
    if (_isAnnual) {
      price = _selectedPlanIndex == 0
          ? (basicPlan?.annualPricePerMonth.round() ?? 29)
          : (proPlan?.annualPricePerMonth.round() ?? 89);
    } else {
      price = _selectedPlanIndex == 0
          ? (basicPlan?.priceMonthly.toInt() ?? 49)
          : (proPlan?.priceMonthly.toInt() ?? 149);
    }

    // Determine button text based on subscription status
    String buttonText;
    if (isAlreadySubscribed) {
      if (_willRenew) {
        buttonText = 'Subscribed ✓';
      } else {
        buttonText = 'Subscription Expires Soon';
      }
    } else {
      buttonText = 'Start 7-Day Free Trial';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Subscription info banner (if already subscribed)
          if (_isProSubscriber) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              margin: const EdgeInsets.only(bottom: TossSpacing.space3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re a Pro subscriber!',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        if (_expirationDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _willRenew
                                ? 'Renews on ${_formatDate(_expirationDate!)}'
                                : 'Expires on ${_formatDate(_expirationDate!)}',
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
            onTap: (isAlreadySubscribed || _isPurchasing || _isLoadingPackages)
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    _handleSubscribe();
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: (isAlreadySubscribed || _isPurchasing)
                    ? null
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: _selectedPlanIndex == 1
                            ? [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)]
                            : [const Color(0xFF10B981), const Color(0xFF059669)],
                      ),
                color: (isAlreadySubscribed || _isPurchasing) ? TossColors.gray200 : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: (isAlreadySubscribed || _isPurchasing)
                    ? null
                    : [
                        BoxShadow(
                          color: (_selectedPlanIndex == 1
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF10B981))
                              .withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Center(
                child: _isPurchasing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray500),
                        ),
                      )
                    : Text(
                        buttonText,
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: isAlreadySubscribed ? TossColors.gray500 : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Price reminder
          if (!isAlreadySubscribed && !_isPurchasing)
            Text(
              'Then \$$price/month${_isAnnual ? ' (billed annually)' : ''}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),

          const SizedBox(height: TossSpacing.space2),

          // Restore purchases link
          GestureDetector(
            onTap: _isPurchasing
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    _handleRestorePurchases();
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
        ],
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildTrustSignals() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTrustItem(LucideIcons.shield, 'Secure'),
          Container(
            width: 1,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            color: TossColors.gray200,
          ),
          _buildTrustItem(LucideIcons.refreshCcw, 'Cancel anytime'),
          Container(
            width: 1,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            color: TossColors.gray200,
          ),
          _buildTrustItem(LucideIcons.creditCard, 'No hidden fees'),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: TossColors.gray400),
        const SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureComparison() {
    final features = [
      _FeatureRow('Stores', 'Free', '1', 'Basic', '5', 'Pro', '∞'),
      _FeatureRow('Employees', 'Free', '3', 'Basic', '10', 'Pro', '∞'),
      _FeatureRow('AI Reports', 'Free', '5/day', 'Basic', '20/day', 'Pro', '∞'),
      _FeatureRow('Analytics', 'Free', 'Basic', 'Basic', 'Advanced', 'Pro', 'All'),
      _FeatureRow('Support', 'Free', 'Email', 'Basic', 'Priority', 'Pro', '24/7'),
      _FeatureRow('API Access', 'Free', '✗', 'Basic', '✗', 'Pro', '✓'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compare Plans',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: TossColors.gray200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: SizedBox()),
                      Expanded(
                        child: Text(
                          'Free',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Basic',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Pro',
                          textAlign: TextAlign.center,
                          style: TossTextStyles.small.copyWith(
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rows
                ...features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  final isLast = index == features.length - 1;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: TossColors.gray200),
                            ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            feature.name,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.freeValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.basicValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature.proValue,
                            textAlign: TextAlign.center,
                            style: TossTextStyles.small.copyWith(
                              color: const Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialProof() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        children: [
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                5,
                (index) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB800),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '4.9',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                ' (2,847 reviews)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Testimonial
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '"Pro has saved us hours of bookkeeping every week. The AI reports are incredibly accurate."',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'JK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'James Kim',
                          style: TossTextStyles.small.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        Text(
                          'Owner, Seoul Cafe',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe() async {
    // Find the appropriate package based on selection
    Package? targetPackage;

    // Map selection to package type
    // _selectedPlanIndex: 0 = Basic, 1 = Pro
    // _isAnnual: true = annual, false = monthly
    final planName = _selectedPlanIndex == 0 ? 'basic' : 'pro';
    final periodName = _isAnnual ? 'yearly' : 'monthly';
    final targetIdentifier = '$planName.$periodName'; // e.g., 'basic.monthly', 'pro.yearly'

    // Debug log
    debugPrint('🛒 Subscribe clicked:');
    debugPrint('  - Selected Plan: $planName');
    debugPrint('  - Period: $periodName');
    debugPrint('  - Target Identifier: $targetIdentifier');
    debugPrint('  - Available packages: ${_packages.length}');

    // Find package by identifier (RevenueCat package identifier format)
    for (final package in _packages) {
      debugPrint('  - Checking: ${package.identifier} contains $targetIdentifier?');

      // Match by package identifier (e.g., 'basic.monthly', 'pro.yearly')
      if (package.identifier == targetIdentifier) {
        targetPackage = package;
        debugPrint('  ✅ Found matching package: ${package.storeProduct.identifier}');
        break;
      }

      // Fallback: match by product ID
      final productId = package.storeProduct.identifier.toLowerCase();
      if (productId.contains(planName) &&
          ((_isAnnual && (productId.contains('annual') || productId.contains('yearly'))) ||
           (!_isAnnual && productId.contains('monthly')))) {
        targetPackage = package;
        debugPrint('  ✅ Found matching package by product ID: ${package.storeProduct.identifier}');
        break;
      }
    }

    if (targetPackage == null) {
      // No package found - show error
      debugPrint('  ❌ No matching package found!');
      _showErrorDialog('No subscription package found. Please try again later.');
      return;
    }

    // Start purchase
    setState(() => _isPurchasing = true);

    try {
      final success = await RevenueCatService().purchasePackage(targetPackage);

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          // Purchase successful!
          _showSuccessDialog();
        } else {
          // Purchase cancelled by user
          // No need to show error - user cancelled intentionally
        }
      }
    } on PurchasesErrorCode catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);

        if (e != PurchasesErrorCode.purchaseCancelledError) {
          _showErrorDialog('Purchase failed: ${e.name}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        _showErrorDialog('An unexpected error occurred. Please try again.');
      }
    }
  }

  void _showSuccessDialog() {
    // Refresh subscription status after purchase
    _loadSubscriptionStatus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.checkCircle,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome to Pro!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'Your subscription is now active. Enjoy all Pro features!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.alertCircle,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Oops!'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestorePurchases() async {
    setState(() => _isPurchasing = true);

    try {
      final success = await RevenueCatService().restorePurchases();

      if (mounted) {
        setState(() => _isPurchasing = false);

        if (success) {
          _showSuccessDialog();
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('No Purchases Found'),
              content: const Text(
                'We couldn\'t find any previous purchases to restore. '
                'If you believe this is an error, please contact support.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPurchasing = false);
        _showErrorDialog('Failed to restore purchases. Please try again.');
      }
    }
  }
}

// Data classes
class _PlanData {
  final String name;
  final int monthlyPrice;
  final int annualPrice;
  final String tagline;
  final List<String> features;
  final Color color;
  final bool isPopular;

  const _PlanData({
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.tagline,
    required this.features,
    required this.color,
    required this.isPopular,
  });
}

class _FeatureRow {
  final String name;
  final String freePlan;
  final String freeValue;
  final String basicPlan;
  final String basicValue;
  final String proPlan;
  final String proValue;

  const _FeatureRow(
    this.name,
    this.freePlan,
    this.freeValue,
    this.basicPlan,
    this.basicValue,
    this.proPlan,
    this.proValue,
  );
}
