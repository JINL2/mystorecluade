/**
 * Salary Repository Interface
 * Domain layer - Contract for salary data operations
 */

import { SalaryRecord } from '../entities/SalaryRecord';
import { SalarySummary } from '../entities/SalarySummary';

export interface SalaryDataResult {
  success: boolean;
  records?: SalaryRecord[];
  summary?: SalarySummary;
  error?: string;
}

export interface SalaryExportResult {
  success: boolean;
  blob?: Blob;
  filename?: string;
  recordCount?: number;
  error?: string;
}

export interface ISalaryRepository {
  /**
   * Get salary records for a specific month
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @param storeId - Optional store filter
   * @returns SalaryDataResult with records and summary
   */
  getSalaryData(companyId: string, month: string, storeId?: string | null): Promise<SalaryDataResult>;

  /**
   * Export salary data to Excel
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @param storeId - Optional store filter
   * @param companyName - Company name for filename
   * @param storeName - Store name for filename
   * @returns SalaryExportResult with Excel blob
   */
  exportToExcel(
    companyId: string,
    month: string,
    storeId?: string | null,
    companyName?: string,
    storeName?: string
  ): Promise<SalaryExportResult>;
}
