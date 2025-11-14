/**
 * Excel Tab State Interface
 * State definitions for Excel-like journal entry input
 */

import type {
  Account,
  CashLocation,
  Counterparty,
  CounterpartyStore,
} from '../../../domain/repositories/IJournalInputRepository';

/**
 * Row data structure for Excel tab
 */
export interface ExcelRowData {
  id: number;
  date: string;
  accountId: string;
  locationId: string;
  internalId: string;
  externalId: string;
  detail: string;
  debit: string;
  credit: string;
  counterpartyStoreId: string;
  counterpartyCashLocationId: string;
  debtCategory: string; // 'note', 'account', 'loan', or 'other'
}

/**
 * Modal state for counterparty cash location selection
 */
export interface CounterpartyModalData {
  counterpartyId: string;
  counterpartyName: string;
  linkedCompanyId: string;
}

/**
 * Excel Tab State Interface
 * All state and actions for Excel tab component
 */
export interface ExcelTabState {
  // Row State
  rows: ExcelRowData[];
  nextId: number;

  // UI State
  submitting: boolean;
  showMappingWarning: boolean;
  mappingWarningMessage: string;

  // Modal State
  showCashLocationModal: boolean;
  selectedRowForModal: number | null;
  modalCounterpartyData: CounterpartyModalData | null;

  // Actions - Row Operations
  addRow: () => void;
  deleteRow: (rowId: number) => void;
  updateRowField: (rowId: number, field: keyof ExcelRowData, value: any) => void;
  clearCounterparty: (rowId: number, field: 'internalId' | 'externalId') => void;

  // Actions - Modal Operations
  openCashLocationModal: (rowId: number, data: CounterpartyModalData) => void;
  closeCashLocationModal: () => void;
  confirmCashLocationModal: (storeId: string, cashLocationId: string, debtCategory: string) => void;

  // Actions - Warning Operations
  showWarning: (message: string) => void;
  hideWarning: () => void;

  // Actions - Submit
  submitExcelEntry: (
    companyId: string,
    selectedStoreId: string | null,
    userId: string,
    accounts: Account[],
    counterparties: Counterparty[]
  ) => Promise<{ success: boolean; error?: string }>;

  // Reset
  reset: () => void;
}
