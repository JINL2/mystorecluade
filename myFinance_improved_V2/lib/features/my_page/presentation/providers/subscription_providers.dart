import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/revenuecat_service.dart';
import '../../../../core/subscription/providers/subscription_state_notifier.dart';
import '../../data/datasources/subscription_datasource.dart';

part 'subscription_providers.g.dart';

// =============================================================================
// DataSource Provider
// =============================================================================

/// SubscriptionDataSource Provider
@Riverpod(keepAlive: true)
SubscriptionDataSource subscriptionDataSource(Ref ref) {
  return SubscriptionDataSource();
}

/// Subscription Plan model from database
class SubscriptionPlan {
  final String planName;
  final String displayName;
  final double priceMonthly;
  final double priceYearly;
  final int? maxStores;
  final int? maxEmployees;
  final int? aiDailyLimit;
  final List<String> features;
  final String description;

  const SubscriptionPlan({
    required this.planName,
    required this.displayName,
    required this.priceMonthly,
    required this.priceYearly,
    this.maxStores,
    this.maxEmployees,
    this.aiDailyLimit,
    required this.features,
    required this.description,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planName: json['plan_name'] as String,
      displayName: json['display_name'] as String,
      priceMonthly: double.tryParse(json['price_monthly'].toString()) ?? 0.0,
      priceYearly: double.tryParse(json['price_yearly'].toString()) ?? 0.0,
      maxStores: json['max_stores'] as int?,
      maxEmployees: json['max_employees'] as int?,
      aiDailyLimit: json['ai_daily_limit'] as int?,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
    );
  }

  /// Get annual price per month (for display)
  double get annualPricePerMonth => priceYearly / 12;

  /// Check if this is unlimited (null means unlimited)
  bool get hasUnlimitedStores => maxStores == null;
  bool get hasUnlimitedEmployees => maxEmployees == null;
  bool get hasUnlimitedAI => aiDailyLimit == null;
}

// =============================================================================
// RevenueCat Providers (for subscription_page purchase UI)
// =============================================================================

/// Provider for available packages (subscription options)
@riverpod
Future<List<Package>> availablePackages(Ref ref) async {
  try {
    return await RevenueCatService().getAvailablePackages();
  } catch (_) {
    return [];
  }
}

/// Provider for customer info
@riverpod
Future<CustomerInfo?> customerInfo(Ref ref) async {
  try {
    return await RevenueCatService().getCustomerInfo();
  } catch (_) {
    return null;
  }
}

/// Provider for subscription plans from database
///
/// Fetches all active subscription plans from Supabase.
/// Automatically caches the result. Use ref.invalidate() to refresh.
@riverpod
Future<List<SubscriptionPlan>> subscriptionPlans(Ref ref) async {
  try {
    final dataSource = ref.watch(subscriptionDataSourceProvider);
    final response = await dataSource.getActiveSubscriptionPlans();

    return response.map((json) => SubscriptionPlan.fromJson(json)).toList();
  } catch (_) {
    return [];
  }
}

/// Provider for a specific plan by name
@riverpod
Future<SubscriptionPlan?> subscriptionPlanByName(Ref ref, String planName) async {
  final plans = await ref.watch(subscriptionPlansProvider.future);
  try {
    return plans.firstWhere((p) => p.planName == planName);
  } catch (e) {
    return null;
  }
}

/// Provider for Basic plan
@riverpod
Future<SubscriptionPlan?> basicPlan(Ref ref) async {
  return ref.watch(subscriptionPlanByNameProvider('basic').future);
}

/// Provider for Pro plan
@riverpod
Future<SubscriptionPlan?> proPlan(Ref ref) async {
  return ref.watch(subscriptionPlanByNameProvider('pro').future);
}

// =============================================================================
// Subscription Details Model (Trial 상태 포함)
// =============================================================================

/// Subscription details including trial information
///
/// Used for displaying trial countdown, expiration, and renewal status.
class SubscriptionDetails {
  final String tier; // 'free', 'basic', 'pro'
  final bool isOnTrial;
  final DateTime? trialEndDate;
  final DateTime? expirationDate;
  final bool willRenew;
  final String? productId;

  const SubscriptionDetails({
    required this.tier,
    this.isOnTrial = false,
    this.trialEndDate,
    this.expirationDate,
    this.willRenew = false,
    this.productId,
  });

  /// Factory for free plan (default state)
  factory SubscriptionDetails.free() => const SubscriptionDetails(tier: 'free');

