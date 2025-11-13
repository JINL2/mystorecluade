/**
 * useCurrency Hook
 *
 * Custom hook for currency management that wraps the Zustand store.
 * Following ARCHITECTURE.md pattern: Zustand + Custom Hooks (2025 Best Practice)
 *
 * Key principles:
 * - Selector optimization: Only subscribe to needed state slices
 * - No local state management (all in Zustand store)
 * - Clean API for components
 * - Prevents unnecessary re-renders through fine-grained selectors
 */

import { useEffect } from 'react';
import { useCurrencyStore } from '../providers/currency_provider';

/**
 * Currency management hook
 *
 * Provides access to currency state and actions from Zustand store.
 * Uses selector pattern to prevent unnecessary re-renders.
 *
 * @param companyId - Current company ID
 * @param userId - Current user ID
 * @returns Currency state and actions
 */
export const useCurrency = (companyId: string, userId: string) => {
  // ========================================
  // Selector Pattern: Subscribe to specific state slices
  // This prevents re-renders when unrelated state changes
  // ========================================

  // Core data state
  const currencies = useCurrencyStore((state) => state.currencies);
  const loading = useCurrencyStore((state) => state.loading);
  const error = useCurrencyStore((state) => state.error);

  // UI state
  const editingCurrency = useCurrencyStore((state) => state.editingCurrency);
  const showAddModal = useCurrencyStore((state) => state.showAddModal);
  const currencyToRemove = useCurrencyStore((state) => state.currencyToRemove);
  const isRemoving = useCurrencyStore((state) => state.isRemoving);
  const notification = useCurrencyStore((state) => state.notification);

  // Actions (these don't cause re-renders as they're stable references)
  const setContext = useCurrencyStore((state) => state.setContext);
  const setEditingCurrency = useCurrencyStore((state) => state.setEditingCurrency);
  const setShowAddModal = useCurrencyStore((state) => state.setShowAddModal);
  const setCurrencyToRemove = useCurrencyStore((state) => state.setCurrencyToRemove);
  const setNotification = useCurrencyStore((state) => state.setNotification);
  const clearNotification = useCurrencyStore((state) => state.clearNotification);

  // Async operations
  const loadCurrencies = useCurrencyStore((state) => state.loadCurrencies);
  const getAllCurrencyTypes = useCurrencyStore((state) => state.getAllCurrencyTypes);
  const updateExchangeRate = useCurrencyStore((state) => state.updateExchangeRate);
  const addCurrency = useCurrencyStore((state) => state.addCurrency);
  const removeCurrency = useCurrencyStore((state) => state.removeCurrency);
  const setDefaultCurrency = useCurrencyStore((state) => state.setDefaultCurrency);

  // UI action handlers
  const handleEditCurrency = useCurrencyStore((state) => state.handleEditCurrency);
  const handleRemoveCurrency = useCurrencyStore((state) => state.handleRemoveCurrency);
  const confirmRemoveCurrency = useCurrencyStore((state) => state.confirmRemoveCurrency);

  // ========================================
  // Effects: Initialize context and load data
  // ========================================

  useEffect(() => {
    // Set company and user context when they change
    if (companyId && userId) {
      setContext(companyId, userId);
      loadCurrencies();
    }
  }, [companyId, userId, setContext, loadCurrencies]);

  // ========================================
  // Return API: Clean interface for components
  // ========================================

  return {
    // Core data state
    currencies,
    loading,
    error,

    // UI state
    editingCurrency,
    showAddModal,
    currencyToRemove,
    isRemoving,
    notification,

    // State setters
    setEditingCurrency,
    setShowAddModal,
    setCurrencyToRemove,
    setNotification,
    clearNotification,

    // Async operations
    loadCurrencies,
    getAllCurrencyTypes,
    updateExchangeRate,
    addCurrency,
    removeCurrency,
    setDefaultCurrency,

    // UI action handlers
    handleEditCurrency,
    handleRemoveCurrency,
    confirmRemoveCurrency,
  };
};
