/**
 * IJournalRepository Interface
 * Repository interface for journal entry operations
 */

export interface JournalLine {
  account_id: string;
  description: string;
  debit: number;
  credit: number;
  cash?: { cash_location_id: string };
}

export interface InsertJournalParams {
  baseAmount: number;
  companyId: string;
  createdBy: string;
  description: string;
  entryDateUtc: string;
  lines: JournalLine[];
  storeId: string;
  counterpartyId?: string | null;
  ifCashLocationId?: string | null;
}

export interface AccountIds {
  cash: string;
  errorAdjustment: string;
  foreignCurrencyTranslation: string;
}

export interface IJournalRepository {
  /**
   * Account IDs for journal entries
   */
  readonly accountIds: AccountIds;

  /**
   * Insert journal entry with all details
   */
  insertJournalWithEverything(params: InsertJournalParams): Promise<{ success: boolean; error?: string }>;
}
