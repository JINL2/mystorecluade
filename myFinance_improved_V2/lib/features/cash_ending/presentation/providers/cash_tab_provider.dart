// lib/features/cash_ending/presentation/providers/cash_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'cash_tab_notifier.dart';
import 'cash_tab_state.dart';

/// Provider for Cash Tab
///
/// ✅ Injects GetStockFlowsUseCase (Clean Architecture compliant)
final cashTabProvider = StateNotifierProvider<CashTabNotifier, CashTabState>((ref) {
  final getStockFlowsUseCase = ref.watch(getStockFlowsUseCaseProvider);
  final cashEndingRepo = ref.watch(cashEndingRepositoryProvider);

  return CashTabNotifier(
    getStockFlowsUseCase: getStockFlowsUseCase,
    cashEndingRepository: cashEndingRepo,
  );
});
