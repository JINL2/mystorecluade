import 'package:dio/dio.dart';

class ExchangeRateService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  
  // Alternative free APIs you can use:
  // - https://api.fixer.io/latest (requires API key)
  // - https://api.currencyapi.com/v3/latest (requires API key)
  // - https://openexchangerates.org/api/latest.json (requires API key)
  
  final Dio _dio;
  
  ExchangeRateService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),);

  /// Fetches exchange rates from base currency to target currency
  /// 
  /// [baseCurrency] - The base currency code (e.g., 'USD')
  /// [targetCurrency] - The target currency code (e.g., 'EUR')
  /// 
  /// Returns the exchange rate as double, or null if failed
  Future<double?> getExchangeRate(String baseCurrency, String targetCurrency) async {
    try {
      // If same currency, return 1.0
      if (baseCurrency.toUpperCase() == targetCurrency.toUpperCase()) {
        return 1.0;
      }

      final response = await _dio.get(
        '$_baseUrl/$baseCurrency',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        
        // Get the exchange rate for target currency
        final rate = rates[targetCurrency.toUpperCase()];
        
        if (rate != null) {
          return (rate as num).toDouble();
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching exchange rate: $e');
      return null;
    }
  }

  /// Fetches multiple exchange rates from base currency
  /// 
  /// [baseCurrency] - The base currency code (e.g., 'USD')
  /// [targetCurrencies] - List of target currency codes
  /// 
  /// Returns a map of currency code to exchange rate
  Future<Map<String, double>> getMultipleExchangeRates(
    String baseCurrency, 
    List<String> targetCurrencies,
  ) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/$baseCurrency',
      );

      final Map<String, double> result = {};

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        
        for (final currency in targetCurrencies) {
          final rate = rates[currency.toUpperCase()];
          if (rate != null) {
            result[currency] = (rate as num).toDouble();
          }
        }
      }
      
      return result;
    } catch (e) {
      print('Error fetching multiple exchange rates: $e');
      return {};
    }
  }

  /// Gets supported currency codes from the API
  Future<List<String>> getSupportedCurrencies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/USD', // Use USD as base to get all supported currencies
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.keys.toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching supported currencies: $e');
      return [];
    }
  }

  /// Alternative method using Fixer.io API (requires API key)
  /// Uncomment and use if you have a Fixer.io API key
  /*
  Future<double?> getExchangeRateFromFixer(String baseCurrency, String targetCurrency, String apiKey) async {
    try {
      final response = await _dio.get(
        'https://api.fixer.io/latest',
        queryParameters: {
          'access_key': apiKey,
          'base': baseCurrency,
          'symbols': targetCurrency,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          final rates = data['rates'] as Map<String, dynamic>;
          return (rates[targetCurrency] as num?)?.toDouble();
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching exchange rate from Fixer: $e');
      return null;
    }
  }
  */

  /// Alternative method using CurrencyAPI (requires API key)
  /// Uncomment and use if you have a CurrencyAPI key
  /*
  Future<double?> getExchangeRateFromCurrencyAPI(String baseCurrency, String targetCurrency, String apiKey) async {
    try {
      final response = await _dio.get(
        'https://api.currencyapi.com/v3/latest',
        queryParameters: {
          'apikey': apiKey,
          'base_currency': baseCurrency,
          'currencies': targetCurrency,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final dataSection = data['data'] as Map<String, dynamic>;
        final currencyData = dataSection[targetCurrency] as Map<String, dynamic>;
        return (currencyData['value'] as num?)?.toDouble();
      }
      
      return null;
    } catch (e) {
      print('Error fetching exchange rate from CurrencyAPI: $e');
      return null;
    }
  }
  */
}