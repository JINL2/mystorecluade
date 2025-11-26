import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

/// Remote data source for journal entry operations
/// Handles communication with Supabase for journal-related data
class JournalRemoteDataSource {
  final SupabaseClient _supabase;

  JournalRemoteDataSource({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Insert journal entry with all details via Supabase RPC
  ///
  /// This calls the 'insert_journal_with_everything' RPC function
  /// which creates a complete journal entry with header and lines
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  }) async {
    try {
      final response = await _supabase.rpc(
        'insert_journal_with_everything_utc',
        params: {
          'p_base_amount': baseAmount,
          'p_company_id': companyId,
          'p_created_by': createdBy,
          'p_description': description,
          'p_entry_date_utc': entryDate,
          'p_lines': lines,
          'p_counterparty_id': counterpartyId,
          'p_if_cash_location_id': ifCashLocationId,
          'p_store_id': storeId,
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Journal insert operation timed out');
        },
      );

      if (response == null) {
        throw Exception('Failed to insert journal entry: No response from server');
      }

      // Handle response based on type
      if (response is Map<String, dynamic>) {
        return response;
      } else if (response is String) {
        // If RPC returns a string (e.g., journal_id), wrap it
        return {'journal_id': response, 'status': 'success'};
      } else {
        // For other types, return a generic success response
        return {'data': response, 'status': 'success'};
      }
    } catch (e) {
      throw Exception('Failed to insert journal entry: $e');
    }
  }
}
