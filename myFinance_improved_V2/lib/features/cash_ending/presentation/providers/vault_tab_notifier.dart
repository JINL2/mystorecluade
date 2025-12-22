// lib/features/cash_ending/presentation/providers/vault_tab_notifier.dart

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/entities/vault_transaction.dart';
import '../../domain/entities/vault_recount.dart';
import '../../domain/entities/multi_currency_recount.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import '../../domain/usecases/save_vault_transaction_usecase.dart';
import '../../domain/usecases/recount_vault_usecase.dart';
import '../../domain/usecases/execute_multi_currency_recount_usecase.dart';
import '../../domain/usecases/get_balance_summary_usecase.dart';
import 'base_tab_notifier.dart';
import 'vault_tab_state.dart';

/// Notifier for Vault Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
class VaultTabNotifier extends BaseTabNotifier<VaultTabState> {
  final SaveVaultTransactionUseCase _saveVaultTransactionUseCase;
  final RecountVaultUseCase _recountVaultUseCase;
  final ExecuteMultiCurrencyRecountUseCase _executeMultiCurrencyRecountUseCase;
  final GetVaultBalanceSummaryUseCase _getBalanceSummaryUseCase;

  VaultTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required SaveVaultTransactionUseCase saveVaultTransactionUseCase,
    required RecountVaultUseCase recountVaultUseCase,
    required ExecuteMultiCurrencyRecountUseCase executeMultiCurrencyRecountUseCase,
    required GetVaultBalanceSummaryUseCase getBalanceSummaryUseCase,
  })  : _saveVaultTransactionUseCase = saveVaultTransactionUseCase,
        _recountVaultUseCase = recountVaultUseCase,
        _executeMultiCurrencyRecountUseCase = executeMultiCurrencyRecountUseCase,
        _getBalanceSummaryUseCase = getBalanceSummaryUseCase,
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
  ///
  /// ✅ Uses SaveVaultTransactionUseCase (Clean Architecture compliant)
  @override
  Future<bool> saveData({
    required data,
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (!mounted) return false;
    if (data is! VaultTransaction) {
      throw ArgumentError('Expected VaultTransaction, got ${data.runtimeType}');
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // ✅ UseCase handles validation and save
      await _saveVaultTransactionUseCase.execute(data);

      if (!mounted) return true;
      safeSetState(state.copyWith(isSaving: false));

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
      safeSetState(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
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

  /// Perform vault recount (Stock to Flow conversion)
  ///
  /// Takes actual stock count and returns adjustment details.
  /// Returns a map with:
  /// - success: bool
  /// - adjustment_count: int
  /// - total_variance: num
  /// - adjustments: List<Map>
  ///
  /// ✅ Uses RecountVaultUseCase (Clean Architecture compliant)
  Future<Map<String, dynamic>> recountVault(VaultRecount recount) async {
    if (!mounted) return {'success': false, 'error': 'Notifier disposed'};
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // ✅ UseCase handles validation and recount
      final result = await _recountVaultUseCase.execute(recount);

      if (!mounted) return result;
      safeSetState(state.copyWith(isSaving: false));

      // Reload stock flows after recount
      if (recount.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: recount.companyId,
          storeId: recount.storeId ?? '',
          locationId: recount.locationId,
        );
      }

      return result;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'VaultTabNotifier.recountVault failed',
        extra: {
          'locationId': recount.locationId,
          'currencyId': recount.currencyId,
        },
      );
      safeSetState(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
      rethrow; // Re-throw to let caller handle the error
    }
  }

  /// Submit vault ending and show balance summary dialog
  ///
  /// This is the main submit method called after vault recount.
  /// It fetches the balance summary and triggers the dialog display.
  ///
  /// ✅ Uses GetVaultBalanceSummaryUseCase (Clean Architecture compliant)
  Future<void> submitVaultEnding({
    required String locationId,
  }) async {
    if (!mounted) return;
    try {
      // ✅ UseCase handles validation and fetches balance summary
      final balanceSummary = await _getBalanceSummaryUseCase.execute(locationId);

      // Update state with balance summary and show dialog
      safeSetState(state.copyWith(
        balanceSummary: balanceSummary,
        showBalanceDialog: true,
      ));
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'VaultTabNotifier.submitVaultEnding failed',
        extra: {'locationId': locationId},
      );
      safeSetState(state.copyWith(
        errorMessage: 'Failed to get balance summary: $e',
      ));
    }
  }

  /// Close balance summary dialog
  void closeBalanceDialog() {
    if (!mounted) return;
    safeSetState(state.copyWith(
      showBalanceDialog: false,
      balanceSummary: null,
    ));
  }

  /// Execute multi-currency RECOUNT (all currencies in one RPC call)
  ///
  /// ✅ Uses ExecuteMultiCurrencyRecountUseCase (Clean Architecture compliant)
  /// ✅ Now accepts MultiCurrencyRecount entity instead of Map
  Future<void> executeMultiCurrencyRecount(MultiCurrencyRecount recount) async {
    if (!mounted) return;
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // ✅ UseCase handles validation and RPC execution
      await _executeMultiCurrencyRecountUseCase.execute(recount);

      if (!mounted) return;
      safeSetState(state.copyWith(isSaving: false));

      // Reload stock flows after recount
      if (recount.locationId.isNotEmpty) {
        await loadStockFlows(
          companyId: recount.companyId,
          storeId: recount.storeId ?? '',
          locationId: recount.locationId,
        );
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'VaultTabNotifier.executeMultiCurrencyRecount failed',
        extra: {
          'locationId': recount.locationId,
          'currencyCount': recount.currencyRecounts.length,
        },
      );
      safeSetState(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Reset vault tab state (including isSaving flag)
  void reset() {
    if (!mounted) return;
    safeSetState(state.copyWith(
      isSaving: false,
      errorMessage: null,
      showBalanceDialog: false,
      balanceSummary: null,
    ));
  }

  /// Set saving state immediately (for double-tap prevention)
  /// Call this at the START of onSave callback to prevent rapid taps
  void setSaving(bool value) {
    if (!mounted) return;
    safeSetState(state.copyWith(isSaving: value));
  }
}
