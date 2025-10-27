// lib/features/cash_ending/presentation/providers/cash_ending_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/exceptions/cash_ending_exception.dart';
import 'cash_ending_state.dart';

/// State Notifier for Cash Ending feature
class CashEndingNotifier extends StateNotifier<CashEndingState> {
  final CashEndingRepository _cashEndingRepository;
  final LocationRepository _locationRepository;
  final CurrencyRepository _currencyRepository;

  CashEndingNotifier({
    required CashEndingRepository cashEndingRepository,
    required LocationRepository locationRepository,
    required CurrencyRepository currencyRepository,
  })  : _cashEndingRepository = cashEndingRepository,
        _locationRepository = locationRepository,
        _currencyRepository = currencyRepository,
        super(const CashEndingState());

  /// Load stores for a company
  Future<void> loadStores(String companyId) async {
    state = state.copyWith(isLoadingStores: true, errorMessage: null);

    try {
      final stores = await _locationRepository.getStores(companyId);
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
  Future<void> loadLocations({
    required String companyId,
    required String locationType,
    String? storeId,
  }) async {
    // Set appropriate loading state
    if (locationType == 'cash') {
      state = state.copyWith(isLoadingCashLocations: true, errorMessage: null);
    } else if (locationType == 'bank') {
      state = state.copyWith(isLoadingBankLocations: true, errorMessage: null);
    } else if (locationType == 'vault') {
      state = state.copyWith(isLoadingVaultLocations: true, errorMessage: null);
    }

    try {
      final locations = await _locationRepository.getLocationsByType(
        companyId: companyId,
        locationType: locationType,
        storeId: storeId,
      );

      // Update appropriate state based on type
      if (locationType == 'cash') {
        state = state.copyWith(
          cashLocations: locations,
          isLoadingCashLocations: false,
        );
      } else if (locationType == 'bank') {
        state = state.copyWith(
          bankLocations: locations,
          isLoadingBankLocations: false,
        );
      } else if (locationType == 'vault') {
        state = state.copyWith(
          vaultLocations: locations,
          isLoadingVaultLocations: false,
        );
      }
    } catch (e) {
      final errorMsg =
          e is CashEndingException ? e.message : 'Failed to load $locationType locations';

      if (locationType == 'cash') {
        state = state.copyWith(isLoadingCashLocations: false, errorMessage: errorMsg);
      } else if (locationType == 'bank') {
        state = state.copyWith(isLoadingBankLocations: false, errorMessage: errorMsg);
      } else if (locationType == 'vault') {
        state = state.copyWith(isLoadingVaultLocations: false, errorMessage: errorMsg);
      }
    }
  }

  /// Load company currencies with denominations
  Future<void> loadCurrencies(String companyId) async {
    state = state.copyWith(isLoadingCurrencies: true, errorMessage: null);

    try {
      final currencies = await _currencyRepository.getCompanyCurrencies(companyId);

      state = state.copyWith(
        currencies: currencies,
        isLoadingCurrencies: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCurrencies: false,
        errorMessage: e is CashEndingException ? e.message : 'Failed to load currencies',
      );
    }
  }

  /// Load recent cash endings for a location
  Future<void> loadRecentCashEndings(String locationId) async {
    state = state.copyWith(isLoadingRecentEndings: true, errorMessage: null);

    try {
      final recentEndings = await _cashEndingRepository.getCashEndingHistory(
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
  Future<bool> saveCashEnding(CashEnding cashEnding) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {

      await _cashEndingRepository.saveCashEnding(cashEnding);

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

  /// Select store and auto-load all locations (like lib_old)
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

    // Auto-load all location types (cash, bank, vault) like lib_old
    await Future.wait([
      loadLocations(companyId: companyId, locationType: 'cash', storeId: storeId),
      loadLocations(companyId: companyId, locationType: 'bank', storeId: storeId),
      loadLocations(companyId: companyId, locationType: 'vault', storeId: storeId),
    ]);
  }

  /// Update selected cash location
  void setSelectedCashLocation(String? locationId) {
    state = state.copyWith(selectedCashLocationId: locationId);
  }

  /// Update selected bank location
  void setSelectedBankLocation(String? locationId) {
    state = state.copyWith(selectedBankLocationId: locationId);
  }

  /// Update selected vault location
  void setSelectedVaultLocation(String? locationId) {
    state = state.copyWith(selectedVaultLocationId: locationId);
  }

  /// Update selected currency for cash tab
  void setSelectedCashCurrency(String? currencyId) {
    state = state.copyWith(selectedCashCurrencyId: currencyId);
  }

  /// Update selected currency for bank tab
  void setSelectedBankCurrency(String? currencyId) {
    state = state.copyWith(selectedBankCurrencyId: currencyId);
  }

  /// Update selected currency for vault tab
  void setSelectedVaultCurrency(String? currencyId) {
    state = state.copyWith(selectedVaultCurrencyId: currencyId);
  }

  /// Change current tab
  void setCurrentTab(int tabIndex) {
    state = state.copyWith(currentTabIndex: tabIndex);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
