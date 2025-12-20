// lib/features/cash_ending/presentation/providers/base_tab_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../core/constants.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import 'base_tab_state.dart';

/// Base notifier for all tab notifiers (Cash, Bank, Vault)
///
/// Eliminates 150+ lines of duplicate code by centralizing common logic:
/// - Stock flow loading with pagination
/// - Error handling
/// - State management patterns
///
/// Each tab only needs to implement tab-specific save logic (10-20 lines)
///
/// ✅ Uses GetStockFlowsUseCase (Clean Architecture compliant)
abstract class BaseTabNotifier<T extends BaseTabState> extends StateNotifier<T> {
  final GetStockFlowsUseCase _getStockFlowsUseCase;

  BaseTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required T initialState,
  })  : _getStockFlowsUseCase = getStockFlowsUseCase,
        super(initialState);

  /// Safe state update - checks if notifier is still mounted
  void safeSetState(T newState) {
    if (mounted) {
      state = newState;
    }
  }

  /// Update loading state - must be implemented by each subclass
  /// This ensures type safety without dynamic casting
  T updateLoadingState({required bool isLoading, String? error});

  /// Update flows state - must be implemented by each subclass
  T updateFlowsState({
    required List<ActualFlow> flows,
    LocationSummary? summary,
    required bool hasMore,
    required int offset,
  });

  /// Update error state - must be implemented by each subclass
  T updateErrorState(String error);

  /// Load stock flows for the selected location
  ///
  /// ✅ Uses GetStockFlowsUseCase with pagination support
  /// Common implementation used by all tabs
  /// Handles pagination, loading states, and error management
  Future<void> loadStockFlows({
    required String companyId,
    required String storeId,
    required String locationId,
    bool loadMore = false,
  }) async {
    if (!mounted) return;
    if (state.isLoadingFlows) return;

    state = updateLoadingState(isLoading: true, error: null);

    try {
      final offset = loadMore ? state.flowsOffset : 0;

      // ✅ Use UseCase instead of direct Repository access
      final result = await _getStockFlowsUseCase.execute(
        GetStockFlowsParams(
          companyId: companyId,
          storeId: storeId,
          locationId: locationId,
          offset: offset,
          limit: CashEndingConstants.defaultPageSize,
          existingFlows: loadMore ? state.stockFlows : [],
        ),
      );

      if (!mounted) return;

      if (result.success) {
        // UseCase handles pagination merge logic
        safeSetState(updateFlowsState(
          flows: result.actualFlows,
          summary: loadMore ? state.locationSummary : result.locationSummary,
          hasMore: result.pagination?.hasMore ?? false,
          offset: result.actualFlows.length,
        ));
      } else {
        safeSetState(updateErrorState('Failed to load stock flows'));
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEnding: Failed to load stock flows',
        extra: {
          'locationId': locationId,
          'loadMore': loadMore,
          'offset': state.flowsOffset,
        },
      );
      safeSetState(updateErrorState(e.toString()));
    }
  }

  /// Clear error message
  ///
  /// Common implementation for all tabs
  void clearError() {
    if (!mounted) return;
    state = updateLoadingState(isLoading: state.isLoadingFlows, error: null);
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
