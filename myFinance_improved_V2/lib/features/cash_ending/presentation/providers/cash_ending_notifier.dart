// lib/features/cash_ending/presentation/providers/cash_ending_notifier.dart
//
// REFACTORED VERSION - Uses UseCases instead of direct Repository calls
// This follows Clean Architecture by keeping business logic in Domain layer

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../core/constants.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/location.dart';
import '../../domain/exceptions/cash_ending_exception.dart';
import '../../domain/usecases/get_balance_summary_usecase.dart';
import '../../domain/usecases/load_currencies_usecase.dart';
import '../../domain/usecases/load_locations_usecase.dart';
import '../../domain/usecases/load_recent_cash_endings_usecase.dart';
import '../../domain/usecases/load_stores_usecase.dart';
import '../../domain/usecases/save_cash_ending_usecase.dart';
import '../../domain/usecases/select_store_usecase.dart';
import 'cash_ending_state.dart';

/// State Notifier for Cash Ending feature
///
/// REFACTORED: Now uses UseCases for all business logic
/// Responsibilities:
/// - State management only
/// - Coordinate UseCase calls
/// - Update UI state based on results
///
/// ✅ 100% UseCase-based (Clean Architecture compliant)
class CashEndingNotifier extends StateNotifier<CashEndingState> {
  // UseCases - all business logic delegated here
  final LoadStoresUseCase _loadStoresUseCase;
  final LoadCurrenciesUseCase _loadCurrenciesUseCase;
  final LoadLocationsUseCase _loadLocationsUseCase;
  final SelectStoreUseCase _selectStoreUseCase;
  final LoadRecentCashEndingsUseCase _loadRecentCashEndingsUseCase;
  final SaveCashEndingUseCase _saveCashEndingUseCase;
  final GetCashBalanceSummaryUseCase? _getCashBalanceSummaryUseCase;
  final GetBankBalanceSummaryUseCase? _getBankBalanceSummaryUseCase;
  final GetVaultBalanceSummaryUseCase? _getVaultBalanceSummaryUseCase;

  CashEndingNotifier({
    required LoadStoresUseCase loadStoresUseCase,
    required LoadCurrenciesUseCase loadCurrenciesUseCase,
    required LoadLocationsUseCase loadLocationsUseCase,
    required SelectStoreUseCase selectStoreUseCase,
    required LoadRecentCashEndingsUseCase loadRecentCashEndingsUseCase,
    required SaveCashEndingUseCase saveCashEndingUseCase,
    GetCashBalanceSummaryUseCase? getCashBalanceSummaryUseCase,
    GetBankBalanceSummaryUseCase? getBankBalanceSummaryUseCase,
    GetVaultBalanceSummaryUseCase? getVaultBalanceSummaryUseCase,
  })  : _loadStoresUseCase = loadStoresUseCase,
        _loadCurrenciesUseCase = loadCurrenciesUseCase,
        _loadLocationsUseCase = loadLocationsUseCase,
        _selectStoreUseCase = selectStoreUseCase,
        _loadRecentCashEndingsUseCase = loadRecentCashEndingsUseCase,
        _saveCashEndingUseCase = saveCashEndingUseCase,
        _getCashBalanceSummaryUseCase = getCashBalanceSummaryUseCase,
        _getBankBalanceSummaryUseCase = getBankBalanceSummaryUseCase,
        _getVaultBalanceSummaryUseCase = getVaultBalanceSummaryUseCase,
        super(const CashEndingState());

  /// Load stores for a company
  ///
  /// ✅ Uses LoadStoresUseCase (business logic in Domain)
  Future<void> loadStores(String companyId) async {
    state = state.copyWith(isLoadingStores: true, errorMessage: null);

    try {
      // ✅ UseCase handles business logic
      final stores = await _loadStoresUseCase.execute(companyId);

      state = state.copyWith(
        stores: stores,
        isLoadingStores: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingStores: false,
        errorMessage: e is CashEndingException ? e.message : 'Failed to load stores',
      );
    }
  }

