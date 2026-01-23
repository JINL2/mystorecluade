/**
 * CashEndingRepositoryImpl
 * Repository implementation for cash ending operations
 */

import {
  cashEndingDataSource,
  type CurrencyPayload,
} from '../datasources/CashEndingDataSource';
import { CashLocationModel } from '../models/CashLocationModel';
import { CurrencyModel } from '../models/CurrencyModel';
import { BalanceSummaryModel } from '../models/BalanceSummaryModel';
import type { CashLocationEntity } from '../../domain/entities/CashLocation';
import type { CurrencyEntity } from '../../domain/entities/Currency';
import type { BalanceSummaryEntity } from '../../domain/entities/BalanceSummary';
import type {
  ICashEndingRepository,
  SubmitResult,
} from '../../domain/repositories/ICashEndingRepository';

export class CashEndingRepository implements ICashEndingRepository {
  /**
   * Get cash locations for a store
   */
  async getCashLocations(companyId: string, storeId: string): Promise<CashLocationEntity[]> {
    const data = await cashEndingDataSource.getCashLocations(companyId, storeId);
    return data.map((item) => CashLocationModel.fromJson(item));
  }

  /**
   * Get currencies with exchange rates
   */
  async getCurrencies(companyId: string): Promise<CurrencyEntity[]> {
    const today = new Date().toISOString().split('T')[0];
    const data = await cashEndingDataSource.getCurrencies(companyId, today);
    return data.map((item) => CurrencyModel.fromJson(item));
  }

  /**
   * Get balance summary for a location
   */
  async getBalanceSummary(locationId: string): Promise<BalanceSummaryEntity | null> {
    const data = await cashEndingDataSource.getBalanceSummary(locationId);
    return data ? BalanceSummaryModel.fromJson(data) : null;
  }

  /**
   * Submit cash ending - for bank type
   */
  async submitBankEnding(params: {
    companyId: string;
    storeId: string;
    locationId: string;
    userId: string;
    currencies: CurrencyEntity[];
    bankAmounts: Record<string, number>;
  }): Promise<SubmitResult> {
    try {
      const currenciesPayload: CurrencyPayload[] = params.currencies
        .filter(currency => (params.bankAmounts[currency.currencyId] || 0) > 0)
        .map(currency => ({
          currency_id: currency.currencyId,
          total_amount: params.bankAmounts[currency.currencyId] || 0,
        }));

      if (currenciesPayload.length === 0) {
        return { success: false, error: 'Please enter at least one bank amount' };
      }

      const today = new Date().toISOString().split('T')[0];

      await cashEndingDataSource.submitCashEnding({
        companyId: params.companyId,
        storeId: params.storeId,
        locationId: params.locationId,
        entryType: 'bank',
        currencies: currenciesPayload,
        recordDate: today,
        createdBy: params.userId,
        description: 'Bank ending entry',
        vaultTransactionType: null,
      });

      return { success: true };
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : 'Unknown error';
      return { success: false, error: errMsg };
    }
  }

  /**
   * Submit cash ending - for cash/vault type
   */
  async submitCashVaultEnding(params: {
    companyId: string;
    storeId: string;
    locationId: string;
    locationType: 'cash' | 'vault';
    userId: string;
    currencies: CurrencyEntity[];
    denomQuantities: Record<string, number>;
    vaultTransactionType?: 'in' | 'out' | 'recount';
  }): Promise<SubmitResult> {
    try {
      const currenciesPayload: CurrencyPayload[] = params.currencies
        .map(currency => {
          const denominations = currency.denominations
            .filter(denom => (params.denomQuantities[denom.denomination_id] || 0) > 0)
            .map(denom => ({
              denomination_id: denom.denomination_id,
              quantity: params.denomQuantities[denom.denomination_id] || 0,
            }));

          return {
            currency_id: currency.currencyId,
            denominations,
          };
        })
        .filter(c => c.denominations && c.denominations.length > 0);

      if (currenciesPayload.length === 0) {
        return { success: false, error: 'Please enter at least one denomination quantity' };
      }

      const today = new Date().toISOString().split('T')[0];

      await cashEndingDataSource.submitCashEnding({
        companyId: params.companyId,
        storeId: params.storeId,
        locationId: params.locationId,
        entryType: params.locationType,
        currencies: currenciesPayload,
        recordDate: today,
        createdBy: params.userId,
        description: 'Cash ending entry',
        vaultTransactionType: params.locationType === 'vault' ? (params.vaultTransactionType || 'recount') : null,
      });

      return { success: true };
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : 'Unknown error';
      return { success: false, error: errMsg };
    }
  }
}

export const cashEndingRepository = new CashEndingRepository();
