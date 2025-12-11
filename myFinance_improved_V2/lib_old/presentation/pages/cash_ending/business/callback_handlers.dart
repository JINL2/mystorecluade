import 'package:flutter/material.dart';
import '../data/services/stock_flow_service.dart';
import 'cash_ending_coordinator.dart';

/// Callback handlers for Cash Ending Page
/// Manages all callback functions passed to extracted widgets
class CallbackHandlers {
  
  /// Create state update callback for store selection
  static Function(String) createStoreSelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setSelectedStoreId,
    required Function(String) fetchLocations,
    required Function() refreshData,
  }) {
    return (String storeId) {
      setState(() {
        setSelectedStoreId(storeId);
      });
      // Fetch locations for new store
      fetchLocations('cash');
      fetchLocations('bank');
      fetchLocations('vault');
      // Refresh data
      refreshData();
    };
  }

  /// Create state update callback for location selection
  static Function(String) createLocationSelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setSelectedLocationId,
    required Function(String) loadRecentCashEndings,
    required Function(String, {bool isLoadMore}) fetchLocationStockFlow,
  }) {
    return (String locationId) {
      setState(() {
        setSelectedLocationId(locationId);
      });
      // Load recent endings for new location
      loadRecentCashEndings(locationId);
      // Load stock flow data for Real/Journal tabs
      fetchLocationStockFlow(locationId, isLoadMore: false);
    };
  }

  /// Create state update callback for bank location selection
  static Function(String) createBankLocationSelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setSelectedBankLocationId,
    required Function() fetchRecentBankTransactions,
    required Function() fetchVaultBalance,
  }) {
    return (String locationId) {
      setState(() {
        setSelectedBankLocationId(locationId);
      });
      // Fetch bank transactions for new location
      fetchRecentBankTransactions();
    };
  }

  /// Create state update callback for vault location selection
  static Function(String) createVaultLocationSelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setSelectedVaultLocationId,
    required Function() fetchVaultBalance,
  }) {
    return (String locationId) {
      setState(() {
        setSelectedVaultLocationId(locationId);
      });
      // Fetch vault balance for new location
      fetchVaultBalance();
    };
  }

  /// Create state update callback for currency selection
  static Function(String) createCurrencySelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setCurrencyId,
    String tabType = 'cash',
  }) {
    return (String currencyId) {
      setState(() {
        setCurrencyId(currencyId);
      });
    };
  }

  /// Create state update callback for transaction type selection (vault)
  static Function(String) createTransactionTypeSelectionCallback({
    required Function(void Function()) setState,
    required Function(String?) setTransactionType,
  }) {
    return (String type) {
      setState(() {
        setTransactionType(type);
      });
    };
  }

  /// Create state update callback for filter selection
  static Function(String) createFilterSelectionCallback({
    required Function(void Function()) setState,
    required Function(String) setSelectedFilter,
  }) {
    return (String filter) {
      setState(() {
        setSelectedFilter(filter);
      });
    };
  }

  /// Create callback for loading recent cash endings
  static Function(String) createLoadRecentCashEndingsCallback({
    required BuildContext context,
    required Function(void Function()) setState,
    required Function(List<Map<String, dynamic>>, bool) updateEndingsState,
  }) {
    return (String locationId) async {
      await CashEndingCoordinator.loadRecentCashEndings(
        context: context,
        locationId: locationId,
        onEndingsLoaded: (endings, isLoading) {
          setState(() {
            updateEndingsState(endings, isLoading);
          });
        },
      );
    };
  }

  /// Create callback for saving cash ending
  static Function() createSaveCashEndingCallback({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedLocationId,
    required String? selectedStoreId,
    required int tabIndex,
    required String? selectedBankLocationId,
    required String? selectedVaultLocationId,
    required String? selectedCashCurrencyId,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Function(double) showSuccessBottomSheet,
    required Function(String) showErrorMessage,
  }) {
    return () async {
      await CashEndingCoordinator.saveCashEnding(
        context: context,
        companyId: companyId,
        userId: userId,
        selectedLocationId: selectedLocationId,
        selectedStoreId: selectedStoreId,
        tabIndex: tabIndex,
        selectedBankLocationId: selectedBankLocationId,
        selectedVaultLocationId: selectedVaultLocationId,
        selectedCashCurrencyId: selectedCashCurrencyId,
        selectedBankCurrencyId: selectedBankCurrencyId,
        selectedVaultCurrencyId: selectedVaultCurrencyId,
        denominationControllers: denominationControllers,
        companyCurrencies: companyCurrencies,
        currencyDenominations: currencyDenominations,
        currencyHasData: (currencyId) => CashEndingCoordinator.currencyHasData(
          currencyId: currencyId,
          denominationControllers: denominationControllers,
        ),
        onSaveComplete: (success, {errorMessage, savedTotal}) {
          if (success && savedTotal != null) {
            showSuccessBottomSheet(savedTotal);
          } else {
            showErrorMessage(errorMessage ?? 'Failed to save cash ending');
          }
        },
      );
    };
  }

  /// Create callback for fetching location stock flow (Real only - Journal removed)
  static Function(String, {bool isLoadMore}) createFetchLocationStockFlowCallback({
    required BuildContext context,
    required String companyId,
    required String storeId,
    required int currentOffset,
    required Function(void Function()) setState,
    required Function(List<ActualFlow>, LocationSummary?, bool, bool) updateFlowsState,
  }) {
    return (String locationId, {bool isLoadMore = false}) async {
      await CashEndingCoordinator.fetchLocationStockFlow(
        context: context,
        locationId: locationId,
        companyId: companyId,
        storeId: storeId,
        isLoadMore: isLoadMore,
        currentOffset: currentOffset,
        onFlowsLoaded: (actualFlows, locationSummary, isLoading, hasMore) {
          setState(() {
            updateFlowsState(actualFlows, locationSummary, isLoading, hasMore);
          });
        },
      );
    };
  }

  /// Create callback for fetching recent bank transactions
  static Function() createFetchRecentBankTransactionsCallback({
    required BuildContext context,
    required String companyId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required Function(void Function()) setState,
    required Function(List<Map<String, dynamic>>, bool) updateTransactionsState,
  }) {
    return () async {
      await CashEndingCoordinator.fetchRecentBankTransactions(
        context: context,
        companyId: companyId,
        selectedStoreId: selectedStoreId,
        selectedBankLocationId: selectedBankLocationId,
        onTransactionsLoaded: (transactions, isLoading) {
          setState(() {
            updateTransactionsState(transactions, isLoading);
          });
        },
      );
    };
  }

  /// Create callback for saving bank balance
  static Function() createSaveBankBalanceCallback({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required TextEditingController bankAmountController,
    required String? selectedBankCurrencyType,
    required List<Map<String, dynamic>> currencyTypes,
    required Function(bool, {String? errorMessage, String? amount}) showBankBalanceResultDialog,
  }) {
    return () async {
      await CashEndingCoordinator.saveBankBalance(
        context: context,
        companyId: companyId,
        userId: userId,
        selectedStoreId: selectedStoreId,
        selectedBankLocationId: selectedBankLocationId,
        bankAmountController: bankAmountController,
        selectedBankCurrencyType: selectedBankCurrencyType,
        currencyTypes: currencyTypes,
        onSaveComplete: (success, {errorMessage, amount}) {
          showBankBalanceResultDialog(success, errorMessage: errorMessage, amount: amount);
        },
      );
    };
  }

  /// Create callback for fetching all bank transactions
  static Future<void> Function({bool loadMore, required Function updateUI}) createFetchAllBankTransactionsCallback({
    required BuildContext context,
    required String companyId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required Function(void Function()) setState,
    required Function(List<Map<String, dynamic>>, bool, bool, int) updateAllTransactionsState,
  }) {
    return ({bool loadMore = false, required Function updateUI}) async {
      await CashEndingCoordinator.fetchAllBankTransactions(
        context: context,
        companyId: companyId,
        selectedStoreId: selectedStoreId,
        loadMore: loadMore,
        updateUI: updateUI as dynamic Function(),
        selectedBankLocationId: selectedBankLocationId,
        onTransactionsLoaded: (transactions, isLoading, hasMore, offset) {
          setState(() {
            updateAllTransactionsState(transactions, isLoading, hasMore, offset);
          });
        },
      );
    };
  }

  /// Create callback for saving bank location currency
  static Function() createSaveBankLocationCurrencyCallback({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedBankLocationId,
    required String? tempSelectedBankCurrency,
    required Function(void Function()) setState,
    required Function(bool, bool, String?) updateCurrencySaveState,
  }) {
    return () async {
      await CashEndingCoordinator.saveBankLocationCurrency(
        context: context,
        companyId: companyId,
        userId: userId,
        selectedBankLocationId: selectedBankLocationId,
        tempSelectedBankCurrency: tempSelectedBankCurrency,
        onSaveComplete: (success, {errorMessage}) {
          setState(() {
            updateCurrencySaveState(success, false, errorMessage);
          });
        },
      );
    };
  }

  /// Create callback for fetching vault balance
  static Function() createFetchVaultBalanceCallback({
    required BuildContext context,
    required String? selectedVaultLocationId,
    required Function(void Function()) setState,
    required Function(Map<String, dynamic>?, bool) updateVaultBalanceState,
  }) {
    return () async {
      await CashEndingCoordinator.fetchVaultBalance(
        context: context,
        selectedVaultLocationId: selectedVaultLocationId,
        onBalanceLoaded: (balanceData, isLoading) {
          setState(() {
            updateVaultBalanceState(balanceData, isLoading);
          });
        },
      );
    };
  }

  /// Create callback for saving vault balance
  static Function() createSaveVaultBalanceCallback({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedStoreId,
    required String? selectedVaultLocationId,
    required String? vaultTransactionType,
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Function(double) showSuccessBottomSheet,
    required Function(String) showErrorMessage,
  }) {
    return () async {
      await CashEndingCoordinator.saveVaultBalance(
        context: context,
        companyId: companyId,
        userId: userId,
        selectedStoreId: selectedStoreId,
        selectedVaultLocationId: selectedVaultLocationId,
        vaultTransactionType: vaultTransactionType,
        selectedVaultCurrencyId: selectedVaultCurrencyId,
        denominationControllers: denominationControllers,
        companyCurrencies: companyCurrencies,
        currencyDenominations: currencyDenominations,
        onSaveComplete: (success, {errorMessage, savedTotal}) {
          if (success && savedTotal != null) {
            showSuccessBottomSheet(savedTotal);
          } else {
            showErrorMessage(errorMessage ?? 'Failed to save vault balance');
          }
        },
      );
    };
  }

  /// Create callback for resetting transaction state
  static Function() createResetTransactionStateCallback({
    required Function(void Function()) setState,
    required Function() resetAllTransactionState,
  }) {
    return () {
      setState(() {
        resetAllTransactionState();
      });
    };
  }

  /// Create currency has data checker callback
  static Function(String) createCurrencyHasDataCallback({
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    return (String currencyId) {
      return CashEndingCoordinator.currencyHasData(
        currencyId: currencyId,
        denominationControllers: denominationControllers,
      );
    };
  }

  /// Create comprehensive refresh data callback
  static Function() createRefreshDataCallback({
    required BuildContext context,
    required String? selectedStoreId,
    required String? selectedLocationId,
    required String? selectedBankLocationId,
    required String? selectedVaultLocationId,
    required String? selectedCashLocationIdForFlow,
    required Function(String) fetchLocations,
    required Function(String) loadRecentCashEndings,
    required Function() fetchRecentBankTransactions,
    required Function() fetchVaultBalance,
    required Function(String, {bool isLoadMore}) fetchLocationStockFlow,
  }) {
    return () async {
      await CashEndingCoordinator.refreshData(
        context: context,
        selectedStoreId: selectedStoreId,
        selectedLocationId: selectedLocationId,
        selectedBankLocationId: selectedBankLocationId,
        selectedVaultLocationId: selectedVaultLocationId,
        selectedCashLocationIdForFlow: selectedCashLocationIdForFlow,
        fetchLocations: fetchLocations,
        loadRecentCashEndings: loadRecentCashEndings,
        fetchRecentBankTransactions: fetchRecentBankTransactions,
        fetchVaultBalance: fetchVaultBalance,
        fetchLocationStockFlow: fetchLocationStockFlow,
      );
    };
  }
}