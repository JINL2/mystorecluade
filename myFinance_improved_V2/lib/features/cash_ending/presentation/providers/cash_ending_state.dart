// lib/features/cash_ending/presentation/providers/cash_ending_state.dart

import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/store.dart';
import '../../domain/entities/currency.dart';

/// State for Cash Ending feature
class CashEndingState {
  // Store and location selection
  final String? selectedStoreId;
  final String? selectedCashLocationId;
  final String? selectedBankLocationId;
  final String? selectedVaultLocationId;

  // Available data
  final List<Store> stores;
  final List<Location> cashLocations;
  final List<Location> bankLocations;
  final List<Location> vaultLocations;
  final List<Currency> currencies;

  // Current tab (0=cash, 1=bank, 2=vault)
  final int currentTabIndex;

  // Selected currency for each tab
  final String? selectedCashCurrencyId;
  final String? selectedBankCurrencyId;
  final String? selectedVaultCurrencyId;

  // Recent cash endings history
  final List<CashEnding> recentCashEndings;

  // Loading states
  final bool isLoadingStores;
  final bool isLoadingCashLocations;
  final bool isLoadingBankLocations;
  final bool isLoadingVaultLocations;
  final bool isLoadingCurrencies;
  final bool isLoadingRecentEndings;
  final bool isSaving;

  // Error state
  final String? error;

  const CashEndingState({
    this.selectedStoreId,
    this.selectedCashLocationId,
    this.selectedBankLocationId,
    this.selectedVaultLocationId,
    this.stores = const [],
    this.cashLocations = const [],
    this.bankLocations = const [],
    this.vaultLocations = const [],
    this.currencies = const [],
    this.currentTabIndex = 0,
    this.selectedCashCurrencyId,
    this.selectedBankCurrencyId,
    this.selectedVaultCurrencyId,
    this.recentCashEndings = const [],
    this.isLoadingStores = false,
    this.isLoadingCashLocations = false,
    this.isLoadingBankLocations = false,
    this.isLoadingVaultLocations = false,
    this.isLoadingCurrencies = false,
    this.isLoadingRecentEndings = false,
    this.isSaving = false,
    this.error,
  });

  /// Get current selected location based on tab
  String? get currentSelectedLocationId {
    switch (currentTabIndex) {
      case 0:
        return selectedCashLocationId;
      case 1:
        return selectedBankLocationId;
      case 2:
        return selectedVaultLocationId;
      default:
        return null;
    }
  }

  /// Get current selected currency based on tab
  String? get currentSelectedCurrencyId {
    switch (currentTabIndex) {
      case 0:
        return selectedCashCurrencyId;
      case 1:
        return selectedBankCurrencyId;
      case 2:
        return selectedVaultCurrencyId;
      default:
        return null;
    }
  }

  /// Check if any loading is in progress
  bool get isLoading =>
      isLoadingStores ||
      isLoadingCashLocations ||
      isLoadingBankLocations ||
      isLoadingVaultLocations ||
      isLoadingCurrencies ||
      isLoadingRecentEndings ||
      isSaving;

  CashEndingState copyWith({
    String? selectedStoreId,
    String? selectedCashLocationId,
    String? selectedBankLocationId,
    String? selectedVaultLocationId,
    List<Store>? stores,
    List<Location>? cashLocations,
    List<Location>? bankLocations,
    List<Location>? vaultLocations,
    List<Currency>? currencies,
    int? currentTabIndex,
    String? selectedCashCurrencyId,
    String? selectedBankCurrencyId,
    String? selectedVaultCurrencyId,
    List<CashEnding>? recentCashEndings,
    bool? isLoadingStores,
    bool? isLoadingCashLocations,
    bool? isLoadingBankLocations,
    bool? isLoadingVaultLocations,
    bool? isLoadingCurrencies,
    bool? isLoadingRecentEndings,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return CashEndingState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      selectedCashLocationId: selectedCashLocationId ?? this.selectedCashLocationId,
      selectedBankLocationId: selectedBankLocationId ?? this.selectedBankLocationId,
      selectedVaultLocationId: selectedVaultLocationId ?? this.selectedVaultLocationId,
      stores: stores ?? this.stores,
      cashLocations: cashLocations ?? this.cashLocations,
      bankLocations: bankLocations ?? this.bankLocations,
      vaultLocations: vaultLocations ?? this.vaultLocations,
      currencies: currencies ?? this.currencies,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      selectedCashCurrencyId: selectedCashCurrencyId ?? this.selectedCashCurrencyId,
      selectedBankCurrencyId: selectedBankCurrencyId ?? this.selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId ?? this.selectedVaultCurrencyId,
      recentCashEndings: recentCashEndings ?? this.recentCashEndings,
      isLoadingStores: isLoadingStores ?? this.isLoadingStores,
      isLoadingCashLocations: isLoadingCashLocations ?? this.isLoadingCashLocations,
      isLoadingBankLocations: isLoadingBankLocations ?? this.isLoadingBankLocations,
      isLoadingVaultLocations: isLoadingVaultLocations ?? this.isLoadingVaultLocations,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
      isLoadingRecentEndings: isLoadingRecentEndings ?? this.isLoadingRecentEndings,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
