/**
 * useTransactionFormState Hook
 * Manages all form state for TransactionForm component
 */

import { useState } from 'react';
import type { TransactionFormData } from '../TransactionForm.types';

export interface TransactionFormState {
  // Basic form fields
  isDebit: boolean;
  selectedAccountId: string;
  amount: string;
  description: string;
  selectedCashLocation: string;
  selectedCounterparty: string;

  // Counterparty-related state
  counterpartyStores: Array<{ storeId: string; storeName: string }>;
  selectedCounterpartyStore: string;
  counterpartyCashLocations: any[];
  selectedCounterpartyCashLocation: string;
  loadingCounterpartyStores: boolean;
  loadingCounterpartyCashLocations: boolean;

  // Debt-related state
  debtCategory: string;
  interestRate: string;
  interestAccountId: string;
  interestDueDay: string;
  issueDate: string;
  dueDate: string;
  debtDescription: string;
}

export interface UseTransactionFormStateProps {
  initialData?: Partial<TransactionFormData>;
  initialIsDebit: boolean;
  suggestedAmount?: number;
}

export const useTransactionFormState = ({
  initialData,
  initialIsDebit,
  suggestedAmount,
}: UseTransactionFormStateProps) => {
  // Helper function to get today's date in YYYY-MM-DD format
  const getTodayDate = (): string => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // Form state
  const [isDebit, setIsDebit] = useState(initialData?.isDebit ?? initialIsDebit);
  const [selectedAccountId, setSelectedAccountId] = useState<string>(initialData?.accountId ?? '');
  const [amount, setAmount] = useState(
    initialData?.amount ? initialData.amount.toString() : (suggestedAmount ? suggestedAmount.toString() : '')
  );
  const [description, setDescription] = useState(initialData?.description ?? '');
  const [selectedCashLocation, setSelectedCashLocation] = useState<string>(initialData?.cashLocationId ?? '');
  const [selectedCounterparty, setSelectedCounterparty] = useState<string>(initialData?.counterpartyId ?? '');

  // Counterparty-related state
  const [counterpartyStores, setCounterpartyStores] = useState<Array<{ storeId: string; storeName: string }>>([]);
  const [selectedCounterpartyStore, setSelectedCounterpartyStore] = useState<string>(initialData?.counterpartyStoreId ?? '');
  const [counterpartyCashLocations, setCounterpartyCashLocations] = useState<any[]>([]);
  const [selectedCounterpartyCashLocation, setSelectedCounterpartyCashLocation] = useState<string>(initialData?.counterpartyCashLocationId ?? '');
  const [loadingCounterpartyStores, setLoadingCounterpartyStores] = useState(false);
  const [loadingCounterpartyCashLocations, setLoadingCounterpartyCashLocations] = useState(false);

  // Debt-related state
  const [debtCategory, setDebtCategory] = useState<string>(initialData?.debtCategory ?? '');
  const [interestRate, setInterestRate] = useState<string>(initialData?.interestRate?.toString() ?? '0');
  const [interestAccountId, setInterestAccountId] = useState<string>(initialData?.interestAccountId ?? '');
  const [interestDueDay, setInterestDueDay] = useState<string>(initialData?.interestDueDay?.toString() ?? '');
  const [issueDate, setIssueDate] = useState<string>(initialData?.issueDate ?? getTodayDate());
  const [dueDate, setDueDate] = useState<string>(initialData?.dueDate ?? '');
  const [debtDescription, setDebtDescription] = useState<string>(initialData?.debtDescription ?? '');

  // Format amount for display
  const formatAmountDisplay = (value: string): string => {
    if (!value) return '';

    const num = parseFloat(value);
    if (isNaN(num)) return value;

    return num.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 2,
    });
  };

  // Handle amount input formatting
  const handleAmountChange = (value: string) => {
    // Remove non-numeric characters except decimal point
    const cleaned = value.replace(/[^\d.]/g, '');

    // Ensure only one decimal point
    const parts = cleaned.split('.');
    if (parts.length > 2) {
      return;
    }

    setAmount(cleaned);
  };

  // Handle account selection (reset dependent fields)
  const handleAccountChange = (value: string) => {
    setSelectedAccountId(value);
    setSelectedCashLocation('');
    setSelectedCounterparty('');
  };

  return {
    // State values
    isDebit,
    selectedAccountId,
    amount,
    description,
    selectedCashLocation,
    selectedCounterparty,
    counterpartyStores,
    selectedCounterpartyStore,
    counterpartyCashLocations,
    selectedCounterpartyCashLocation,
    loadingCounterpartyStores,
    loadingCounterpartyCashLocations,
    debtCategory,
    interestRate,
    interestAccountId,
    interestDueDay,
    issueDate,
    dueDate,
    debtDescription,

    // State setters
    setIsDebit,
    setSelectedAccountId,
    setAmount,
    setDescription,
    setSelectedCashLocation,
    setSelectedCounterparty,
    setCounterpartyStores,
    setSelectedCounterpartyStore,
    setCounterpartyCashLocations,
    setSelectedCounterpartyCashLocation,
    setLoadingCounterpartyStores,
    setLoadingCounterpartyCashLocations,
    setDebtCategory,
    setInterestRate,
    setInterestAccountId,
    setInterestDueDay,
    setIssueDate,
    setDueDate,
    setDebtDescription,

    // Helper functions
    formatAmountDisplay,
    handleAmountChange,
    handleAccountChange,
  };
};
