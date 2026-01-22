/**
 * useCashAdjustment Hook
 * Hook for handling error adjustment and forex translation
 * Uses UseCase pattern for business logic separation
 */

import { useCallback, useMemo } from 'react';
import { useCashEndingStore } from '../providers/cash_ending_provider';
import {
  createErrorAdjustmentUseCase,
  createForeignCurrencyTranslationUseCase,
  createGetBalanceSummaryUseCase,
} from '../../di';
import { CashEndingValidator } from '../../domain/validators/CashEndingValidator';
import type { AdjustmentType } from '../providers/states/cash_ending_state';

interface UseCashAdjustmentParams {
  companyId: string;
  storeId: string | null;
  locationId: string;
  userId: string;
}

export const useCashAdjustment = ({
  companyId,
  storeId,
  locationId,
  userId,
}: UseCashAdjustmentParams) => {
  // UseCases - memoized to prevent recreation on each render
  const errorAdjustmentUseCase = useMemo(() => createErrorAdjustmentUseCase(), []);
  const forexTranslationUseCase = useMemo(() => createForeignCurrencyTranslationUseCase(), []);
  const getBalanceSummaryUseCase = useMemo(() => createGetBalanceSummaryUseCase(), []);

  // Store selectors
  const isAdjusting = useCashEndingStore((s) => s.isAdjusting);
  const showAdjustmentConfirmModal = useCashEndingStore((s) => s.showAdjustmentConfirmModal);
  const adjustmentType = useCashEndingStore((s) => s.adjustmentType);
  const successModalData = useCashEndingStore((s) => s.successModalData);

  // Actions
  const setIsAdjusting = useCashEndingStore((s) => s.setIsAdjusting);
  const openAdjustmentConfirm = useCashEndingStore((s) => s.openAdjustmentConfirm);
  const closeAdjustmentConfirm = useCashEndingStore((s) => s.closeAdjustmentConfirm);
  const setBalanceSummary = useCashEndingStore((s) => s.setBalanceSummary);
  const setSuccessModalData = useCashEndingStore((s) => s.setSuccessModalData);
  const setErrorMessage = useCashEndingStore((s) => s.setErrorMessage);
  const setShowErrorModal = useCashEndingStore((s) => s.setShowErrorModal);

  // Open adjustment confirmation
  const handleOpenAdjustmentConfirm = useCallback(
    (type: AdjustmentType) => {
      openAdjustmentConfirm(type);
    },
    [openAdjustmentConfirm]
  );

  // Close adjustment confirmation
  const handleCloseAdjustmentConfirm = useCallback(() => {
    if (!isAdjusting) {
      closeAdjustmentConfirm();
    }
  }, [isAdjusting, closeAdjustmentConfirm]);

  // Execute adjustment using appropriate UseCase
  const executeAdjustment = useCallback(async () => {
    if (!successModalData || !adjustmentType) return;

    const difference = successModalData.balanceSummary.difference;

    // Validate
    const errors = CashEndingValidator.validateAdjustment({
      companyId,
      storeId,
      locationId,
      userId,
      difference,
      adjustmentType,
    });

    if (errors.length > 0) {
      closeAdjustmentConfirm();
      setErrorMessage(errors[0].message);
      setShowErrorModal(true);
      return;
    }

    setIsAdjusting(true);
    try {
      // Use appropriate UseCase based on adjustment type
      const useCase = adjustmentType === 'error'
        ? errorAdjustmentUseCase
        : forexTranslationUseCase;

      const result = await useCase.execute({
        differenceAmount: difference,
        companyId,
        userId,
        locationName: successModalData.locationName,
        cashLocationId: locationId,
        storeId: storeId || undefined,
      });

      if (!result.success) {
        closeAdjustmentConfirm();
        setErrorMessage(result.error || 'Unknown error');
        setShowErrorModal(true);
        return;
      }

      // Refresh balance summary using GetBalanceSummaryUseCase
      const summary = await getBalanceSummaryUseCase.execute({ locationId });
      if (summary) {
        setBalanceSummary(summary);
        setSuccessModalData({
          ...successModalData,
          balanceSummary: summary,
        });
      }

      closeAdjustmentConfirm();
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : 'Unknown error';
      closeAdjustmentConfirm();
      setErrorMessage(errMsg);
      setShowErrorModal(true);
    } finally {
      setIsAdjusting(false);
    }
  }, [
    companyId,
    storeId,
    locationId,
    userId,
    adjustmentType,
    successModalData,
    errorAdjustmentUseCase,
    forexTranslationUseCase,
    getBalanceSummaryUseCase,
    setIsAdjusting,
    closeAdjustmentConfirm,
    setBalanceSummary,
    setSuccessModalData,
    setErrorMessage,
    setShowErrorModal,
  ]);

  return {
    // State
    isAdjusting,
    showAdjustmentConfirmModal,
    adjustmentType,

    // Actions
    openAdjustmentConfirm: handleOpenAdjustmentConfirm,
    closeAdjustmentConfirm: handleCloseAdjustmentConfirm,
    executeAdjustment,
  };
};
