/**
 * Salary Repository Implementation
 * Data layer - Implements ISalaryRepository interface
 */

import type {
  ISalaryRepository,
  SalaryDataResult,
  SalaryExportResult,
} from '../../domain/repositories/ISalaryRepository';
import { SalaryDataSource } from '../datasources/SalaryDataSource';
import { SalaryModel } from '../models/SalaryModel';

export class SalaryRepositoryImpl implements ISalaryRepository {
  private dataSource: SalaryDataSource;

  constructor() {
    this.dataSource = new SalaryDataSource();
  }

  async getSalaryData(companyId: string, month: string): Promise<SalaryDataResult> {
    try {
      const result = await this.dataSource.getSalaryData(companyId, month);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch salary data',
        };
      }

      const { records, summary } = SalaryModel.fromSupabase(result.data);

      return {
        success: true,
        records,
        summary,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async exportToExcel(companyId: string, month: string): Promise<SalaryExportResult> {
    try {
      const result = await this.dataSource.exportToExcel(companyId, month);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to export salary data',
        };
      }

      // TODO: Convert result.data to Excel Blob using SheetJS
      // For now, return a placeholder
      const blob = new Blob(['Excel export placeholder'], {
        type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });

      return {
        success: true,
        blob,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }
}
