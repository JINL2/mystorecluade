/**
 * useJournalInput Hook
 * Custom hook for journal input management
 */

import { useState, useEffect, useCallback } from 'react';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { TransactionLine } from '../../domain/entities/TransactionLine';
import { JournalInputRepositoryImpl } from '../../data/repositories/JournalInputRepositoryImpl';
import { JournalDate } from '../../domain/value-objects/JournalDate';
import type {
  Account,
  CashLocation,
  Counterparty,
} from '../../domain/repositories/IJournalInputRepository';

export const useJournalInput = (
  companyId: string,
  storeId: string | null,
  userId: string
) => {
  const [journalEntry, setJournalEntry] = useState<JournalEntry>(() =>
    new JournalEntry(
      companyId,
      storeId,
      JournalDate.today(),
      []
    )
  );

  const [accounts, setAccounts] = useState<Account[]>([]);
  const [cashLocations, setCashLocations] = useState<CashLocation[]>([]);
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  const repository = new JournalInputRepositoryImpl();

  // Load initial data
  useEffect(() => {
    const loadData = async () => {
      setLoading(true);

      try {
        const [accountsData, cashLocationsData, counterpartiesData] = await Promise.all([
          repository.getAccounts(companyId),
          repository.getCashLocations(companyId, storeId),
          repository.getCounterparties(companyId),
        ]);

        setAccounts(accountsData);
        setCashLocations(cashLocationsData);
        setCounterparties(counterpartiesData);
      } catch (err) {
        // Data loading errors are handled silently
        // Dropdown components will show empty state with "No items found" message
        console.error('Failed to load initial data:', err);
      } finally {
        setLoading(false);
      }
    };

    if (companyId) {
      loadData();
    }
  }, [companyId, storeId]);

  // Add transaction line
  const addTransactionLine = useCallback(
    (line: TransactionLine) => {
      setJournalEntry((prev) => prev.addTransactionLine(line));
    },
    []
  );

  // Update transaction line
  const updateTransactionLine = useCallback(
    (index: number, line: TransactionLine) => {
      setJournalEntry((prev) => prev.updateTransactionLine(index, line));
    },
    []
  );

  // Remove transaction line
  const removeTransactionLine = useCallback((index: number) => {
    setJournalEntry((prev) => prev.removeTransactionLine(index));
  }, []);

  // Submit journal entry
  const submitJournalEntry = useCallback(
    async (description?: string) => {
      if (!journalEntry.canSubmit()) {
        return {
          success: false,
          error: 'Journal entry must be balanced with at least 2 transaction lines'
        };
      }

      setSubmitting(true);

      try {
        const result = await repository.submitJournalEntry(
          journalEntry,
          userId,
          description
        );

        if (result.success) {
          // Reset journal entry after successful submission
          setJournalEntry(
            new JournalEntry(
              companyId,
              storeId,
              JournalDate.today(),
              []
            )
          );
        }

        return result;
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : 'Failed to submit journal entry';
        return { success: false, error: errorMessage };
      } finally {
        setSubmitting(false);
      }
    },
    [journalEntry, companyId, storeId, userId]
  );

  // Change journal date
  const changeJournalDate = useCallback((date: string) => {
    setJournalEntry((prev) => new JournalEntry(
      prev.companyId,
      prev.storeId,
      date,
      prev.transactionLines
    ));
  }, []);

  // Reset journal entry (for store changes)
  const resetJournalEntry = useCallback((newStoreId: string | null) => {
    setJournalEntry(
      new JournalEntry(
        companyId,
        newStoreId,
        JournalDate.today(),
        []
      )
    );
  }, [companyId]);

  // Check account mapping for internal counterparty validation
  const checkAccountMapping = useCallback(
    async (companyId: string, counterpartyId: string, accountId: string): Promise<boolean> => {
      try {
        const mapping = await repository.checkAccountMapping(companyId, counterpartyId, accountId);
        return mapping !== null;
      } catch (error) {
        console.error('Error checking account mapping:', error);
        return false;
      }
    },
    []
  );

  // Get counterparty stores for internal counterparties
  const getCounterpartyStores = useCallback(
    async (linkedCompanyId: string) => {
      try {
        return await repository.getCounterpartyStores(linkedCompanyId);
      } catch (error) {
        console.error('Error fetching counterparty stores:', error);
        return [];
      }
    },
    []
  );

  // Get cash locations for counterparty's company/store
  const getCounterpartyCashLocations = useCallback(
    async (linkedCompanyId: string, storeId?: string | null) => {
      try {
        return await repository.getCashLocations(linkedCompanyId, storeId);
      } catch (error) {
        console.error('Error fetching counterparty cash locations:', error);
        return [];
      }
    },
    []
  );

  return {
    journalEntry,
    accounts,
    cashLocations,
    counterparties,
    loading,
    submitting,
    addTransactionLine,
    updateTransactionLine,
    removeTransactionLine,
    submitJournalEntry,
    changeJournalDate,
    resetJournalEntry,
    checkAccountMapping,
    getCounterpartyStores,
    getCounterpartyCashLocations,
  };
};
