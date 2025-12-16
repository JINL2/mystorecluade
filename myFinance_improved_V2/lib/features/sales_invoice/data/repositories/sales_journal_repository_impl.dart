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
    required String cogsAccountId,
    required String inventoryAccountId,
    required double totalCost,
  }) async {
    final entryDateUtc = DateTimeUtils.toRpcFormat(DateTime.now());

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
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date_utc': entryDateUtc,
      'p_lines': salesJournalLines,
      'p_store_id': storeId,
    };

    await _client.rpc<dynamic>(
      'insert_journal_with_everything_utc',
      params: salesJournalParams,
    );

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
        'p_base_amount': totalCost,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': 'COGS - $description',
        'p_entry_date_utc': entryDateUtc,
        'p_lines': cogsJournalLines,
        'p_store_id': storeId,
      };

      await _client.rpc<dynamic>(
        'insert_journal_with_everything_utc',
        params: cogsJournalParams,
      );
    }
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
    required String cogsAccountId,
    required String inventoryAccountId,
    required double totalCost,
    required String invoiceId,
  }) async {
    final entryDateUtc = DateTimeUtils.toRpcFormat(DateTime.now());

    // ============================================================
    // RPC Call 1: Sales Refund Journal Entry
    // Debit: Sales Revenue (decrease revenue)
    // Credit: Cash (decrease cash)
    // ============================================================

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

    final refundJournalLines = [
      {
        'account_id': salesAccountId,
        'description': lineDescription,
        'debit': amount.toString(),
        'credit': '0',
      },
      cashLine,
    ];

    final refundJournalParams = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_created_by': userId,
      'p_description': description,
      'p_entry_date_utc': entryDateUtc,
      'p_lines': refundJournalLines,
      'p_store_id': storeId,
      'p_invoice_id': invoiceId,
    };

    await _client.rpc<dynamic>(
      'insert_journal_with_everything_v2',
      params: refundJournalParams,
    );

    // ============================================================
    // RPC Call 2: COGS Reversal Journal Entry (only if totalCost > 0)
    // Debit: Inventory (increase asset - inventory restored)
    // Credit: COGS (decrease expense - cost reversed)
    // ============================================================
    if (totalCost > 0) {
      final cogsReversalLines = [
        {
          'account_id': inventoryAccountId,
          'description': lineDescription,
          'debit': totalCost.toString(),
          'credit': '0',
        },
        {
          'account_id': cogsAccountId,
          'description': lineDescription,
          'debit': '0',
          'credit': totalCost.toString(),
        },
      ];

      final cogsReversalParams = {
        'p_base_amount': totalCost,
        'p_company_id': companyId,
        'p_created_by': userId,
        'p_description': 'COGS Reversal - $description',
        'p_entry_date_utc': entryDateUtc,
        'p_lines': cogsReversalLines,
        'p_store_id': storeId,
        'p_invoice_id': invoiceId,
      };

      await _client.rpc<dynamic>(
        'insert_journal_with_everything_v2',
        params: cogsReversalParams,
      );
    }
  }
}
