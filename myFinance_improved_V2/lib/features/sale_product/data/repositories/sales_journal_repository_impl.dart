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
  Future<String?> createSalesJournalEntry({
    required String companyId,
    required String storeId,
    required String userId,
    required double amount,
    required String description,
    required String lineDescription,
    required String cashLocationId,
    required String cashAccountId,
    required String salesAccountId,
    required String cogsAccountId,
    required String inventoryAccountId,
    required double totalCost,
    required String invoiceId,
  }) async {
    final entryDate = DateTimeUtils.toRpcFormat(DateTime.now());

    // ============================================================
    // RPC Call 1: Cash Sales Journal Entry
    // Debit: Cash (increase cash asset)
    // Credit: Sales Revenue (increase revenue)
    // ============================================================
    final salesJournalLines = [
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

    final salesJournalParams = {
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_time': entryDate,
      'p_description': description,
      'p_lines': salesJournalLines,
      'p_created_by': userId,
      'p_counterparty_id': null,
      'p_if_cash_location_id': null,
      'p_invoice_id': invoiceId,
      'p_base_amount': amount,
      'p_timezone': DateTimeUtils.getLocalTimezone(),
    };

    final salesJournalResult = await _client.rpc<dynamic>(
      'insert_journal_with_everything_v2',
      params: salesJournalParams,
    );

    // Extract journal_id from result (RPC returns the journal_id as string)
    String? journalId;
    if (salesJournalResult != null) {
      journalId = salesJournalResult.toString();
    }

    // ============================================================
    // RPC Call 2: COGS Journal Entry (only if totalCost > 0)
    // Debit: COGS (increase expense - cost of goods sold)
    // Credit: Inventory (decrease asset - inventory reduced)
    // ============================================================
    if (totalCost > 0) {
      final cogsJournalLines = [
        {
          'account_id': cogsAccountId,
          'description': lineDescription,
          'debit': totalCost.toString(),
          'credit': '0',
        },
        {
          'account_id': inventoryAccountId,
          'description': lineDescription,
          'debit': '0',
          'credit': totalCost.toString(),
        },
      ];

      final cogsJournalParams = {
        'p_company_id': companyId,
        'p_store_id': storeId,
        'p_time': entryDate,
        'p_description': 'COGS - $description',
        'p_lines': cogsJournalLines,
        'p_created_by': userId,
        'p_counterparty_id': null,
        'p_if_cash_location_id': null,
        'p_invoice_id': invoiceId,
        'p_base_amount': totalCost,
        'p_timezone': DateTimeUtils.getLocalTimezone(),
      };

      await _client.rpc<dynamic>(
        'insert_journal_with_everything_v2',
        params: cogsJournalParams,
      );
    }

    return journalId;
  }
}
