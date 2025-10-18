import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Bank service for saving bank balance data
/// FROM PRODUCTION LINES 2446-2586 and 2589-2713
class BankService {
  
  /// Save bank balance to database
  /// CRITICAL: FROM PRODUCTION LINES 2446-2586
  /// Contains the critical RPC call from lines 2510-2511
  Future<Map<String, dynamic>> saveBankBalance({
    required String companyId,
    required String? userId,
    required String? selectedStoreId,
    required String? selectedBankLocationId,
    required String? selectedBankCurrencyType,
    required TextEditingController bankAmountController,
    required List<Map<String, dynamic>> currencyTypes,
  }) async {
    try {
      // Validation
      if (companyId.isEmpty || userId == null) {
        return {
          'success': false,
          'error': 'Missing company or user information',
        };
      }
      
      if (selectedBankLocationId == null) {
        return {
          'success': false,
          'error': 'Please select a bank location',
        };
      }
      
      if (selectedBankCurrencyType == null) {
        return {
          'success': false,
          'error': 'Please select a currency',
        };
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      
      // Format created_at with microseconds like "2025-06-07 23:40:55.948829"
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now) + 
                       '.${now.microsecond.toString().padLeft(6, '0')}';
      
      // Parse the amount (remove commas) as integer
      final amountText = bankAmountController.text.replaceAll(',', '');
      final totalAmount = int.tryParse(amountText) ?? 0;
      
      // Prepare parameters for RPC call
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': selectedStoreId == 'headquarter' ? null : selectedStoreId,
        'p_record_date': recordDate,
        'p_location_id': selectedBankLocationId,
        'p_currency_id': selectedBankCurrencyType,
        'p_total_amount': totalAmount,
        'p_created_by': userId,
        'p_created_at': createdAt,
      };
      
      // CRITICAL: Call the RPC function - EXACT FROM LINES 2510-2511
      final response = await Supabase.instance.client
          .rpc('bank_amount_insert_v2', params: params);
      
      
      // Get currency symbol for display
      final currency = currencyTypes.firstWhere(
        (c) => c['currency_id'].toString() == selectedBankCurrencyType,
        orElse: () => {'symbol': '', 'currency_code': ''},
      );
      final currencySymbol = currency['symbol'] ?? '';
      
      // Trigger haptic feedback for success
      HapticFeedback.mediumImpact();
      
      return {
        'success': true,
        'response': response,
        'amount': '$currencySymbol${bankAmountController.text}',
      };
      
    } catch (e) {
      // Parse error message for user-friendly display
      String errorMessage = 'Failed to save bank balance';
      if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('duplicate')) {
        errorMessage = 'Bank balance for today already exists.';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'You do not have permission to save bank balance.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  /// Save currency for bank location
  /// FROM PRODUCTION LINES 2589-2713 (to be added when reading those lines)
  Future<Map<String, dynamic>> saveBankLocationCurrency({
    required String companyId,
    required String? userId,
    required String? selectedBankLocationId,
    required String? tempSelectedBankCurrency,
  }) async {
    // This function will be implemented when we read lines 2589-2713
    // Placeholder for now
    return {
      'success': false,
      'error': 'Not yet implemented',
    };
  }

  /// Clear bank form after successful save
  /// FROM PRODUCTION LINES 2531-2554
  Map<String, dynamic> clearBankFormAfterSave({
    required TextEditingController bankAmountController,
    required List<Map<String, dynamic>> bankLocations,
    required String? selectedBankLocationId,
    required String? selectedBankCurrencyType,
  }) {
    // Clear the amount controller
    bankAmountController.clear();
    
    // Check if the selected location has a fixed currency
    Map<String, dynamic>? selectedLocation;
    if (selectedBankLocationId != null) {
      try {
        selectedLocation = bankLocations.firstWhere(
          (loc) => loc['cash_location_id']?.toString() == selectedBankLocationId,
        );
      } catch (e) {
        // Location not found
      }
    }
    
    // Only clear currency if the location doesn't have a fixed currency
    final locationCurrencyId = selectedLocation?['currency_id']?.toString();
    String? newSelectedBankCurrencyType = selectedBankCurrencyType;
    if (locationCurrencyId == null || locationCurrencyId.isEmpty) {
      newSelectedBankCurrencyType = null;
    }
    // If location has fixed currency, keep it selected
    
    return {
      'selectedBankCurrencyType': newSelectedBankCurrencyType,
    };
  }
}