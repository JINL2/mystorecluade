import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Cash service for saving cash ending data
/// FROM PRODUCTION LINES 3832-4041
class CashService {
  
  /// Save cash ending to database
  /// CRITICAL: FROM PRODUCTION LINES 3832-4041
  /// Contains the critical RPC call from lines 3985-3986
  Future<Map<String, dynamic>> saveCashEnding({
    required String companyId,
    required String? userId,
    required String? locationId,
    required String? selectedStoreId,
    required int tabIndex,
    required String? selectedBankLocationId,
    required String? selectedVaultLocationId,
    required List<Map<String, dynamic>> companyCurrencies,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
    required String? selectedBankCurrencyId,
    required String? selectedVaultCurrencyId,
    required bool Function(String) currencyHasData,
  }) async {
    try {
      if (companyId.isEmpty || userId == null) {
        return {
          'success': false,
          'error': 'Missing company or user information',
        };
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      
      // Determine which tab's data to save
      String? locationIdToSave;
      if (tabIndex == 0) {
        locationIdToSave = locationId;
      } else if (tabIndex == 1) {
        locationIdToSave = selectedBankLocationId;
      } else if (tabIndex == 2) {
        locationIdToSave = selectedVaultLocationId;
      }
      
      if (locationIdToSave == null) {
        return {
          'success': false,
          'error': 'Please select a location',
        };
      }
      
      // Build currencies JSON structure
      List<Map<String, dynamic>> currencies = [];
      
      // For cash tab (index 0), collect data from ALL currencies that have data
      if (tabIndex == 0) {
        // Iterate through all company currencies
        for (var currency in companyCurrencies) {
          final currencyId = currency['currency_id']?.toString();
          
          if (currencyId != null && currencyHasData(currencyId)) {
            List<Map<String, dynamic>> denominationsList = [];
            
            // Get the controllers for this currency
            final controllers = denominationControllers[currencyId] ?? {};
            
            // Get denominations for this currency
            final denominationsForCurrency = currencyDenominations[currencyId] ?? [];
            
            // Iterate through denominations and add ONLY those with quantity > 0
            for (var denomination in denominationsForCurrency) {
              final denominationId = denomination['denomination_id']?.toString();
              final denominationValue = (denomination['value'] ?? 0).toString();
              
              if (denominationValue != null && controllers.containsKey(denominationValue)) {
                final controller = controllers[denominationValue];
                final quantityText = controller?.text.trim() ?? '';
                
                if (quantityText.isNotEmpty && quantityText != '0') {
                  final quantity = int.tryParse(quantityText) ?? 0;
                  if (quantity > 0) {
                    denominationsList.add({
                      'denomination_id': denominationId,
                      'quantity': quantity,
                    });
                  }
                }
              }
            }
            
            if (denominationsList.isNotEmpty) {
              currencies.add({
                'currency_id': currencyId,
                'denominations': denominationsList,
              });
            }
          }
        }
      } else {
        // For bank and vault tabs, use only the selected currency (existing behavior)
        String? currentCurrencyId;
        if (tabIndex == 1) {
          currentCurrencyId = selectedBankCurrencyId;
        } else if (tabIndex == 2) {
          currentCurrencyId = selectedVaultCurrencyId;
        }
        
        if (currentCurrencyId != null) {
          List<Map<String, dynamic>> denominationsList = [];
          
          // Get the controllers for the selected currency
          final controllers = denominationControllers[currentCurrencyId] ?? {};
          
          // Get denominations for the current currency
          final denominationsForCurrency = currencyDenominations[currentCurrencyId] ?? [];
          
          // Iterate through denominations and add ONLY those with quantity > 0
          for (var denomination in denominationsForCurrency) {
            final denominationId = denomination['denomination_id']?.toString();
            final denominationValue = (denomination['value'] ?? 0).toString();
            
            if (denominationValue != null && controllers.containsKey(denominationValue)) {
              final controller = controllers[denominationValue];
              final quantityText = controller?.text.trim() ?? '';
              
              if (quantityText.isNotEmpty && quantityText != '0') {
                final quantity = int.tryParse(quantityText) ?? 0;
                if (quantity > 0) {
                  denominationsList.add({
                    'denomination_id': denominationId,
                    'quantity': quantity,
                  });
                }
              }
            }
          }
          
          if (denominationsList.isNotEmpty) {
            currencies.add({
              'currency_id': currentCurrencyId,
              'denominations': denominationsList,
            });
          }
        }
      }
      
      // Check if at least one denomination was entered
      if (currencies.isEmpty || 
          (currencies.isNotEmpty && currencies[0]['denominations'].isEmpty)) {
        return {
          'success': false,
          'error': 'Please enter at least one denomination quantity',
        };
      }
      
      // Prepare parameters for RPC call
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_location_id': locationIdToSave,
        'p_record_date': recordDate,
        'p_created_by': userId,
        'p_currencies': currencies,
        'p_created_at': createdAt,
        // Always include p_store_id, set to null for Headquarter
        'p_store_id': (selectedStoreId == 'headquarter') ? null : selectedStoreId,
      };
      
      // CRITICAL: Call the RPC function - EXACT FROM LINES 3985-3986
      final response = await Supabase.instance.client
          .rpc('insert_cashier_amount_lines', params: params);
      
      // RPC returns null on success, so we don't check the response
      return {
        'success': true,
        'response': response,
      };
      
    } catch (e) {
      return {
        'success': false,
        'error': 'Error saving cash ending: ${e.toString()}',
      };
    }
  }

  /// Clear form controllers after successful save
  /// FROM PRODUCTION LINES 4005-4030
  void clearFormAfterSave({
    required int tabIndex,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    if (tabIndex == 0) {
      // For cash tab, optionally clear all currency data after successful save
      denominationControllers.forEach((currencyId, controllers) {
        controllers.forEach((denominationId, controller) {
          controller.clear();
        });
      });
    } else {
      // For bank and vault tabs, clear only the selected currency
      denominationControllers.forEach((currencyId, controllers) {
        controllers.forEach((denominationId, controller) {
          controller.clear();
        });
      });
    }
  }
}