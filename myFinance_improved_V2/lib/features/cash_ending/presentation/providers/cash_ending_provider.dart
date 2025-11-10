// lib/features/cash_ending/presentation/providers/cash_ending_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/repository_providers.dart';
import 'cash_ending_state.dart';
import 'cash_ending_notifier.dart';

/// Main Provider for Cash Ending feature
final cashEndingProvider =
    StateNotifierProvider<CashEndingNotifier, CashEndingState>((ref) {
  final cashEndingRepo = ref.watch(cashEndingRepositoryProvider);
  final locationRepo = ref.watch(locationRepositoryProvider);
  final currencyRepo = ref.watch(currencyRepositoryProvider);
  final bankRepo = ref.watch(bankRepositoryProvider);
  final vaultRepo = ref.watch(vaultRepositoryProvider);

  return CashEndingNotifier(
    cashEndingRepository: cashEndingRepo,
    locationRepository: locationRepo,
    currencyRepository: currencyRepo,
    bankRepository: bankRepo,
    vaultRepository: vaultRepo,
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
