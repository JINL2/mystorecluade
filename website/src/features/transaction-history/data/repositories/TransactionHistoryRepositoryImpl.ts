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

      // Flatten journal entries with their lines into individual transactions
      const transactions: Transaction[] = [];

      data.forEach((journal: any) => {
        if (journal.lines && Array.isArray(journal.lines)) {
          journal.lines.forEach((line: any) => {
            transactions.push(
              new Transaction(
                line.line_id || journal.journal_id,
                journal.entry_date,
                line.account_name || '',
                line.description || journal.description || '',
                line.debit || 0,
                line.credit || 0,
                0, // Balance calculation would need to be done separately
                null, // category_tag not in line structure
                line.counterparty?.name || line.display_counterparty || null,
                journal.currency_symbol || '₩'
              )
            );
          });
        }
      });

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
