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
  error?: string;
}

export interface ISalaryRepository {
  /**
   * Get salary records for a specific month
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @returns SalaryDataResult with records and summary
   */
  getSalaryData(companyId: string, month: string): Promise<SalaryDataResult>;

  /**
   * Export salary data to Excel
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @returns SalaryExportResult with Excel blob
   */
  exportToExcel(companyId: string, month: string): Promise<SalaryExportResult>;
}
