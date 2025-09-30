import 'package:flutter/material.dart';
import '../data/services/stock_flow_service.dart';

/// Integration utilities for Cash Ending Page
/// Provides helper methods for coordinating extracted components
class IntegrationUtils {
  
  /// Create state update functions for managing component state
  static Map<String, Function> createStateUpdateFunctions({
    required Function(void Function()) setState,
  }) {
    return {
      'setSelectedStoreId': (String? storeId) => setState(() {}),
      'setSelectedLocationId': (String? locationId) => setState(() {}),
      'setSelectedBankLocationId': (String? locationId) => setState(() {}),
      'setSelectedVaultLocationId': (String? locationId) => setState(() {}),
      'setSelectedCashCurrencyId': (String? currencyId) => setState(() {}),
      'setSelectedBankCurrencyType': (String? currencyType) => setState(() {}),
      'setSelectedVaultCurrencyId': (String? currencyId) => setState(() {}),
      'setVaultTransactionType': (String? type) => setState(() {}),
      'setSelectedFilter': (String filter) => setState(() {}),
      'updateRecentCashEndings': (List<Map<String, dynamic>> endings, bool isLoading) => setState(() {}),
      'updateRecentBankTransactions': (List<Map<String, dynamic>> transactions, bool isLoading) => setState(() {}),
      'updateAllBankTransactions': (List<Map<String, dynamic>> transactions, bool isLoading, bool hasMore, int offset) => setState(() {}),
      'updateVaultBalanceData': (Map<String, dynamic>? data, bool isLoading) => setState(() {}),
      'updateFlowsData': (List<ActualFlow> actualFlows, LocationSummary? summary, bool isLoading, bool hasMore) => setState(() {}),
      'resetAllTransactionState': () => setState(() {}),
      'updateCurrencySaveState': (bool success, bool isSaving, String? error) => setState(() {}),
    };
  }

