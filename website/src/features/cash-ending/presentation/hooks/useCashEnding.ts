/**
 * useCashEnding Hook
 * Main hook for cash ending page operations
 * Uses UseCase pattern for business logic separation
 */

import { useEffect, useCallback, useMemo } from 'react';
import { useCashEndingStore } from '../providers/cash_ending_provider';
import {
  getCashEndingRepository,
  createSaveCashEndingUseCase,
  createSaveBankEndingUseCase,
  createGetBalanceSummaryUseCase,
} from '../../di';
import { CashEndingValidator } from '../../domain/validators/CashEndingValidator';
import type { CurrencyEntity } from '../../domain/entities/Currency';
import type { Store } from '@/app/providers/app_state_provider';

interface UseCashEndingParams {
  companyId: string;
  userId: string;
  stores: Store[];
  currentStoreId: string | null;
  setCurrentStore: (store: Store | null) => void;
}

export const useCashEnding = ({
  companyId,
  userId,
  stores,
  currentStoreId,
  setCurrentStore,
}: UseCashEndingParams) => {
  // Repository and UseCases - memoized to prevent recreation on each render
  const cashEndingRepository = useMemo(() => getCashEndingRepository(), []);
  const saveCashEndingUseCase = useMemo(() => createSaveCashEndingUseCase(), []);
  const saveBankEndingUseCase = useMemo(() => createSaveBankEndingUseCase(), []);
  const getBalanceSummaryUseCase = useMemo(() => createGetBalanceSummaryUseCase(), []);

  // Store selectors
  const selectedStoreId = useCashEndingStore((s) => s.selectedStoreId);
  const cashLocations = useCashEndingStore((s) => s.cashLocations);
  const selectedLocationId = useCashEndingStore((s) => s.selectedLocationId);
  const isLoadingLocations = useCashEndingStore((s) => s.isLoadingLocations);
  const currencies = useCashEndingStore((s) => s.currencies);
  const selectedCurrencyId = useCashEndingStore((s) => s.selectedCurrencyId);
  const isLoadingCurrencies = useCashEndingStore((s) => s.isLoadingCurrencies);
  const denomQuantities = useCashEndingStore((s) => s.denomQuantities);
  const bankAmounts = useCashEndingStore((s) => s.bankAmounts);
  const vaultTransactionType = useCashEndingStore((s) => s.vaultTransactionType);
  const balanceSummary = useCashEndingStore((s) => s.balanceSummary);
  const isLoadingBalance = useCashEndingStore((s) => s.isLoadingBalance);
  const isCompareExpanded = useCashEndingStore((s) => s.isCompareExpanded);
  const isSubmitting = useCashEndingStore((s) => s.isSubmitting);
  const showSuccessModal = useCashEndingStore((s) => s.showSuccessModal);
  const showErrorModal = useCashEndingStore((s) => s.showErrorModal);
  const errorMessage = useCashEndingStore((s) => s.errorMessage);
  const successModalData = useCashEndingStore((s) => s.successModalData);

  // Actions
  const setSelectedStoreId = useCashEndingStore((s) => s.setSelectedStoreId);
  const setCashLocations = useCashEndingStore((s) => s.setCashLocations);
  const setSelectedLocationId = useCashEndingStore((s) => s.setSelectedLocationId);
  const setIsLoadingLocations = useCashEndingStore((s) => s.setIsLoadingLocations);
  const setCurrencies = useCashEndingStore((s) => s.setCurrencies);
  const setSelectedCurrencyId = useCashEndingStore((s) => s.setSelectedCurrencyId);
  const setIsLoadingCurrencies = useCashEndingStore((s) => s.setIsLoadingCurrencies);
  const setDenomQuantity = useCashEndingStore((s) => s.setDenomQuantity);
  const setBankAmount = useCashEndingStore((s) => s.setBankAmount);
  const resetAmounts = useCashEndingStore((s) => s.resetAmounts);
  const setVaultTransactionType = useCashEndingStore((s) => s.setVaultTransactionType);
  const setBalanceSummary = useCashEndingStore((s) => s.setBalanceSummary);
  const setIsLoadingBalance = useCashEndingStore((s) => s.setIsLoadingBalance);
  const setIsCompareExpanded = useCashEndingStore((s) => s.setIsCompareExpanded);
  const setIsSubmitting = useCashEndingStore((s) => s.setIsSubmitting);
  const setShowSuccessModal = useCashEndingStore((s) => s.setShowSuccessModal);
  const setShowErrorModal = useCashEndingStore((s) => s.setShowErrorModal);
  const setErrorMessage = useCashEndingStore((s) => s.setErrorMessage);
  const setSuccessModalData = useCashEndingStore((s) => s.setSuccessModalData);
  const resetLocationState = useCashEndingStore((s) => s.resetLocationState);

  // Initialize with current store
  useEffect(() => {
    if (currentStoreId && !selectedStoreId) {
      setSelectedStoreId(currentStoreId);
    }
  }, [currentStoreId, selectedStoreId, setSelectedStoreId]);

  // Fetch cash locations when store changes
  useEffect(() => {
    const fetchLocations = async () => {
      if (!selectedStoreId || !companyId) {
        setCashLocations([]);
        return;
      }

      setIsLoadingLocations(true);
      try {
        const locations = await cashEndingRepository.getCashLocations(companyId, selectedStoreId);
        setCashLocations(locations);
      } catch (error) {
        console.error('Failed to fetch cash locations:', error);
        setCashLocations([]);
      } finally {
        setIsLoadingLocations(false);
      }
    };

    fetchLocations();
  }, [selectedStoreId, companyId, setCashLocations, setIsLoadingLocations]);

  // Fetch currencies and balance when location changes
  useEffect(() => {
    const fetchCurrenciesAndBalance = async () => {
      if (!selectedLocationId || !companyId) {
        setCurrencies([]);
        setBalanceSummary(null);
        return;
      }

      // Fetch currencies
      setIsLoadingCurrencies(true);
      try {
        const currencyData = await cashEndingRepository.getCurrencies(companyId);
        setCurrencies(currencyData);

        // Auto-select currency
        if (currencyData.length > 0) {
          const selectedLoc = cashLocations.find((l) => l.cashLocationId === selectedLocationId);
          if (selectedLoc?.isBank) {
            const baseCurrency = currencyData.find((c) => c.isBaseCurrency);
            setSelectedCurrencyId(baseCurrency?.currencyId || currencyData[0].currencyId);
          } else {
            setSelectedCurrencyId(currencyData[0].currencyId);
          }
        }
      } catch (error) {
        console.error('Failed to fetch currencies:', error);
        setCurrencies([]);
      } finally {
        setIsLoadingCurrencies(false);
      }

      // Fetch balance summary
      setIsLoadingBalance(true);
      try {
        const summary = await cashEndingRepository.getBalanceSummary(selectedLocationId);
        setBalanceSummary(summary);
      } catch (error) {
        console.error('Failed to fetch balance summary:', error);
        setBalanceSummary(null);
      } finally {
        setIsLoadingBalance(false);
      }
    };

    fetchCurrenciesAndBalance();
  }, [
    selectedLocationId,
    companyId,
    cashLocations,
    setCurrencies,
    setSelectedCurrencyId,
    setIsLoadingCurrencies,
    setBalanceSummary,
    setIsLoadingBalance,
  ]);

  // Handle store selection
  const handleStoreSelect = useCallback(
    (storeId: string | null) => {
      setSelectedStoreId(storeId);
      resetLocationState();

      if (storeId) {
        const store = stores.find((s) => s.store_id === storeId);
        if (store) {
          setCurrentStore(store);
        }
      } else {
        setCurrentStore(null);
      }
    },
    [stores, setSelectedStoreId, resetLocationState, setCurrentStore]
  );

  // Handle location selection
  const handleLocationSelect = useCallback(
    (locationId: string) => {
      setSelectedLocationId(locationId);
      resetAmounts();
      setBalanceSummary(null);
      setVaultTransactionType('recount');
    },
    [setSelectedLocationId, resetAmounts, setBalanceSummary, setVaultTransactionType]
  );

  // Get selected location entity
  const selectedLocation = cashLocations.find((l) => l.cashLocationId === selectedLocationId);

  // Get selected currency entity
  const selectedCurrency = currencies.find((c) => c.currencyId === selectedCurrencyId);

  // Calculate currency subtotal
  const calculateCurrencySubtotal = useCallback(
    (currency: CurrencyEntity) => {
      return currency.calculateSubtotal(denomQuantities);
    },
    [denomQuantities]
  );

  // Calculate grand total
  const calculateGrandTotal = useCallback(() => {
    if (selectedLocation?.isBank) {
      return currencies.reduce((total, currency) => {
        const amount = bankAmounts[currency.currencyId] || 0;
        return total + currency.convertToBase(amount);
      }, 0);
    }

    return currencies.reduce((total, currency) => {
      const subtotal = currency.calculateSubtotal(denomQuantities);
      return total + currency.convertToBase(subtotal);
    }, 0);
  }, [currencies, bankAmounts, denomQuantities, selectedLocation]);

  // Get entered amount for a currency
  const getCurrencyEnteredAmount = useCallback(
    (currency: CurrencyEntity) => {
      if (selectedLocation?.isBank) {
        return bankAmounts[currency.currencyId] || 0;
      }
      return currency.calculateSubtotal(denomQuantities);
    },
    [selectedLocation, bankAmounts, denomQuantities]
  );

  // Check if can submit
  const canSubmit = selectedLocationId && (
    selectedLocation?.isBank
      ? Object.values(bankAmounts).some((amt) => amt > 0)
      : Object.values(denomQuantities).some((qty) => qty > 0)
  );

  // Handle submit using appropriate UseCase
  const handleSubmit = useCallback(async () => {
    if (!selectedLocation) return;

    // Validate
    const errors = CashEndingValidator.validateSubmit({
      companyId,
      storeId: selectedStoreId,
      locationId: selectedLocationId,
      locationType: selectedLocation.locationType,
      denomQuantities,
      bankAmounts,
    });

    if (errors.length > 0) {
      setErrorMessage(errors[0].message);
      setShowErrorModal(true);
      return;
    }

    setIsSubmitting(true);
    try {
      let result;
      const submittedAmount = calculateGrandTotal();

      if (selectedLocation.isBank) {
        // Use SaveBankEndingUseCase for bank locations
        result = await saveBankEndingUseCase.execute({
          companyId,
          storeId: selectedStoreId!,
          locationId: selectedLocationId,
          userId,
          currencies,
          bankAmounts,
        });
      } else {
        // Use SaveCashEndingUseCase for cash/vault locations
        result = await saveCashEndingUseCase.execute({
          companyId,
          storeId: selectedStoreId!,
          locationId: selectedLocationId,
          locationType: selectedLocation.locationType as 'cash' | 'vault',
          userId,
          currencies,
          denomQuantities,
          vaultTransactionType,
        });
      }

      if (!result.success) {
        setErrorMessage(result.error || 'Unknown error');
        setShowErrorModal(true);
        return;
      }

      // Reset amounts
      resetAmounts();

      // Refresh balance summary using GetBalanceSummaryUseCase
      const summary = await getBalanceSummaryUseCase.execute({ locationId: selectedLocationId });
      if (summary) {
        setBalanceSummary(summary);
        setSuccessModalData({
          submittedAmount,
          balanceSummary: summary,
          locationName: selectedLocation.locationName,
          locationType: selectedLocation.locationType,
        });
      }

      setShowSuccessModal(true);
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : 'Unknown error';
      setErrorMessage(errMsg);
      setShowErrorModal(true);
    } finally {
      setIsSubmitting(false);
    }
  }, [
    companyId,
    userId,
    selectedStoreId,
    selectedLocationId,
    selectedLocation,
    currencies,
    denomQuantities,
    bankAmounts,
    vaultTransactionType,
    calculateGrandTotal,
    resetAmounts,
    saveBankEndingUseCase,
    saveCashEndingUseCase,
    getBalanceSummaryUseCase,
    setIsSubmitting,
    setBalanceSummary,
    setSuccessModalData,
    setShowSuccessModal,
    setErrorMessage,
    setShowErrorModal,
  ]);

  // Close modals
  const closeSuccessModal = useCallback(() => {
    setShowSuccessModal(false);
    setSuccessModalData(null);
  }, [setShowSuccessModal, setSuccessModalData]);

  const closeErrorModal = useCallback(() => {
    setShowErrorModal(false);
  }, [setShowErrorModal]);

  return {
    // State
    selectedStoreId,
    cashLocations,
    selectedLocationId,
    isLoadingLocations,
    currencies,
    selectedCurrencyId,
    isLoadingCurrencies,
    denomQuantities,
    bankAmounts,
    vaultTransactionType,
    balanceSummary,
    isLoadingBalance,
    isCompareExpanded,
    isSubmitting,
    showSuccessModal,
    showErrorModal,
    errorMessage,
    successModalData,
    selectedLocation,
    selectedCurrency,
    canSubmit,

    // Actions
    handleStoreSelect,
    handleLocationSelect,
    setSelectedCurrencyId,
    setDenomQuantity,
    setBankAmount,
    setVaultTransactionType,
    setIsCompareExpanded,
    handleSubmit,
    closeSuccessModal,
    closeErrorModal,

    // Calculations
    calculateCurrencySubtotal,
    calculateGrandTotal,
    getCurrencyEnteredAmount,
  };
};
