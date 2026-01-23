/**
 * IBalanceSheetRepository Interface
 * Repository interface for balance sheet operations
 */

import { BalanceSheetData } from '../entities/BalanceSheetData';

export interface BalanceSheetResult {
  success: boolean;
  data?: BalanceSheetData;
  error?: string;
}

export interface IBalanceSheetRepository {
  /**
   * Get balance sheet data filtered by store
   */
  getBalanceSheet(companyId: string, storeId: string | null): Promise<BalanceSheetResult>;
}
