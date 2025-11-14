/**
 * CashEndingRepositoryImpl
 * Implementation of ICashEndingRepository interface
 */

import {
  ICashEndingRepository,
  CashEndingResult,
} from '../../domain/repositories/ICashEndingRepository';
import { CashEndingDataSource } from '../datasources/CashEndingDataSource';
import { CashEndingModel } from '../models/CashEndingModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { ACCOUNT_IDS } from '@/core/constants/account-ids';

interface JournalLine {
  account_id: string;
  description: string;
  debit: number;
  credit: number;
  cash?: {
    cash_location_id: string;
  };
}

interface CreateJournalParams {
  companyId: string;
  userId: string;
  storeId: string | null;
  cashLocationId: string;
  difference: number;
  type: 'error' | 'exchange';
}

export class CashEndingRepositoryImpl implements ICashEndingRepository {
  private dataSource: CashEndingDataSource;

  constructor() {
    this.dataSource = new CashEndingDataSource();
  }

  async getCashEndings(
    companyId: string,
    storeId: string | null
  ): Promise<CashEndingResult> {
    try {
      // Load cash locations and balance/actual amounts
      const locations = await this.dataSource.getCashLocations(companyId);
      const balanceData = await this.dataSource.getBalanceAndActualAmounts(companyId, storeId);

      console.log('Cash locations:', locations);
      console.log('Balance data:', balanceData);

      // Parse balance/actual response using CashEndingModel
      const { balance, actual } = CashEndingModel.parseBalanceActualResponse(balanceData);

      // Convert locations with balance/actual data to CashEnding entities
      const cashEndings = CashEndingModel.fromLocationList(locations, balance, actual);

      return {
        success: true,
        data: cashEndings,
      };
    } catch (error) {
      console.error('Repository error fetching cash endings:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch cash endings',
      };
    }
  }

  async createJournalEntry(params: CreateJournalParams): Promise<{ success: boolean; error?: string }> {
    const { companyId, userId, storeId, cashLocationId, difference, type } = params;

    try {
      // Get current date in RPC format (UTC)
      const now = new Date();
      const dateStr = DateTimeUtils.toRpcFormat(now);

      // Create description based on type
      const description = type === 'error'
        ? `Make Error ${dateStr}`
        : `Exchange Rate Difference ${dateStr}`;

      // Get absolute difference
      const absDifference = Math.abs(difference);

      // Use account IDs from constants
      const cashAccountId = ACCOUNT_IDS.CASH;
      const errorAccountId = ACCOUNT_IDS.MAKE_ERROR;
      const exchangeRateAccountId = ACCOUNT_IDS.EXCHANGE_RATE_DIFFERENCE;

      // Select appropriate account based on type
      const offsetAccountId = type === 'error' ? errorAccountId : exchangeRateAccountId;

      // Create journal lines based on difference direction
      const lines: JournalLine[] = [];

      if (difference > 0) {
        // Positive difference: debit cash, credit offset account
        lines.push({
          account_id: cashAccountId,
          description: description,
          debit: absDifference,
          credit: 0,
          cash: {
            cash_location_id: cashLocationId
          }
        });
        lines.push({
          account_id: offsetAccountId,
          description: description,
          debit: 0,
          credit: absDifference
        });
      } else {
        // Negative difference: credit cash, debit offset account
        lines.push({
          account_id: cashAccountId,
          description: description,
          debit: 0,
          credit: absDifference,
          cash: {
            cash_location_id: cashLocationId
          }
        });
        lines.push({
          account_id: offsetAccountId,
          description: description,
          debit: absDifference,
          credit: 0
        });
      }

      // Prepare RPC parameters
      const rpcParams = {
        p_base_amount: absDifference,
        p_company_id: companyId,
        p_created_by: userId,
        p_description: description,
        p_entry_date: dateStr,
        p_lines: lines,
        p_store_id: storeId
      };

      console.log('Calling insert_journal_with_everything with params:', rpcParams);

      // Call DataSource
      const result = await this.dataSource.createJournalEntry(rpcParams);

      if (!result.success) {
        return {
          success: false,
          error: result.error
        };
      }

      console.log('Journal entry created successfully:', result.data);
      return {
        success: true
      };

    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Unknown error occurred';
      console.error('Error in createJournalEntry:', err);
      return {
        success: false,
        error: errorMessage
      };
    }
  }
}
