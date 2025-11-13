// lib/features/cash_ending/presentation/providers/vault_tab_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../domain/entities/vault_transaction.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../../domain/repositories/vault_repository.dart';
import 'vault_tab_state.dart';

/// Notifier for Vault Tab
class VaultTabNotifier extends StateNotifier<VaultTabState> {
  final StockFlowRepository _stockFlowRepository;
  final VaultRepository _vaultRepository;

  VaultTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required VaultRepository vaultRepository,
  })  : _stockFlowRepository = stockFlowRepository,
        _vaultRepository = vaultRepository,
        super(const VaultTabState());

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

  /// Save vault transaction
  Future<bool> saveVaultTransaction(VaultTransaction transaction) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _vaultRepository.saveVaultTransaction(transaction);

      state = state.copyWith(isSaving: false);

      // Reload stock flows after save
      if (transaction.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: transaction.companyId,
          storeId: transaction.storeId ?? '',
          locationId: transaction.locationId,
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
