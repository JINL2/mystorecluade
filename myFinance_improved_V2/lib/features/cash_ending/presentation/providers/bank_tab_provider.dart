// lib/features/cash_ending/presentation/providers/bank_tab_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'bank_tab_notifier.dart';
import 'bank_tab_state.dart';

/// Provider for Bank Tab
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
final bankTabProvider = StateNotifierProvider<BankTabNotifier, BankTabState>((ref) {
  final getStockFlowsUseCase = ref.watch(getStockFlowsUseCaseProvider);
  final saveBankBalanceUseCase = ref.watch(saveBankBalanceUseCaseProvider);
  final getBalanceSummaryUseCase = ref.watch(getBankBalanceSummaryUseCaseProvider);

  return BankTabNotifier(
    getStockFlowsUseCase: getStockFlowsUseCase,
    saveBankBalanceUseCase: saveBankBalanceUseCase,
    getBalanceSummaryUseCase: getBalanceSummaryUseCase,
  );
});
