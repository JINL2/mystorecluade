/**
 * useJournalInput Hook
 * Custom hook for journal input management
 */

import { useState, useEffect, useCallback } from 'react';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { TransactionLine } from '../../domain/entities/TransactionLine';
import { JournalInputRepositoryImpl } from '../../data/repositories/JournalInputRepositoryImpl';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
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
      DateTimeUtils.toDateOnly(new Date()),
      []
    )
  );

  const [accounts, setAccounts] = useState<Account[]>([]);
  const [cashLocations, setCashLocations] = useState<CashLocation[]>([]);
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const repository = new JournalInputRepositoryImpl();

  // Load initial data
  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      setError(null);

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
        setError(err instanceof Error ? err.message : 'Failed to load data');
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
        setError('Journal entry must be balanced with at least 2 transaction lines');
        return { success: false };
      }

      setSubmitting(true);
      setError(null);

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
              DateTimeUtils.toDateOnly(new Date()),
              []
            )
          );
        } else {
          setError(result.error || 'Failed to submit journal entry');
        }

        return result;
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : 'Failed to submit journal entry';
        setError(errorMessage);
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

  return {
    journalEntry,
    accounts,
    cashLocations,
    counterparties,
    loading,
    submitting,
    error,
    addTransactionLine,
    updateTransactionLine,
    removeTransactionLine,
    submitJournalEntry,
    changeJournalDate,
  };
};
