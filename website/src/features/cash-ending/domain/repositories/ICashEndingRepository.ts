/**
 * ICashEndingRepository Interface
 * Repository interface for cash ending operations
 */

import { CashEnding } from '../entities/CashEnding';

export interface CashEndingResult {
  success: boolean;
  data?: CashEnding[];
  error?: string;
}

export interface ICashEndingRepository {
  /**
   * Get cash ending currency configuration
   */
  getCashEndings(
    companyId: string,
    storeId: string | null
  ): Promise<CashEndingResult>;
}