  /// Initialize denomination controllers for a currency
  static void initializeDenominationControllers({
    required String currencyId,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    final denominations = currencyDenominations[currencyId] ?? [];
    
    if (!denominationControllers.containsKey(currencyId)) {
      denominationControllers[currencyId] = {};
    }

    for (final denom in denominations) {
      final denomValue = denom['value']?.toString() ?? '';
      if (denomValue.isNotEmpty && !denominationControllers[currencyId]!.containsKey(denomValue)) {
        denominationControllers[currencyId]![denomValue] = TextEditingController();
      }
    }
  }

  /// Dispose denomination controllers for a currency
  static void disposeDenominationControllers({
    required String currencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    final controllers = denominationControllers[currencyId];
    if (controllers != null) {
      controllers.forEach((key, controller) {
        controller.dispose();
      });
      denominationControllers.remove(currencyId);
    }
  }

  /// Clear denomination controllers values for a currency
  static void clearDenominationControllers({
    required String currencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    final controllers = denominationControllers[currencyId];
    if (controllers != null) {
      controllers.forEach((key, controller) {
        controller.clear();
      });
    }
  }

  /// Get available currencies for a specific tab
  static List<Map<String, dynamic>> getAvailableCurrencies({
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    String tabType = 'cash',
  }) {
    return companyCurrencies.where((currency) {
      final currencyId = currency['currency_id']?.toString();
      if (currencyId == null) return false;
      
      // For cash and vault tabs, only show currencies that have denominations
      if (tabType == 'cash' || tabType == 'vault') {
        final denominations = currencyDenominations[currencyId] ?? [];
        return denominations.isNotEmpty;
      }
      
      // For bank tab, show all company currencies
      return true;
    }).toList();
  }

  /// Validate required data for saving
  static Map<String, dynamic> validateSaveData({
    required String? selectedLocationId,
    required String? selectedCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    String tabType = 'cash',
  }) {
    if (selectedLocationId == null || selectedLocationId.isEmpty) {
      return {
        'isValid': false,
        'errorMessage': 'Please select a location first',
      };
    }

    if (selectedCurrencyId == null || selectedCurrencyId.isEmpty) {
      return {
        'isValid': false,
        'errorMessage': 'Please select a currency first',
      };
    }

    // For cash and vault tabs, validate denomination data
    if (tabType == 'cash' || tabType == 'vault') {
      final controllers = denominationControllers[selectedCurrencyId];
      if (controllers == null || controllers.isEmpty) {
        return {
          'isValid': false,
          'errorMessage': 'No denomination data available',
        };
      }

      bool hasData = controllers.values.any((controller) {
        final value = controller.text.trim();
        return value.isNotEmpty && double.tryParse(value) != null && double.parse(value) > 0;
      });

      if (!hasData) {
        return {
          'isValid': false,
          'errorMessage': 'Please enter at least one denomination count',
        };
      }
    }

    return {
      'isValid': true,
      'errorMessage': null,
    };
  }

  /// Get current total for a currency
  static double getCurrentTotal({
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

  /// Show error message using SnackBar
  static void showErrorMessage({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success message using SnackBar
  static void showSuccessMessage({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Reset transaction state data
  static void resetTransactionStateData({
    required Function(List<Map<String, dynamic>>) setAllBankTransactions,
    required Function(bool) setIsLoadingAllTransactions,
    required Function(bool) setHasMoreTransactions,
    required Function(int) setTransactionOffset,
  }) {
    setAllBankTransactions([]);
    setIsLoadingAllTransactions(false);
    setHasMoreTransactions(true);
    setTransactionOffset(0);
  }

  /// Create Real item widget with callbacks
  static Widget createRealItemWidget({
    required ActualFlow flow,
    required bool showDate,
    required LocationSummary? locationSummary,
    required Map<String, dynamic> Function() getBaseCurrency,
    required String Function(double amount, String symbol) formatBalance,
    required TabController tabController,
    required Function(ActualFlow flow, {String locationType}) showRealDetailBottomSheet,
  }) {
    return GestureDetector(
      onTap: () {
        // Determine location type based on current tab
        String locationType = 'cash';
        if (tabController.index == 1) {
          locationType = 'bank';
        } else if (tabController.index == 2) {
          locationType = 'vault';
        }
        showRealDetailBottomSheet(flow, locationType: locationType);
      },
      child: Container(
        // Build the actual widget content here
        child: Text('Real Item: ${flow.flowId}'), // Use flowId
      ),
    );
  }


  /// Check if app state is valid for operations
  static bool isAppStateValid({
    required String? selectedStoreId,
    required List<Map<String, dynamic>> stores,
    required List<Map<String, dynamic>> companyCurrencies,
    required List<Map<String, dynamic>> currencyTypes,
  }) {
    return selectedStoreId != null &&
           selectedStoreId.isNotEmpty &&
           stores.isNotEmpty &&
           companyCurrencies.isNotEmpty &&
           currencyTypes.isNotEmpty;
  }

  /// Get location name by ID
  static String getLocationNameById({
    required String locationId,
    required List<Map<String, dynamic>> locations,
  }) {
    final location = locations.firstWhere(
      (loc) => loc['cash_location_id']?.toString() == locationId ||
               loc['location_id']?.toString() == locationId,
      orElse: () => {},
    );
    return location['location_name'] ?? 'Unknown Location';
  }

  /// Get currency name by ID
  static String getCurrencyNameById({
    required String currencyId,
    required List<Map<String, dynamic>> currencies,
  }) {
    final currency = currencies.firstWhere(
      (curr) => curr['currency_id']?.toString() == currencyId,
      orElse: () => {},
    );
    return currency['currency_code'] ?? 'Unknown Currency';
  }

  /// Get currency symbol by ID
  static String getCurrencySymbolById({
    required String currencyId,
    required List<Map<String, dynamic>> currencies,
  }) {
    final currency = currencies.firstWhere(
      (curr) => curr['currency_id']?.toString() == currencyId,
      orElse: () => {},
    );
    return currency['symbol'] ?? '';
  }
}