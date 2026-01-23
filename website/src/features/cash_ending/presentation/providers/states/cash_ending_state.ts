/**
 * Cash Ending State Types
 * State definitions for Zustand provider
 */

import type { CashLocationEntity } from '../../../domain/entities/CashLocation';
import type { CurrencyEntity } from '../../../domain/entities/Currency';
import type { BalanceSummaryEntity } from '../../../domain/entities/BalanceSummary';

export type VaultTransactionType = 'in' | 'out' | 'recount';
export type AdjustmentType = 'error' | 'forex';

export interface SuccessModalData {
  submittedAmount: number;
  balanceSummary: BalanceSummaryEntity;
  locationName: string;
  locationType: string;
}

export interface CashEndingState {
  // Store & Location
  selectedStoreId: string | null;
  cashLocations: CashLocationEntity[];
  selectedLocationId: string;
  isLoadingLocations: boolean;

  // Currency & Denomination
  currencies: CurrencyEntity[];
  selectedCurrencyId: string;
  isLoadingCurrencies: boolean;
  denomQuantities: Record<string, number>;
  bankAmounts: Record<string, number>;

  // Vault
  vaultTransactionType: VaultTransactionType;

  // Balance
  balanceSummary: BalanceSummaryEntity | null;
  isLoadingBalance: boolean;
  isCompareExpanded: boolean;

  // Submit
  isSubmitting: boolean;

  // Adjustment
  isAdjusting: boolean;
  showAdjustmentConfirmModal: boolean;
  adjustmentType: AdjustmentType | null;

  // Modals
  showSuccessModal: boolean;
  showErrorModal: boolean;
  errorMessage: string;
  successModalData: SuccessModalData | null;
}

export interface CashEndingActions {
  // Store & Location
  setSelectedStoreId: (storeId: string | null) => void;
  setCashLocations: (locations: CashLocationEntity[]) => void;
  setSelectedLocationId: (locationId: string) => void;
  setIsLoadingLocations: (loading: boolean) => void;

  // Currency & Denomination
  setCurrencies: (currencies: CurrencyEntity[]) => void;
  setSelectedCurrencyId: (currencyId: string) => void;
  setIsLoadingCurrencies: (loading: boolean) => void;
  setDenomQuantity: (denominationId: string, quantity: number) => void;
  setBankAmount: (currencyId: string, amount: number) => void;
  resetAmounts: () => void;

  // Vault
  setVaultTransactionType: (type: VaultTransactionType) => void;

  // Balance
  setBalanceSummary: (summary: BalanceSummaryEntity | null) => void;
  setIsLoadingBalance: (loading: boolean) => void;
  setIsCompareExpanded: (expanded: boolean) => void;

  // Submit
  setIsSubmitting: (submitting: boolean) => void;

  // Adjustment
  setIsAdjusting: (adjusting: boolean) => void;
  openAdjustmentConfirm: (type: AdjustmentType) => void;
  closeAdjustmentConfirm: () => void;

  // Modals
  setShowSuccessModal: (show: boolean) => void;
  setShowErrorModal: (show: boolean) => void;
  setErrorMessage: (message: string) => void;
  setSuccessModalData: (data: SuccessModalData | null) => void;

  // Reset
  resetLocationState: () => void;
  resetAll: () => void;
}

export type CashEndingStore = CashEndingState & CashEndingActions;
