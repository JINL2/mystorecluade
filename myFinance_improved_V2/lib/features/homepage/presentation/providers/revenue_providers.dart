/// Revenue Presentation Layer Providers
///
/// This file contains revenue-related providers for homepage feature.
/// Extracted from homepage_providers.dart for better organization.
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/revenue_period.dart';

// ============================================================================
// Revenue View Tab
// ============================================================================

/// Revenue view tab (Company or Store)
enum RevenueViewTab { company, store }

/// Provider for selected revenue view tab
final selectedRevenueTabProvider = StateProvider<RevenueViewTab>((ref) {
  return RevenueViewTab.store;
});

/// Provider that auto-switches to Store tab when store selection changes
/// Use ref.watch(autoSwitchToStoreTabProvider) in homepage widgets to enable this behavior
final autoSwitchToStoreTabProvider = Provider<void>((ref) {
  ref.listen(appStateProvider.select((state) => state.storeChoosen), (previous, next) {
    // Auto-switch to Store tab when store changes (not on initial load)
    if (previous != null && previous != next && next.isNotEmpty) {
      ref.read(selectedRevenueTabProvider.notifier).state = RevenueViewTab.store;
    }
  });
});

// ============================================================================
// Revenue Period Selection
// ============================================================================

/// Selected revenue period for revenue card
final selectedRevenuePeriodProvider = StateProvider<RevenuePeriod>(
  (ref) => RevenuePeriod.today,
);

/// Flag to track if user manually selected a period
/// When true, auto-switch to thisYear is disabled
/// Reset to false when navigating away from homepage
final userManuallySelectedPeriodProvider = StateProvider<bool>(
  (ref) => false,
);

// ============================================================================
// Revenue Data Provider
// ============================================================================

/// Provider for fetching revenue data
///
/// Depends on app state for company/store selection AND selected tab.
/// - Company tab: Returns revenue for the entire company
/// - Store tab: Returns revenue for the selected store only
final revenueProvider = FutureProvider.family<Revenue, RevenuePeriod>(
  (ref, period) async {
    // Check authentication first
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, __) => false,
    );

    if (!isAuthenticated) {
      throw Exception('User not authenticated');
    }

    final appState = ref.watch(appStateProvider);
    final repository = ref.watch(homepageRepositoryProvider);

    // Watch selected tab to determine which revenue to fetch
    final selectedTab = ref.watch(selectedRevenueTabProvider);

    // Get selected company/store from app state
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }

    // Determine storeId based on selected tab:
    // - Company tab: pass null to get company-wide revenue
    // - Store tab: pass storeId to get store-specific revenue
    final effectiveStoreId = (selectedTab == RevenueViewTab.store && storeId.isNotEmpty)
        ? storeId
        : null;

    final revenue = await repository.getRevenue(
      companyId: companyId,
      storeId: effectiveStoreId,
      period: period,
    );
    return revenue;
  },
);
