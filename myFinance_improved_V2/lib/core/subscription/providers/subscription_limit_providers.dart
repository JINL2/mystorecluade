/// Subscription Limit Providers
///
/// Provides both cache-based (instant) and fresh (RPC-based) limit checks.
/// Use cache providers for UI state, fresh providers before create actions.
///
/// 2026 Update: Added integration with SubscriptionStateNotifier for
/// real-time subscription updates via RevenueCat + Supabase Realtime.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_state.dart';
import '../../../app/providers/app_state_provider.dart';
import '../entities/subscription_limit_check.dart';
import '../entities/subscription_state.dart';
import 'subscription_state_notifier.dart';

part 'subscription_limit_providers.g.dart';

// =====================================================
// CACHE-BASED LIMIT CHECK PROVIDERS (Instant UI Response)
// =====================================================

/// Company limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
@riverpod
SubscriptionLimitCheck companyLimitFromCache(Ref ref) {
  final appState = ref.watch(appStateProvider);
  return SubscriptionLimitCheck.fromCache(
    canAdd: appState.canAddCompany,
    planName: appState.planType,
    maxLimit: appState.hasUnlimitedCompanies ? null : appState.maxCompanies,
    currentCount: appState.currentCompanyCount,
    checkType: 'company',
  );
}

/// Store limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
@riverpod
SubscriptionLimitCheck storeLimitFromCache(Ref ref) {
  final appState = ref.watch(appStateProvider);

  return SubscriptionLimitCheck.fromCache(
    canAdd: appState.canAddStore,
    planName: appState.planType,
    maxLimit: appState.hasUnlimitedStores ? null : appState.maxStores,
    currentCount: appState.currentStoreCount,
    checkType: 'store',
  );
}

/// Employee limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
@riverpod
SubscriptionLimitCheck employeeLimitFromCache(Ref ref) {
  final appState = ref.watch(appStateProvider);

  return SubscriptionLimitCheck.fromCache(
    canAdd: appState.canAddEmployee,
    planName: appState.planType,
    maxLimit: appState.hasUnlimitedEmployees ? null : appState.maxEmployees,
    currentCount: appState.currentEmployeeCount,
    checkType: 'employee',
  );
}

// =====================================================
// FRESH LIMIT CHECK PROVIDERS (RPC-based, use before create)
// =====================================================

/// Fresh company limit check from RPC
///
/// Call this when user clicks "Create Company" button to get latest count.
/// This ensures multi-device scenarios are handled correctly.
@riverpod
Future<SubscriptionLimitCheck> companyLimitFresh(Ref ref) async {
  final appState = ref.read(appStateProvider);
  final userId = appState.userId;

  if (userId.isEmpty) {
    return SubscriptionLimitCheck.fromCache(
      canAdd: false,
      planName: 'free',
      maxLimit: 1,
      currentCount: 0,
      checkType: 'company',
    );
  }

  try {
    final result = await Supabase.instance.client.rpc(
      'check_subscription_limit',
      params: {
        'p_user_id': userId,
        'p_check_type': 'company',
      },
    );

    return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
  } catch (e) {
    // Fallback to cache on error
    return ref.read(companyLimitFromCacheProvider);
  }
}

/// Fresh store limit check from RPC
///
/// Call this when user clicks "Create Store" button to get latest count.
/// Pass companyId to check limit for specific company.
@riverpod
Future<SubscriptionLimitCheck> storeLimitFresh(
  Ref ref, {
  String? companyId,
}) async {
  final appState = ref.read(appStateProvider);
  final userId = appState.userId;
  final targetCompanyId = companyId ?? appState.companyChoosen;

  if (userId.isEmpty) {
    return SubscriptionLimitCheck.fromCache(
      canAdd: false,
      planName: 'free',
      maxLimit: 1,
      currentCount: 0,
      checkType: 'store',
    );
  }

  try {
    final result = await Supabase.instance.client.rpc(
      'check_subscription_limit',
      params: {
        'p_user_id': userId,
        'p_check_type': 'store',
        'p_company_id': targetCompanyId.isNotEmpty ? targetCompanyId : null,
      },
    );

    return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
  } catch (e) {
    // Fallback to cache on error
    return ref.read(storeLimitFromCacheProvider);
  }
}

