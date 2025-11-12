/**
 * useBalanceSheet Hook
 * Custom hook for balance sheet data management
 *
 * Following Clean Architecture:
 * - Hook EXECUTES validation (using Validator)
 * - Hook calls Repository for data operations
 * - Validator defines rules, Hook executes them
 */

import { useState, useCallback } from 'react';
import { BalanceSheetData } from '../../domain/entities/BalanceSheetData';
import { BalanceSheetRepositoryImpl } from '../../data/repositories/BalanceSheetRepositoryImpl';
import { BalanceSheetValidator } from '../../domain/validators/BalanceSheetValidator';

export const useBalanceSheet = (companyId: string, initialStoreId: string | null) => {
  const [balanceSheet, setBalanceSheet] = useState<BalanceSheetData | null>(null);
  const [loading, setLoading] = useState(false); // Start with false - no auto-load
  const [error, setError] = useState<string | null>(null);
  const [validationErrors, setValidationErrors] = useState<Record<string, string>>({});
  const [storeId, setStoreId] = useState<string | null>(initialStoreId);
  const [startDate, setStartDate] = useState<string | null>(null);
  const [endDate, setEndDate] = useState<string | null>(null);

  const repository = new BalanceSheetRepositoryImpl();

  const loadBalanceSheet = useCallback(
    async (
      overrideStoreId?: string | null,
      overrideStartDate?: string | null,
      overrideEndDate?: string | null
    ) => {
      // Use override values if provided, otherwise use state values
      const finalStoreId = overrideStoreId !== undefined ? overrideStoreId : storeId;
      const finalStartDate = overrideStartDate !== undefined ? overrideStartDate : startDate;
      const finalEndDate = overrideEndDate !== undefined ? overrideEndDate : endDate;

      // Step 1: Validate filters using Validator
      const validationResult = BalanceSheetValidator.validateFilters({
        companyId,
        storeId: finalStoreId,
        startDate: finalStartDate,
        endDate: finalEndDate,
      });

      if (validationResult.length > 0) {
        console.log('🚫 Validation errors:', validationResult);

        // Convert validation errors to map
        const errorMap: Record<string, string> = {};
        validationResult.forEach((err) => {
          errorMap[err.field] = err.message;
        });

        setValidationErrors(errorMap);
        setError('Please fix validation errors');
        setBalanceSheet(null);
        return { success: false, errors: validationResult };
      }

      // Clear validation errors
      setValidationErrors({});
      setLoading(true);
      setError(null);

      try {
        // Step 2: Call Repository for data
        const result = await repository.getBalanceSheet(
          companyId,
          finalStoreId,
          finalStartDate,
          finalEndDate
        );

        if (!result.success) {
          setError(result.error || 'Failed to load balance sheet');
          setBalanceSheet(null);
          return { success: false, error: result.error };
        }

        // Step 3: Validate balance equation (business rule check)
        if (result.data) {
          const balanceCheck = BalanceSheetValidator.validateBalanceEquation(
            result.data.totalAssets,
            result.data.totalLiabilitiesAndEquity
          );

          if (!balanceCheck.valid) {
            console.warn('⚠️ Balance equation warning:', balanceCheck.message);
          }
        }

        setBalanceSheet(result.data || null);
        return { success: true, data: result.data };
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
        setError(errorMessage);
        setBalanceSheet(null);
        return { success: false, error: errorMessage };
      } finally {
        setLoading(false);
      }
    },
    [companyId, storeId, startDate, endDate]
  );

  // Removed auto-load useEffect - user must click Search button to load data

  const changeDateRange = useCallback((start: string | null, end: string | null) => {
    setStartDate(start);
    setEndDate(end);
    // Clear validation errors when user changes input
    setValidationErrors({});
  }, []);

  const changeStore = useCallback((store: string | null) => {
    setStoreId(store);
    // Clear validation errors when user changes input
    setValidationErrors({});
  }, []);

  const refresh = useCallback(() => {
    loadBalanceSheet();
  }, [loadBalanceSheet]);

  return {
    balanceSheet,
    loading,
    error,
    validationErrors, // Expose validation errors for UI
    storeId,
    startDate,
    endDate,
    changeDateRange,
    changeStore,
    refresh,
    loadBalanceSheet, // Expose for manual triggering
  };
};
