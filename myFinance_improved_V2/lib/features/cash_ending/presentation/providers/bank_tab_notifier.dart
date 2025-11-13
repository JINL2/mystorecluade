// lib/features/cash_ending/presentation/providers/bank_tab_notifier.dart

import '../../domain/entities/bank_balance.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/stock_flow_repository.dart';
import 'bank_tab_state.dart';
import 'base_tab_notifier.dart';

/// Notifier for Bank Tab
///
/// Extends BaseTabNotifier to eliminate duplicate code
/// Only implements tab-specific save logic
class BankTabNotifier extends BaseTabNotifier<BankTabState> {
  final BankRepository _bankRepository;

  BankTabNotifier({
    required StockFlowRepository stockFlowRepository,
    required BankRepository bankRepository,
  })  : _bankRepository = bankRepository,
        super(
          stockFlowRepository: stockFlowRepository,
          initialState: const BankTabState(),
        );

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
}
