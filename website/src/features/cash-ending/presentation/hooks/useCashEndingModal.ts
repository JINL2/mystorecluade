/**
 * useCashEndingModal Hook
 * Custom hook wrapper for modal state management
 * Following 2025 Best Practice - Zustand Provider Wrapper Pattern
 */

import { useCashEndingStore } from '../providers/cash_ending_provider';

export type { ModalState } from '../providers/states/types';

/**
 * Custom hook for cash ending modal management
 * Wraps Zustand store modal state and actions
 */
export const useCashEndingModal = () => {
  // Select modal state
  const modalState = useCashEndingStore((state) => state.modalState);

  // Select modal actions
  const openErrorModal = useCashEndingStore((state) => state.openErrorModal);
  const openExchangeModal = useCashEndingStore((state) => state.openExchangeModal);
  const closeModal = useCashEndingStore((state) => state.closeModal);
  const resetModal = useCashEndingStore((state) => state.resetModal);

  return {
    modalState,
    openErrorModal,
    openExchangeModal,
    closeModal,
    resetModal,
  };
};
