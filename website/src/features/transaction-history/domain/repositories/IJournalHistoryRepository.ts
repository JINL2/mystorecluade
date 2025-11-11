/**
 * IJournalHistoryRepository
 * Repository interface for journal entry history operations
 */

import { JournalEntry } from '../entities/JournalEntry';

export interface JournalHistoryResult {
  success: boolean;
  data?: JournalEntry[];
  error?: string;
}

export interface IJournalHistoryRepository {
  getJournalEntries(
    companyId: string,
    storeId: string | null,
    startDate: string | null,
    endDate: string | null,
    accountId?: string | null
  ): Promise<JournalHistoryResult>;
}
