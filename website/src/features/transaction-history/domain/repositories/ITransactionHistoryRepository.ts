/**
 * ITransactionHistoryRepository Interface
 * Repository interface for transaction history operations
 */

import { Transaction } from '../entities/Transaction';

export interface TransactionHistoryResult {
  success: boolean;
  data?: Transaction[];
  error?: string;
}

export interface ITransactionHistoryRepository {
  /**
   * Get transaction history for a date range
   */
  getTransactions(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string,
    accountId?: string | null
  ): Promise<TransactionHistoryResult>;
}
