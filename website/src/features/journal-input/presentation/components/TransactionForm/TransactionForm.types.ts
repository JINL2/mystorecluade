/**
 * TransactionForm Component Types
 */

import type { Account, CashLocation, Counterparty } from '../../../domain/repositories/IJournalInputRepository';

export interface TransactionFormProps {
  /**
   * Whether transaction is debit or credit
   */
  isDebit: boolean;

  /**
   * Callback when form is submitted
   */
  onSubmit: (transaction: TransactionFormData) => void;

  /**
   * Callback when form is cancelled
   */
  onCancel: () => void;

  /**
   * Available accounts
   */
  accounts: Account[];

  /**
   * Available cash locations
   */
  cashLocations: CashLocation[];

  /**
   * Available counterparties
   */
  counterparties: Counterparty[];

  /**
   * Company ID
   */
  companyId: string;

  /**
   * Store ID (optional)
   */
  storeId?: string | null;

  /**
   * Suggested amount (usually the difference to balance the journal)
   */
  suggestedAmount?: number;
}

export interface TransactionFormData {
  accountId: string;
  accountName: string;
  categoryTag?: string;
  amount: number;
  description?: string;
  isDebit: boolean;
  cashLocationId?: string;
  counterpartyId?: string;
}

// Re-export types for convenience
export type { Account, CashLocation, Counterparty };
