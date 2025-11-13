// lib/features/cash_ending/presentation/providers/vault_tab_notifier.dart

import '../../domain/entities/vault_transaction.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import '../../domain/repositories/vault_repository.dart';
import 'base_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Notifier for Vault Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
class VaultTabNotifier extends BaseTabNotifier<VaultTabState> {
  final VaultRepository _vaultRepository;

  VaultTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required VaultRepository vaultRepository,
  })  : _vaultRepository = vaultRepository,
        super(
          stockFlowRepository: stockFlowRepository,
          initialState: const VaultTabState(),
        );

  /// Save vault transaction - tab-specific implementation
  @override
  Future<bool> saveData({
    required data,
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (data is! VaultTransaction) {
      throw ArgumentError('Expected VaultTransaction, got ${data.runtimeType}');
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _vaultRepository.saveVaultTransaction(data);

      state = state.copyWith(isSaving: false);

      // Reload stock flows after save
      if (locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: companyId,
          storeId: storeId,
          locationId: locationId,
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

  /// Convenience method for type-safe saving
  Future<bool> saveVaultTransaction(VaultTransaction transaction) {
    return saveData(
      data: transaction,
      companyId: transaction.companyId,
      storeId: transaction.storeId ?? '',
      locationId: transaction.locationId,
    );
  }
}
