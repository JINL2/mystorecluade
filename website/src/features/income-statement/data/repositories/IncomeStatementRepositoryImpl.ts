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
import { IncomeStatementModel } from '../models/IncomeStatementModel';

export class IncomeStatementRepositoryImpl implements IIncomeStatementRepository {
  private dataSource: IncomeStatementDataSource;

  constructor() {
    this.dataSource = new IncomeStatementDataSource();
  }

  /**
   * Get monthly income statement data
   * Uses Model to transform RPC response to Domain Entity
   */
  async getMonthlyIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<MonthlyIncomeStatementResult> {
    try {
      console.log('📊 [Repository] Getting monthly income statement');

      const rawData = await this.dataSource.getMonthlyIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!rawData || !Array.isArray(rawData) || rawData.length === 0) {
        return {
          success: false,
          error: 'No monthly income statement data available',
        };
      }

      // Get currency symbol
      const currency = await this.dataSource.getBaseCurrencySymbol(companyId);

      // Transform RPC response to Domain Entity using Model (with currency)
      const data = IncomeStatementModel.fromMonthlyRpcResponse(rawData, currency);

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
   * Uses Model to transform RPC response to Domain Entity
   */
  async get12MonthIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<TwelveMonthIncomeStatementResult> {
    try {
      console.log('📊 [Repository] Getting 12-month income statement');

      const rawData = await this.dataSource.get12MonthIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!rawData || !rawData.sections || !rawData.months) {
        return {
          success: false,
          error: 'No 12-month income statement data available',
        };
      }

      // Get currency symbol
      const currency = await this.dataSource.getBaseCurrencySymbol(companyId);

      // Transform RPC response to Domain Entity using Model (with currency)
      const data = IncomeStatementModel.from12MonthRpcResponse(rawData, currency);

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
