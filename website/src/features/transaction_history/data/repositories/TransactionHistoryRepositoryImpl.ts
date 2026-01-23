/**
 * TransactionHistoryRepositoryImpl
 * Implementation of ITransactionHistoryRepository interface
 */

import {
  ITransactionHistoryRepository,
  TransactionHistoryResult,
} from '../../domain/repositories/ITransactionHistoryRepository';
import { TransactionHistoryDataSource } from '../datasources/TransactionHistoryDataSource';
import { TransactionModel } from '../models/TransactionModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class TransactionHistoryRepositoryImpl implements ITransactionHistoryRepository {
  private dataSource: TransactionHistoryDataSource;

  constructor() {
    this.dataSource = new TransactionHistoryDataSource();
  }

  async getTransactions(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string,
    accountId?: string | null
  ): Promise<TransactionHistoryResult> {
    try {
      // Convert date-only strings to UTC datetime for RPC call
      // Date format: YYYY-MM-DD → YYYY-MM-DDT00:00:00Z
      const utcStartDate = startDate
        ? DateTimeUtils.toRpcFormat(new Date(startDate + 'T00:00:00'))
        : '';
      const utcEndDate = endDate
        ? DateTimeUtils.toRpcFormat(new Date(endDate + 'T23:59:59'))
        : '';

      const data = await this.dataSource.getTransactions(
        companyId,
        storeId,
        utcStartDate,
        utcEndDate,
        accountId
      );

      // Use TransactionModel to flatten journal entries into individual transactions
      const transactions = data.flatMap((journal: any) =>
        TransactionModel.fromJournalLines(journal)
      );

      return {
        success: true,
        data: transactions,
      };
    } catch (error) {
      console.error('Repository error fetching transactions:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch transactions',
      };
    }
  }
}

// Singleton instance for dependency injection
export const transactionHistoryRepository = new TransactionHistoryRepositoryImpl();
