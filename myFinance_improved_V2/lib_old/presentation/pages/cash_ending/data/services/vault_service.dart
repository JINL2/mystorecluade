import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Vault service for saving vault balance data
/// FROM PRODUCTION LINES 3722-3831 and vault balance fetching
class VaultService {
  
  /// Save vault balance to database
  /// CRITICAL: FROM PRODUCTION LINES 3722-3831
  /// Contains the critical RPC call from lines 3790-3791
  Future<Map<String, dynamic>> saveVaultBalance({
    required String companyId,
    required String? userId,
    required String? selectedStoreId,
    required String? selectedVaultLocationId,
    required String? selectedVaultCurrencyId,
    required String? vaultTransactionType,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
  }) async {
    try {
      if (companyId.isEmpty || userId == null) {
        return {
          'success': false,
          'error': 'Missing company or user information',
        };
      }
      
      if (selectedVaultLocationId == null || selectedVaultCurrencyId == null || vaultTransactionType == null) {
        return {
          'success': false,
          'error': 'Please select location, currency, and transaction type',
        };
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);
      
      // Build vault_amount_line_json with denomination details
      List<Map<String, dynamic>> vaultAmountLineJson = [];
      
      if (denominationControllers.containsKey(selectedVaultCurrencyId)) {
        final controllers = denominationControllers[selectedVaultCurrencyId]!;
        final denominations = currencyDenominations[selectedVaultCurrencyId] ?? [];
        
        for (var denom in denominations) {
          final denomId = denom['denomination_id']?.toString() ?? denom['id']?.toString() ?? '';
          final denomValue = (denom['value'] ?? 0).toString();
          final controller = controllers[denomValue];
          
          if (controller != null && controller.text.isNotEmpty) {
            final quantity = int.tryParse(controller.text) ?? 0;
            if (quantity > 0) {
              vaultAmountLineJson.add({
                'quantity': quantity.toString(),
                'denomination_id': denomId,
                'denomination_value': denomValue,
                'denomination_type': denom['denomination_type'] ?? 'BILL',
              });
            }
          }
        }
      }
      
      // Prepare RPC parameters
      final params = {
        'p_location_id': selectedVaultLocationId,
        'p_company_id': companyId,
        'p_created_at': createdAt,
        'p_created_by': userId,
        'p_credit': vaultTransactionType == 'credit',
        'p_debit': vaultTransactionType == 'debit',
        'p_currency_id': selectedVaultCurrencyId,
        'p_record_date': recordDate,
        'p_store_id': selectedStoreId,
        'p_vault_amount_line_json': vaultAmountLineJson,
      };
      
      // CRITICAL: Call the RPC function - EXACT FROM LINES 3790-3791
      final response = await Supabase.instance.client
          .rpc('vault_amount_insert', params: params);
      
      return {
        'success': true,
        'response': response,
      };
      
    } catch (e) {
      return {
        'success': false,
        'error': 'Error saving vault balance: ${e.toString()}',
      };
    }
  }

  /// Clear vault form after successful save
  /// FROM PRODUCTION LINES 3801-3811
  void clearVaultFormAfterSave({
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
  }) {
    // Clear the form after success
    if (selectedVaultCurrencyId != null && 
        denominationControllers.containsKey(selectedVaultCurrencyId)) {
      denominationControllers[selectedVaultCurrencyId]!.forEach((key, controller) {
        controller.clear();
      });
    }
  }

  /// Calculate vault total amount
  /// Helper function for vault calculations
  int calculateVaultTotalAmount({
    required String? selectedVaultCurrencyId,
    required Map<String, Map<String, TextEditingController>> denominationControllers,
    required Map<String, List<Map<String, dynamic>>> currencyDenominations,
  }) {
    int total = 0;
    
    if (selectedVaultCurrencyId != null && 
        denominationControllers.containsKey(selectedVaultCurrencyId)) {
      final controllers = denominationControllers[selectedVaultCurrencyId]!;
      final denominations = currencyDenominations[selectedVaultCurrencyId] ?? [];
      
      for (var denom in denominations) {
        final denomValue = (denom['value'] ?? 0);
        final denomValueString = denomValue.toString();
        final controller = controllers[denomValueString];
        
        if (controller != null && controller.text.isNotEmpty) {
          final quantity = int.tryParse(controller.text) ?? 0;
          if (quantity > 0) {
            total += (denomValue * quantity) as int;
          }
        }
      }
    }
    
    return total;
  }
}