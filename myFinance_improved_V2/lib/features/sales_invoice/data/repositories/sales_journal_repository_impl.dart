import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/sales_journal_repository.dart';

/// Sales Journal Repository Implementation
///
/// Implements the SalesJournalRepository interface using Supabase RPC.
/// Account IDs are now received from Domain layer via UseCase.
class SalesJournalRepositoryImpl implements SalesJournalRepository {
  final SupabaseClient _client;

  SalesJournalRepositoryImpl(this._client);

  @override
  Future<void> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required String cashAccountId,
    required String salesAccountId,
  }) async {
    // Prepare journal lines for cash sales
    final journalLines = [
      {
        'account_id': cashAccountId,
        'description': lineDescription,
        'debit': amount,
        'credit': 0.0,
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': salesAccountId,
        'description': lineDescription,
        'debit': 0.0,
        'credit': amount,
      },
    ];

    // Prepare journal params
    final journalParams = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date_utc': DateTime.now().toUtc().toIso8601String(),
      'p_lines': journalLines,
      'p_store_id': storeId,
    };

    // Call journal RPC
    await _client.rpc<Map<String, dynamic>>(
      'insert_journal_with_everything_utc',
      params: journalParams,
    );
  }
}
