// lib/features/cash_ending/presentation/providers/bank_tab_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import 'bank_tab_state.dart';

/// Notifier for Bank Tab
class BankTabNotifier extends StateNotifier<BankTabState> {
  final StockFlowRepository _stockFlowRepository;
  final BankRepository _bankRepository;

  BankTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required BankRepository bankRepository,
  })  : _stockFlowRepository = stockFlowRepository,
        _bankRepository = bankRepository,
        super(const BankTabState());

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

  /// Save bank balance
  Future<bool> saveBankBalance(BankBalance bankBalance) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _bankRepository.saveBankBalance(bankBalance);

      state = state.copyWith(isSaving: false);

      // Reload stock flows after save
      if (bankBalance.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: bankBalance.companyId,
          storeId: bankBalance.storeId ?? '',
          locationId: bankBalance.locationId,
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
