/**
 * useDashboard Hook
 * Presentation layer - Custom hook for dashboard data management
 *
 * Follows Dependency Inversion Principle:
 * - Depends on IDashboardRepository interface (abstraction)
 * - Accepts repository via dependency injection for better testability
 * - Uses centralized message constants
 * - Provides ErrorMessage component state
 */

import { useState, useEffect, useMemo } from 'react';
import type { DashboardData } from '../../domain/entities/DashboardData';
import type { IDashboardRepository } from '../../domain/repositories/IDashboardRepository';
import type { ErrorMessageVariant } from '@/shared/components/common/ErrorMessage';
import { DashboardRepositoryImpl } from '../../data/repositories/DashboardRepositoryImpl';
import { DashboardValidator } from '../../domain/validators/DashboardValidator';
import { DashboardMessages } from '../../domain/constants/DashboardMessages';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export interface DashboardErrorDialog {
  variant: ErrorMessageVariant;
  title: string;
  message: string;
  isOpen: boolean;
}

export interface UseDashboardOptions {
  repository?: IDashboardRepository;
  autoLoad?: boolean;
}

export const useDashboard = (
  companyId: string,
  options: UseDashboardOptions = {}
) => {
  const { repository: injectedRepository, autoLoad = true } = options;

  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Memoize repository instance to prevent recreation on each render
  const repository = useMemo(
    () => injectedRepository || new DashboardRepositoryImpl(),
    [injectedRepository]
  );

  const loadDashboardData = async () => {
    // Validate company ID before making request
    const companyIdValidation = DashboardValidator.validateCompanyId(companyId);
    if (!companyIdValidation.isValid) {
      setError(
        companyIdValidation.error || DashboardMessages.errors.invalidCompanyId
      );
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // Get current date in UTC format (yyyy-MM-dd) for RPC query
      // This converts user's local time to UTC, then extracts date only
      const currentDate = DateTimeUtils.nowUtcDate();

      // Validate date format
      const dateValidation = DashboardValidator.validateDateFormat(currentDate);
      if (!dateValidation.isValid) {
        setError(
          dateValidation.error || DashboardMessages.errors.invalidDate
        );
        setLoading(false);
        return;
      }

      const result = await repository.getDashboardData(companyId, currentDate);

      if (!result.success || !result.data) {
        setError(result.error || DashboardMessages.errors.loadFailed);
        setData(null);
        return;
      }

      // Validate dashboard data integrity (optional, but good practice)
      const validation = DashboardValidator.validateDashboardData({
        todayRevenue: result.data.todayRevenue,
        todayExpense: result.data.todayExpense,
        thisMonthRevenue: result.data.thisMonthRevenue,
        lastMonthRevenue: result.data.lastMonthRevenue,
        currency: result.data.currency,
        expenseBreakdown: result.data.expenseBreakdown,
        recentTransactions: result.data.recentTransactions,
      });

      if (!validation.isValid) {
        console.warn(
          DashboardMessages.technical.validationWarnings(validation.errors)
        );
        // Don't block rendering for data integrity issues, just log warnings
      }

      setData(result.data);
    } catch (err) {
      setError(
        err instanceof Error ? err.message : DashboardMessages.errors.unexpectedError
      );
      setData(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (companyId && autoLoad) {
      loadDashboardData();
    }
  }, [companyId, autoLoad]);

  const refresh = () => {
    loadDashboardData();
  };

  const clearError = () => {
    setError(null);
  };

  // ErrorMessage component state
  const errorDialog: DashboardErrorDialog = {
    variant: 'error',
    title: DashboardMessages.errors.loadFailedTitle,
    message: error || '',
    isOpen: !!error && !loading,
  };

  return {
    data,
    loading,
    error,
    errorDialog,
    refresh,
    clearError,
  };
};
