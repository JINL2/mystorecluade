// lib/features/cash_ending/presentation/providers/cash_ending_notifier.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/types/result.dart';
import '../../domain/repositories/cash_ending_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/vault_repository.dart';
import '../../domain/entities/cash_ending.dart';
import '../../domain/entities/bank_balance.dart';
import '../../domain/entities/vault_transaction.dart';
import 'cash_ending_state.dart';

/// State Notifier for Cash Ending feature
class CashEndingNotifier extends StateNotifier<CashEndingState> {
  final CashEndingRepository _cashEndingRepository;
  final LocationRepository _locationRepository;
  final CurrencyRepository _currencyRepository;
  final BankRepository _bankRepository;
  final VaultRepository _vaultRepository;

  CashEndingNotifier({
    required CashEndingRepository cashEndingRepository,
    required LocationRepository locationRepository,
    required CurrencyRepository currencyRepository,
    required BankRepository bankRepository,
    required VaultRepository vaultRepository,
  })  : _cashEndingRepository = cashEndingRepository,
        _locationRepository = locationRepository,
        _currencyRepository = currencyRepository,
        _bankRepository = bankRepository,
        _vaultRepository = vaultRepository,
        super(const CashEndingState());

  /// Load stores for a company
  Future<void> loadStores(String companyId) async {
    debugPrint('🔍 [CashEndingNotifier] loadStores called with companyId: $companyId');
    state = state.copyWith(isLoadingStores: true, errorMessage: null);

    final result = await _locationRepository.getStores(companyId);

    switch (result) {
      case Success(value: final stores):
        debugPrint('✅ [CashEndingNotifier] Stores loaded: ${stores.length} stores');
        for (final store in stores) {
          debugPrint('   - Store: ${store.storeName} (${store.storeId})');
        }
        state = state.copyWith(
          stores: stores,
          isLoadingStores: false,
        );
      case ResultFailure(error: final failure):
        debugPrint('❌ [CashEndingNotifier] Failed to load stores: ${failure.message}');
        state = state.copyWith(
          isLoadingStores: false,
          errorMessage: failure.message,
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

    final result = await _locationRepository.getLocationsByType(
      companyId: companyId,
      locationType: locationType,
      storeId: storeId,
    );

    switch (result) {
      case Success(value: final locations):
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
      case ResultFailure(error: final failure):
        if (locationType == 'cash') {
          state = state.copyWith(isLoadingCashLocations: false, errorMessage: failure.message);
        } else if (locationType == 'bank') {
          state = state.copyWith(isLoadingBankLocations: false, errorMessage: failure.message);
        } else if (locationType == 'vault') {
          state = state.copyWith(isLoadingVaultLocations: false, errorMessage: failure.message);
        }
    }
  }

  /// Load company currencies with denominations
  Future<void> loadCurrencies(String companyId) async {
    state = state.copyWith(isLoadingCurrencies: true, errorMessage: null);

    final result = await _currencyRepository.getCompanyCurrencies(companyId);

    switch (result) {
      case Success(value: final currencies):
        state = state.copyWith(
          currencies: currencies,
          isLoadingCurrencies: false,
        );
      case ResultFailure(error: final failure):
        state = state.copyWith(
          isLoadingCurrencies: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Load recent cash endings for a location
  Future<void> loadRecentCashEndings(String locationId) async {
    state = state.copyWith(isLoadingRecentEndings: true, errorMessage: null);

    final result = await _cashEndingRepository.getCashEndingHistory(
      locationId: locationId,
      limit: 10,
    );

    switch (result) {
      case Success(value: final recentEndings):
        state = state.copyWith(
          recentCashEndings: recentEndings,
          isLoadingRecentEndings: false,
        );
      case ResultFailure(error: final failure):
        state = state.copyWith(
          isLoadingRecentEndings: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Save cash ending
  Future<bool> saveCashEnding(CashEnding cashEnding) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _cashEndingRepository.saveCashEnding(cashEnding);

    switch (result) {
      case Success():
        state = state.copyWith(
          isSaving: false,
          successMessage: 'Cash ending saved successfully',
        );

        // Reload recent cash endings for the location
        if (cashEnding.locationId.isNotEmpty) {
          await loadRecentCashEndings(cashEnding.locationId);
        }

        return true;
      case ResultFailure(error: final failure):
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
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

  /// Save bank balance
  Future<bool> saveBankBalance(BankBalance bankBalance) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _bankRepository.saveBankBalance(bankBalance);

    switch (result) {
      case Success():
        state = state.copyWith(
          isSaving: false,
          successMessage: 'Bank balance saved successfully',
        );

        return true;
      case ResultFailure(error: final failure):
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );

        return false;
    }
  }

  /// Save vault transaction
  Future<bool> saveVaultTransaction(VaultTransaction vaultTransaction) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    final result = await _vaultRepository.saveVaultTransaction(vaultTransaction);

    switch (result) {
      case Success():
        state = state.copyWith(
          isSaving: false,
          successMessage: 'Vault transaction saved successfully',
        );

        return true;
      case ResultFailure(error: final failure):
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );

        return false;
    }
  }
}
