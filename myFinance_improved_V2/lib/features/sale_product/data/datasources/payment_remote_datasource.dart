import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/cash_location_model.dart';

/// Payment exception base class
abstract class PaymentException implements Exception {
  final String message;
  final dynamic originalError;

  const PaymentException(this.message, {this.originalError});

  @override
  String toString() => message;
}

/// Payment data exception
class PaymentDataException extends PaymentException {
  const PaymentDataException(super.message, {super.originalError});
}

/// Payment network exception
class PaymentNetworkException extends PaymentException {
  final String? code;

  const PaymentNetworkException(
    super.message, {
    this.code,
    super.originalError,
  });
}

/// Payment remote data source for sale product
class PaymentRemoteDataSource {
  final SupabaseClient _client;

  PaymentRemoteDataSource(this._client);

  /// Get currency data using table queries
  Future<Map<String, dynamic>> getCurrencyData({
    required String companyId,
  }) async {
    try {
      // 1. Get company's base currency ID
      final companyResult = await _client
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .maybeSingle();

      if (companyResult == null) {
        throw const PaymentDataException(
          'Company not found',
        );
      }

      final baseCurrencyId = companyResult['base_currency_id'] as String?;
      if (baseCurrencyId == null || baseCurrencyId.isEmpty) {
        throw const PaymentDataException(
          'Base currency not configured for this company',
        );
      }

      // 2. Get base currency details from currency_types
      final baseCurrencyResult = await _client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol, flag_emoji')
          .eq('currency_id', baseCurrencyId)
          .maybeSingle();

      if (baseCurrencyResult == null) {
        throw const PaymentDataException(
          'Base currency type not found',
        );
      }

      // 3. Get company currencies (non-deleted)
      final companyCurrencies = await _client
          .from('company_currency')
          .select('currency_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      List<Map<String, dynamic>> companyCurrencyList = [];

      if (companyCurrencies.isNotEmpty) {
        final currencyIds = (companyCurrencies as List<dynamic>)
            .map((cc) => (cc as Map<String, dynamic>)['currency_id'] as String)
            .toList();

        // 4. Get currency details for company currencies
        final currencyTypes = await _client
            .from('currency_types')
            .select('currency_id, currency_code, currency_name, symbol, flag_emoji')
            .inFilter('currency_id', currencyIds);

        companyCurrencyList = (currencyTypes as List<dynamic>)
            .map((ct) {
              final ctMap = ct as Map<String, dynamic>;
              return {
                'currency_id': ctMap['currency_id'],
                'currency_code': ctMap['currency_code'],
                'currency_name': ctMap['currency_name'],
                'symbol': ctMap['symbol'],
                'flag_emoji': ctMap['flag_emoji'] ?? '🏳️',
                'exchange_rate_to_base':
                    ctMap['currency_id'] == baseCurrencyId ? 1.0 : null,
              };
            })
            .toList();
      }

      return {
        'base_currency': {
          'currency_id': baseCurrencyResult['currency_id'],
          'currency_code': baseCurrencyResult['currency_code'],
          'currency_name': baseCurrencyResult['currency_name'],
          'symbol': baseCurrencyResult['symbol'],
          'flag_emoji': baseCurrencyResult['flag_emoji'] ?? '🏳️',
          'exchange_rate_to_base': 1.0,
        },
        'company_currencies': companyCurrencyList,
      };
    } on PostgrestException catch (e) {
      throw PaymentNetworkException(
        'Failed to load currency data: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentDataException(
        'Failed to parse currency data: $e',
        originalError: e,
      );
    }
  }

  /// Get cash locations using RPC
  Future<List<CashLocationModel>> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_type': null,
        },
      );

      return (response)
          .map((e) => CashLocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw PaymentNetworkException(
        'Failed to load cash locations: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentDataException(
        'Failed to parse cash location data: $e',
        originalError: e,
      );
    }
  }

  /// Get exchange rates
  Future<Map<String, dynamic>?> getExchangeRates({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>?>(
        'get_exchange_rate_v2',
        params: {
          'p_company_id': companyId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw PaymentNetworkException(
        'Failed to load exchange rates: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentDataException(
        'Failed to parse exchange rate data: $e',
        originalError: e,
      );
    }
  }

  /// Create invoice using inventory_create_invoice_v3
  Future<Map<String, dynamic>> createInvoice({
    required String companyId,
    required String storeId,
    required String userId,
    required DateTime saleDate,
    required List<InvoiceItem> items,
    required String paymentMethod,
    double? discountAmount,
    double? taxRate,
    String? notes,
    String? cashLocationId,
    String? customerId,
  }) async {
    try {
      // Get user's local timezone (IANA format)
      final timezone = DateTimeUtils.getLocalTimezone();

      // Format sale_date as timestamptz with local timezone offset
      // e.g., "2025-12-03T18:47:56+07:00"
      final saleDateWithOffset = DateTimeUtils.toLocalWithOffset(saleDate);

      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_create_invoice_v3',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_created_by': userId,
          'p_sale_date': saleDateWithOffset,
          'p_items': items.map((item) => item.toJson()).toList(),
          'p_payment_method': paymentMethod,
          'p_timezone': timezone,
          if (discountAmount != null) 'p_discount_amount': discountAmount,
          if (taxRate != null) 'p_tax_rate': taxRate,
          if (notes != null) 'p_notes': notes,
          if (cashLocationId != null) 'p_cash_location_id': cashLocationId,
          if (customerId != null) 'p_customer_id': customerId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw PaymentNetworkException(
        'Failed to create invoice: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is PaymentException) rethrow;
      throw PaymentDataException(
        'Failed to process invoice creation: $e',
        originalError: e,
      );
    }
  }
}
