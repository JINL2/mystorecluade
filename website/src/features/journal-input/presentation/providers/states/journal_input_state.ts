/**
 * JournalInput Store Types
 * State interface definitions for journal input feature
 */

import type { JournalEntry } from '../../domain/entities/JournalEntry';
import type { TransactionLine } from '../../domain/entities/TransactionLine';
import type {
  Account,
  CashLocation,
  Counterparty,
  CounterpartyStore,
} from '../../domain/repositories/IJournalInputRepository';

/**
 * Journal Input State Interface
 * All state and actions for journal input feature
 */
export interface JournalInputState {
  // Core State
  journalEntry: JournalEntry;
  companyId: string;
  storeId: string | null;
  userId: string;

  // Reference Data
  accounts: Account[];
  cashLocations: CashLocation[];
  counterparties: Counterparty[];

  // Loading States
  loading: boolean;
  submitting: boolean;
  error: string | null;

  // Actions - State Management
  setJournalEntry: (entry: JournalEntry) => void;
  setAccounts: (accounts: Account[]) => void;
  setCashLocations: (locations: CashLocation[]) => void;
  setCounterparties: (counterparties: Counterparty[]) => void;

  // Actions - Transaction Operations
  addTransactionLine: (line: TransactionLine) => void;
  updateTransactionLine: (index: number, line: TransactionLine) => void;
  removeTransactionLine: (index: number) => void;

  // Actions - Journal Operations
  changeJournalDate: (date: string) => void;
  resetJournalEntry: (newStoreId: string | null) => void;

  // Async Actions - Data Loading
  loadInitialData: () => Promise<void>;
  submitJournalEntry: (description?: string) => Promise<{ success: boolean; error?: string }>;

  // Async Actions - Counterparty Operations
  checkAccountMapping: (
    companyId: string,
    counterpartyId: string,
    accountId: string
  ) => Promise<boolean>;
  getCounterpartyStores: (linkedCompanyId: string) => Promise<CounterpartyStore[]>;
  getCounterpartyCashLocations: (
    linkedCompanyId: string,
    storeId?: string | null
  ) => Promise<CashLocation[]>;

  // Reset
  reset: () => void;
}