  /// Days remaining in trial (returns 0 if not on trial or expired)
  int get trialDaysRemaining {
    if (!isOnTrial || trialEndDate == null) return 0;
    final now = DateTime.now();
    final difference = trialEndDate!.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Hours remaining in trial (for countdown when < 1 day)
  int get trialHoursRemaining {
    if (!isOnTrial || trialEndDate == null) return 0;
    final now = DateTime.now();
    final difference = trialEndDate!.difference(now).inHours;
    return difference > 0 ? difference : 0;
  }

  /// Days remaining until subscription expires
  int get daysUntilExpiration {
    if (expirationDate == null) return 0;
    final now = DateTime.now();
    final difference = expirationDate!.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Check if trial is expiring soon (within 3 days)
  bool get isTrialExpiringSoon => isOnTrial && trialDaysRemaining <= 3 && trialDaysRemaining > 0;

  /// Check if trial has expired
  bool get isTrialExpired {
    if (!isOnTrial || trialEndDate == null) return false;
    return DateTime.now().isAfter(trialEndDate!);
  }

  /// Check if this is a paid plan (basic or pro)
  bool get isPaidPlan => tier == 'basic' || tier == 'pro';

  /// Check if this is free tier
  bool get isFreeTier => tier == 'free';

  /// Get display string for tier
  String get tierDisplayName {
    switch (tier) {
      case 'basic':
        return 'Basic';
      case 'pro':
        return 'Pro';
      default:
        return 'Free';
    }
  }

  /// Get billing cycle from product ID
  String get billingCycle {
    if (productId == null) return 'monthly';
    if (productId!.contains('yearly') || productId!.contains('annual')) {
      return 'yearly';
    }
    return 'monthly';
  }

  @override
  String toString() {
    return 'SubscriptionDetails(tier: $tier, isOnTrial: $isOnTrial, '
        'trialEndDate: $trialEndDate, expirationDate: $expirationDate, '
        'willRenew: $willRenew, productId: $productId)';
  }
}

/// Provider for subscription details including trial information
///
/// Returns comprehensive subscription details combining:
/// 1. **Supabase DB** (SubscriptionStateNotifier) - Stripe 웹 결제 반영
/// 2. **RevenueCat SDK** - iOS/Android 앱 내 결제 반영
///
/// ## 데이터 소스 우선순위
/// - DB에 유료 플랜이 있으면 DB 데이터 우선 (Stripe 결제)
/// - RevenueCat에만 유료 플랜이 있으면 RevenueCat 사용 (앱 내 결제)
/// - 둘 다 없으면 free
///
/// 2026 Update: Now watches subscriptionStateNotifierProvider to auto-refresh
/// when Supabase Realtime detects subscription changes (e.g., from web/Stripe).
///
/// keepAlive: true - Provider stays alive so Realtime updates work even when
/// my_page is not on screen. Without this, autoDispose would disconnect
/// the watch link when user navigates away.
///
/// ## Data Source Priority (DB is SSOT)
/// DB (Supabase) is the Single Source of Truth because:
/// 1. RevenueCat webhook updates DB on purchase/cancel
/// 2. Stripe webhook updates DB on web purchase/cancel
/// 3. DB has the most accurate, up-to-date state
///
/// RevenueCat SDK cache can be stale (shows old Pro status after cancellation),
/// so we ALWAYS trust DB over RevenueCat SDK.
@Riverpod(keepAlive: true)
Future<SubscriptionDetails> subscriptionDetails(Ref ref) async {
  // Watch subscriptionStateNotifierProvider to trigger refresh on Realtime changes
  // This ensures my_page UI updates when subscription changes via DB (Stripe)
  final subscriptionStateAsync = ref.watch(subscriptionStateNotifierProvider);

  // Get DB subscription state - THIS IS THE SINGLE SOURCE OF TRUTH
  final dbState = subscriptionStateAsync.valueOrNull;
  final dbTier = dbState?.planName ?? 'free';

  // DB is loaded and has valid data - use it directly
  // Don't check RevenueCat because DB is already updated by webhooks
  if (dbState != null && dbState.userId.isNotEmpty) {
    return SubscriptionDetails(
      tier: dbTier,
      isOnTrial: dbState.isOnTrial,
      trialEndDate: dbState.trialEndsAt,
      expirationDate: dbState.currentPeriodEndsAt,
      willRenew: dbState.status == 'active',
      productId: null,
    );
  }

  // DB not loaded yet - fallback to RevenueCat SDK (for initial load only)
  try {
    final data = await RevenueCatService().getSubscriptionDetails();
    return SubscriptionDetails(
      tier: data.tier,
      isOnTrial: data.isOnTrial,
      trialEndDate: data.trialEndDate,
      expirationDate: data.expirationDate,
      willRenew: data.willRenew,
      productId: data.productId,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ [subscriptionDetailsProvider] RevenueCat error: $e');
    }
  }

  // Fallback to free
  return SubscriptionDetails.free();
}
