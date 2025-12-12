import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/revenuecat_service.dart';

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

/// Subscription state for the app
class SubscriptionState {
  final bool isPro;
  final bool isLoading;
  final String? errorMessage;
  final CustomerInfo? customerInfo;

  const SubscriptionState({
    this.isPro = false,
    this.isLoading = false,
    this.errorMessage,
    this.customerInfo,
  });

  SubscriptionState copyWith({
    bool? isPro,
    bool? isLoading,
    String? errorMessage,
    CustomerInfo? customerInfo,
  }) {
    return SubscriptionState(
      isPro: isPro ?? this.isPro,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      customerInfo: customerInfo ?? this.customerInfo,
    );
  }
}

/// Subscription notifier for managing subscription state
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  /// Check current subscription status
  Future<void> checkSubscriptionStatus() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final isPro = await RevenueCatService().checkProStatus();
      final customerInfo = await RevenueCatService().getCustomerInfo();

      state = state.copyWith(
        isPro: isPro,
        isLoading: false,
        customerInfo: customerInfo,
      );

      debugPrint('✅ [SubscriptionProvider] Pro status: $isPro');
    } catch (e) {
      debugPrint('❌ [SubscriptionProvider] Error checking status: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update subscription state after purchase
  void updateProStatus(bool isPro, CustomerInfo? customerInfo) {
    state = state.copyWith(
      isPro: isPro,
      customerInfo: customerInfo,
    );
  }

  /// Reset subscription state (e.g., on logout)
  void reset() {
    state = const SubscriptionState();
  }
}

/// Provider for subscription state
final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

/// Simple provider to check if user is Pro
///
/// Use this provider to conditionally show Pro features:
/// ```dart
/// final isPro = ref.watch(isProProvider);
/// if (isPro) {
///   // Show Pro feature
/// }
/// ```
final isProProvider = Provider<bool>((ref) {
  final subscriptionState = ref.watch(subscriptionProvider);
  return subscriptionState.isPro;
});

/// FutureProvider to fetch Pro status from RevenueCat
///
/// Automatically fetches and caches the Pro status.
/// Use ref.invalidate(proStatusProvider) to refresh.
final proStatusProvider = FutureProvider<bool>((ref) async {
  try {
    final isPro = await RevenueCatService().checkProStatus();

    // Update the subscription state provider too
    ref.read(subscriptionProvider.notifier).updateProStatus(
      isPro,
      await RevenueCatService().getCustomerInfo(),
    );

    return isPro;
  } catch (e) {
    debugPrint('❌ [proStatusProvider] Error: $e');
    return false;
  }
});

/// Provider for available packages (subscription options)
final availablePackagesProvider = FutureProvider<List<Package>>((ref) async {
  try {
    return await RevenueCatService().getAvailablePackages();
  } catch (e) {
    debugPrint('❌ [availablePackagesProvider] Error: $e');
    return [];
  }
});

/// Provider for customer info
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  try {
    return await RevenueCatService().getCustomerInfo();
  } catch (e) {
    debugPrint('❌ [customerInfoProvider] Error: $e');
    return null;
  }
});

/// Provider for subscription plans from database
///
/// Fetches all active subscription plans from Supabase.
/// Automatically caches the result. Use ref.invalidate() to refresh.
final subscriptionPlansProvider =
    FutureProvider<List<SubscriptionPlan>>((ref) async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('subscription_plans')
        .select()
        .eq('is_active', true)
        .order('sort_order');

    final plans = (response as List)
        .map((json) => SubscriptionPlan.fromJson(json as Map<String, dynamic>))
        .toList();

    debugPrint('✅ [subscriptionPlansProvider] Loaded ${plans.length} plans');
    return plans;
  } catch (e) {
    debugPrint('❌ [subscriptionPlansProvider] Error: $e');
    return [];
  }
});

/// Provider for a specific plan by name
final subscriptionPlanByNameProvider =
    FutureProvider.family<SubscriptionPlan?, String>((ref, planName) async {
  final plans = await ref.watch(subscriptionPlansProvider.future);
  try {
    return plans.firstWhere((p) => p.planName == planName);
  } catch (e) {
    return null;
  }
});

/// Provider for Basic plan
final basicPlanProvider = FutureProvider<SubscriptionPlan?>((ref) async {
  return ref.watch(subscriptionPlanByNameProvider('basic').future);
});

/// Provider for Pro plan
final proPlanProvider = FutureProvider<SubscriptionPlan?>((ref) async {
  return ref.watch(subscriptionPlanByNameProvider('pro').future);
});
