import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Calculation utility functions for Cash Ending page
/// FROM PRODUCTION LINES 3601-3720
class CalculationUtils {
  
  /// Get denomination value as string
  /// FROM PRODUCTION LINES 3601-3605
  static String getDenominationValueAsString(Map<String, dynamic> denomination) {
    final amountRaw = denomination['value'] ?? 0;
    final amount = amountRaw is int ? amountRaw : (amountRaw as num).toInt();
    return amount.toString();
  }

  /// Calculate subtotal for denomination input
  /// FROM PRODUCTION LINES 3607-3613
  static String calculateSubtotal(String denomination, String quantity, String currencySymbol) {
    // Parse denomination and quantity values
    final denom = int.tryParse(denomination.trim()) ?? 0;
    final qty = int.tryParse(quantity.trim()) ?? 0;
    final subtotal = denom * qty;
    return '$currencySymbol${NumberFormat('#,###').format(subtotal)}';
  }
  
  /// Helper function to check if a currency has any data entered
  /// FROM PRODUCTION LINES 3615-3628
  static bool currencyHasData(String currencyId, Map<String, Map<String, TextEditingController>> denominationControllers) {
    if (!denominationControllers.containsKey(currencyId)) {
      return false;
    }
    
    final controllers = denominationControllers[currencyId]!;
    for (var controller in controllers.values) {
      if (controller.text.isNotEmpty && controller.text != '0') {
        return true;
      }
    }
    return false;
  }
  
  /// Calculate total with currency symbol formatting
  /// FROM PRODUCTION LINES 3630-3667
  static String calculateTotal({
    required String tabType,
    required String? selectedCashCurrencyId,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
  }) {
    // Get selected currency ID based on tab
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    if (selectedCurrencyId == null || !denominationControllers.containsKey(selectedCurrencyId)) {
      return '0';
    }
    
    // Get currency info from companyCurrencies (already has all details)
    final currencyInfo = companyCurrencies.firstWhere(
      (c) => c['currency_id'].toString() == selectedCurrencyId,
      orElse: () => {'symbol': ''},
    );
    
    int total = 0;
    final controllers = denominationControllers[selectedCurrencyId] ?? {};
    final denominations = currencyDenominations[selectedCurrencyId] ?? [];
    
    for (var denom in denominations) {
      final denomValue = (denom['value'] ?? 0).toString();
      final controller = controllers[denomValue];
      if (controller != null) {
        final value = ((denom['value'] ?? 0) as num).toInt();
        final qty = int.tryParse(controller.text) ?? 0;
        total += value * qty;
      }
    }
    
    final currencySymbol = currencyInfo['symbol'] ?? '';
    return '$currencySymbol${NumberFormat('#,###').format(total)}';
  }
  
  /// Calculate total amount as integer
  /// FROM PRODUCTION LINES 3669-3720
  static int calculateTotalAmount({
    required String tabType,
    required String? selectedCashCurrencyId,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required Function(String) currencyHasDataCallback,
  }) {
    // For cash tab, calculate total across ALL currencies that have data
    if (tabType == 'cash') {
      int total = 0;
      for (var currency in companyCurrencies) {
        final currencyId = currency['currency_id']?.toString();
        if (currencyId != null && currencyHasDataCallback(currencyId)) {
          final controllers = denominationControllers[currencyId] ?? {};
          final denominations = currencyDenominations[currencyId] ?? [];
          
          for (var denom in denominations) {
            final denomValue = (denom['value'] ?? 0).toString();
            final controller = controllers[denomValue];
            if (controller != null) {
              final value = ((denom['value'] ?? 0) as num).toInt();
              final qty = int.tryParse(controller.text) ?? 0;
              total += value * qty;
            }
          }
        }
      }
      return total;
    } else {
      // For bank and vault tabs, use the existing single currency logic
      final String? selectedCurrencyId;
      if (tabType == 'bank') {
        selectedCurrencyId = selectedBankCurrencyId;
      } else {
        selectedCurrencyId = selectedVaultCurrencyId;
      }
      
      if (selectedCurrencyId == null || !denominationControllers.containsKey(selectedCurrencyId)) {
        return 0;
      }
      
      int total = 0;
      final controllers = denominationControllers[selectedCurrencyId] ?? {};
      final denominations = currencyDenominations[selectedCurrencyId] ?? [];
      
      for (var denom in denominations) {
        final denomValue = (denom['value'] ?? 0).toString();
        final controller = controllers[denomValue];
        if (controller != null) {
          final value = ((denom['value'] ?? 0) as num).toInt();
          final qty = int.tryParse(controller.text) ?? 0;
          total += value * qty;
        }
      }
      
      return total;
    }
  }
}