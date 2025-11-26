// lib/features/cash_ending/presentation/providers/cash_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'cash_tab_notifier.dart';
import 'cash_tab_state.dart';

/// Provider for Cash Tab
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
final cashTabProvider = StateNotifierProvider<CashTabNotifier, CashTabState>((ref) {
  final getStockFlowsUseCase = ref.watch(getStockFlowsUseCaseProvider);
  final saveCashEndingUseCase = ref.watch(saveCashEndingUseCaseProvider);
  final getBalanceSummaryUseCase = ref.watch(getCashBalanceSummaryUseCaseProvider);

  return CashTabNotifier(
    getStockFlowsUseCase: getStockFlowsUseCase,
    saveCashEndingUseCase: saveCashEndingUseCase,
    getBalanceSummaryUseCase: getBalanceSummaryUseCase,
  );
});
