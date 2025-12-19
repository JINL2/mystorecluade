// lib/features/cash_ending/presentation/providers/bank_tab_notifier.dart

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import '../../domain/usecases/save_bank_balance_usecase.dart';
import '../../domain/usecases/get_balance_summary_usecase.dart';
import 'bank_tab_state.dart';
import 'base_tab_notifier.dart';

/// Notifier for Bank Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
class BankTabNotifier extends BaseTabNotifier<BankTabState> {
  final SaveBankBalanceUseCase _saveBankBalanceUseCase;
  final GetBankBalanceSummaryUseCase _getBalanceSummaryUseCase;

  BankTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required SaveBankBalanceUseCase saveBankBalanceUseCase,
    required GetBankBalanceSummaryUseCase getBalanceSummaryUseCase,
  })  : _saveBankBalanceUseCase = saveBankBalanceUseCase,
        _getBalanceSummaryUseCase = getBalanceSummaryUseCase,
        super(
          getStockFlowsUseCase: getStockFlowsUseCase,
          initialState: const BankTabState(),
        );

  /// Update loading state - type-safe implementation
  @override
  BankTabState updateLoadingState({required bool isLoading, String? error}) {
    return state.copyWith(
      isLoadingFlows: isLoading,
      errorMessage: error,
    );
  }

  /// Update flows state - type-safe implementation
  @override
  BankTabState updateFlowsState({
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
  BankTabState updateErrorState(String error) {
    return state.copyWith(
      isLoadingFlows: false,
      errorMessage: error,
    );
  }

  /// Save bank balance - tab-specific implementation
  ///
  /// ✅ Uses SaveBankBalanceUseCase (Clean Architecture compliant)
  @override
  Future<bool> saveData({
    required data,
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (data is! BankBalance) {
      throw ArgumentError('Expected BankBalance, got ${data.runtimeType}');
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // ✅ UseCase handles validation and save
      await _saveBankBalanceUseCase.execute(data);

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
  Future<bool> saveBankBalance(BankBalance bankBalance) {
    return saveData(
      data: bankBalance,
      companyId: bankBalance.companyId,
      storeId: bankBalance.storeId ?? '',
      locationId: bankBalance.locationId,
    );
  }

  /// Submit bank ending and show balance summary dialog
  ///
  /// This is the main submit method called after bank balance save.
  /// It fetches the balance summary and triggers the dialog display.
  ///
  /// ✅ Uses GetBankBalanceSummaryUseCase (Clean Architecture compliant)
  Future<void> submitBankEnding({
    required String locationId,
  }) async {
    try {
      // ✅ UseCase handles validation and fetches balance summary
      final balanceSummary = await _getBalanceSummaryUseCase.execute(locationId);

      // Update state with balance summary and show dialog
      state = state.copyWith(
        balanceSummary: balanceSummary,
        showBalanceDialog: true,
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'BankTabNotifier.submitBankEnding failed',
        extra: {'locationId': locationId},
      );
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

  /// Reset bank tab state (including isSaving flag)
  void reset() {
    state = state.copyWith(
      isSaving: false,
      errorMessage: null,
      showBalanceDialog: false,
      balanceSummary: null,
    );
  }

  /// Set saving state immediately (for double-tap prevention)
  /// Call this at the START of onSave callback to prevent rapid taps
  void setSaving(bool value) {
    state = state.copyWith(isSaving: value);
  }
}
