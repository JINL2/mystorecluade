/**
 * useCashEndingModal Hook
 * Manages modal state for Make Error and Foreign Currency Translation
 */

import { useState, useCallback } from 'react';
import { CashEnding } from '../../domain/entities/CashEnding';

export interface ModalState {
  isOpen: boolean;
  type: 'error' | 'exchange' | null;
  locationId: string | null;
  locationName: string;
  storeId: string | null;
  difference: number;
}

export const useCashEndingModal = () => {
  const [modalState, setModalState] = useState<ModalState>({
    isOpen: false,
    type: null,
    locationId: null,
    locationName: '',
    storeId: null,
    difference: 0,
  });

  /**
   * Open modal for Make Error
   */
  const openErrorModal = useCallback((cashEnding: CashEnding) => {
    setModalState({
      isOpen: true,
      type: 'error',
      locationId: cashEnding.locationId,
      locationName: cashEnding.locationName,
      storeId: cashEnding.storeId,
      difference: cashEnding.difference,
    });
  }, []);

  /**
   * Open modal for Foreign Currency Translation
   */
  const openExchangeModal = useCallback((cashEnding: CashEnding) => {
    setModalState({
      isOpen: true,
      type: 'exchange',
      locationId: cashEnding.locationId,
      locationName: cashEnding.locationName,
      storeId: cashEnding.storeId,
      difference: cashEnding.difference,
    });
  }, []);

  /**
   * Close modal
   */
  const closeModal = useCallback(() => {
    setModalState({
      isOpen: false,
      type: null,
      locationId: null,
      locationName: '',
      storeId: null,
      difference: 0,
    });
  }, []);

  /**
   * Reset modal state
   */
  const resetModal = useCallback(() => {
    closeModal();
  }, [closeModal]);

  return {
    modalState,
    openErrorModal,
    openExchangeModal,
    closeModal,
    resetModal,
  };
};
