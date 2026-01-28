import 'dart:convert';
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

  /// Get currency data using get_base_currency RPC
  ///
  /// Returns base currency info and company currencies with exchange rates
  Future<Map<String, dynamic>> getCurrencyData({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_base_currency',
        params: {'p_company_id': companyId},
      );

      // RPC returns: { base_currency: {...}, company_currencies: [...] }
      final baseCurrency = response['base_currency'] as Map<String, dynamic>?;
      final companyCurrencies = response['company_currencies'] as List<dynamic>?;

      if (baseCurrency == null) {
        throw const PaymentDataException(
          'Base currency not configured for this company',
        );
      }

      // Transform company_currencies to match expected format
      final companyCurrencyList = (companyCurrencies ?? []).map((currency) {
        final c = currency as Map<String, dynamic>;
        return {
          'currency_id': c['currency_id'],
          'currency_code': c['currency_code'],
          'currency_name': c['currency_name'],
          'symbol': c['symbol'],
          'flag_emoji': c['flag_emoji'] ?? '🏳️',
          'exchange_rate_to_base': c['exchange_rate_to_base'] ?? 1.0,
        };
      }).toList();

      return {
        'base_currency': {
          'currency_id': baseCurrency['currency_id'],
          'currency_code': baseCurrency['currency_code'],
          'currency_name': baseCurrency['currency_name'],
          'symbol': baseCurrency['symbol'],
          'flag_emoji': baseCurrency['flag_emoji'] ?? '🏳️',
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

  /// Get cash locations using get_cash_locations_v2 RPC
  ///
  /// v2 changes from v1:
  /// - Field names match actual database column names (snake_case)
  /// - Added store_name, currency_id, icon, note, main_cash_location fields
  /// - Removed duplicate additionalData fields
  Future<List<CashLocationModel>> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations_v2',
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

  /// Create invoice using inventory_create_invoice_v5
  /// v5 changes:
  /// - p_items now supports variant_id field for variant products
  /// - inventory_flow table INSERT removed (deprecated)
  /// - Response includes warnings array
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
    print('🚀 [RPC] createInvoice() START');

    try {
      // Get user's local timezone (IANA format)
      final timezone = DateTimeUtils.getLocalTimezone();
      print('🌍 [RPC] timezone=$timezone');

      // Format sale_date as timestamptz with local timezone offset
      // e.g., "2025-12-03T18:47:56+07:00"
      final saleDateWithOffset = DateTimeUtils.toLocalWithOffset(saleDate);
      print('📅 [RPC] saleDateWithOffset=$saleDateWithOffset');

      // Prepare items for logging (v5: includes variant_id if present)
      final itemsList = items.map((item) => item.toJson()).toList();
      print('📦 [RPC] items JSON: ${jsonEncode(itemsList)}');

      // Build params
      final params = <String, dynamic>{
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_created_by': userId,
        'p_sale_date': saleDateWithOffset,
        'p_items': itemsList,
        'p_payment_method': paymentMethod,
        'p_timezone': timezone,
      };

      if (discountAmount != null) params['p_discount_amount'] = discountAmount;
      if (taxRate != null) params['p_tax_rate'] = taxRate;
      if (notes != null) params['p_notes'] = notes;
      if (cashLocationId != null) params['p_cash_location_id'] = cashLocationId;
      if (customerId != null) params['p_customer_id'] = customerId;

      print('📤 [RPC] Full params: ${jsonEncode(params)}');
      print('🔄 [RPC] Calling inventory_create_invoice_v5...');

      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_create_invoice_v5',
        params: params,
      );

      print('📥 [RPC] Response: ${jsonEncode(response)}');

      // v5: Log warnings if present
      if (response['warnings'] != null && (response['warnings'] as List).isNotEmpty) {
        print('⚠️ [RPC] Warnings: ${response['warnings']}');
      }

      print('✅ [RPC] createInvoice() SUCCESS');

      return response;
    } on PostgrestException catch (e) {
      print('❌ [RPC] PostgrestException:');
      print('   code: ${e.code}');
      print('   message: ${e.message}');
      print('   details: ${e.details}');
      print('   hint: ${e.hint}');

      throw PaymentNetworkException(
        'Failed to create invoice: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      print('💥 [RPC] Exception: $e');
      print('📚 [RPC] StackTrace: $stackTrace');

      if (e is PaymentException) rethrow;
      throw PaymentDataException(
        'Failed to process invoice creation: $e',
        originalError: e,
      );
    }
  }
}
