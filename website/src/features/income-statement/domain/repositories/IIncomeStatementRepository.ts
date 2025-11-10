/**
 * IIncomeStatementRepository Interface
 * Repository interface for income statement operations
 */

import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../entities/IncomeStatementData';

export interface MonthlyIncomeStatementResult {
  success: boolean;
  data?: MonthlyIncomeStatementData;
  error?: string;
  currency?: string;
}

export interface TwelveMonthIncomeStatementResult {
  success: boolean;
  data?: TwelveMonthIncomeStatementData;
  error?: string;
  currency?: string;
}

export interface IIncomeStatementRepository {
  /**
   * Get monthly income statement data
   */
  getMonthlyIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<MonthlyIncomeStatementResult>;

  /**
   * Get 12-month income statement data
   */
  get12MonthIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ): Promise<TwelveMonthIncomeStatementResult>;
}
