// lib/features/cash_ending/presentation/providers/cash_tab_notifier.dart

import '../../domain/entities/cash_ending.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import 'base_tab_notifier.dart';
import 'cash_tab_state.dart';

/// Notifier for Cash Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
class CashTabNotifier extends BaseTabNotifier<CashTabState> {
  final CashEndingRepository _cashEndingRepository;

  CashTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required CashEndingRepository cashEndingRepository,
  })  : _cashEndingRepository = cashEndingRepository,
        super(
          stockFlowRepository: stockFlowRepository,
          initialState: const CashTabState(),
        );

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
}
