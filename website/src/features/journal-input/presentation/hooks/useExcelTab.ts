/**
 * useExcelTab Hook
 * Custom hook wrapper for Excel tab provider (selector optimization)
 */

import { useExcelTabStore } from '../providers/excel_tab_provider';

/**
 * Custom hook for Excel tab state and actions
 * Provides optimized selectors to prevent unnecessary re-renders
 */
export const useExcelTab = () => {
  // Select state with individual selectors (prevents unnecessary re-renders)
  const rows = useExcelTabStore((state) => state.rows);
  const nextId = useExcelTabStore((state) => state.nextId);
  const submitting = useExcelTabStore((state) => state.submitting);
  const showMappingWarning = useExcelTabStore((state) => state.showMappingWarning);
  const mappingWarningMessage = useExcelTabStore((state) => state.mappingWarningMessage);
  const showCashLocationModal = useExcelTabStore((state) => state.showCashLocationModal);
  const selectedRowForModal = useExcelTabStore((state) => state.selectedRowForModal);
  const modalCounterpartyData = useExcelTabStore((state) => state.modalCounterpartyData);

  // Select actions (these don't cause re-renders as they are stable references)
  const addRow = useExcelTabStore((state) => state.addRow);
  const deleteRow = useExcelTabStore((state) => state.deleteRow);
  const updateRowField = useExcelTabStore((state) => state.updateRowField);
  const clearCounterparty = useExcelTabStore((state) => state.clearCounterparty);
  const openCashLocationModal = useExcelTabStore((state) => state.openCashLocationModal);
  const closeCashLocationModal = useExcelTabStore((state) => state.closeCashLocationModal);
  const confirmCashLocationModal = useExcelTabStore((state) => state.confirmCashLocationModal);
  const showWarning = useExcelTabStore((state) => state.showWarning);
  const hideWarning = useExcelTabStore((state) => state.hideWarning);
  const submitExcelEntry = useExcelTabStore((state) => state.submitExcelEntry);
  const reset = useExcelTabStore((state) => state.reset);

  return {
    // State
    rows,
    nextId,
    submitting,
    showMappingWarning,
    mappingWarningMessage,
    showCashLocationModal,
    selectedRowForModal,
    modalCounterpartyData,

    // Actions
    addRow,
    deleteRow,
    updateRowField,
    clearCounterparty,
    openCashLocationModal,
    closeCashLocationModal,
    confirmCashLocationModal,
    showWarning,
    hideWarning,
    submitExcelEntry,
    reset,
  };
};
