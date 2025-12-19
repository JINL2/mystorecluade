/**
 * Excel Tab Zustand Store
 * Centralized state management for Excel-like journal entry input
 */

import { create } from 'zustand';
import type { ExcelTabState, ExcelRowData, CounterpartyModalData } from './states/excel_tab_state';
import { JournalInputRepositoryImpl } from '../../data/repositories/JournalInputRepositoryImpl';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { TransactionLine } from '../../domain/entities/TransactionLine';
import { JournalDate } from '../../domain/value-objects/JournalDate';

const repository = new JournalInputRepositoryImpl();

// Initial row template
const createEmptyRow = (id: number): ExcelRowData => ({
  id,
  date: '',
  accountId: '',
  locationId: '',
  internalId: '',
  externalId: '',
  detail: '',
  debit: '',
  credit: '',
  counterpartyStoreId: '',
  counterpartyCashLocationId: '',
  debtCategory: '',
});

export const useExcelTabStore = create<ExcelTabState>((set, get) => ({
  // Initial State
  rows: [createEmptyRow(1), createEmptyRow(2)],
  nextId: 3,

  // UI State
  submitting: false,
  showMappingWarning: false,
  mappingWarningMessage: '',

  // Modal State
  showCashLocationModal: false,
  selectedRowForModal: null,
  modalCounterpartyData: null,

  // Actions - Row Operations
  addRow: () => {
    const state = get();
    set({
      rows: [...state.rows, createEmptyRow(state.nextId)],
      nextId: state.nextId + 1,
    });
  },

  deleteRow: (rowId) => {
    const state = get();
    if (state.rows.length <= 2) return; // Minimum 2 rows required
    set({
      rows: state.rows.filter((row) => row.id !== rowId),
    });
  },

  updateRowField: (rowId, field, value) => {
    const state = get();
    set({
      rows: state.rows.map((row, index) => {
        if (row.id === rowId) {
          const updated = { ...row, [field]: value };

          // If account is changed, reset all fields except date
          if (field === 'accountId') {
            updated.locationId = '';
            updated.internalId = '';
            updated.externalId = '';
            updated.detail = '';
            updated.debit = '';
            updated.credit = '';
            updated.counterpartyStoreId = '';
            updated.counterpartyCashLocationId = '';
            updated.debtCategory = '';
          }

          // If internal is selected, clear external
          if (field === 'internalId' && value) {
            updated.externalId = '';
            updated.counterpartyStoreId = '';
            updated.counterpartyCashLocationId = '';
            updated.debtCategory = '';
          }
          // If external is selected, clear internal and counterparty cash location
          if (field === 'externalId' && value) {
            updated.internalId = '';
            updated.counterpartyStoreId = '';
            updated.counterpartyCashLocationId = '';
            updated.debtCategory = '';
          }

          return updated;
        }

        // Date synchronization logic for first two rows
        if (field === 'date' && value) {
          // If date is set on first row (index 0) and second row (index 1) has no date, copy it
          if (rowId === 1 && index === 1 && !row.date) {
            return { ...row, date: value };
          }
          // If date is set on second row (index 1) and first row (index 0) has no date, copy it
          if (rowId === 2 && index === 0 && !row.date) {
            return { ...row, date: value };
          }
        }

        return row;
      }),
    });
  },

  clearCounterparty: (rowId, field) => {
    get().updateRowField(rowId, field, '');
  },

  // Actions - Modal Operations
  openCashLocationModal: (rowId, data) => {
    set({
      selectedRowForModal: rowId,
      modalCounterpartyData: data,
      showCashLocationModal: true,
    });
  },

  closeCashLocationModal: () => {
    set({
      showCashLocationModal: false,
      selectedRowForModal: null,
      modalCounterpartyData: null,
    });
  },

  confirmCashLocationModal: (storeId, cashLocationId, debtCategory) => {
    const state = get();
    if (state.selectedRowForModal !== null && state.modalCounterpartyData) {
      set({
        rows: state.rows.map((row) =>
          row.id === state.selectedRowForModal
            ? {
                ...row,
                internalId: state.modalCounterpartyData!.counterpartyId,
                externalId: '',
                counterpartyStoreId: storeId,
                counterpartyCashLocationId: cashLocationId,
                debtCategory: debtCategory,
              }
            : row
        ),
        showCashLocationModal: false,
        selectedRowForModal: null,
        modalCounterpartyData: null,
      });
    }
  },

  // Actions - Warning Operations
  showWarning: (message) => {
    set({
      showMappingWarning: true,
      mappingWarningMessage: message,
    });
  },

  hideWarning: () => {
    set({
      showMappingWarning: false,
      mappingWarningMessage: '',
    });
  },

  // Actions - Submit
  submitExcelEntry: async (companyId, selectedStoreId, selectedDate, userId, accounts, counterparties) => {
    const state = get();

    // Validate date
    if (!selectedDate) {
      return { success: false, error: 'Date must be selected' };
    }

    // Validate form
    const { isValid, error } = validateExcelForm(state.rows, accounts);
    if (!isValid) {
      return { success: false, error };
    }

    set({ submitting: true });

    try {
      // Transform rows to transaction lines
      const transactionLines: TransactionLine[] = state.rows.map((row) => {
        const account = accounts.find((acc) => acc.accountId === row.accountId);
        const debitValue = parseFloat(row.debit.replace(/,/g, '')) || 0;
        const creditValue = parseFloat(row.credit.replace(/,/g, '')) || 0;
        const amount = debitValue > 0 ? debitValue : creditValue;
        const isDebit = debitValue > 0;

        // Find counterparty data
        const counterpartyId = row.internalId || row.externalId || null;
        const counterparty = counterpartyId
          ? counterparties.find((cp) => cp.counterpartyId === counterpartyId)
          : null;

        // Use debt category from row (selected by user in modal)
        // Only use it if counterparty exists
        let debtCategory = null;
        if (counterpartyId && row.debtCategory) {
          debtCategory = row.debtCategory;
        }

        return new TransactionLine(
          isDebit,
          row.accountId,
          account?.accountName || '', // accountName
          amount,
          row.detail || '',
          account?.categoryTag || null, // categoryTag
          row.locationId || null, // cashLocationId
          null, // cashLocationName
          null, // cashLocationType
          counterpartyId,
          counterparty?.counterpartyName || null, // counterpartyName
          row.counterpartyStoreId || null,
          null, // counterpartyStoreName
          debtCategory,
          null, // interestRate
          null, // interestAccountId
          null, // interestDueDay
          selectedDate, // issueDate (shared date field)
          null, // dueDate
          null, // debtDescription
          counterparty?.linkedCompanyId || null,
          row.counterpartyCashLocationId || null
        );
      });

      // Create JournalEntry entity
      const journalEntry = new JournalEntry(
        companyId,
        selectedStoreId,
        selectedDate, // Use shared date field
        transactionLines
      );

      // Submit through repository
      const result = await repository.submitJournalEntry(
        journalEntry,
        userId,
        'Excel journal entry'
      );

      if (result.success) {
        // Reset form on success
        set({
          rows: [createEmptyRow(1), createEmptyRow(2)],
          nextId: 3,
          submitting: false,
        });
        return { success: true };
      } else {
        set({ submitting: false });
        return { success: false, error: result.error };
      }
    } catch (error) {
      set({ submitting: false });
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to submit journal entry',
      };
    }
  },

  // Actions - Template
  applyTemplateToRows: (templateData: any, amount?: number) => {
    if (!templateData) return;

    // Handle both array format (data is array) and object format (data.lines is array)
    let lines: any[] = [];

    if (Array.isArray(templateData)) {
      // Format 1: data is directly an array of lines
      lines = templateData;
    } else if (templateData.lines && Array.isArray(templateData.lines)) {
      // Format 2: data has a lines property
      lines = templateData.lines;
    } else {
      console.warn('Unknown template data format:', templateData);
      return;
    }

    if (lines.length === 0) return;

    // Convert template lines to Excel rows
    const newRows: ExcelRowData[] = lines.map((line: any, index: number) => {
      // Determine if debit or credit based on different possible formats
      let debitValue = '';
      let creditValue = '';

      // Use custom amount if provided, otherwise use template values
      const customAmount = amount ? String(amount) : null;

      // Format 1: type: 'debit' or 'credit'
      if (line.type === 'debit') {
        debitValue = customAmount || String(line.amount || line.debit || 0);
        creditValue = '';
      } else if (line.type === 'credit') {
        debitValue = '';
        creditValue = customAmount || String(line.amount || line.credit || 0);
      }
      // Format 2: debit/credit as numbers
      else if (line.debit && Number(line.debit) > 0) {
        debitValue = customAmount || String(line.debit);
        creditValue = '';
      } else if (line.credit && Number(line.credit) > 0) {
        debitValue = '';
        creditValue = customAmount || String(line.credit);
      }

      // Get cash location ID from different possible formats
      const cashLocationId = line.cash_location_id || line.cash?.cash_location_id || '';

      // Get counterparty ID
      const counterpartyId = line.counterparty_id || '';

      return {
        id: index + 1,
        date: '',
        accountId: line.account_id || '',
        locationId: cashLocationId,
        internalId: '', // Internal counterparty - needs to be determined from counterparty type
        externalId: '', // External counterparty - needs to be determined from counterparty type
        detail: line.description || '',
        debit: debitValue,
        credit: creditValue,
        counterpartyStoreId: '',
        counterpartyCashLocationId: line.counterparty_cash_location_id || '',
        debtCategory: '',
      };
    });

    // Ensure minimum 2 rows
    while (newRows.length < 2) {
      newRows.push(createEmptyRow(newRows.length + 1));
    }

    set({
      rows: newRows,
      nextId: newRows.length + 1,
    });
  },

  // Reset
  reset: () => {
    set({
      rows: [createEmptyRow(1), createEmptyRow(2)],
      nextId: 3,
      submitting: false,
      showMappingWarning: false,
      mappingWarningMessage: '',
      showCashLocationModal: false,
      selectedRowForModal: null,
      modalCounterpartyData: null,
    });
  },
}));

