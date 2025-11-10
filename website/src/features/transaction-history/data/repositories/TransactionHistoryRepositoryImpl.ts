/**
 * TransactionHistoryRepositoryImpl
 * Implementation of ITransactionHistoryRepository interface
 */

import {
  ITransactionHistoryRepository,
  TransactionHistoryResult,
} from '../../domain/repositories/ITransactionHistoryRepository';
import { Transaction } from '../../domain/entities/Transaction';
import { TransactionHistoryDataSource } from '../datasources/TransactionHistoryDataSource';

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
      const data = await this.dataSource.getTransactions(
        companyId,
        storeId,
        startDate,
        endDate,
        accountId
      );

      const transactions = data.map(
        (item: any) =>
          new Transaction(
            item.transaction_id,
            item.date,
            item.account_name,
            item.description,
            item.debit_amount,
            item.credit_amount,
            item.balance,
            item.category_tag,
            item.counterparty_name,
            item.currency_symbol || '₩'
          )
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
