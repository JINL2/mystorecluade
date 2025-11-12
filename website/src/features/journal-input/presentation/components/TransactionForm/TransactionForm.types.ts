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

  /**
   * Initial data for editing (optional)
   */
  initialData?: TransactionFormData;

  /**
   * Whether this is edit mode
   */
  isEditMode?: boolean;

  /**
   * Cash location ID that is already used in another transaction
   * This cash location should not be selectable in the dropdown
   */
  disabledCashLocationId?: string | null;

  /**
   * Repository for account mapping validation
   */
  onCheckAccountMapping?: (companyId: string, counterpartyId: string, accountId: string) => Promise<boolean>;

  /**
   * Callback to get counterparty stores
   */
  onGetCounterpartyStores?: (linkedCompanyId: string) => Promise<Array<{ storeId: string; storeName: string }>>;

  /**
   * Callback to get counterparty cash locations
   */
  onGetCounterpartyCashLocations?: (linkedCompanyId: string, storeId?: string | null) => Promise<CashLocation[]>;

  /**
   * Callback when form validation state changes
   */
  onValidationChange?: (isValid: boolean) => void;
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
  // Counterparty-related fields (for internal counterparties)
  counterpartyStoreId?: string;
  counterpartyCashLocationId?: string;
  // Debt-related fields (for payable/receivable accounts)
  debtCategory?: string;
  interestRate?: number;
  interestAccountId?: string;
  interestDueDay?: number;
  issueDate?: string; // ISO date string (yyyy-MM-dd)
  dueDate?: string; // ISO date string (yyyy-MM-dd)
  debtDescription?: string;
}

// Re-export types for convenience
export type { Account, CashLocation, Counterparty };