// Helper functions
function validateExcelForm(rows: ExcelRowData[], accounts: any[]) {
  // Calculate totals
  const totalDebit = rows.reduce((sum, row) => {
    const value = parseFloat(row.debit.replace(/,/g, '')) || 0;
    return sum + value;
  }, 0);

  const totalCredit = rows.reduce((sum, row) => {
    const value = parseFloat(row.credit.replace(/,/g, '')) || 0;
    return sum + value;
  }, 0);

  const difference = totalDebit - totalCredit;

  // Check difference is 0
  if (difference !== 0) {
    return { isValid: false, error: 'Debits and credits must be balanced' };
  }

  // Check each row
  for (const row of rows) {
    // Account must be selected
    if (!row.accountId) {
      return { isValid: false, error: 'All rows must have an account selected' };
    }

    // If Cash account, Location must be selected
    const account = accounts.find((acc) => acc.accountId === row.accountId);
    const isCashAccount = account && account.accountName.toLowerCase() === 'cash';
    if (isCashAccount && !row.locationId) {
      return { isValid: false, error: 'Cash accounts must have a location selected' };
    }

    // If Payable/Receivable account, either Internal or External must be selected
    const isPayableOrReceivable =
      account &&
      account.categoryTag &&
      (account.categoryTag.toLowerCase() === 'payable' ||
        account.categoryTag.toLowerCase() === 'receivable');
    if (isPayableOrReceivable && !row.internalId && !row.externalId) {
      return {
        isValid: false,
        error: 'Payable/Receivable accounts must have a counterparty selected',
      };
    }

    // If Internal counterparty is selected, debt category must be selected
    if (row.internalId && !row.debtCategory) {
      return {
        isValid: false,
        error: 'Internal counterparties must have a debt category selected',
      };
    }

    // Either Debit or Credit must have a value
    const debitValue = parseFloat(row.debit.replace(/,/g, '')) || 0;
    const creditValue = parseFloat(row.credit.replace(/,/g, '')) || 0;
    if (debitValue === 0 && creditValue === 0) {
      return { isValid: false, error: 'Each row must have either a debit or credit value' };
    }
  }

  return { isValid: true };
}
