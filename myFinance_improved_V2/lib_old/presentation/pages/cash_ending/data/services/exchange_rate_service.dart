import 'package:supabase_flutter/supabase_flutter.dart';

/// Exchange rate service for currency conversion in Cash Ending
class ExchangeRateService {
  
  /// Get the base currency ID for the company
  static Future<String?> getCompanyBaseCurrencyId(String companyId) async {
    try {
      if (companyId.isEmpty) return null;
      
      final supabase = Supabase.instance.client;
      
      // Query companies table to get base_currency_id
      final companyResult = await supabase
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .maybeSingle();
          
      if (companyResult != null && companyResult['base_currency_id'] != null) {
        return companyResult['base_currency_id'] as String;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Load exchange rates for all company currencies
  static Future<Map<String, double>> loadExchangeRates(
    String companyId,
    List<Map<String, dynamic>> companyCurrencies,
  ) async {
    try {
      if (companyId.isEmpty || companyCurrencies.isEmpty) {
        return {};
      }
      
      final supabase = Supabase.instance.client;
      
      // Get the base currency ID
      final baseCurrencyId = await getCompanyBaseCurrencyId(companyId);
      if (baseCurrencyId == null) {
        // If no base currency, assume 1:1 rates
        return {};
      }
      
      // Create a map to store exchange rates (currency_id -> rate)
      Map<String, double> exchangeRates = {};
      
      // Base currency always has rate of 1
      exchangeRates[baseCurrencyId] = 1.0;
      
      // Get exchange rates for all non-base currencies
      for (var currency in companyCurrencies) {
        final currencyId = currency['currency_id']?.toString();
        if (currencyId == null || currencyId == baseCurrencyId) continue;
        
        // Get the latest exchange rate from book_exchange_rates table
        // Note: Rate is from from_currency to to_currency
        // So we need rate from foreign currency to base currency
        final rateResult = await supabase
            .from('book_exchange_rates')
            .select('rate')
            .eq('company_id', companyId)
            .eq('from_currency_id', currencyId)
            .eq('to_currency_id', baseCurrencyId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
            
        if (rateResult != null && rateResult['rate'] != null) {
          exchangeRates[currencyId] = (rateResult['rate'] as num).toDouble();
        } else {
          // If no exchange rate found, try the reverse direction
          final reverseRateResult = await supabase
              .from('book_exchange_rates')
              .select('rate')
              .eq('company_id', companyId)
              .eq('from_currency_id', baseCurrencyId)
              .eq('to_currency_id', currencyId)
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();
              
          if (reverseRateResult != null && reverseRateResult['rate'] != null) {
            // If we have base -> foreign rate, invert it to get foreign -> base
            final reverseRate = (reverseRateResult['rate'] as num).toDouble();
            if (reverseRate > 0) {
              exchangeRates[currencyId] = 1.0 / reverseRate;
            } else {
              exchangeRates[currencyId] = 1.0; // Fallback to 1:1
            }
          } else {
            // No exchange rate found, default to 1:1
            exchangeRates[currencyId] = 1.0;
          }
        }
      }
      
      return exchangeRates;
    } catch (e) {
      return {};
    }
  }
  
  /// Convert amount from one currency to base currency
  static double convertToBaseCurrency(
    double amount,
    String currencyId,
    Map<String, double> exchangeRates,
    String? baseCurrencyId,
  ) {
    // If no base currency or same as base, return as is
    if (baseCurrencyId == null || currencyId == baseCurrencyId) {
      return amount;
    }
    
    // Get the exchange rate for this currency
    final rate = exchangeRates[currencyId] ?? 1.0;
    
    // Convert to base currency
    // If rate is "1 foreign = X base", then amount * rate = base amount
    return amount * rate;
  }
  
  /// Calculate total in base currency for multiple currencies
  static double calculateMultiCurrencyTotal(
    Map<String, double> currencyAmounts,
    Map<String, double> exchangeRates,
    String? baseCurrencyId,
  ) {
    if (baseCurrencyId == null) {
      // No base currency, just sum all amounts
      return currencyAmounts.values.fold(0.0, (sum, amount) => sum + amount);
    }
    
    double totalInBaseCurrency = 0.0;
    
    for (var entry in currencyAmounts.entries) {
      final currencyId = entry.key;
      final amount = entry.value;
      
      final convertedAmount = convertToBaseCurrency(
        amount,
        currencyId,
        exchangeRates,
        baseCurrencyId,
      );
      
      totalInBaseCurrency += convertedAmount;
    }
    
    return totalInBaseCurrency;
  }
}