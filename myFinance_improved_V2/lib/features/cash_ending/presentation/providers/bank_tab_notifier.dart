// lib/features/cash_ending/presentation/providers/bank_tab_notifier.dart

import 'package:flutter/foundation.dart';

import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/usecases/get_stock_flows_usecase.dart';
import 'bank_tab_state.dart';
import 'base_tab_notifier.dart';

/// Notifier for Bank Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
///
/// ✅ Uses GetStockFlowsUseCase (Clean Architecture compliant)
class BankTabNotifier extends BaseTabNotifier<BankTabState> {
  final BankRepository _bankRepository;

  BankTabNotifier({
    required GetStockFlowsUseCase getStockFlowsUseCase,
    required BankRepository bankRepository,
  })  : _bankRepository = bankRepository,
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
      await _bankRepository.saveBankBalance(data);

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
  Future<void> submitBankEnding({
    required String locationId,
  }) async {
    debugPrint('\n📊 [BankTabNotifier] submitBankEnding() 호출');
    debugPrint('   - locationId: $locationId');

    try {
      // Fetch balance summary from repository
      debugPrint('🚀 [BankTabNotifier] getBalanceSummary() 호출...');
      final balanceSummary = await _bankRepository.getBalanceSummary(
        locationId: locationId,
      );

      debugPrint('✅ [BankTabNotifier] Balance Summary 받음:');
      debugPrint('   - Total Journal: ${balanceSummary.formattedTotalJournal}');
      debugPrint('   - Total Real: ${balanceSummary.formattedTotalReal}');
      debugPrint('   - Difference: ${balanceSummary.formattedDifference}');

      // Update state with balance summary and show dialog
      state = state.copyWith(
        balanceSummary: balanceSummary,
        showBalanceDialog: true,
      );

      debugPrint('✅ [BankTabNotifier] Dialog 표시 준비 완료');
    } catch (e) {
      debugPrint('❌ [BankTabNotifier] submitBankEnding() 에러: $e');
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
}
