// lib/features/cash_ending/presentation/providers/cash_tab_notifier.dart

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import '../../domain/usecases/save_cash_ending_usecase.dart';
import '../../domain/usecases/get_balance_summary_usecase.dart';
import 'base_tab_notifier.dart';
import 'cash_tab_state.dart';

/// Notifier for Cash Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
class CashTabNotifier extends BaseTabNotifier<CashTabState> {
  final SaveCashEndingUseCase _saveCashEndingUseCase;
  final GetCashBalanceSummaryUseCase _getBalanceSummaryUseCase;

  CashTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required SaveCashEndingUseCase saveCashEndingUseCase,
    required GetCashBalanceSummaryUseCase getBalanceSummaryUseCase,
  })  : _saveCashEndingUseCase = saveCashEndingUseCase,
        _getBalanceSummaryUseCase = getBalanceSummaryUseCase,
        super(
          getStockFlowsUseCase: getStockFlowsUseCase,
          initialState: const CashTabState(),
        );

  /// Update loading state - type-safe implementation
  @override
  CashTabState updateLoadingState({required bool isLoading, String? error}) {
    return state.copyWith(
      isLoadingFlows: isLoading,
      errorMessage: error,
    );
  }

  /// Update flows state - type-safe implementation
  @override
  CashTabState updateFlowsState({
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
  CashTabState updateErrorState(String error) {
    return state.copyWith(
      isLoadingFlows: false,
      errorMessage: error,
    );
  }

  /// Save cash ending - tab-specific implementation
  ///
  /// ✅ Uses SaveCashEndingUseCase (Clean Architecture compliant)
  @override
  Future<bool> saveData({
    required data,
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (!mounted) return false;
    if (data is! CashEnding) {
      throw ArgumentError('Expected CashEnding, got ${data.runtimeType}');
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      // ✅ UseCase handles validation and save
      await _saveCashEndingUseCase.execute(data);

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
  Future<bool> saveCashEnding(CashEnding cashEnding) {
    return saveData(
      data: cashEnding,
      companyId: cashEnding.companyId,
      storeId: cashEnding.storeId ?? '',
      locationId: cashEnding.locationId,
    );
  }

  /// Submit cash ending and show balance summary dialog
  ///
  /// This is the main submit method called after cash ending save.
  /// It fetches the balance summary and triggers the dialog display.
  ///
  /// ✅ Uses GetCashBalanceSummaryUseCase (Clean Architecture compliant)
  Future<void> submitCashEnding({
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
        hint: 'CashTabNotifier.submitCashEnding failed',
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
    state = state.copyWith(
      showBalanceDialog: false,
      balanceSummary: null,
    );
  }

  /// Reset cash tab state (including isSaving flag)
  void reset() {
    if (!mounted) return;
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
    if (!mounted) return;
    state = state.copyWith(isSaving: value);
  }
}
