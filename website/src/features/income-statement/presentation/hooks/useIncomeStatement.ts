/**
 * useIncomeStatement Hook
 * Custom hook for income statement management
 */

import { useState, useCallback } from 'react';
import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../../domain/entities/IncomeStatementData';
import { IncomeStatementRepositoryImpl } from '../../data/repositories/IncomeStatementRepositoryImpl';

export interface UseIncomeStatementReturn {
  monthlyData: MonthlyIncomeStatementData | null;
  twelveMonthData: TwelveMonthIncomeStatementData | null;
  currency: string;
  loading: boolean;
  error: string | null;
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
  const [error, setError] = useState<string | null>(null);

  const repository = new IncomeStatementRepositoryImpl();

  /**
   * Load monthly income statement data
   */
  const loadMonthlyData = useCallback(async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Hook] Loading monthly income statement:', { companyId, storeId, startDate, endDate });

    setLoading(true);
    setError(null);
    setTwelveMonthData(null); // Clear 12-month data

    try {
      const result = await repository.getMonthlyIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        setError(result.error || 'Failed to load monthly income statement');
        setMonthlyData(null);
        console.error('❌ [Hook] Failed to load monthly data:', result.error);
        return;
      }

      setMonthlyData(result.data || null);
      setCurrency(result.currency || '$');
      console.log('✅ [Hook] Monthly income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setError(errorMessage);
      setMonthlyData(null);
      console.error('❌ [Hook] Error loading monthly data:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  /**
   * Load 12-month income statement data
   */
  const load12MonthData = useCallback(async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Hook] Loading 12-month income statement:', { companyId, storeId, startDate, endDate });

    setLoading(true);
    setError(null);
    setMonthlyData(null); // Clear monthly data

    try {
      const result = await repository.get12MonthIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        setError(result.error || 'Failed to load 12-month income statement');
        setTwelveMonthData(null);
        console.error('❌ [Hook] Failed to load 12-month data:', result.error);
        return;
      }

      setTwelveMonthData(result.data || null);
      setCurrency(result.currency || '$');
      console.log('✅ [Hook] 12-month income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      setError(errorMessage);
      setTwelveMonthData(null);
      console.error('❌ [Hook] Error loading 12-month data:', err);
    } finally {
      setLoading(false);
    }
  }, []);

  /**
   * Clear all data
   */
  const clearData = useCallback(() => {
    console.log('🧹 [Hook] Clearing income statement data');
    setMonthlyData(null);
    setTwelveMonthData(null);
    setError(null);
  }, []);

  return {
    monthlyData,
    twelveMonthData,
    currency,
    loading,
    error,
    loadMonthlyData,
    load12MonthData,
    clearData,
  };
};
