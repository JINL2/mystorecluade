/**
 * JournalHistoryRepositoryImpl
 * Implementation of IJournalHistoryRepository interface
 */

import {
  IJournalHistoryRepository,
  JournalHistoryResult,
} from '../../domain/repositories/IJournalHistoryRepository';
import { JournalEntry, JournalLine } from '../../domain/entities/JournalEntry';
import { TransactionHistoryDataSource } from '../datasources/TransactionHistoryDataSource';

export class JournalHistoryRepositoryImpl implements IJournalHistoryRepository {
  private dataSource: TransactionHistoryDataSource;

  constructor() {
    this.dataSource = new TransactionHistoryDataSource();
  }

  async getJournalEntries(
    companyId: string,
    storeId: string | null,
    startDate: string | null,
    endDate: string | null,
    accountId?: string | null
  ): Promise<JournalHistoryResult> {
    try {
      const data = await this.dataSource.getTransactions(
        companyId,
        storeId,
        startDate || '',
        endDate || '',
        accountId
      );

      const journalEntries: JournalEntry[] = data.map((journal: any) => {
        // Map journal lines
        const lines: JournalLine[] = (journal.lines || []).map((line: any) => ({
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

        return new JournalEntry(
          journal.journal_id,
          journal.journal_number,
          journal.entry_date,
          journal.created_at,
          journal.description || '',
          journal.journal_type || '',
          journal.is_draft || false,
          journal.store_id || null,
          journal.store_name || null,
          journal.store_code || null,
          journal.created_by,
          journal.created_by_name || 'System',
          journal.currency_code || '',
          journal.currency_symbol || '',
          journal.total_debit || 0,
          journal.total_credit || 0,
          journal.total_amount || 0,
          lines
        );
      });

      // Sort by created_at descending (newest first)
      journalEntries.sort((a, b) => {
        return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
      });

      return {
        success: true,
        data: journalEntries,
      };
    } catch (error) {
      console.error('Repository error fetching journal entries:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch journal entries',
      };
    }
  }
}
