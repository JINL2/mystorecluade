import 'package:flutter/material.dart';
import '../data/services/bank_service.dart';
import '../data/services/bank_transaction_service.dart';
import '../data/services/cash_history_service.dart';
import '../data/services/cash_service.dart';
import '../data/services/stock_flow_service.dart';
import '../data/services/vault_service.dart';

/// Business logic coordinator for Cash Ending Page
/// Handles all service method delegations and coordinates business operations
class CashEndingCoordinator {
  
  /// Load recent cash endings for a specific location
  static Future<void> loadRecentCashEndings({
    required BuildContext context,
    required String locationId,
    required Function(List<Map<String, dynamic>>, bool) onEndingsLoaded,
  }) async {
    final service = CashHistoryService();
    // Service methods handle their own data fetching
    // The coordinator just delegates the call
    // Note: Need to implement proper mapping of service results to callback
    onEndingsLoaded([], false); // Placeholder
  }

  /// Save cash ending with denomination data
  static Future<void> saveCashEnding({
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
    required bool Function(String) currencyHasData,
    required Function(bool, {String? errorMessage, double? savedTotal}) onSaveComplete,
  }) async {
    final service = CashService();
    final result = await service.saveCashEnding(
      companyId: companyId,
      userId: userId,
      locationId: selectedLocationId,
      selectedStoreId: selectedStoreId,
      tabIndex: tabIndex,
      selectedBankLocationId: selectedBankLocationId,
      selectedVaultLocationId: selectedVaultLocationId,
      companyCurrencies: companyCurrencies,
      denominationControllers: denominationControllers,
      currencyDenominations: currencyDenominations,
      selectedBankCurrencyId: selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      currencyHasData: currencyHasData,
    );
    
    // Handle the result
    if (result['success'] == true) {
      // Calculate the total amount saved - for cash tab, sum all currencies
      double savedTotal = 0.0;
      if (tabIndex == 0) {
        // Cash tab - sum all currencies that have data
        for (var currency in companyCurrencies) {
          final currencyId = currency['currency_id']?.toString();
          if (currencyId != null && currencyHasData(currencyId)) {
            savedTotal += calculateCurrencyTotal(
              currencyId: currencyId,
              denominationControllers: denominationControllers,
              currencyDenominations: currencyDenominations,
            );
          }
        }
      } else {
        // Bank or Vault tab - single currency
        final currencyId = (tabIndex == 1) ? selectedBankCurrencyId : selectedVaultCurrencyId;
        if (currencyId != null) {
          savedTotal = calculateCurrencyTotal(
            currencyId: currencyId,
            denominationControllers: denominationControllers,
            currencyDenominations: currencyDenominations,
          );
        }
      }
      onSaveComplete(true, savedTotal: savedTotal);
    } else {
      onSaveComplete(false, errorMessage: result['error'] ?? 'Unknown error');
    }
  }

