/**
 * useIncomeStatement Hook
 * Custom hook for income statement management
 *
 * Following ARCHITECTURE.md pattern:
 * - Validators: define rules (domain layer)
 * - Hooks: execute validation + call Repository (presentation layer)
 * - ErrorMessage: Unified error/success notification system
 */

import { useState, useCallback, useMemo } from 'react';
import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../../domain/entities/IncomeStatementData';
import { IncomeStatementRepositoryImpl } from '../../data/repositories/IncomeStatementRepositoryImpl';
import { IncomeStatementValidator } from '../../domain/validators/IncomeStatementValidator';
import { useErrorMessage } from '@/shared/hooks/useErrorMessage';

export interface UseIncomeStatementReturn {
  monthlyData: MonthlyIncomeStatementData | null;
  twelveMonthData: TwelveMonthIncomeStatementData | null;
  currency: string;
  loading: boolean;
  // ErrorMessage integration
  messageState: ReturnType<typeof useErrorMessage>['messageState'];
  closeMessage: () => void;
  loadMonthlyData: (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => Promise<void>;
  load12MonthData: (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => Promise<void>;
  clearData: () => void;
}

export const useIncomeStatement = (): UseIncomeStatementReturn => {
  const [monthlyData, setMonthlyData] = useState<MonthlyIncomeStatementData | null>(null);
  const [twelveMonthData, setTwelveMonthData] = useState<TwelveMonthIncomeStatementData | null>(null);
  const [currency, setCurrency] = useState<string>('$');
  const [loading, setLoading] = useState(false);

  // ErrorMessage Hook integration
  const { messageState, closeMessage, showError, showWarning, showInfo } = useErrorMessage();

  // Create repository instance only once using useMemo
  const repository = useMemo(() => new IncomeStatementRepositoryImpl(), []);

  /**
   * Load monthly income statement data
   * Executes validation before calling repository
   */
  const loadMonthlyData = useCallback(async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Hook] Loading monthly income statement:', { companyId, storeId, startDate, endDate });

    setLoading(true);
    setTwelveMonthData(null); // Clear 12-month data

    try {
      // Execute validation using Validator
      const validationResult = IncomeStatementValidator.validateQuery(
        companyId,
        storeId,
        startDate,
        endDate,
        'monthly'
      );

      if (!validationResult.isValid) {
        const errorMessages = validationResult.errors.map(e => e.message).join(', ');
        setMonthlyData(null);
        console.error('❌ [Hook] Validation failed:', validationResult.errors);
        setLoading(false);

        // Show warning for validation errors
        showWarning({
          title: 'Validation Error',
          message: errorMessages,
        });
        return;
      }

      // Call Repository
      const result = await repository.getMonthlyIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        setMonthlyData(null);
        console.error('❌ [Hook] Repository error:', result.error);
        setLoading(false);

        // Show info for "no data" or error for server errors
        if (result.error?.includes('No') || result.error?.includes('available')) {
          showInfo({
            title: 'No Data Available',
            message: result.error || 'No income statement data found for the selected period.',
          });
        } else {
          showError({
            title: 'Error Loading Data',
            message: result.error || 'Failed to load income statement. Please try again.',
          });
        }
        return;
      }

      setMonthlyData(result.data || null);
      setCurrency(result.currency || '$');
      console.log('✅ [Hook] Monthly income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setMonthlyData(null);
      console.error('❌ [Hook] Error loading monthly data:', err);

      // Show error for exceptions
      showError({
        title: 'Unexpected Error',
        message: errorMessage,
      });
    } finally {
      setLoading(false);
    }
  }, [repository, showError, showWarning, showInfo]);

  /**
   * Load 12-month income statement data
   * Executes validation before calling repository
   */
  const load12MonthData = useCallback(async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Hook] Loading 12-month income statement:', { companyId, storeId, startDate, endDate });

    setLoading(true);
    setMonthlyData(null); // Clear monthly data

    try {
      // Execute validation using Validator
      const validationResult = IncomeStatementValidator.validateQuery(
        companyId,
        storeId,
        startDate,
        endDate,
        '12month'
      );

      if (!validationResult.isValid) {
        const errorMessages = validationResult.errors.map(e => e.message).join(', ');
        setTwelveMonthData(null);
        console.error('❌ [Hook] Validation failed:', validationResult.errors);
        setLoading(false);

        // Show warning for validation errors
        showWarning({
          title: 'Validation Error',
          message: errorMessages,
        });
        return;
      }

      // Call Repository
      const result = await repository.get12MonthIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        setTwelveMonthData(null);
        console.error('❌ [Hook] Repository error:', result.error);
        setLoading(false);

        // Show info for "no data" or error for server errors
        if (result.error?.includes('No') || result.error?.includes('available')) {
          showInfo({
            title: 'No Data Available',
            message: result.error || 'No income statement data found for the selected period.',
          });
        } else {
          showError({
            title: 'Error Loading Data',
            message: result.error || 'Failed to load income statement. Please try again.',
          });
        }
        return;
      }

      setTwelveMonthData(result.data || null);
      setCurrency(result.currency || '$');
      console.log('✅ [Hook] 12-month income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setTwelveMonthData(null);
      console.error('❌ [Hook] Error loading 12-month data:', err);

      // Show error for exceptions
      showError({
        title: 'Unexpected Error',
        message: errorMessage,
      });
    } finally {
      setLoading(false);
    }
  }, [repository, showError, showWarning, showInfo]);

  /**
   * Clear all data
   */
  const clearData = useCallback(() => {
    console.log('🧹 [Hook] Clearing income statement data');
    setMonthlyData(null);
    setTwelveMonthData(null);
    setCurrency('$');
  }, []);

  return {
    monthlyData,
    twelveMonthData,
    currency,
    loading,
    messageState,
    closeMessage,
    loadMonthlyData,
    load12MonthData,
    clearData,
  };
};
