/**
 * ICashEndingRepository Interface
 * Repository interface for cash ending operations
 */

import type { CashLocationEntity } from '../entities/CashLocation';
import type { CurrencyEntity } from '../entities/Currency';
import type { BalanceSummaryEntity } from '../entities/BalanceSummary';

export interface SubmitResult {
  success: boolean;
  error?: string;
}

export interface ICashEndingRepository {
  /**
   * Get cash locations for a store
   */
  getCashLocations(companyId: string, storeId: string): Promise<CashLocationEntity[]>;

  /**
   * Get currencies with exchange rates
   */
  getCurrencies(companyId: string): Promise<CurrencyEntity[]>;

  /**
   * Get balance summary for a location
   */
  getBalanceSummary(locationId: string): Promise<BalanceSummaryEntity | null>;

  /**
   * Submit cash ending - for bank type
   */
  submitBankEnding(params: {
    companyId: string;
    storeId: string;
    locationId: string;
    userId: string;
    currencies: CurrencyEntity[];
    bankAmounts: Record<string, number>;
  }): Promise<SubmitResult>;

  /**
   * Submit cash ending - for cash/vault type
   */
  submitCashVaultEnding(params: {
    companyId: string;
    storeId: string;
    locationId: string;
    locationType: 'cash' | 'vault';
    userId: string;
    currencies: CurrencyEntity[];
    denomQuantities: Record<string, number>;
    vaultTransactionType?: 'in' | 'out' | 'recount';
  }): Promise<SubmitResult>;
}
