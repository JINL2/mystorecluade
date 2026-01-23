/**
 * JournalRepositoryImpl
 * Repository implementation for journal entry operations
 */

import { cashEndingDataSource, ACCOUNT_IDS } from '../datasources/CashEndingDataSource';
import type {
  IJournalRepository,
  InsertJournalParams,
  AccountIds,
} from '../../domain/repositories/IJournalRepository';

export class JournalRepositoryImpl implements IJournalRepository {
  /**
   * Account IDs for journal entries
   */
  readonly accountIds: AccountIds = {
    cash: ACCOUNT_IDS.cash,
    errorAdjustment: ACCOUNT_IDS.errorAdjustment,
    foreignCurrencyTranslation: ACCOUNT_IDS.foreignCurrencyTranslation,
  };

  /**
   * Insert journal entry with all details
   */
  async insertJournalWithEverything(params: InsertJournalParams): Promise<{ success: boolean; error?: string }> {
    try {
      await cashEndingDataSource.insertJournal({
        baseAmount: params.baseAmount,
        companyId: params.companyId,
        createdBy: params.createdBy,
        description: params.description,
        entryDateUtc: params.entryDateUtc,
        lines: params.lines,
        storeId: params.storeId,
      });

      return { success: true };
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : 'Unknown error';
      return { success: false, error: errMsg };
    }
  }
}

export const journalRepository = new JournalRepositoryImpl();
