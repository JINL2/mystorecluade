/**
 * Salary Provider
 * Following 2025 Best Practice - Zustand Store
 */

import { create } from 'zustand';
import { SalaryState, AsyncOperationResult } from './states/salary_state';
import { SalaryRepositoryImpl } from '../../data/repositories/SalaryRepositoryImpl';
import { SalaryValidator } from '../../domain/validators/SalaryValidator';

const repository = new SalaryRepositoryImpl();

// Helper: Get current month in YYYY-MM format
const getCurrentMonth = () => {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
};

export const useSalaryStore = create<SalaryState>((set, get) => ({
  // ==================== Initial State ====================
  records: [],
  summary: null,
  currentMonth: getCurrentMonth(),
  companyId: '',
  loading: false,
  exporting: false,
  error: null,
  notification: null,

  // ==================== Data Actions ====================
  setRecords: (records) => set({ records }),
  setSummary: (summary) => set({ summary }),
  setCurrentMonth: (month) => set({ currentMonth: month }),
  setCompanyId: (companyId) => set({ companyId }),

  // ==================== Loading Actions ====================
  setLoading: (loading) => set({ loading }),
  setExporting: (exporting) => set({ exporting }),

  // ==================== Error Actions ====================
  setError: (error) => set({ error }),
  setNotification: (notification) => set({ notification }),
  clearErrors: () => set({ error: null, notification: null }),

  // ==================== Async Actions ====================

  loadSalaryData: async (companyId: string, month: string, storeId?: string | null): Promise<AsyncOperationResult> => {
    set({ loading: true, error: null });

    try {
      // Validate input parameters before making API call
      const validationErrors = SalaryValidator.validateSalaryQuery(companyId, month);

      if (validationErrors.length > 0) {
        const errorMessages = validationErrors.map((err) => err.message).join(', ');
        set({
          error: errorMessages,
          records: [],
          summary: null,
          loading: false,
        });
        return { success: false, error: errorMessages };
      }

      const result = await repository.getSalaryData(companyId, month, storeId);

      if (!result.success) {
        const errorMsg = result.error || 'Failed to load salary data';
        set({
          error: errorMsg,
          records: [],
          summary: null,
        });
        return { success: false, error: errorMsg };
      }

      set({
        records: result.records || [],
        summary: result.summary || null,
        error: null,
      });

      return { success: true };
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : 'An unexpected error occurred';
      set({
        error: errorMsg,
        records: [],
        summary: null,
      });
      return { success: false, error: errorMsg };
    } finally {
      set({ loading: false });
    }
  },

  refresh: async (): Promise<AsyncOperationResult> => {
    const { companyId, currentMonth, loadSalaryData } = get();
    if (!companyId) {
      return { success: false, error: 'Company ID is required' };
    }
    return loadSalaryData(companyId, currentMonth);
  },

  goToPreviousMonth: () => {
    const currentMonth = get().currentMonth;
    const [year, month] = currentMonth.split('-').map(Number);
    const date = new Date(year, month - 1, 1);
    date.setMonth(date.getMonth() - 1);
    const newMonth = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    set({ currentMonth: newMonth });
  },

  goToNextMonth: () => {
    const currentMonth = get().currentMonth;
    const [year, month] = currentMonth.split('-').map(Number);
    const date = new Date(year, month - 1, 1);
    date.setMonth(date.getMonth() + 1);
    const newMonth = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    set({ currentMonth: newMonth });
  },

  goToCurrentMonth: () => {
    set({ currentMonth: getCurrentMonth() });
  },

  exportToExcel: async (
    storeId: string | null,
    companyName: string,
    storeName: string,
    selectedColumns?: string[]
  ): Promise<AsyncOperationResult> => {
    const { companyId, currentMonth } = get();

    // Validate input parameters before export
    const validationErrors = SalaryValidator.validateExcelExport(
      companyId,
      currentMonth,
      companyName,
      storeName
    );

    if (validationErrors.length > 0) {
      const errorMessages = validationErrors.map((err) => err.message).join(', ');
      set({
        notification: {
          variant: 'error',
          title: 'Validation Error',
          message: errorMessages,
        },
      });
      return { success: false, error: errorMessages };
    }

    // Validate optional storeId if provided
    if (storeId !== null) {
      const storeErrors = SalaryValidator.validateStoreId(storeId);
      if (storeErrors.length > 0) {
        const errorMessages = storeErrors.map((err) => err.message).join(', ');
        set({
          notification: {
            variant: 'error',
            title: 'Validation Error',
            message: errorMessages,
          },
        });
        return { success: false, error: errorMessages };
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

      } catch (err: any) {
        if (err && err.name === 'AbortError') {
          return { success: false, error: 'User cancelled' };
        }
        // Continue with fallback
      }
    }

    set({ exporting: true });
    try {
      const result = await repository.exportToExcel(
        companyId,
        currentMonth,
        storeId,
        companyName,
        storeName,
        selectedColumns
      );

      if (!result.success || !result.blob) {
        throw new Error(result.error || 'Failed to export data');
      }

      const blob = result.blob;
      const filename = result.filename || `salary_${currentMonth}.xlsx`;

      // If we have a file handle, use it
      if (fileHandle) {
        try {
          const writable = await fileHandle.createWritable();
          await writable.write(blob);
          await writable.close();

          set({
            notification: {
              variant: 'success',
              message: `${result.recordCount || 0} shift records exported successfully to: ${filename}`,
            },
          });
        } catch {
          // Fall back to traditional download
          fallbackDownload(blob, filename, set);
        }
      } else {
        // Traditional download fallback
        fallbackDownload(blob, filename, set);
      }
      return { success: true };
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : 'Failed to export data';
      set({
        notification: {
          variant: 'error',
          title: 'Export Failed',
          message: errorMsg,
        },
      });
      return { success: false, error: errorMsg };
    } finally {
      set({ exporting: false });
    }
  },

  // ==================== Reset ====================
  reset: () =>
    set({
      records: [],
      summary: null,
      currentMonth: getCurrentMonth(),
      companyId: '',
      loading: false,
      exporting: false,
      error: null,
      notification: null,
    }),
}));

// Fallback download function
const fallbackDownload = (blob: Blob, filename: string, set: any) => {
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
      set({
        notification: {
          variant: 'success',
          message: `File "${filename}" has been downloaded successfully.`,
        },
      });
    }, 1000);
  } catch {
    set({
      notification: {
        variant: 'error',
        title: 'Download Failed',
        message: 'Failed to download the Excel file. Please try again.',
      },
    });
  }
};
