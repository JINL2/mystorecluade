// lib/features/cash_ending/presentation/providers/cash_tab_notifier.dart

import 'package:flutter/foundation.dart';

import '../../domain/entities/cash_ending.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import 'base_tab_notifier.dart';
import 'cash_tab_state.dart';

/// Notifier for Cash Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ Uses GetStockFlowsUseCase (Clean Architecture compliant)
class CashTabNotifier extends BaseTabNotifier<CashTabState> {
  final CashEndingRepository _cashEndingRepository;

  CashTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required CashEndingRepository cashEndingRepository,
  })  : _cashEndingRepository = cashEndingRepository,
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
  @override
  Future<bool> saveData({
    required data,
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (data is! CashEnding) {
      throw ArgumentError('Expected CashEnding, got ${data.runtimeType}');
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _cashEndingRepository.saveCashEnding(data);

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
  Future<void> submitCashEnding({
    required String locationId,
  }) async {
    debugPrint('\n📊 [CashTabNotifier] submitCashEnding() 호출');
    debugPrint('   - locationId: $locationId');

    try {
      // Fetch balance summary from repository
      debugPrint('🚀 [CashTabNotifier] getBalanceSummary() 호출...');
      final balanceSummary = await _cashEndingRepository.getBalanceSummary(
        locationId: locationId,
      );

      debugPrint('✅ [CashTabNotifier] Balance Summary 받음:');
      debugPrint('   - Total Journal: ${balanceSummary.formattedTotalJournal}');
      debugPrint('   - Total Real: ${balanceSummary.formattedTotalReal}');
      debugPrint('   - Difference: ${balanceSummary.formattedDifference}');

      // Update state with balance summary and show dialog
      state = state.copyWith(
        balanceSummary: balanceSummary,
        showBalanceDialog: true,
      );

      debugPrint('✅ [CashTabNotifier] Dialog 표시 준비 완료');
    } catch (e) {
      debugPrint('❌ [CashTabNotifier] submitCashEnding() 에러: $e');
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

  /// Reset cash tab state (including isSaving flag)
  void reset() {
    state = state.copyWith(
      isSaving: false,
      errorMessage: null,
      showBalanceDialog: false,
      balanceSummary: null,
    );
  }
}