/// Fresh employee limit check from RPC
///
/// Call this when user clicks "Add Employee" button to get latest count.
/// Pass companyId to check limit for specific company.
@riverpod
Future<SubscriptionLimitCheck> employeeLimitFresh(
  Ref ref, {
  String? companyId,
}) async {
  final appState = ref.read(appStateProvider);
  final userId = appState.userId;
  final targetCompanyId = companyId ?? appState.companyChoosen;

  if (userId.isEmpty) {
    return SubscriptionLimitCheck.fromCache(
      canAdd: false,
      planName: 'free',
      maxLimit: 5,
      currentCount: 0,
      checkType: 'employee',
    );
  }

  try {
    final result = await Supabase.instance.client.rpc(
      'check_subscription_limit',
      params: {
        'p_user_id': userId,
        'p_check_type': 'employee',
        'p_company_id': targetCompanyId.isNotEmpty ? targetCompanyId : null,
      },
    );

    return SubscriptionLimitCheck.fromJson(result as Map<String, dynamic>);
  } catch (e) {
    // Fallback to cache on error
    return ref.read(employeeLimitFromCacheProvider);
  }
}

// =====================================================
// HELPER PROVIDERS
// =====================================================

/// Check if current plan is Pro (unlimited everything)
@riverpod
bool isProPlan(Ref ref) {
  final appState = ref.watch(appStateProvider);
  return appState.isProPlan;
}

/// Check if user should see upgrade prompt
@riverpod
bool shouldShowUpgradePrompt(Ref ref) {
  final appState = ref.watch(appStateProvider);

  // Don't show for Pro users
  if (appState.isProPlan) return false;

  // Show if any limit is close to being reached
  final storeLimit = ref.watch(storeLimitFromCacheProvider);
  final employeeLimit = ref.watch(employeeLimitFromCacheProvider);

  return storeLimit.isCloseToLimit || employeeLimit.isCloseToLimit;
}

// =====================================================
// SUBSCRIPTION STATE NOTIFIER INTEGRATION (2026)
// =====================================================

/// Employee limit check from SubscriptionStateNotifier
///
/// New 2026 provider that uses real-time subscription data.
/// Falls back to AppState if SubscriptionState is not yet loaded.
///
/// Combines SubscriptionState (limits) + AppState (usage counts).
@riverpod
SubscriptionLimitCheck employeeLimitFromSubscriptionState(Ref ref) {
  final subscriptionAsync = ref.watch(subscriptionStateNotifierProvider);
  final appState = ref.watch(appStateProvider);

  return subscriptionAsync.when(
    data: (subState) {
      return SubscriptionLimitCheck.fromCache(
        canAdd: subState.canAddEmployee(appState.currentEmployeeCount),
        planName: subState.planName,
        maxLimit: subState.hasUnlimitedEmployees ? null : subState.maxEmployees,
        currentCount: appState.currentEmployeeCount,
        checkType: 'employee',
      );
    },
    loading: () => ref.read(employeeLimitFromCacheProvider),
    error: (_, __) => ref.read(employeeLimitFromCacheProvider),
  );
}

/// Store limit check from SubscriptionStateNotifier
@riverpod
SubscriptionLimitCheck storeLimitFromSubscriptionState(Ref ref) {
  final subscriptionAsync = ref.watch(subscriptionStateNotifierProvider);
  final appState = ref.watch(appStateProvider);

  return subscriptionAsync.when(
    data: (subState) {
      return SubscriptionLimitCheck.fromCache(
        canAdd: subState.canAddStore(appState.currentStoreCount),
        planName: subState.planName,
        maxLimit: subState.hasUnlimitedStores ? null : subState.maxStores,
        currentCount: appState.currentStoreCount,
        checkType: 'store',
      );
    },
    loading: () => ref.read(storeLimitFromCacheProvider),
    error: (_, __) => ref.read(storeLimitFromCacheProvider),
  );
}

/// Company limit check from SubscriptionStateNotifier
@riverpod
SubscriptionLimitCheck companyLimitFromSubscriptionState(Ref ref) {
  final subscriptionAsync = ref.watch(subscriptionStateNotifierProvider);
  final appState = ref.watch(appStateProvider);

  return subscriptionAsync.when(
    data: (subState) {
      return SubscriptionLimitCheck.fromCache(
        canAdd: subState.canAddCompany(appState.currentCompanyCount),
        planName: subState.planName,
        maxLimit: subState.hasUnlimitedCompanies ? null : subState.maxCompanies,
        currentCount: appState.currentCompanyCount,
        checkType: 'company',
      );
    },
    loading: () => ref.read(companyLimitFromCacheProvider),
    error: (_, __) => ref.read(companyLimitFromCacheProvider),
  );
}

/// Check if subscription is stale and needs refresh
@riverpod
bool isSubscriptionDataStale(Ref ref) {
  final subscriptionAsync = ref.watch(subscriptionStateNotifierProvider);
  return subscriptionAsync.when(
    data: (subState) =>
        subState.syncStatus == SyncStatus.stale || subState.isStale,
    loading: () => false,
    error: (_, __) => true,
  );
}
