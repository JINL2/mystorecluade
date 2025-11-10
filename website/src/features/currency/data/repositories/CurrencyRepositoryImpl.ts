import { ICurrencyRepository, CurrencyResult } from '../../domain/repositories/ICurrencyRepository';
import { Currency } from '../../domain/entities/Currency';
import { CurrencyDataSource } from '../datasources/CurrencyDataSource';

export class CurrencyRepositoryImpl implements ICurrencyRepository {
  private dataSource = new CurrencyDataSource();
  async getCurrencies(companyId: string): Promise<CurrencyResult> {
    try {
      const data = await this.dataSource.getCurrencies(companyId);
      const currencies = data.map((d: any) => new Currency(d.currency_id, d.company_id, d.code, d.symbol, d.name, d.is_default));
      return { success: true, data: currencies };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async setDefaultCurrency(currencyId: string) {
    try {
      await this.dataSource.setDefaultCurrency(currencyId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
}