  /// Load locations by type (cash, bank, vault)
  ///
  /// ✅ Uses LoadLocationsUseCase (simplified, no complex branching)
  Future<void> loadLocations({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    // Set loading state based on type
    _setLocationLoadingState(locationType, true);

    try {
      // ✅ UseCase handles the load logic
      final result = await _loadLocationsUseCase.execute(
        LoadLocationsParams(
          companyId: companyId,
          locationType: locationType,
          storeId: storeId,
        ),
      );

      // Update state based on type
      _updateLocationState(result.locationType, result.locations);
    } catch (e) {
      final errorMsg = e is CashEndingException
          ? e.message
          : 'Failed to load $locationType locations';

      _setLocationErrorState(locationType, errorMsg);
    }
  }

  /// Load company currencies with denominations
  ///
  /// ✅ Uses LoadCurrenciesUseCase (auto-selection logic in Domain)
  Future<void> loadCurrencies(String companyId) async {
    state = state.copyWith(isLoadingCurrencies: true, errorMessage: null);

    try {
      // ✅ UseCase handles auto-selection business logic
      final result = await _loadCurrenciesUseCase.execute(companyId);

      // Build selection lists
      final selectedCashIds = state.selectedCashCurrencyIds.isEmpty && result.defaultCurrencyId != null
          ? [result.defaultCurrencyId!]
          : state.selectedCashCurrencyIds;

      final selectedVaultIds = state.selectedVaultCurrencyIds.isEmpty && result.defaultCurrencyId != null
          ? [result.defaultCurrencyId!]
          : state.selectedVaultCurrencyIds;

      state = state.copyWith(
        currencies: result.currencies,
        baseCurrency: result.baseCurrency,
        isLoadingCurrencies: false,
        selectedCashCurrencyIds: selectedCashIds,
        selectedVaultCurrencyIds: selectedVaultIds,
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEndingNotifier.loadCurrencies failed',
        extra: {'companyId': companyId},
      );

      state = state.copyWith(
        isLoadingCurrencies: false,
        errorMessage: e is CashEndingException ? e.message : 'Failed to load currencies',
      );
    }
  }

  /// Load recent cash endings for a location
  ///
  /// ✅ Uses LoadRecentCashEndingsUseCase (Clean Architecture compliant)
  Future<void> loadRecentCashEndings(String locationId) async {
    state = state.copyWith(isLoadingRecentEndings: true, errorMessage: null);

    try {
      final recentEndings = await _loadRecentCashEndingsUseCase.execute(
        locationId: locationId,
        limit: 10,
      );

      state = state.copyWith(
        recentCashEndings: recentEndings,
        isLoadingRecentEndings: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRecentEndings: false,
        errorMessage: e is CashEndingException ? e.message : 'Failed to load recent cash endings',
      );
    }
  }

  /// Save cash ending
  ///
  /// ✅ Uses SaveCashEndingUseCase (includes validation logic)
  Future<bool> saveCashEnding(CashEnding cashEnding) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await _saveCashEndingUseCase.execute(cashEnding);

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Cash ending saved successfully',
      );

      // Reload recent cash endings for the location
      if (cashEnding.locationId.isNotEmpty) {
        await loadRecentCashEndings(cashEnding.locationId);
      }

