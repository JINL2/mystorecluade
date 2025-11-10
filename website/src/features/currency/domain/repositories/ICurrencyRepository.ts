import { Currency } from '../entities/Currency';
export interface CurrencyResult { success: boolean; data?: Currency[]; error?: string; }
export interface ICurrencyRepository {
  getCurrencies(companyId: string): Promise<CurrencyResult>;
  setDefaultCurrency(currencyId: string): Promise<{ success: boolean; error?: string; }>;
}
