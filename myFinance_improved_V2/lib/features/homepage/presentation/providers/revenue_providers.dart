/// Revenue Presentation Layer Providers
///
/// This file contains revenue-related providers for homepage feature.
/// Extracted from homepage_providers.dart for better organization.
///
/// Following Clean Architecture:
/// - NO imports from Data layer
/// - Only Domain layer imports allowed
///
/// Optimization (2026-01-04):
/// - Uses selective watching to prevent unnecessary rebuilds
/// - Combines company+store+tab into single cache key for efficient invalidation
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/revenue_period.dart';

// ============================================================================
// Revenue Request Key (for deduplication)
// ============================================================================

/// Immutable key representing a unique revenue request
/// Used to prevent duplicate API calls for the same parameters
@immutable
class RevenueRequestKey {
  final String companyId;
  final String? storeId;
  final RevenuePeriod period;
  final RevenueViewTab tab;

  const RevenueRequestKey({
    required this.companyId,
    required this.storeId,
    required this.period,
    required this.tab,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevenueRequestKey &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          period == other.period &&
          tab == other.tab;

  @override
  int get hashCode => Object.hash(companyId, storeId, period, tab);

  @override
  String toString() => 'RevenueRequestKey($companyId, $storeId, ${period.name}, ${tab.name})';
}

// ============================================================================
// Company/Store Change Listener (for debugging)
// ============================================================================

/// Provider that logs when company changes (debug only)
final companyChangeListenerProvider = Provider<void>((ref) {
  ref.listen(appStateProvider.select((state) => state.companyChoosen), (previous, next) {
    // Debug logging disabled - uncomment for debugging
    // if (previous != null && previous != next) {
    //   debugPrint('🏢 [Revenue] Company changed: $previous → $next');
    // }
  });
});

/// Provider that logs when store changes (debug only)
final storeChangeListenerProvider = Provider<void>((ref) {
  ref.listen(appStateProvider.select((state) => state.storeChoosen), (previous, next) {
    // Debug logging disabled - uncomment for debugging
    // if (previous != null && previous != next) {
    //   debugPrint('🏪 [Revenue] Store changed: $previous → $next');
    // }
  });
});

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
// Revenue Request Key Provider (combines all dependencies)
// ============================================================================

/// Provider that creates a unique request key from current state
/// This is the ONLY provider that watches appState, preventing multiple rebuilds
final _revenueRequestKeyProvider = Provider<RevenueRequestKey?>((ref) {
  // Watch auth state
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );

  if (!isAuthenticated) return null;

  // SELECTIVE watching - only watch the specific fields we need
  final companyId = ref.watch(
    appStateProvider.select((state) => state.companyChoosen),
  );
  final storeId = ref.watch(
    appStateProvider.select((state) => state.storeChoosen),
  );
  final selectedTab = ref.watch(selectedRevenueTabProvider);
  final period = ref.watch(selectedRevenuePeriodProvider);

  if (companyId.isEmpty) return null;

  return RevenueRequestKey(
    companyId: companyId,
    storeId: storeId.isEmpty ? null : storeId,
    period: period,
    tab: selectedTab,
  );
});

// ============================================================================
// Revenue Data Provider
// ============================================================================

/// Provider for fetching revenue data
///
/// OPTIMIZED (2026-01-04):
/// - Uses _revenueRequestKeyProvider to combine all dependencies
/// - Only rebuilds when the effective request key changes
/// - Selective watching prevents unnecessary rebuilds during initialization
///
/// Depends on app state for company/store selection AND selected tab.
/// - Company tab: Returns revenue for the entire company
/// - Store tab: Returns revenue for the selected store only
final revenueProvider = FutureProvider.family<Revenue, RevenuePeriod>(
  (ref, period) async {
    // Watch the combined request key - this handles all dependency changes
    final requestKey = ref.watch(_revenueRequestKeyProvider);

    if (requestKey == null) {
      throw Exception('User not authenticated or no company selected');
    }

    // Skip if the period param doesn't match the current selected period
    // This handles stale family instances and prevents duplicate API calls
    if (period != requestKey.period) {
      throw Exception('Period mismatch - stale provider instance');
    }

    final repository = ref.watch(homepageRepositoryProvider);

    // Determine storeId based on selected tab:
    // - Company tab: pass null to get company-wide revenue
    // - Store tab: pass storeId to get store-specific revenue
    final effectiveStoreId = (requestKey.tab == RevenueViewTab.store && requestKey.storeId != null)
        ? requestKey.storeId
        : null;

    return await repository.getRevenue(
      companyId: requestKey.companyId,
      storeId: effectiveStoreId,
      period: period,
    );
  },
);

// ============================================================================
// Cached Revenue for Smooth UI Transitions (Toss Style)
// ============================================================================

/// Holds the last successfully loaded revenue data
/// Used to prevent layout jump when scope/period changes
final _cachedRevenueProvider = StateProvider<Revenue?>((ref) => null);

/// Provider that returns cached revenue + loading state
/// This enables "show previous data with shimmer overlay" pattern
final revenueWithCacheProvider = Provider.family<RevenueWithLoadingState, RevenuePeriod>(
  (ref, period) {
    final asyncValue = ref.watch(revenueProvider(period));
    final cachedRevenue = ref.watch(_cachedRevenueProvider);

    // Update cache when new data arrives successfully
    // Use ref.listen instead of whenData + Future.microtask to avoid disposed ref issues
    ref.listen(revenueProvider(period), (previous, next) {
      next.whenData((revenue) {
        ref.read(_cachedRevenueProvider.notifier).state = revenue;
      });
    });

    return RevenueWithLoadingState(
      revenue: asyncValue.valueOrNull ?? cachedRevenue,
      isLoading: asyncValue.isLoading,
      hasError: asyncValue.hasError,
      error: asyncValue.error,
    );
  },
);

/// State class that holds revenue data with loading status
@immutable
class RevenueWithLoadingState {
  final Revenue? revenue;
  final bool isLoading;
  final bool hasError;
  final Object? error;

  const RevenueWithLoadingState({
    required this.revenue,
    required this.isLoading,
    required this.hasError,
    this.error,
  });

  /// True if we have data to display (either fresh or cached)
  bool get hasData => revenue != null;

  /// True if showing cached data while loading new data
  bool get isRefreshing => isLoading && hasData;
}
