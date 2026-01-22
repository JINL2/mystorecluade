/**
 * Cash Ending Zustand Provider
 * Centralized state management for cash ending page
 */

import { create } from 'zustand';
import type {
  CashEndingStore,
  CashEndingState,
  VaultTransactionType,
  AdjustmentType,
  SuccessModalData,
} from './states/cash_ending_state';
import type { CashLocationEntity } from '../../domain/entities/CashLocation';
import type { CurrencyEntity } from '../../domain/entities/Currency';
import type { BalanceSummaryEntity } from '../../domain/entities/BalanceSummary';

const initialState: CashEndingState = {
  // Store & Location
  selectedStoreId: null,
  cashLocations: [],
  selectedLocationId: '',
  isLoadingLocations: false,

  // Currency & Denomination
  currencies: [],
  selectedCurrencyId: '',
  isLoadingCurrencies: false,
  denomQuantities: {},
  bankAmounts: {},

  // Vault
  vaultTransactionType: 'recount',

  // Balance
  balanceSummary: null,
  isLoadingBalance: false,
  isCompareExpanded: true,

  // Submit
  isSubmitting: false,

  // Adjustment
  isAdjusting: false,
  showAdjustmentConfirmModal: false,
  adjustmentType: null,

  // Modals
  showSuccessModal: false,
  showErrorModal: false,
  errorMessage: '',
  successModalData: null,
};

export const useCashEndingStore = create<CashEndingStore>((set) => ({
  ...initialState,

  // Store & Location Actions
  setSelectedStoreId: (storeId: string | null) =>
    set({ selectedStoreId: storeId }),

  setCashLocations: (locations: CashLocationEntity[]) =>
    set({ cashLocations: locations }),

  setSelectedLocationId: (locationId: string) =>
    set({ selectedLocationId: locationId }),

  setIsLoadingLocations: (loading: boolean) =>
    set({ isLoadingLocations: loading }),

  // Currency & Denomination Actions
  setCurrencies: (currencies: CurrencyEntity[]) =>
    set({ currencies }),

  setSelectedCurrencyId: (currencyId: string) =>
    set({ selectedCurrencyId: currencyId }),

  setIsLoadingCurrencies: (loading: boolean) =>
    set({ isLoadingCurrencies: loading }),

  setDenomQuantity: (denominationId: string, quantity: number) =>
    set((state) => ({
      denomQuantities: {
        ...state.denomQuantities,
        [denominationId]: Math.max(0, quantity),
      },
    })),

  setBankAmount: (currencyId: string, amount: number) =>
    set((state) => ({
      bankAmounts: {
        ...state.bankAmounts,
        [currencyId]: Math.max(0, amount),
      },
    })),

  resetAmounts: () =>
    set({ denomQuantities: {}, bankAmounts: {} }),

  // Vault Actions
  setVaultTransactionType: (type: VaultTransactionType) =>
    set({ vaultTransactionType: type }),

  // Balance Actions
  setBalanceSummary: (summary: BalanceSummaryEntity | null) =>
    set({ balanceSummary: summary }),

  setIsLoadingBalance: (loading: boolean) =>
    set({ isLoadingBalance: loading }),

  setIsCompareExpanded: (expanded: boolean) =>
    set({ isCompareExpanded: expanded }),

  // Submit Actions
  setIsSubmitting: (submitting: boolean) =>
    set({ isSubmitting: submitting }),

  // Adjustment Actions
  setIsAdjusting: (adjusting: boolean) =>
    set({ isAdjusting: adjusting }),

  openAdjustmentConfirm: (type: AdjustmentType) =>
    set({ adjustmentType: type, showAdjustmentConfirmModal: true }),

  closeAdjustmentConfirm: () =>
    set({ showAdjustmentConfirmModal: false, adjustmentType: null }),

  // Modal Actions
  setShowSuccessModal: (show: boolean) =>
    set({ showSuccessModal: show }),

  setShowErrorModal: (show: boolean) =>
    set({ showErrorModal: show }),

  setErrorMessage: (message: string) =>
    set({ errorMessage: message }),

  setSuccessModalData: (data: SuccessModalData | null) =>
    set({ successModalData: data }),

  // Reset Actions
  resetLocationState: () =>
    set({
      selectedLocationId: '',
      currencies: [],
      selectedCurrencyId: '',
      denomQuantities: {},
      bankAmounts: {},
      balanceSummary: null,
      vaultTransactionType: 'recount',
    }),

  resetAll: () => set(initialState),
}));
