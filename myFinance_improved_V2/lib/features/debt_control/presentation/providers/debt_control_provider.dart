import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/aging_analysis.dart';
import '../../domain/entities/debt_overview.dart';
import '../../domain/entities/kpi_metrics.dart';
import '../../domain/value_objects/debt_filter.dart';
import 'debt_repository_provider.dart';
import 'states/debt_control_state.dart';

/// Main debt control provider managing overview and debts list
final debtControlProvider =
    AsyncNotifierProvider<DebtControlNotifier, DebtControlState>(
  () => DebtControlNotifier(),
);

class DebtControlNotifier extends AsyncNotifier<DebtControlState> {
  @override
  Future<DebtControlState> build() async {
    // Start with loading state to prevent showing empty state before data loads
    return const DebtControlState(isLoadingDebts: true);
  }

  /// Load smart overview with AI-driven insights
  Future<void> loadSmartOverview({
    required String companyId,
    String? storeId,
    required String viewpoint,
  }) async {
    // Set loading state for overview only
    state = AsyncValue.data(
      state.value?.copyWith(isLoadingOverview: true) ?? const DebtControlState(isLoadingOverview: true),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);

      // Use the repository's getSmartOverview which fetches all data in parallel
      final overview = await repository.getSmartOverview(
        companyId: companyId,
        storeId: storeId,
        viewpoint: viewpoint,
      );

      state = AsyncValue.data(
        state.value?.copyWith(
              overview: overview,
              viewpoint: viewpoint,
              isLoadingOverview: false,
            ) ??
            DebtControlState(
              overview: overview,
              viewpoint: viewpoint,
              isLoadingOverview: false,
            ),
      );
    } catch (error) {
      // Provide default state instead of error for better UX
      state = AsyncValue.data(
        state.value?.copyWith(
              overview: DebtOverview(
                kpiMetrics: const KpiMetrics(),
                agingAnalysis: const AgingAnalysis(),
                criticalAlerts: const [],
                topRisks: const [],
                viewpointDescription: _getViewpointDescription(viewpoint),
                lastUpdated: DateTime.now(),
              ),
              viewpoint: viewpoint,
              isLoadingOverview: false,
            ) ??
            DebtControlState(
              overview: DebtOverview(
                kpiMetrics: const KpiMetrics(),
                agingAnalysis: const AgingAnalysis(),
                criticalAlerts: const [],
                topRisks: const [],
                viewpointDescription: _getViewpointDescription(viewpoint),
                lastUpdated: DateTime.now(),
              ),
              viewpoint: viewpoint,
              isLoadingOverview: false,
            ),
      );
    }
  }

  /// Load prioritized debts with risk scoring
  Future<void> loadPrioritizedDebts({
    required String companyId,
    String? storeId,
    required String viewpoint,
    String filter = 'all',
    int limit = 50,
    int offset = 0,
  }) async {
    // Set loading state for debts only
    state = AsyncValue.data(
      state.value?.copyWith(isLoadingDebts: true) ?? const DebtControlState(isLoadingDebts: true),
    );

    try {
      final repository = ref.read(debtRepositoryProvider);

      final debts = await repository.getPrioritizedDebts(
        companyId: companyId,
        storeId: storeId,
        viewpoint: viewpoint,
        filter: filter,
        limit: limit,
        offset: offset,
      );

      // Sort debts once: Internal companies first, then by absolute amount (descending)
      final sortedDebts = List.of(debts)
        ..sort((a, b) {
          // First priority: Internal companies on top
          if (a.isInternal && !b.isInternal) return -1;
          if (!a.isInternal && b.isInternal) return 1;
          // Second priority: Sort by absolute amount (descending)
          return b.amount.abs().compareTo(a.amount.abs());
        });

      state = AsyncValue.data(
        state.value?.copyWith(
              debts: sortedDebts,
              viewpoint: viewpoint,
              isLoadingDebts: false,
            ) ??
            DebtControlState(
              debts: sortedDebts,
              viewpoint: viewpoint,
              isLoadingDebts: false,
            ),
      );
    } catch (error) {
      // Provide empty list instead of error for better UX
      state = AsyncValue.data(
        state.value?.copyWith(
              debts: const [],
              isLoadingDebts: false,
            ) ??
            const DebtControlState(
              debts: [],
              isLoadingDebts: false,
            ),
      );
    }
  }

  /// Refresh all data (overview + debts)
  Future<void> refresh({
    required String companyId,
    String? storeId,
    required String viewpoint,
    String filter = 'all',
  }) async {
    final repository = ref.read(debtRepositoryProvider);
    await repository.refreshData();

    // Load both overview and debts in parallel
    await Future.wait([
      loadSmartOverview(
        companyId: companyId,
        storeId: storeId,
        viewpoint: viewpoint,
      ),
      loadPrioritizedDebts(
        companyId: companyId,
        storeId: storeId,
        viewpoint: viewpoint,
        filter: filter,
      ),
    ]);
  }

  /// Update filter
  void updateFilter(DebtFilter filter) {
    state = AsyncValue.data(
      state.value?.copyWith(filter: filter) ?? DebtControlState(filter: filter),
    );
  }

  /// Update viewpoint
  void updateViewpoint(String viewpoint) {
    state = AsyncValue.data(
      state.value?.copyWith(viewpoint: viewpoint) ?? DebtControlState(viewpoint: viewpoint),
    );
  }

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    try {
      final repository = ref.read(debtRepositoryProvider);
      await repository.markAlertAsRead(alertId);

      // Update local state by removing the alert
      if (state.value?.overview != null) {
        final overview = state.value!.overview!;
        final updatedAlerts = overview.criticalAlerts
            .map((alert) => alert.id == alertId ? alert.copyWith(isRead: true) : alert)
            .toList();

        state = AsyncValue.data(
          state.value!.copyWith(
            overview: overview.copyWith(criticalAlerts: updatedAlerts),
          ),
        );
      }
    } catch (error) {
      // Silently fail for better UX
    }
  }

  String _getViewpointDescription(String viewpoint) {
    switch (viewpoint) {
      case 'company':
        return 'Company-wide debt overview';
      case 'store':
        return 'Store-specific debt analysis';
      case 'headquarters':
        return 'Headquarters debt management';
      default:
        return 'Debt overview';
    }
  }
}
