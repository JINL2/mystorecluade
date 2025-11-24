// lib/features/cash_ending/presentation/providers/vault_tab_notifier.dart

import 'package:flutter/foundation.dart';

import '../../domain/entities/vault_transaction.dart';
import '../../domain/entities/vault_recount.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import '../../domain/repositories/vault_repository.dart';
import 'base_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Notifier for Vault Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ Uses GetStockFlowsUseCase (Clean Architecture compliant)
class VaultTabNotifier extends BaseTabNotifier<VaultTabState> {
  final VaultRepository _vaultRepository;

  VaultTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required VaultRepository vaultRepository,
  })  : _vaultRepository = vaultRepository,
        super(
          getStockFlowsUseCase: getStockFlowsUseCase,
          initialState: const VaultTabState(),
        );

  /// Update loading state - type-safe implementation
  @override
  VaultTabState updateLoadingState({required bool isLoading, String? error}) {
    return state.copyWith(
      isLoadingFlows: isLoading,
      errorMessage: error,
    );
  }

  /// Update flows state - type-safe implementation
  @override
  VaultTabState updateFlowsState({
    required flows,
    summary,
    required bool hasMore,
    required int offset,
  }) {
    return state.copyWith(
      stockFlows: flows,
      locationSummary: summary,
      hasMoreFlows: hasMore,
      flowsOffset: offset,
      isLoadingFlows: false,
    );
  }

  /// Update error state - type-safe implementation
  @override
  VaultTabState updateErrorState(String error) {
    return state.copyWith(
      isLoadingFlows: false,
      errorMessage: error,
    );
  }

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
    debugPrint('\n🔷 [VaultTabNotifier] saveVaultTransaction() 호출');
    debugPrint('   - locationId: ${transaction.locationId}');
    debugPrint('   - isCredit: ${transaction.isCredit}');
    debugPrint('   - totalAmount: ${transaction.totalAmount}');

    return saveData(
      data: transaction,
      companyId: transaction.companyId,
      storeId: transaction.storeId ?? '',
      locationId: transaction.locationId,
    );
  }

  /// Perform vault recount (Stock to Flow conversion)
  ///
  /// Takes actual stock count and returns adjustment details.
  /// Returns a map with:
  /// - success: bool
  /// - adjustment_count: int
  /// - total_variance: num
  /// - adjustments: List<Map>
  Future<Map<String, dynamic>> recountVault(VaultRecount recount) async {
    debugPrint('\n🟢 [VaultTabNotifier] recountVault() 호출 - Stock → Flow 변환 시작');
    debugPrint('   - locationId: ${recount.locationId}');
    debugPrint('   - currencyId: ${recount.currencyId}');
    debugPrint('   - totalAmount (Stock): ${recount.totalAmount}');
    debugPrint('   - denominations: ${recount.denominations.length}개');

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      debugPrint('🚀 [VaultTabNotifier] VaultRepository.recountVault() 호출...');
      // Call repository to perform recount
      final result = await _vaultRepository.recountVault(recount);

      debugPrint('✅ [VaultTabNotifier] RPC 응답 받음:');
      debugPrint('   - success: ${result['success']}');
      debugPrint('   - adjustment_count: ${result['adjustment_count']}');
      debugPrint('   - total_variance: ${result['total_variance']}');

      state = state.copyWith(isSaving: false);

      // Reload stock flows after recount
      debugPrint('🔄 [VaultTabNotifier] Stock flows 리로드 중...');
      if (recount.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: recount.companyId,
          storeId: recount.storeId ?? '',
          locationId: recount.locationId,
        );
      }

      debugPrint('✅ [VaultTabNotifier] recountVault() 완료!');
      return result;
    } catch (e) {
      debugPrint('❌ [VaultTabNotifier] recountVault() 에러: $e');
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      rethrow; // Re-throw to let caller handle the error
    }
  }

  /// Submit vault ending and show balance summary dialog
  ///
  /// This is the main submit method called after vault recount.
  /// It fetches the balance summary and triggers the dialog display.
  Future<void> submitVaultEnding({
    required String locationId,
  }) async {
    debugPrint('\n📊 [VaultTabNotifier] submitVaultEnding() 호출');
    debugPrint('   - locationId: $locationId');

    try {
      // Fetch balance summary from repository
      debugPrint('🚀 [VaultTabNotifier] getBalanceSummary() 호출...');
      final balanceSummary = await _vaultRepository.getBalanceSummary(
        locationId: locationId,
      );

      debugPrint('✅ [VaultTabNotifier] Balance Summary 받음:');
      debugPrint('   - Total Journal: ${balanceSummary.formattedTotalJournal}');
      debugPrint('   - Total Real: ${balanceSummary.formattedTotalReal}');
      debugPrint('   - Difference: ${balanceSummary.formattedDifference}');

      // Update state with balance summary and show dialog
      state = state.copyWith(
        balanceSummary: balanceSummary,
        showBalanceDialog: true,
      );

      debugPrint('✅ [VaultTabNotifier] Dialog 표시 준비 완료');
    } catch (e) {
      debugPrint('❌ [VaultTabNotifier] submitVaultEnding() 에러: $e');
      state = state.copyWith(
        errorMessage: 'Failed to get balance summary: $e',
      );
    }
  }

  /// Close balance summary dialog
  void closeBalanceDialog() {
    state = state.copyWith(
      showBalanceDialog: false,
      balanceSummary: null,
    );
  }

  /// Execute multi-currency RECOUNT (all currencies in one RPC call)
  ///
  /// This directly calls insert_amount_multi_currency RPC with multiple currencies.
  /// More efficient than calling recountVault() multiple times.
  ///
  /// RPC Parameters:
  /// - p_entry_type: 'vault'
  /// - p_vault_transaction_type: 'recount'
  /// - p_currencies: [{ currency_id, denominations: [...] }, ...]
  Future<void> executeMultiCurrencyRecount(Map<String, dynamic> rpcParams) async {
    debugPrint('\n🟢 [VaultTabNotifier] executeMultiCurrencyRecount() 호출');
    debugPrint('   - Location: ${rpcParams['p_location_id']}');
    debugPrint('   - Currencies: ${(rpcParams['p_currencies'] as List).length}개');

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      debugPrint('🚀 [VaultTabNotifier] Calling insert_amount_multi_currency RPC directly...');

      // Call RPC directly through repository's data source
      await _vaultRepository.executeMultiCurrencyRecount(rpcParams);

      debugPrint('✅ [VaultTabNotifier] Multi-currency RECOUNT 완료!');
      state = state.copyWith(isSaving: false);

      // Reload stock flows after recount
      if ((rpcParams['p_location_id'] as String).isNotEmpty) {
        await loadStockFlows(
          companyId: rpcParams['p_company_id'] as String,
          storeId: rpcParams['p_store_id'] as String? ?? '',
          locationId: rpcParams['p_location_id'] as String,
        );
      }
    } catch (e) {
      debugPrint('❌ [VaultTabNotifier] executeMultiCurrencyRecount() 에러: $e');
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  /// Reset vault tab state (including isSaving flag)
  void reset() {
    state = state.copyWith(
      isSaving: false,
      errorMessage: null,
      showBalanceDialog: false,
      balanceSummary: null,
    );
  }
}
