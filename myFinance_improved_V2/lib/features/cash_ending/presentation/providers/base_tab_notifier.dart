// lib/features/cash_ending/presentation/providers/base_tab_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import 'base_tab_state.dart';

/// Base notifier for all tab notifiers (Cash, Bank, Vault)
///
/// Eliminates 150+ lines of duplicate code by centralizing common logic:
/// - Stock flow loading with pagination
/// - Error handling
/// - State management patterns
///
/// Each tab only needs to implement tab-specific save logic (10-20 lines)
abstract class BaseTabNotifier<T extends BaseTabState> extends StateNotifier<T> {
  final StockFlowRepository stockFlowRepository;

  BaseTabNotifier({
    required this.stockFlowRepository,
    required T initialState,
  }) : super(initialState);

  /// Load stock flows for the selected location
  ///
  /// Common implementation used by all tabs
  /// Handles pagination, loading states, and error management
  Future<void> loadStockFlows({
    required String companyId,
    required String storeId,
    required String locationId,
    bool loadMore = false,
  }) async {
    if (state.isLoadingFlows) return;

    state = (state as dynamic).copyWith(
      isLoadingFlows: true,
      errorMessage: null,
    ) as T;

    try {
      final offset = loadMore ? state.flowsOffset : 0;

      final result = await stockFlowRepository.getLocationStockFlow(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: locationId,
        offset: offset,
        limit: CashEndingConstants.defaultPageSize,
      );

      if (result.success) {
        // Optimize list copying: use List.of() + addAll() instead of spread operator
        // This is more efficient for large lists (O(n) single allocation vs O(n) multiple allocations)
        final newFlows = loadMore
            ? (List<ActualFlow>.of(state.stockFlows)..addAll(result.actualFlows))
            : result.actualFlows;

        state = (state as dynamic).copyWith(
          stockFlows: newFlows,
          locationSummary: loadMore ? state.locationSummary : result.locationSummary,
          hasMoreFlows: result.pagination?.hasMore ?? false,
          flowsOffset: newFlows.length,
          isLoadingFlows: false,
        ) as T;
      } else {
        state = (state as dynamic).copyWith(
          isLoadingFlows: false,
          errorMessage: 'Failed to load stock flows',
        ) as T;
      }
    } catch (e) {
      state = (state as dynamic).copyWith(
        isLoadingFlows: false,
        errorMessage: e.toString(),
      ) as T;
    }
  }

  /// Clear error message
  ///
  /// Common implementation for all tabs
  void clearError() {
    state = (state as dynamic).copyWith(errorMessage: null) as T;
  }

  /// Save operation - to be implemented by each tab
  ///
  /// Each tab has unique save logic:
  /// - CashTab: saveCashEnding(CashEnding)
  /// - BankTab: saveBankBalance(BankBalance)
  /// - VaultTab: saveVaultTransaction(VaultTransaction)
  ///
  /// Common pattern:
  /// 1. Set isSaving = true
  /// 2. Call repository
  /// 3. Set isSaving = false
  /// 4. Reload stock flows
  /// 5. Return success/failure
  Future<bool> saveData({
    required dynamic data,
    required String companyId,
    required String storeId,
    required String locationId,
  });
}
