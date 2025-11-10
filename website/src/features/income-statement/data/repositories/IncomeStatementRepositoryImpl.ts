/**
 * IncomeStatementRepositoryImpl
 * Implementation of IIncomeStatementRepository interface
 */

import {
  IIncomeStatementRepository,
  MonthlyIncomeStatementResult,
  TwelveMonthIncomeStatementResult,
} from '../../domain/repositories/IIncomeStatementRepository';
import { IncomeStatementDataSource } from '../datasources/IncomeStatementDataSource';

export class IncomeStatementRepositoryImpl implements IIncomeStatementRepository {
  private dataSource: IncomeStatementDataSource;

  constructor() {
    this.dataSource = new IncomeStatementDataSource();
  }

  /**
   * Get monthly income statement data
   * Returns raw data from RPC as-is
   */
  async getMonthlyIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<MonthlyIncomeStatementResult> {
    try {
      console.log('📊 [Repository] Getting monthly income statement');

      const data = await this.dataSource.getMonthlyIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!data || !Array.isArray(data) || data.length === 0) {
        return {
          success: false,
          error: 'No monthly income statement data available',
        };
      }

      // Get currency symbol
      const currency = await this.dataSource.getCompanyCurrency(companyId);

      console.log('✅ [Repository] Monthly income statement data processed successfully');

      return {
        success: true,
        data: data,
        currency: currency,
      };
    } catch (error) {
      console.error('❌ [Repository] Error fetching monthly income statement:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch monthly income statement',
      };
    }
  }

  /**
   * Get 12-month income statement data
   * Returns raw data from RPC as-is
   */
  async get12MonthIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<TwelveMonthIncomeStatementResult> {
    try {
      console.log('📊 [Repository] Getting 12-month income statement');

      const data = await this.dataSource.get12MonthIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!data || !data.sections || !data.months) {
        return {
          success: false,
          error: 'No 12-month income statement data available',
        };
      }

      // Get currency symbol
      const currency = await this.dataSource.getCompanyCurrency(companyId);

      console.log('✅ [Repository] 12-month income statement data processed successfully');

      return {
        success: true,
        data: data,
        currency: currency,
      };
    } catch (error) {
      console.error('❌ [Repository] Error fetching 12-month income statement:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch 12-month income statement',
      };
    }
  }
}
