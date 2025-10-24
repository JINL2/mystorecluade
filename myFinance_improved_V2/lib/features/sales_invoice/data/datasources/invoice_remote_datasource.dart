import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/invoice_exceptions.dart';
import '../../domain/value_objects/invoice_filter.dart';
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

      final response = await _client.rpc<Map<String, dynamic>>('get_invoice_page', params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_page': filter.page,
        'p_limit': filter.limit,
        'p_search': filter.searchQuery,
        'p_start_date': dateRange.startDate != null ? DateTimeUtils.toUtc(dateRange.startDate!) : null,
        'p_end_date': dateRange.endDate != null ? DateTimeUtils.toUtc(dateRange.endDate!) : null,
      });

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

  /// Refund invoice
  Future<Map<String, dynamic>> refundInvoice({
    required String invoiceId,
    required String userId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'refund_invoice',
        params: {
          'p_invoice_id': invoiceId,
          'p_user_id': userId,
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
}