      return true;
    } catch (e) {
      final errorMsg = e is CashEndingException ? e.message : 'Failed to save cash ending';

      state = state.copyWith(
        isSaving: false,
        errorMessage: errorMsg,
      );

      return false;
    }
  }

  /// Update selected store
  void setSelectedStore(String? storeId) {
    state = state.copyWith(selectedStoreId: storeId);
  }

  /// Select store and auto-load all locations
  ///
  /// ✅ Uses SelectStoreUseCase (parallel loading logic in Domain)
  Future<void> selectStore(String storeId, String companyId) async {
    // Clear all location selections when store changes
    state = state.copyWith(
      selectedStoreId: storeId,
      selectedCashLocationId: null,
      selectedBankLocationId: null,
      selectedVaultLocationId: null,
      cashLocations: [],
      bankLocations: [],
      vaultLocations: [],
    );

    try {
      // ✅ UseCase handles parallel loading business logic
      final result = await _selectStoreUseCase.execute(
        storeId: storeId,
        companyId: companyId,
      );

      state = state.copyWith(
        cashLocations: result.cashLocations,
        bankLocations: result.bankLocations,
        vaultLocations: result.vaultLocations,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e is CashEndingException
            ? e.message
            : 'Failed to load locations for store',
      );
    }
  }

  // ============================================================================
  // Helper methods for state updates (Presentation logic only)
  // ============================================================================

  /// Set loading state for location type
  void _setLocationLoadingState(String locationType, bool isLoading) {
    if (locationType == CashEndingConstants.locationTypeCash) {
      state = state.copyWith(isLoadingCashLocations: isLoading, errorMessage: null);
    } else if (locationType == CashEndingConstants.locationTypeBank) {
      state = state.copyWith(isLoadingBankLocations: isLoading, errorMessage: null);
    } else if (locationType == CashEndingConstants.locationTypeVault) {
      state = state.copyWith(isLoadingVaultLocations: isLoading, errorMessage: null);
    }
  }

  /// Update location state based on type
  void _updateLocationState(String locationType, List<Location> locations) {
    if (locationType == CashEndingConstants.locationTypeCash) {
      state = state.copyWith(
        cashLocations: locations,
        isLoadingCashLocations: false,
      );
    } else if (locationType == CashEndingConstants.locationTypeBank) {
      state = state.copyWith(
        bankLocations: locations,
        isLoadingBankLocations: false,
      );
    } else if (locationType == CashEndingConstants.locationTypeVault) {
      state = state.copyWith(
        vaultLocations: locations,
        isLoadingVaultLocations: false,
      );
    }
  }

  /// Set error state for location type
  void _setLocationErrorState(String locationType, String errorMsg) {
    if (locationType == CashEndingConstants.locationTypeCash) {
      state = state.copyWith(isLoadingCashLocations: false, errorMessage: errorMsg);
    } else if (locationType == CashEndingConstants.locationTypeBank) {
      state = state.copyWith(isLoadingBankLocations: false, errorMessage: errorMsg);
    } else if (locationType == CashEndingConstants.locationTypeVault) {
      state = state.copyWith(isLoadingVaultLocations: false, errorMessage: errorMsg);
    }
  }

  // ============================================================================
  // Simple state update methods (no business logic)
  // ============================================================================

  void setSelectedCashLocation(String? locationId) {
    state = state.copyWith(
      selectedCashLocationId: locationId,
      // Reset journal amount when location changes
      cashLocationJournalAmount: null,
    );

    // Fetch journal amount for the selected location
    if (locationId != null && locationId.isNotEmpty) {
      _fetchCashLocationJournalAmount(locationId);
    }
  }

  /// Fetch journal amount for a cash location
  ///
  /// Called when cash location is selected to show journal balance
  /// for user verification before submit
  Future<void> _fetchCashLocationJournalAmount(String locationId) async {
    if (_getCashBalanceSummaryUseCase == null) return;

    state = state.copyWith(isLoadingJournalAmount: true);

    try {
      final balanceSummary = await _getCashBalanceSummaryUseCase!.execute(locationId);

      state = state.copyWith(
        cashLocationJournalAmount: balanceSummary.totalJournal,
        isLoadingJournalAmount: false,
      );
    } catch (e) {
      // Silently fail - journal amount is optional reference info
      state = state.copyWith(
        isLoadingJournalAmount: false,
        cashLocationJournalAmount: null,
      );
    }
  }

  void setSelectedBankLocation(String? locationId) {
    state = state.copyWith(
      selectedBankLocationId: locationId,
      // Reset journal amount when location changes
      bankLocationJournalAmount: null,
    );

    // Fetch journal amount for the selected location
    if (locationId != null && locationId.isNotEmpty) {
      _fetchBankLocationJournalAmount(locationId);
    }
  }

  /// Fetch journal amount for a bank location
  Future<void> _fetchBankLocationJournalAmount(String locationId) async {
    if (_getBankBalanceSummaryUseCase == null) return;

    state = state.copyWith(isLoadingBankJournalAmount: true);

    try {
      final balanceSummary = await _getBankBalanceSummaryUseCase!.execute(locationId);

      state = state.copyWith(
        bankLocationJournalAmount: balanceSummary.totalJournal,
        isLoadingBankJournalAmount: false,
      );
    } catch (e) {
      // Silently fail - journal amount is optional reference info
      state = state.copyWith(
        isLoadingBankJournalAmount: false,
        bankLocationJournalAmount: null,
      );
    }
  }

  void setSelectedVaultLocation(String? locationId) {
    state = state.copyWith(
      selectedVaultLocationId: locationId,
      // Reset journal amount when location changes
      vaultLocationJournalAmount: null,
    );

    // Fetch journal amount for the selected location
    if (locationId != null && locationId.isNotEmpty) {
      _fetchVaultLocationJournalAmount(locationId);
    }
  }

  /// Fetch journal amount for a vault location
  Future<void> _fetchVaultLocationJournalAmount(String locationId) async {
    if (_getVaultBalanceSummaryUseCase == null) return;

    state = state.copyWith(isLoadingVaultJournalAmount: true);

    try {
      final balanceSummary = await _getVaultBalanceSummaryUseCase!.execute(locationId);

      state = state.copyWith(
        vaultLocationJournalAmount: balanceSummary.totalJournal,
        isLoadingVaultJournalAmount: false,
      );
    } catch (e) {
      // Silently fail - journal amount is optional reference info
      state = state.copyWith(
        isLoadingVaultJournalAmount: false,
        vaultLocationJournalAmount: null,
      );
    }
  }

  void addCashCurrency(String currencyId) {
    if (!state.selectedCashCurrencyIds.contains(currencyId)) {
      state = state.copyWith(
        selectedCashCurrencyIds: [...state.selectedCashCurrencyIds, currencyId],
      );
    }
  }

  void removeCashCurrency(String currencyId) {
    if (state.selectedCashCurrencyIds.length > 1) {
      state = state.copyWith(
        selectedCashCurrencyIds: state.selectedCashCurrencyIds
            .where((id) => id != currencyId)
            .toList(),
      );
    }
  }

  void setSelectedCashCurrency(String? currencyId) {
    if (currencyId != null) {
      state = state.copyWith(selectedCashCurrencyIds: [currencyId]);
    }
  }

  void setSelectedBankCurrency(String? currencyId) {
    state = state.copyWith(selectedBankCurrencyId: currencyId);
  }

  void addVaultCurrency(String currencyId) {
    if (!state.selectedVaultCurrencyIds.contains(currencyId)) {
      state = state.copyWith(
        selectedVaultCurrencyIds: [...state.selectedVaultCurrencyIds, currencyId],
      );
    }
  }

  void removeVaultCurrency(String currencyId) {
    if (state.selectedVaultCurrencyIds.length > 1) {
      state = state.copyWith(
        selectedVaultCurrencyIds: state.selectedVaultCurrencyIds
            .where((id) => id != currencyId)
            .toList(),
      );
    }
  }

  void setSelectedVaultCurrency(String? currencyId) {
    if (currencyId != null) {
      state = state.copyWith(selectedVaultCurrencyIds: [currencyId]);
    }
  }

  void setCurrentTab(int tabIndex) {
    state = state.copyWith(currentTabIndex: tabIndex);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  void resetAfterSubmit() {
    state = state.copyWith(
      selectedCashLocationId: null,
      selectedBankLocationId: null,
      selectedVaultLocationId: null,
      errorMessage: null,
      successMessage: null,
    );
  }

  /// Reset all input fields in all tabs (Cash, Bank, Vault)
  ///
  /// Call this after completing cash ending to clear all denomination inputs
  /// Increments resetInputsCounter to trigger UI updates in tabs
  void resetAllInputs() {
    state = state.copyWith(
      resetInputsCounter: state.resetInputsCounter + 1,
    );
  }
}
