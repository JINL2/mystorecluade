/**
 * JournalEntryModel
 * Data Transfer Object (DTO) and Mapper for JournalEntry entity
 * Handles conversion between database format and domain entity
 */

import { JournalEntry, JournalLine } from '../../domain/entities/JournalEntry';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class JournalEntryModel {
  /**
   * Convert raw database JSON to JournalEntry domain entity
   */
  static fromJson(json: any): JournalEntry {
    // Map journal lines from database format
    const lines: JournalLine[] = (json.lines || []).map((line: any) => ({
      lineId: line.line_id,
      accountId: line.account_id,
      accountName: line.account_name || '',
      accountType: line.account_type || '',
      debit: line.debit || 0,
      credit: line.credit || 0,
      isDebit: line.is_debit || false,
      description: line.description || '',
      counterparty: line.counterparty || null,
      cashLocation: line.cash_location || null,
      displayLocation: line.display_location || '',
      displayCounterparty: line.display_counterparty || '',
    }));

    // Convert UTC timestamps from DB to local time
    const entryDate = json.entry_date
      ? DateTimeUtils.toLocal(json.entry_date).toISOString()
      : '';
    const createdAt = json.created_at
      ? DateTimeUtils.toLocal(json.created_at).toISOString()
      : '';

    return new JournalEntry(
      json.journal_id,
      json.journal_number,
      entryDate,
      createdAt,
      json.description || '',
      json.journal_type || '',
      json.is_draft || false,
      json.store_id || null,
      json.store_name || null,
      json.store_code || null,
      json.created_by,
      json.created_by_name || 'System',
      json.currency_code || '',
      json.currency_symbol || '',
      json.total_debit || 0,
      json.total_credit || 0,
      json.total_amount || 0,
      lines
    );
  }

  /**
   * Convert JournalEntry domain entity to database JSON format
   */
  static toJson(journalEntry: JournalEntry): any {
    return {
      journal_id: journalEntry.journalId,
      journal_number: journalEntry.journalNumber,
      entry_date: journalEntry.entryDate,
      created_at: journalEntry.createdAt,
      description: journalEntry.description,
      journal_type: journalEntry.journalType,
      is_draft: journalEntry.isDraft,
      store_id: journalEntry.storeId,
      store_name: journalEntry.storeName,
      store_code: journalEntry.storeCode,
      created_by: journalEntry.createdBy,
      created_by_name: journalEntry.createdByName,
      currency_code: journalEntry.currencyCode,
      currency_symbol: journalEntry.currencySymbol,
      total_debit: journalEntry.totalDebit,
      total_credit: journalEntry.totalCredit,
      total_amount: journalEntry.totalAmount,
      lines: journalEntry.lines.map((line) => ({
        line_id: line.lineId,
        account_id: line.accountId,
        account_name: line.accountName,
        account_type: line.accountType,
        debit: line.debit,
        credit: line.credit,
        is_debit: line.isDebit,
        description: line.description,
        counterparty: line.counterparty,
        cash_location: line.cashLocation,
        display_location: line.displayLocation,
        display_counterparty: line.displayCounterparty,
      })),
    };
  }

  /**
   * Convert array of raw database JSON to array of JournalEntry entities
   * with sorting by created_at descending (newest first)
   */
  static fromJsonArray(jsonArray: any[]): JournalEntry[] {
    const journalEntries = jsonArray.map((json) => JournalEntryModel.fromJson(json));

    // Sort by created_at descending (newest first)
    journalEntries.sort((a, b) => {
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });

    return journalEntries;
  }
}
