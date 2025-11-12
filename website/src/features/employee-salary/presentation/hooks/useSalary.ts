/**
 * useSalary Hook
 * Presentation layer - Custom hook for salary data management
 */

import { useState, useEffect, useCallback } from 'react';
import { SalaryRecord } from '../../domain/entities/SalaryRecord';
import { SalarySummary } from '../../domain/entities/SalarySummary';
import { SalaryRepositoryImpl } from '../../data/repositories/SalaryRepositoryImpl';
import { SalaryValidator } from '../../domain/validators/SalaryValidator';

export interface SalaryNotification {
  variant: 'success' | 'error' | 'warning' | 'info';
  message: string;
  title?: string;
}

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
  const [notification, setNotification] = useState<SalaryNotification | null>(null);

  const repository = new SalaryRepositoryImpl();

  const loadSalaryData = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      // Validate input parameters before making API call
      const validationErrors = SalaryValidator.validateSalaryQuery(companyId, currentMonth);

      if (validationErrors.length > 0) {
        const errorMessages = validationErrors.map((err) => err.message).join(', ');
        setError(errorMessages);
        setRecords([]);
        setSummary(null);
        setLoading(false);
        return;
      }

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

  const exportToExcel = async (
    storeId: string | null = null,
    companyName: string = 'Company',
    storeName: string = 'AllStores'
  ) => {
    // Validate input parameters before export
    const validationErrors = SalaryValidator.validateExcelExport(
      companyId,
      currentMonth,
      companyName,
      storeName
    );

    if (validationErrors.length > 0) {
      const errorMessages = validationErrors.map((err) => err.message).join(', ');
      setNotification({
        variant: 'error',
        title: 'Validation Error',
        message: errorMessages,
      });
      return { success: false };
    }

    // Validate optional storeId if provided
    if (storeId !== null) {
      const storeErrors = SalaryValidator.validateStoreId(storeId);
      if (storeErrors.length > 0) {
        const errorMessages = storeErrors.map((err) => err.message).join(', ');
        setNotification({
          variant: 'error',
          title: 'Validation Error',
          message: errorMessages,
        });
        return { success: false };
      }
    }

    // Try to get file handle immediately with user gesture
    let fileHandle: any = null;

    // Check if File System Access API is available
    if ('showSaveFilePicker' in window) {
      try {
        const cleanName = (str: string) =>
          str.replace(/[^a-zA-Z0-9가-힣\s-]/g, '').replace(/\s+/g, '_');
        const suggestedFilename = `ShiftRecords_${cleanName(companyName)}_${cleanName(storeName)}_${currentMonth}.xlsx`;

        // Show save dialog immediately
        fileHandle = await (window as any).showSaveFilePicker({
          suggestedName: suggestedFilename,
          types: [
            {
              description: 'Excel Files',
              accept: {
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
              },
            },
          ],
          excludeAcceptAllOption: true,
        });

        console.log('File handle obtained successfully');
      } catch (err: any) {
        if (err && err.name === 'AbortError') {
          console.log('User cancelled file selection');
          return; // User cancelled
        }
        console.log('Could not get file handle:', err?.name || 'Unknown error');
        // Continue with fallback
      }
    }

    setExporting(true);
    try {
      const result = await repository.exportToExcel(
        companyId,
        currentMonth,
        storeId,
        companyName,
        storeName
      );

      if (!result.success || !result.blob) {
        throw new Error(result.error || 'Failed to export data');
      }

      const blob = result.blob;
      const filename = result.filename || `salary_${currentMonth}.xlsx`;

      // If we have a file handle, use it
      if (fileHandle) {
        try {
          console.log('Writing to pre-obtained file handle...');
          const writable = await fileHandle.createWritable();
          await writable.write(blob);
          await writable.close();

          console.log(`Excel file saved successfully: ${filename}`);
          setNotification({
            variant: 'success',
            message: `${result.recordCount || 0} shift records exported successfully to: ${filename}`,
          });
        } catch (error) {
          console.error('Failed to write to file handle:', error);
          // Fall back to traditional download
          fallbackDownload(blob, filename);
        }
      } else {
        // Traditional download fallback
        fallbackDownload(blob, filename);
      }
      return { success: true };
    } catch (err) {
      console.error('Export error:', err);
      setNotification({
        variant: 'error',
        title: 'Export Failed',
        message: err instanceof Error ? err.message : 'Failed to export data',
      });
      return { success: false };
    } finally {
      setExporting(false);
    }
  };

  // Fallback download function
  const fallbackDownload = (blob: Blob, filename: string) => {
    try {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      a.style.display = 'none';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      setTimeout(() => {
        const message = `📁 File "${filename}" is being saved to your browser's default download folder. To change download location, check your browser settings.`;
        console.log(message);
      }, 1000);
    } catch (error) {
      console.error('Fallback download failed:', error);
      setNotification({
        variant: 'error',
        title: 'Download Failed',
        message: 'Failed to download the Excel file. Please try again.',
      });
    }
  };

  return {
    records,
    summary,
    loading,
    error,
    currentMonth,
    exporting,
    notification,
    setNotification,
    refresh,
    goToPreviousMonth,
    goToNextMonth,
    goToCurrentMonth,
    exportToExcel,
  };
};
