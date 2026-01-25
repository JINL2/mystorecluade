/// Subscription Limit Providers
///
/// Provides both cache-based (instant) and fresh (RPC-based) limit checks.
/// Use cache providers for UI state, fresh providers before create actions.
///
/// 2026-01-25 Cleanup: Removed unused xxxFromSubscriptionState providers.
/// Use cache-based providers for UI, fresh providers before create actions.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers/app_state.dart'; // AppStateExtensions 사용을 위해 필요
import '../../../app/providers/app_state_provider.dart';
import '../entities/subscription_limit_check.dart';

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
// REMOVED UNUSED PROVIDERS (2026-01-25 Cleanup)
// =====================================================
//
// The following providers were removed as they had ZERO usage in the codebase:
//
// 1. isProPlanProvider - Use appState.isProPlan directly
// 2. shouldShowUpgradePromptProvider - Use appState.isProPlan directly
// 3. employeeLimitFromSubscriptionStateProvider - Use employeeLimitFromCacheProvider
// 4. storeLimitFromSubscriptionStateProvider - Use storeLimitFromCacheProvider
// 5. companyLimitFromSubscriptionStateProvider - Use companyLimitFromCacheProvider
// 6. isSubscriptionDataStaleProvider - Use subscriptionStateNotifierProvider directly
//
// The cache-based providers (xxxLimitFromCache) are fast and reliable since
// AppState is already loaded at app startup. For real-time updates, watch
// subscriptionStateNotifierProvider directly.
//
// See: lib/core/subscription/README.md for usage guide
