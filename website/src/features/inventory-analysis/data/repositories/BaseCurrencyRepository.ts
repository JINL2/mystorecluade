/**
 * BaseCurrency Repository
 * Repository layer for base currency data
 */

import {
  baseCurrencyDataSource,
  GetBaseCurrencyParams,
} from '../datasources/BaseCurrencyDataSource';
import type { BaseCurrencyResponse } from '../../domain/entities/baseCurrency';

export class BaseCurrencyRepository {
  async getBaseCurrency(params: GetBaseCurrencyParams): Promise<BaseCurrencyResponse> {
    return baseCurrencyDataSource.getBaseCurrency(params);
  }
}

// Singleton instance
export const baseCurrencyRepository = new BaseCurrencyRepository();
