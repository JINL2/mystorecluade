import { ICurrencyRepository, CurrencyResult, CurrencyTypesResult } from '../../domain/repositories/ICurrencyRepository';
import { Currency } from '../../domain/entities/Currency';
import { CurrencyDataSource } from '../datasources/CurrencyDataSource';

export class CurrencyRepositoryImpl implements ICurrencyRepository {
  private dataSource = new CurrencyDataSource();
  async getCurrencies(companyId: string): Promise<CurrencyResult> {
    try {
      const data = await this.dataSource.getCurrencies(companyId);
      const currencies = data.map((d: any) => new Currency(d.currency_id, d.company_id, d.code, d.symbol, d.name, d.is_default, d.exchange_rate));
      return { success: true, data: currencies };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async getAllCurrencyTypes(): Promise<CurrencyTypesResult> {
    try {
      const data = await this.dataSource.getAllCurrencyTypes();
      return { success: true, data };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async setDefaultCurrency(currencyId: string, companyId: string) {
    try {
      await this.dataSource.setDefaultCurrency(currencyId, companyId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async updateExchangeRate(currencyId: string, companyId: string, newRate: number, userId: string) {
    try {
      await this.dataSource.updateExchangeRate(currencyId, companyId, newRate, userId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async addCurrency(currencyId: string, companyId: string, exchangeRate: number, userId: string) {
    try {
      await this.dataSource.addCurrency(currencyId, companyId, exchangeRate, userId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
}
