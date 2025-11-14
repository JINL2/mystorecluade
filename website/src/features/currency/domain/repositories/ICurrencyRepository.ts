import { Currency } from '../entities/Currency';
import type { CurrencyTypeDTO } from '../../data/models/CurrencyTypeModel';

export interface CurrencyResult { success: boolean; data?: Currency[]; error?: string; }
export interface CurrencyTypesResult { success: boolean; data?: CurrencyTypeDTO[]; error?: string; }

export interface ICurrencyRepository {
  getCurrencies(companyId: string): Promise<CurrencyResult>;
  getAllCurrencyTypes(): Promise<CurrencyTypesResult>;
  setDefaultCurrency(currencyId: string, companyId: string): Promise<{ success: boolean; error?: string; }>;
  updateExchangeRate(currencyId: string, companyId: string, newRate: number, userId: string): Promise<{ success: boolean; error?: string; }>;
  addCurrency(currencyId: string, companyId: string, exchangeRate: number, userId: string): Promise<{ success: boolean; error?: string; }>;
  removeCurrency(currencyId: string, companyId: string): Promise<{ success: boolean; error?: string; }>;
}
