import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
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
    // Debit: Cash (increase cash)
    // Credit: Sales Revenue (increase revenue)
    final journalLines = [
      {
        'account_id': cashAccountId,
        'description': lineDescription,
        'debit': amount.toString(),
        'credit': '0',
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': salesAccountId,
        'description': lineDescription,
        'debit': '0',
        'credit': amount.toString(),
      },
    ];

    // Prepare journal params
    final journalParams = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date_utc': DateTimeUtils.toRpcFormat(DateTime.now()),
      'p_lines': journalLines,
      'p_store_id': storeId,
    };

    // Call journal RPC (response type varies, so we use dynamic)
    await _client.rpc<dynamic>(
      'insert_journal_with_everything_utc',
      params: journalParams,
    );
  }

  @override
  Future<void> createRefundJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    String? cashLocationId,
    required String cashAccountId,
    required String salesAccountId,
  }) async {
    // Prepare journal lines for refund (reverse of sales)
    // Debit: Sales Revenue (decrease revenue)
    // Credit: Cash (decrease cash)

    // Build cash line - conditionally include cash location if available
    final cashLine = <String, dynamic>{
      'account_id': cashAccountId,
      'description': lineDescription,
      'debit': '0',
      'credit': amount.toString(),
    };

    // Only add cash location info if provided
    if (cashLocationId != null && cashLocationId.isNotEmpty) {
      cashLine['cash'] = {
        'cash_location_id': cashLocationId,
      };
    }

    final journalLines = [
      {
        'account_id': salesAccountId,
        'description': lineDescription,
        'debit': amount.toString(),
        'credit': '0',
      },
      cashLine,
    ];

    // Prepare journal params
    final journalParams = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date_utc': DateTimeUtils.toRpcFormat(DateTime.now()),
      'p_lines': journalLines,
      'p_store_id': storeId,
    };

    // Call journal RPC (response type varies, so we use dynamic)
    await _client.rpc<dynamic>(
      'insert_journal_with_everything_utc',
      params: journalParams,
    );
  }
}
