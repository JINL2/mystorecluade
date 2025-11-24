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

  return CashEndingNotifier(
    loadStoresUseCase: loadStoresUseCase,
    loadCurrenciesUseCase: loadCurrenciesUseCase,
    loadLocationsUseCase: loadLocationsUseCase,
    selectStoreUseCase: selectStoreUseCase,
    loadRecentCashEndingsUseCase: loadRecentCashEndingsUseCase,
    saveCashEndingUseCase: saveCashEndingUseCase,
  );
});

/// Derived providers for easy access to specific state slices

/// Provider for selected store ID
final selectedStoreIdProvider = Provider<String?>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.selectedStoreId));
});

/// Provider for selected location ID (based on current tab)
final currentLocationIdProvider = Provider<String?>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.currentSelectedLocationId));
});

/// Provider for selected currency ID (based on current tab)
final currentCurrencyIdProvider = Provider<String?>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.currentSelectedCurrencyId));
});

/// Provider for current tab index
final currentTabIndexProvider = Provider<int>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.currentTabIndex));
});

/// Provider for loading state
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.isLoading));
});

/// Provider for error message
final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.errorMessage));
});

/// Provider for success message
final successMessageProvider = Provider<String?>((ref) {
  return ref.watch(cashEndingProvider.select((state) => state.successMessage));
});
