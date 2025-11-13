// lib/features/cash_ending/presentation/providers/cash_tab_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import 'cash_tab_state.dart';

/// Notifier for Cash Tab
class CashTabNotifier extends StateNotifier<CashTabState> {
  final StockFlowRepository _stockFlowRepository;
  final CashEndingRepository _cashEndingRepository;

  CashTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required CashEndingRepository cashEndingRepository,
  })  : _stockFlowRepository = stockFlowRepository,
        _cashEndingRepository = cashEndingRepository,
        super(const CashTabState());

  /// Load stock flows for the selected location
  Future<void> loadStockFlows({
    required String companyId,
    required String storeId,
    required String locationId,
    bool loadMore = false,
  }) async {
    if (state.isLoadingFlows) return;

    state = state.copyWith(
      isLoadingFlows: true,
      errorMessage: null,
    );

    try {
      final offset = loadMore ? state.flowsOffset : 0;

      final result = await _stockFlowRepository.getLocationStockFlow(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: locationId,
        offset: offset,
        limit: CashEndingConstants.defaultPageSize,
      );

      if (result.success) {
        final newFlows = loadMore
            ? [...state.stockFlows, ...result.actualFlows]
            : result.actualFlows;

        state = state.copyWith(
          stockFlows: newFlows,
          locationSummary: loadMore ? state.locationSummary : result.locationSummary,
          hasMoreFlows: result.pagination?.hasMore ?? false,
          flowsOffset: newFlows.length,
          isLoadingFlows: false,
        );
      } else {
        state = state.copyWith(
          isLoadingFlows: false,
          errorMessage: 'Failed to load stock flows',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingFlows: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Save cash ending
  Future<bool> saveCashEnding(CashEnding cashEnding) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _cashEndingRepository.saveCashEnding(cashEnding);

      state = state.copyWith(isSaving: false);

      // Reload stock flows after save
      if (cashEnding.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: cashEnding.companyId,
          storeId: cashEnding.storeId ?? '',
          locationId: cashEnding.locationId,
        );
      }

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
