import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Currency service for loading currency data from Supabase
/// FROM PRODUCTION LINES 205-361, 397-414, 4395-4425
class CurrencyService {
  
  /// Load company currencies from Supabase
  /// FROM PRODUCTION LINES 205-273
  Future<Map<String, dynamic>> loadCompanyCurrencies(String companyId) async {
    try {
      if (companyId.isEmpty) {
        return {
          'companyCurrencies': [],
        };
      }
      
      // Step 1: Query company_currency table to get currency_ids for this company
      // Filter out soft-deleted currencies with is_deleted = false
      final companyCurrencyResponse = await Supabase.instance.client
          .from('company_currency')
          .select('currency_id, company_currency_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false);
      
      if (companyCurrencyResponse.isEmpty) {
        return {
          'companyCurrencies': [],
        };
      }
      
      // Step 2: Extract currency_ids
      final currencyIds = companyCurrencyResponse
          .map((item) => item['currency_id'].toString())
          .toList();
      
      // Step 3: Query currency_types to get full currency details
      final currencyTypesResponse = await Supabase.instance.client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol')
          .inFilter('currency_id', currencyIds);
      
      // Step 4: Combine the data - match currency details with company_currency records
      final combinedCurrencies = <Map<String, dynamic>>[];
      for (var companyCurrency in companyCurrencyResponse) {
        final currencyId = companyCurrency['currency_id'].toString();
        final currencyType = currencyTypesResponse.firstWhere(
          (type) => type['currency_id'].toString() == currencyId,
          orElse: () => <String, dynamic>{},
        );
        
        if (currencyType.isNotEmpty) {
          // Combine company_currency data with currency_type details
          combinedCurrencies.add({
            'currency_id': currencyId,
            'company_currency_id': companyCurrency['company_currency_id'],
            'currency_code': currencyType['currency_code'],
            'currency_name': currencyType['currency_name'],
            'symbol': currencyType['symbol'],
          });
        }
      }
      
      return {
        'companyCurrencies': combinedCurrencies,
      };
    } catch (e) {
      // Error loading company currencies: $e
      return {
        'companyCurrencies': [],
      };
    }
  }

  /// Load currency denominations from Supabase
  /// FROM PRODUCTION LINES 276-334
  Future<Map<String, dynamic>> loadCurrencyDenominations(
    String companyId, 
    List<Map<String, dynamic>> companyCurrencies,
    Map<String, Map<String, TextEditingController>> existingControllers,
  ) async {
    try {
      if (companyId.isEmpty || companyCurrencies.isEmpty) {
        return {
          'currencyDenominations': {},
          'denominationControllers': existingControllers,
          'selectedCurrencyIds': {},
        };
      }
      
      // Query currency_denominations table - only get active (non-deleted) denominations
      final response = await Supabase.instance.client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('value', ascending: false);
      
      // Group denominations by currency_id
      Map<String, List<Map<String, dynamic>>> grouped = {};
      
      // Only create new controllers if they don't exist (preserve existing data)
      Map<String, Map<String, TextEditingController>> controllers = Map.from(existingControllers);
      
      for (var denom in response) {
        final currencyId = denom['currency_id'].toString();
        if (!grouped.containsKey(currencyId)) {
          grouped[currencyId] = [];
        }
        grouped[currencyId]!.add(denom);
        
        // Only create controller if it doesn't exist (preserve existing values)
        if (!controllers.containsKey(currencyId)) {
          controllers[currencyId] = {};
        }
        final denomValue = (denom['value'] ?? 0).toString();
        if (!controllers[currencyId]!.containsKey(denomValue)) {
          controllers[currencyId]![denomValue] = TextEditingController();
        }
      }
      
      // Set default selected currency (first one)
      String? defaultCurrencyId;
      if (companyCurrencies.isNotEmpty) {
        defaultCurrencyId = companyCurrencies.first['currency_id'].toString();
      }
      
      return {
        'currencyDenominations': grouped,
        'denominationControllers': controllers,
        'selectedCashCurrencyId': defaultCurrencyId,
        'selectedBankCurrencyId': defaultCurrencyId,
        'selectedVaultCurrencyId': defaultCurrencyId,
      };
    } catch (e) {
      return {
        'currencyDenominations': {},
        'denominationControllers': existingControllers,
        'selectedCurrencyIds': {},
      };
    }
  }

  /// Load currency types from Supabase
  /// FROM PRODUCTION LINES 337-361
  Future<Map<String, dynamic>> loadCurrencyTypes() async {
    try {
      // Fetch all currency types from the currency_types table
      final response = await Supabase.instance.client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol');
      
      return {
        'currencyTypes': List<Map<String, dynamic>>.from(response),
        'isLoadingCurrency': false,
      };
    } catch (e) {
      // Error loading currency types: $e
      return {
        'currencyTypes': [],
        'isLoadingCurrency': false,
      };
    }
  }

  /// Get the default currency (KRW) or first available
  /// FROM PRODUCTION LINES 397-414
  Map<String, dynamic> getDefaultCurrency(List<Map<String, dynamic>> currencyTypes) {
    if (currencyTypes.isEmpty) {
      return {
        'currency_id': '',
        'currency_code': 'KRW',
        'currency_name': 'Korean Won',
        'symbol': '₩',
      };
    }
    
    // Try to find KRW as default
    final krw = currencyTypes.firstWhere(
      (currency) => currency['currency_code'] == 'KRW',
      orElse: () => currencyTypes.first,
    );
    
    return krw;
  }

  /// Get the base currency
  /// FROM PRODUCTION LINES 4395-4425
  Map<String, dynamic> getBaseCurrency(List<Map<String, dynamic>> currencyTypes) {
    if (currencyTypes.isEmpty) {
      return {
        'currency_id': '',
        'currency_code': 'KRW',
        'currency_name': 'Korean Won',
        'symbol': '₩',
      };
    }
    
    // Try to find KRW as the base currency
    final krw = currencyTypes.firstWhere(
      (currency) => currency['currency_code'] == 'KRW',
      orElse: () => currencyTypes.first,
    );
    
    return krw;
  }
}