/**
 * useSalary Hook
 * Custom hook wrapper for salary state management
 * Following 2025 Best Practice - Zustand Provider Wrapper Pattern
 */

import { useEffect } from 'react';
import { useSalaryStore } from '../providers/salary_provider';

/**
 * Custom hook for salary management
 * Wraps Zustand store and provides selected state/actions
 */
export const useSalary = (companyId: string, initialMonth?: string) => {
  // Select only needed state to prevent unnecessary re-renders
  const records = useSalaryStore((state) => state.records);
  const summary = useSalaryStore((state) => state.summary);
  const loading = useSalaryStore((state) => state.loading);
  const error = useSalaryStore((state) => state.error);
  const currentMonth = useSalaryStore((state) => state.currentMonth);
  const exporting = useSalaryStore((state) => state.exporting);
  const notification = useSalaryStore((state) => state.notification);

  // Select actions
  const setNotification = useSalaryStore((state) => state.setNotification);
  const setCompanyId = useSalaryStore((state) => state.setCompanyId);
  const setCurrentMonth = useSalaryStore((state) => state.setCurrentMonth);
  const loadSalaryData = useSalaryStore((state) => state.loadSalaryData);
  const refresh = useSalaryStore((state) => state.refresh);
  const goToPreviousMonth = useSalaryStore((state) => state.goToPreviousMonth);
  const goToNextMonth = useSalaryStore((state) => state.goToNextMonth);
  const goToCurrentMonth = useSalaryStore((state) => state.goToCurrentMonth);
  const exportToExcel = useSalaryStore((state) => state.exportToExcel);

  // Set company ID when it changes
  useEffect(() => {
    if (companyId) {
      setCompanyId(companyId);
    }
  }, [companyId, setCompanyId]);

  // Set initial month if provided
  useEffect(() => {
    if (initialMonth) {
      setCurrentMonth(initialMonth);
    }
  }, [initialMonth, setCurrentMonth]);

  // Load salary data when companyId or currentMonth changes
  useEffect(() => {
    if (companyId && currentMonth) {
      loadSalaryData(companyId, currentMonth);
    }
  }, [companyId, currentMonth, loadSalaryData]);

  return {
    // State
    records,
    summary,
    loading,
    error,
    currentMonth,
    exporting,
    notification,

    // Actions
    setNotification,
    refresh,
    goToPreviousMonth,
    goToNextMonth,
    goToCurrentMonth,
    exportToExcel,
  };
};
