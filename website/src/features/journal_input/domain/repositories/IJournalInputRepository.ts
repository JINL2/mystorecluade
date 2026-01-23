/**
 * IJournalInputRepository Interface
 * Repository interface for journal input operations
 */

import { JournalEntry } from '../entities/JournalEntry';

export interface Account {
  accountId: string;
  accountName: string;
  categoryTag: string;
  accountType?: string;
  expenseNature?: string;
}

export interface CashLocation {
  locationId: string;
  locationName: string;
  locationType: string;
  storeId?: string | null;
  isCompanyWide?: boolean;
}

export interface Counterparty {
  counterpartyId: string;
  counterpartyName: string;
  type?: string;
  isInternal: boolean;
  email?: string;
  phone?: string;
  linkedCompanyId?: string | null; // For internal counterparties linked to another company
}

export interface JournalSubmitResult {
  success: boolean;
  error?: string;
  journalId?: string;
}

export interface AccountMapping {
  myAccountId: string;
  linkedAccountId: string;
  direction: string;
}

export interface CounterpartyStore {
  storeId: string;
  storeName: string;
}

/**
 * Transaction Template interface
 * Represents a reusable journal entry template
 */
export interface TransactionTemplate {
  templateId: string;
  name: string;
  description: string | null;
  data: any; // Template data with transaction lines
  tags: string[] | null;
  visibilityLevel: 'public' | 'private';
  requiredAttachment: boolean;
  counterpartyId: string | null;
  counterpartyCashLocationId: string | null;
  createdAtUtc: string;
}

export interface IJournalInputRepository {
  /**
   * Get chart of accounts for company
   */
  getAccounts(companyId: string): Promise<Account[]>;

  /**
   * Get cash locations for company and store
   */
  getCashLocations(companyId: string, storeId?: string | null): Promise<CashLocation[]>;

  /**
   * Get counterparties for company
   */
  getCounterparties(companyId: string): Promise<Counterparty[]>;

  /**
   * Check account mapping for internal transactions
   */
  checkAccountMapping(
    companyId: string,
    counterpartyId: string,
    accountId: string
  ): Promise<AccountMapping | null>;

  /**
   * Get stores for counterparty's linked company
   */
  getCounterpartyStores(linkedCompanyId: string): Promise<CounterpartyStore[]>;

  /**
   * Get transaction templates for company and store
   */
  getTransactionTemplates(
    companyId: string,
    storeId: string,
    userId: string
  ): Promise<TransactionTemplate[]>;

  /**
   * Submit journal entry
   */
  submitJournalEntry(
    entry: JournalEntry,
    createdBy: string,
    description?: string
  ): Promise<JournalSubmitResult>;
}
