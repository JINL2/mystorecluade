// lib/features/cash_ending/presentation/providers/cash_ending_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import 'cash_ending_notifier.dart';
import 'cash_ending_state.dart';

/// Main Provider for Cash Ending feature
///
/// REFACTORED: Now injects UseCases instead of direct Repositories
/// This ensures all business logic stays in Domain layer
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
final cashEndingProvider =
    StateNotifierProvider<CashEndingNotifier, CashEndingState>((ref) {
  // UseCases (all business logic in Domain)
  final loadStoresUseCase = ref.watch(loadStoresUseCaseProvider);
  final loadCurrenciesUseCase = ref.watch(loadCurrenciesUseCaseProvider);
  final loadLocationsUseCase = ref.watch(loadLocationsUseCaseProvider);
  final selectStoreUseCase = ref.watch(selectStoreUseCaseProvider);
  final loadRecentCashEndingsUseCase = ref.watch(loadRecentCashEndingsUseCaseProvider);
  final saveCashEndingUseCase = ref.watch(saveCashEndingUseCaseProvider);
  final getCashBalanceSummaryUseCase = ref.watch(getCashBalanceSummaryUseCaseProvider);
  final getBankBalanceSummaryUseCase = ref.watch(getBankBalanceSummaryUseCaseProvider);
  final getVaultBalanceSummaryUseCase = ref.watch(getVaultBalanceSummaryUseCaseProvider);

  return CashEndingNotifier(
    loadStoresUseCase: loadStoresUseCase,
    loadCurrenciesUseCase: loadCurrenciesUseCase,
    loadLocationsUseCase: loadLocationsUseCase,
    selectStoreUseCase: selectStoreUseCase,
    loadRecentCashEndingsUseCase: loadRecentCashEndingsUseCase,
    saveCashEndingUseCase: saveCashEndingUseCase,
    getCashBalanceSummaryUseCase: getCashBalanceSummaryUseCase,
    getBankBalanceSummaryUseCase: getBankBalanceSummaryUseCase,
    getVaultBalanceSummaryUseCase: getVaultBalanceSummaryUseCase,
  );
});

