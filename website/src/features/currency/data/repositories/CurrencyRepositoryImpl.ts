import { ICurrencyRepository, CurrencyResult, CurrencyTypesResult } from '../../domain/repositories/ICurrencyRepository';
import { CurrencyDataSource } from '../datasources/CurrencyDataSource';
import { CurrencyModel } from '../models/CurrencyModel';

export class CurrencyRepositoryImpl implements ICurrencyRepository {
  private dataSource = new CurrencyDataSource();
  async getCurrencies(companyId: string): Promise<CurrencyResult> {
    try {
      const dtos = await this.dataSource.getCurrencies(companyId);
      const currencies = dtos.map(dto => CurrencyModel.toEntity(dto));
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
  async removeCurrency(currencyId: string, companyId: string) {
    try {
      await this.dataSource.removeCurrency(currencyId, companyId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
}
