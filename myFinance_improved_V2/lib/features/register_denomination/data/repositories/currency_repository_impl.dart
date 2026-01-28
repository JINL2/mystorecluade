import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/currency.dart';
import '../../domain/repositories/currency_repository.dart';
import '../mappers/currency_info_mapper.dart';

class SupabaseCurrencyRepository implements CurrencyRepository {
  final SupabaseClient _client;

  SupabaseCurrencyRepository(this._client);

  // Default flag emoji for currencies without a flag
  static const String _defaultFlagEmoji = '🏳️';

  /// Cached RPC response for the current session
  CurrencyInfoResponse? _cachedResponse;
  String? _cachedCompanyId;

  /// Fetch currency info from RPC with optional caching
  Future<CurrencyInfoResponse> _fetchCurrencyInfo(
    String companyId, {
    String? currencyId,
    String? searchQuery,
    bool useCache = true,
  }) async {
    // Return cached response if available and valid
    if (useCache &&
        _cachedResponse != null &&
        _cachedCompanyId == companyId &&
        currencyId == null &&
        searchQuery == null) {
      return _cachedResponse!;
    }

    final response = await _client.rpc<Map<String, dynamic>>(
      'register_denomination_get_currency_info',
      params: {
        'p_company_id': companyId,
        if (currencyId != null) 'p_currency_id': currencyId,
        if (searchQuery != null) 'p_search_query': searchQuery,
      },
    );

    final result = CurrencyInfoMapper.fromRpcResponse(response);

    // Cache the response if it's a full fetch (no filters)
    if (currencyId == null && searchQuery == null) {
      _cachedResponse = result;
      _cachedCompanyId = companyId;
    }

    return result;
  }

  /// Invalidate the cache when data changes
  void _invalidateCache() {
    _cachedResponse = null;
    _cachedCompanyId = null;
  }

  @override
  Future<List<CurrencyType>> getAvailableCurrencyTypes(String companyId) async {
    try {
      final response = await _fetchCurrencyInfo(companyId);
      return response.availableCurrencyTypes;
    } catch (e) {
      throw Exception('Failed to fetch available currency types: $e');
    }
  }

  @override
  Future<List<Currency>> getCompanyCurrencies(String companyId) async {
    try {
      final response = await _fetchCurrencyInfo(companyId);
      return response.companyCurrencies;
    } catch (e) {
      throw Exception('Failed to fetch company currencies: $e');
    }
  }

  @override
  Future<Currency> addCompanyCurrency(String companyId, String currencyId) async {
    try {
      // Use RPC for add operation
      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_company_currency',
        params: {
          'p_company_id': companyId,
          'p_currency_id': currencyId,
          'p_operation': 'add',
        },
      );

      if (response['success'] != true) {
        final errorCode = response['error_code'] as String?;
        final errorMessage = response['error'] as String? ?? 'Failed to add currency';

        // Provide user-friendly error messages
        if (errorCode == 'ALREADY_ADDED') {
          throw Exception('Currency is already added to your company');
        } else if (errorCode == 'CURRENCY_NOT_EXISTS') {
          throw Exception('Currency type not found');
        }
        throw Exception(errorMessage);
      }

      // Invalidate cache after mutation
      _invalidateCache();

      // Parse currency data from RPC response
      final currencyData = response['currency'] as Map<String, dynamic>;
      final companyCurrencyId = response['company_currency_id'] as String;

      return Currency(
        id: currencyData['currency_id'] as String,
        code: currencyData['currency_code'] as String,
        name: currencyData['currency_name'] as String? ?? '',
        fullName: currencyData['currency_name'] as String? ?? '',
        symbol: currencyData['symbol'] as String? ?? '',
        flagEmoji: currencyData['flag_emoji'] as String? ?? _defaultFlagEmoji,
        companyCurrencyId: companyCurrencyId,
        denominations: [],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to add currency to company: $e');
    }
  }

