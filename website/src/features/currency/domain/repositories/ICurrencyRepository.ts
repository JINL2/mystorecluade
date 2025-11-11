import { Currency } from '../entities/Currency';

export interface CurrencyType {
  currency_id: string;
  code: string;
  symbol: string;
  name: string;
}

export interface CurrencyResult { success: boolean; data?: Currency[]; error?: string; }
export interface CurrencyTypesResult { success: boolean; data?: CurrencyType[]; error?: string; }

export interface ICurrencyRepository {
  getCurrencies(companyId: string): Promise<CurrencyResult>;
  getAllCurrencyTypes(): Promise<CurrencyTypesResult>;
  setDefaultCurrency(currencyId: string, companyId: string): Promise<{ success: boolean; error?: string; }>;
  updateExchangeRate(currencyId: string, companyId: string, newRate: number, userId: string): Promise<{ success: boolean; error?: string; }>;
  addCurrency(currencyId: string, companyId: string, exchangeRate: number, userId: string): Promise<{ success: boolean; error?: string; }>;
}
