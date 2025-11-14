/**
 * JournalHistoryRepositoryImpl
 * Implementation of IJournalHistoryRepository interface
 */

import {
  IJournalHistoryRepository,
  JournalHistoryResult,
} from '../../domain/repositories/IJournalHistoryRepository';
import { TransactionHistoryDataSource } from '../datasources/TransactionHistoryDataSource';
import { JournalEntryModel } from '../models/JournalEntryModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

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
      // Convert date-only strings to UTC datetime for RPC call
      // Date format: YYYY-MM-DD → YYYY-MM-DDT00:00:00Z
      const utcStartDate = startDate
        ? DateTimeUtils.toRpcFormat(new Date(startDate + 'T00:00:00'))
        : '';
      const utcEndDate = endDate
        ? DateTimeUtils.toRpcFormat(new Date(endDate + 'T23:59:59'))
        : '';

      const data = await this.dataSource.getTransactions(
        companyId,
        storeId,
        utcStartDate,
        utcEndDate,
        accountId
      );

      // Use JournalEntryModel to convert and sort journal entries
      const journalEntries = JournalEntryModel.fromJsonArray(data);

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

// Singleton instance for dependency injection
export const journalHistoryRepository = new JournalHistoryRepositoryImpl();