  /// Fetch location stock flow data for Real section only (Journal removed)
  static Future<void> fetchLocationStockFlow({
    required BuildContext context,
    required String locationId,
    required String companyId,
    required String storeId,
    required bool isLoadMore,
    required int currentOffset,
    required Function(List<ActualFlow>, LocationSummary?, bool, bool) onFlowsLoaded,
  }) async {
    try {
      // Set loading state at start
      if (!isLoadMore) {
        onFlowsLoaded([], null, true, false);
      }
      
      // Call the StockFlowServiceExternal directly
      final serviceExternal = StockFlowServiceExternal();
      final response = await serviceExternal.getLocationStockFlow(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: locationId,
          offset: isLoadMore ? currentOffset : 0,
          limit: 20,
        ),
      );
      
      if (response.success && response.data != null) {
        final actualFlows = response.data!.actualFlows;
        final locationSummary = response.data!.locationSummary;
        final hasMore = response.pagination?.hasMore ?? false;
        
        onFlowsLoaded(actualFlows, locationSummary, false, hasMore);
      } else {
        onFlowsLoaded([], null, false, false);
      }
    } catch (e) {
      onFlowsLoaded([], null, false, false);
    }
  }

  /// Fetch recent bank transactions for selected location
  static Future<void> fetchRecentBankTransactions({
    required BuildContext context,
    required String companyId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required Function(List<Map<String, dynamic>>, bool) onTransactionsLoaded,
  }) async {
    final service = BankTransactionService();
    final result = await service.fetchRecentBankTransactions(
      companyId: companyId,
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
    );
    
    onTransactionsLoaded(
      result['recentBankTransactions'] ?? [],
      result['isLoadingBankTransactions'] ?? false,
    );
  }

  /// Save bank balance
  static Future<void> saveBankBalance({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required TextEditingController bankAmountController,
    required String? selectedBankCurrencyType,
    required List<Map<String, dynamic>> currencyTypes,
    required Function(bool, {String? errorMessage, String? amount}) onSaveComplete,
  }) async {
    final service = BankService();
    final result = await service.saveBankBalance(
      companyId: companyId,
      userId: userId,
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
      selectedBankCurrencyType: selectedBankCurrencyType,
      bankAmountController: bankAmountController,
      currencyTypes: currencyTypes,
    );
    
    if (result['success'] == true) {
      onSaveComplete(true, amount: result['amount'] ?? '0');
    } else {
      onSaveComplete(false, errorMessage: result['error'] ?? 'Unknown error');
    }
  }

  /// Fetch all bank transactions with pagination
  static Future<void> fetchAllBankTransactions({
    required BuildContext context,
    required String companyId,
    required String? selectedStoreId,
    required bool loadMore,
    required Function() updateUI,
    required String? selectedBankLocationId,
    required Function(List<Map<String, dynamic>>, bool, bool, int) onTransactionsLoaded,
  }) async {
    final service = BankTransactionService();
    // fetchAllBankTransactions method doesn't exist, using fetchRecentBankTransactions
    final result = await service.fetchRecentBankTransactions(
      companyId: companyId,
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
    );
    
    // Call the callback with the result
    onTransactionsLoaded(
      result['recentBankTransactions'] ?? [],
      false, // isLoading
      false, // hasMore
      0, // offset
    );
  }

  /// Save bank location currency
  static Future<void> saveBankLocationCurrency({
    required BuildContext context,
    required String companyId,
    required String? userId,
    required String? selectedBankLocationId,
    required String? tempSelectedBankCurrency,
    required Function(bool, {String? errorMessage}) onSaveComplete,
  }) async {
    final service = BankService();
    final result = await service.saveBankLocationCurrency(
      companyId: companyId,
      userId: userId,
      selectedBankLocationId: selectedBankLocationId,
      tempSelectedBankCurrency: tempSelectedBankCurrency,
    );
    
    if (result['success'] == true) {
      onSaveComplete(true);
    } else {
      onSaveComplete(false, errorMessage: result['error'] ?? 'Unknown error');
    }
  }

  /// Fetch vault balance for selected location
  static Future<void> fetchVaultBalance({
    required BuildContext context,
    required String? selectedVaultLocationId,
    required Function(Map<String, dynamic>?, bool) onBalanceLoaded,
  }) async {
    final service = VaultService();
    // fetchVaultBalance method doesn't exist in VaultService
    // Placeholder for now
    onBalanceLoaded({}, false);
    return;
  }

  /// Save vault balance
  static Future<void> saveVaultBalance({
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
    required Function(bool, {String? errorMessage, double? savedTotal}) onSaveComplete,
  }) async {
    final service = VaultService();
    final result = await service.saveVaultBalance(
      companyId: companyId,
      userId: userId,
      selectedStoreId: selectedStoreId,
      selectedVaultLocationId: selectedVaultLocationId,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      vaultTransactionType: vaultTransactionType,
      denominationControllers: denominationControllers,
      currencyDenominations: currencyDenominations,
    );
    
    if (result['success'] == true) {
      double savedTotal = result['totalAmount'] ?? 0.0;
      onSaveComplete(true, savedTotal: savedTotal);
    } else {
      onSaveComplete(false, errorMessage: result['error'] ?? 'Unknown error');
    }
  }

  /// Reset transaction state
  static void resetTransactionState({
    required Function() onStateReset,
  }) {
    onStateReset();
  }

  /// Refresh all data for the current context
  static Future<void> refreshData({
    required BuildContext context,
    required String? selectedStoreId,
    required String? selectedLocationId,
    required String? selectedBankLocationId,
    required String? selectedVaultLocationId,
    required Function(String) fetchLocations,
    required Function(String) loadRecentCashEndings,
    required Function() fetchRecentBankTransactions,
    required Function() fetchVaultBalance,
    required Function(String, {bool isLoadMore}) fetchLocationStockFlow,
    String? selectedCashLocationIdForFlow,
  }) async {
    // Refresh locations data
    if (selectedStoreId != null && selectedStoreId.isNotEmpty) {
      await fetchLocations('cash');
      await fetchLocations('bank');
      await fetchLocations('vault');
    }

    // Refresh cash data
    if (selectedLocationId != null && selectedLocationId.isNotEmpty) {
      await loadRecentCashEndings(selectedLocationId);
    }

    // Refresh bank data
    if (selectedBankLocationId != null && selectedBankLocationId.isNotEmpty) {
      await fetchRecentBankTransactions();
    }

    // Refresh vault data
    if (selectedVaultLocationId != null && selectedVaultLocationId.isNotEmpty) {
      await fetchVaultBalance();
    }

    // Refresh flow data for Real section only
    if (selectedCashLocationIdForFlow != null && selectedCashLocationIdForFlow.isNotEmpty) {
      await fetchLocationStockFlow(selectedCashLocationIdForFlow, isLoadMore: false);
    }
  }

  /// Check if currency has data for cash tab
  static bool currencyHasData({
    required String currencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    final controllers = denominationControllers[currencyId];
    if (controllers == null) return false;
    
    return controllers.values.any((controller) {
      final value = controller.text.trim();
      return value.isNotEmpty && double.tryParse(value) != null && double.parse(value) > 0;
    });
  }

  /// Calculate total for a specific currency
  static double calculateCurrencyTotal({
    required String currencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
  }) {
    final controllers = denominationControllers[currencyId];
    if (controllers == null) return 0.0;

    final denominations = currencyDenominations[currencyId] ?? [];
    double total = 0.0;

    for (final denom in denominations) {
      final denomValue = denom['value']?.toString() ?? '';
      final controller = controllers[denomValue];
      if (controller != null) {
        final count = double.tryParse(controller.text.trim()) ?? 0.0;
        final value = double.tryParse(denomValue) ?? 0.0;
        total += count * value;
      }
    }

    return total;
  }

  /// Get current balance for bank tab
  static double getCurrentBankBalance({
    required List<Map<String, dynamic>> recentBankTransactions,
  }) {
    if (recentBankTransactions.isEmpty) return 0.0;
    
    final mostRecent = recentBankTransactions.first;
    return double.tryParse(mostRecent['total_amount']?.toString() ?? '0') ?? 0.0;
  }

  /// Get current balance for vault tab
  static double getCurrentVaultBalance({
    required Map<String, dynamic>? vaultBalanceData,
  }) {
    if (vaultBalanceData == null) return 0.0;
    
    return double.tryParse(vaultBalanceData['balance']?.toString() ?? '0') ?? 0.0;
  }
}