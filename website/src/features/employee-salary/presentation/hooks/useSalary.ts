/**
 * useSalary Hook
 * Presentation layer - Custom hook for salary data management
 */

import { useState, useEffect, useCallback } from 'react';
import { SalaryRecord } from '../../domain/entities/SalaryRecord';
import { SalarySummary } from '../../domain/entities/SalarySummary';
import { SalaryRepositoryImpl } from '../../data/repositories/SalaryRepositoryImpl';

export const useSalary = (companyId: string, initialMonth?: string) => {
  // Get current month in YYYY-MM format
  const getCurrentMonth = () => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
  };

  const [records, setRecords] = useState<SalaryRecord[]>([]);
  const [summary, setSummary] = useState<SalarySummary | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currentMonth, setCurrentMonth] = useState(initialMonth || getCurrentMonth());
  const [exporting, setExporting] = useState(false);

  const repository = new SalaryRepositoryImpl();

  const loadSalaryData = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const result = await repository.getSalaryData(companyId, currentMonth);

      console.log('Salary Data Result:', result);

      if (!result.success) {
        setError(result.error || 'Failed to load salary data');
        setRecords([]);
        setSummary(null);
        return;
      }

      console.log('Salary Records:', result.records);
      if (result.records && result.records.length > 0) {
        console.log('First Record:', result.records[0]);
        console.log('Record fullName:', result.records[0].fullName);
        console.log('Record totalSalary:', result.records[0].totalSalary);
      }
      console.log('Salary Summary:', result.summary);

      setRecords(result.records || []);
      setSummary(result.summary || null);
    } catch (err) {
      console.error('Salary data error:', err);
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setRecords([]);
      setSummary(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, currentMonth]);

  useEffect(() => {
    if (companyId) {
      loadSalaryData();
    }
  }, [companyId, currentMonth, loadSalaryData]);

  const refresh = () => {
    loadSalaryData();
  };

  const goToPreviousMonth = () => {
    const [year, month] = currentMonth.split('-').map(Number);
    const date = new Date(year, month - 1, 1);
    date.setMonth(date.getMonth() - 1);
    const newMonth = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    setCurrentMonth(newMonth);
  };

  const goToNextMonth = () => {
    const [year, month] = currentMonth.split('-').map(Number);
    const date = new Date(year, month - 1, 1);
    date.setMonth(date.getMonth() + 1);
    const newMonth = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    setCurrentMonth(newMonth);
  };

  const goToCurrentMonth = () => {
    setCurrentMonth(getCurrentMonth());
  };

  const exportToExcel = async () => {
    setExporting(true);
    try {
      const result = await repository.exportToExcel(companyId, currentMonth);

      if (!result.success || !result.blob) {
        throw new Error(result.error || 'Failed to export data');
      }

      // Download the blob
      const url = URL.createObjectURL(result.blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `salary_${currentMonth}.xlsx`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (err) {
      console.error('Export error:', err);
      alert(err instanceof Error ? err.message : 'Failed to export data');
    } finally {
      setExporting(false);
    }
  };

  return {
    records,
    summary,
    loading,
    error,
    currentMonth,
    exporting,
    refresh,
    goToPreviousMonth,
    goToNextMonth,
    goToCurrentMonth,
    exportToExcel,
  };
};
