/**
 * useJournalInput Hook
 * Custom hook wrapper for journal input store (selector optimization)
 */

import { useEffect } from 'react';
import { useJournalInputStore } from '../providers/journal_input_provider';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { JournalDate } from '../../domain/value-objects/JournalDate';

export const useJournalInput = (
  companyId: string,
  storeId: string | null,
  userId: string
) => {
  // Select only needed state (prevent unnecessary re-renders)
  const journalEntry = useJournalInputStore((state) => state.journalEntry);
  const accounts = useJournalInputStore((state) => state.accounts);
  const cashLocations = useJournalInputStore((state) => state.cashLocations);
  const counterparties = useJournalInputStore((state) => state.counterparties);
  const templates = useJournalInputStore((state) => state.templates);
  const loading = useJournalInputStore((state) => state.loading);
  const submitting = useJournalInputStore((state) => state.submitting);
  const loadingTemplates = useJournalInputStore((state) => state.loadingTemplates);
  const error = useJournalInputStore((state) => state.error);

  // Actions
  const setJournalEntry = useJournalInputStore((state) => state.setJournalEntry);
  const addTransactionLine = useJournalInputStore((state) => state.addTransactionLine);
  const updateTransactionLine = useJournalInputStore((state) => state.updateTransactionLine);
  const removeTransactionLine = useJournalInputStore((state) => state.removeTransactionLine);
  const changeJournalDate = useJournalInputStore((state) => state.changeJournalDate);
  const resetJournalEntry = useJournalInputStore((state) => state.resetJournalEntry);
  const submitJournalEntry = useJournalInputStore((state) => state.submitJournalEntry);
  const checkAccountMapping = useJournalInputStore((state) => state.checkAccountMapping);
  const getCounterpartyStores = useJournalInputStore((state) => state.getCounterpartyStores);
  const getCounterpartyCashLocations = useJournalInputStore(
    (state) => state.getCounterpartyCashLocations
  );
  const loadCashLocations = useJournalInputStore((state) => state.loadCashLocations);
  const loadInitialData = useJournalInputStore((state) => state.loadInitialData);
  const loadTransactionTemplates = useJournalInputStore((state) => state.loadTransactionTemplates);
  const applyTemplate = useJournalInputStore((state) => state.applyTemplate);

  // Initialize store with context values and load data on mount
  useEffect(() => {
    // Update store state
    useJournalInputStore.setState({
      companyId,
      storeId,
      userId,
      journalEntry: new JournalEntry(companyId, storeId, JournalDate.today(), []),
    });

    // Load initial data
    if (companyId) {
      loadInitialData();
      // Load templates after store state is set
      if (storeId) {
        loadTransactionTemplates();
      }
    }
  }, [companyId, storeId, userId, loadInitialData, loadTransactionTemplates]);

  return {
    // State
    journalEntry,
    accounts,
    cashLocations,
    counterparties,
    templates,
    loading,
    submitting,
    loadingTemplates,
    error,

    // Actions
    setJournalEntry,
    addTransactionLine,
    updateTransactionLine,
    removeTransactionLine,
    changeJournalDate,
    resetJournalEntry,
    submitJournalEntry,
    checkAccountMapping,
    getCounterpartyStores,
    getCounterpartyCashLocations,
    loadCashLocations,
    loadTransactionTemplates,
    applyTemplate,
  };
};
