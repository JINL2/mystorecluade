/**
 * useCashEndingJournal Hook
 * Handles journal entry creation for Make Error and Foreign Currency Translation
 */

import { useState } from 'react';
import {
  CashEndingJournalValidator,
  CreateJournalParams,
} from '../../domain/validators/CashEndingJournalValidator';
import { CashEndingRepositoryImpl } from '../../data/repositories/CashEndingRepositoryImpl';

export const useCashEndingJournal = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const repository = new CashEndingRepositoryImpl();

  const createJournalEntry = async (params: CreateJournalParams): Promise<boolean> => {
    setIsLoading(true);
    setError(null);

    try {
      // 1. Validate parameters using CashEndingJournalValidator (Domain Layer)
      const validationErrors = CashEndingJournalValidator.validateJournalParams(params);
      if (validationErrors.length > 0) {
        const errorMessage = validationErrors.map(e => e.message).join(', ');
        setError(errorMessage);
        setIsLoading(false);
        return false;
      }

      // 2. Call Repository (Data Layer)
      const result = await repository.createJournalEntry(params);

      if (!result.success) {
        setError(result.error || 'Failed to create journal entry');
        setIsLoading(false);
        return false;
      }

      setIsLoading(false);
      return true;

    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Unknown error occurred';
      console.error('Error in createJournalEntry:', err);
      setError(errorMessage);
      setIsLoading(false);
      return false;
    }
  };

  return {
    createJournalEntry,
    isLoading,
    error
  };
};
