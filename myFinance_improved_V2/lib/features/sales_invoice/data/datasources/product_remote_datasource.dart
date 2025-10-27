import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/invoice_exceptions.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/cash_location_model.dart';
import '../models/product_list_response_model.dart';

/// Product remote data source for sales invoice
class ProductRemoteDataSource {
  final SupabaseClient _client;

  ProductRemoteDataSource(this._client);

  /// Get products for sales
  Future<ProductListResponseModel> getProductsForSales({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'getInventoryProductListCompany',
        params: {
          'p_company_id': companyId,
        },
      );

      return ProductListResponseModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load products: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse product data: $e',
        originalError: e,
      );
    }
  }

  /// Get currency data
  Future<Map<String, dynamic>> getCurrencyData({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_currency_data',
        params: {
          'p_company_id': companyId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load currency data: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse currency data: $e',
        originalError: e,
      );
    }
  }

  /// Get cash locations
  Future<List<CashLocationModel>> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client
          .from('cash_locations')
          .select()
          .eq('company_id', companyId)
          .or('store_id.eq.$storeId,is_company_wide.eq.true');

      return (response as List)
          .map((e) => CashLocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load cash locations: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
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
        'get_exchange_rates',
        params: {
          'p_company_id': companyId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load exchange rates: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse exchange rate data: $e',
        originalError: e,
      );
    }
  }

  /// Create invoice
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
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_create_invoice',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_user_id': userId,
          'p_sale_date': DateTimeUtils.toUtc(saleDate),
          'p_items': items.map((item) => item.toJson()).toList(),
          'p_payment_method': paymentMethod,
          if (discountAmount != null) 'p_discount_amount': discountAmount,
          if (taxRate != null) 'p_tax_rate': taxRate,
          if (notes != null) 'p_notes': notes,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to create invoice: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to process invoice creation: $e',
        originalError: e,
      );
    }
  }
}
