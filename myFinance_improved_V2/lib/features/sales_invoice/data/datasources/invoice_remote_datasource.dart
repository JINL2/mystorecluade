import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/exceptions/invoice_exceptions.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../models/cash_location_model.dart';
import '../models/invoice_detail_model.dart';
import '../models/invoice_page_response_model.dart';

/// Invoice remote data source
class InvoiceRemoteDataSource {
  final SupabaseClient _client;

  InvoiceRemoteDataSource(this._client);

  /// Get invoices with filters
  Future<InvoicePageResponseModel> getInvoices({
    required String companyId,
    required String storeId,
    required InvoiceFilter filter,
  }) async {
    try {
      final dateRange = filter.period.getDateRange();

      final response = await _client.rpc<Map<String, dynamic>>('get_invoice_page_v3', params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': filter.page,
        'p_limit': filter.limit,
        'p_search': filter.searchQuery,
        'p_start_date': dateRange.startDate?.toIso8601String().split('T').first,
        'p_end_date': dateRange.endDate?.toIso8601String().split('T').first,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
        'p_date_filter': filter.dateFilter,
        'p_amount_filter': filter.amountFilter,
      },);

      return InvoicePageResponseModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load invoices: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse invoice data: $e',
        originalError: e,
      );
    }
  }

  /// Refund invoice(s)
  ///
  /// Calls the `inventory_refund_invoice_v4` RPC function
  /// v4 uses timestamptz, supports inventory_logs, and full variant support
  Future<Map<String, dynamic>> refundInvoice({
    required List<String> invoiceIds,
    required String userId,
    String? notes,
  }) async {
    try {
      // v4 uses timestamptz - send ISO 8601 format with timezone
      final refundDate = DateTime.now().toIso8601String();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'inventory_refund_invoice_v4',
        params: {
          'p_invoice_ids': invoiceIds,
          'p_refund_date': refundDate,
          'p_notes': notes,
          'p_created_by': userId,
          'p_timezone': timezone,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to refund invoice: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to process refund: $e',
        originalError: e,
      );
    }
  }

  /// Get cash locations for filtering
  ///
  /// Calls the `get_cash_locations_v2` RPC function
  /// Note: RPC returns List directly, not a wrapper object
  Future<List<CashLocation>> getCashLocations({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );

      return response
          .map((json) => CashLocationModel.fromJson(json as Map<String, dynamic>).toEntity())
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
        'Failed to parse cash locations: $e',
        originalError: e,
      );
    }
  }

  /// Get invoice detail by ID
  ///
  /// Calls the `get_invoice_detail_v2` RPC function (with variant support)
  Future<InvoiceDetail> getInvoiceDetail({
    required String invoiceId,
    String? timezone,
  }) async {
    try {
      final tz = timezone ?? DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'get_invoice_detail_v2',
        params: {
          'p_invoice_id': invoiceId,
          'p_timezone': tz,
        },
      );

      // Check for success
      final success = response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Unknown error';
        final code = response['code'] as String? ?? 'UNKNOWN';
        throw InvoiceDataException(
          message,
          originalError: {'code': code, 'message': message},
        );
      }

      // Parse data
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw InvoiceDataException('Invoice detail data is null');
      }

      return InvoiceDetailModel.fromJson(data).toEntity();
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load invoice detail: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse invoice detail: $e',
        originalError: e,
      );
    }
  }
}