  @override
  Future<void> removeCompanyCurrency(String companyId, String currencyId) async {
    try {
      // Use RPC for remove operation
      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_company_currency',
        params: {
          'p_company_id': companyId,
          'p_currency_id': currencyId,
          'p_operation': 'remove',
        },
      );

      if (response['success'] != true) {
        final errorCode = response['error_code'] as String?;
        final errorMessage = response['error'] as String? ?? 'Failed to remove currency';

        // Provide user-friendly error messages
        if (errorCode == 'BASE_CURRENCY') {
          throw Exception('Cannot remove base currency. Please change the base currency first.');
        } else if (errorCode == 'NOT_FOUND') {
          throw Exception('Currency not found in company or already removed');
        }
        throw Exception(errorMessage);
      }

      // Invalidate cache after mutation
      _invalidateCache();
    } catch (e) {
      throw Exception('Failed to remove currency: $e');
    }
  }

  @override
  Future<Currency?> getCompanyCurrency(String companyId, String currencyId) async {
    try {
      final response = await _fetchCurrencyInfo(companyId, currencyId: currencyId);

      // Find the specific currency from the response
      final currencies = response.companyCurrencies;
      if (currencies.isEmpty) return null;

      return currencies.firstWhere(
        (c) => c.id == currencyId,
        orElse: () => currencies.first,
      );
    } catch (e) {
      throw Exception('Failed to fetch company currency: $e');
    }
  }

  @override
  Future<List<CurrencyType>> searchCurrencyTypes(String companyId, String query) async {
    try {
      final response = await _fetchCurrencyInfo(companyId, searchQuery: query);
      return response.availableCurrencyTypes;
    } catch (e) {
      throw Exception('Failed to search currency types: $e');
    }
  }

  @override
  Stream<List<Currency>> watchCompanyCurrencies(String companyId) {
    // For real-time updates, we still need to use the stream-based approach
    // but we can simplify by using RPC for the data fetch
    return _client
        .from('company_currency')
        .select('company_currency_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .asStream()
        .asyncMap((_) async {
          // Invalidate cache and fetch fresh data
          _invalidateCache();
          final response = await _fetchCurrencyInfo(companyId, useCache: false);
          return response.companyCurrencies;
        });
  }

  @override
  Future<bool> hasDenominations(String companyId, String currencyId) async {
    try {
      final response = await _fetchCurrencyInfo(companyId, currencyId: currencyId);

      // Find the specific currency and check its denominations
      final currency = response.companyCurrencies.firstWhere(
        (c) => c.id == currencyId,
        orElse: () => Currency(
          id: currencyId,
          code: '',
          name: '',
          fullName: '',
          symbol: '',
          flagEmoji: _defaultFlagEmoji,
          denominations: [],
        ),
      );

      return currency.denominations.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check denominations: $e');
    }
  }

  @override
  Future<bool> isBaseCurrency(String companyId, String currencyId) async {
    try {
      final response = await _fetchCurrencyInfo(companyId);
      return response.baseCurrencyId == currencyId;
    } catch (e) {
      // Log error but return false as default (safer to show Rate button if unsure)
      return false;
    }
  }

  @override
  Future<CurrencyInfoResponse> getCurrencyInfo(String companyId) async {
    try {
      return await _fetchCurrencyInfo(companyId);
    } catch (e) {
      throw Exception('Failed to fetch currency info: $e');
    }
  }

  @override
  Future<ExchangeRateResult> getCurrentExchangeRate(
    String companyId,
    String currencyId,
  ) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_exchange_rate',
        params: {
          'p_company_id': companyId,
          'p_currency_id': currencyId,
          // p_rate is NULL → READ mode
        },
      );

      return ExchangeRateResult.fromRpcResponse(response);
    } catch (e) {
      throw Exception('Failed to get current exchange rate: $e');
    }
  }

  @override
  Future<ExchangeRateResult> insertExchangeRate({
    required String companyId,
    required String currencyId,
    required double rate,
    required String userId,
    DateTime? rateDate,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'register_denomination_upsert_exchange_rate',
        params: {
          'p_company_id': companyId,
          'p_currency_id': currencyId,
          'p_rate': rate,
          'p_user_id': userId,
          if (rateDate != null) 'p_rate_date': rateDate.toIso8601String().split('T')[0],
        },
      );

      return ExchangeRateResult.fromRpcResponse(response);
    } catch (e) {
      throw Exception('Failed to insert exchange rate: $e');
    }
  }
}
