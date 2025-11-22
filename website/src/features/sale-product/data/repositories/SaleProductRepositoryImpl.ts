/**
 * SaleProductRepositoryImpl
 * Implementation of ISaleProductRepository
 */

import {
  ISaleProductRepository,
  PaginationResult,
} from '../../domain/repositories/ISaleProductRepository';
import { Product } from '../../domain/entities/Product';
import { ExchangeRate } from '../../domain/entities/ExchangeRate';
import { CashLocation } from '../../domain/entities/CashLocation';
import { SaleInvoice } from '../../domain/entities/SaleInvoice';
import { SaleProductDataSource } from '../datasources/SaleProductDataSource';
import { ProductModel } from '../models/ProductModel';
import { ExchangeRateModel } from '../models/ExchangeRateModel';
import { CashLocationModel } from '../models/CashLocationModel';

export class SaleProductRepositoryImpl implements ISaleProductRepository {
  private dataSource: SaleProductDataSource;

  constructor() {
    this.dataSource = new SaleProductDataSource();
  }

  async getProducts(
    companyId: string,
    storeId: string,
    page: number,
    limit: number,
    search?: string
  ): Promise<PaginationResult<Product>> {
    const response = await this.dataSource.getProducts(
      companyId,
      storeId,
      page,
      limit,
      search
    );

    if (!response?.success || !response?.data) {
      throw new Error('Failed to load products');
    }

    const productsData = response.data.products || [];
    const products = ProductModel.toDomainList(productsData);

    const pagination = response.data.pagination || {};
    const totalCount = pagination.total_count || pagination.total || 0;
    const totalPages =
      pagination.total_pages || Math.ceil(totalCount / limit) || 1;

    return {
      items: products,
      currentPage: page,
      totalPages,
      totalCount,
    };
  }

  async getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }> {
    return await this.dataSource.getBaseCurrency(companyId);
  }

  async getExchangeRates(companyId: string): Promise<ExchangeRate[]> {
    const response = await this.dataSource.getExchangeRates(companyId);

    if (!response || !response.exchange_rates) {
      return [];
    }

    // Filter out base currency and convert to domain entities
    return ExchangeRateModel.filterAndConvertForeignCurrencies(
      response.exchange_rates
    );
  }

  async getCashLocations(
    companyId: string,
    storeId: string | null
  ): Promise<CashLocation[]> {
    const response = await this.dataSource.getCashLocations(companyId, storeId);

    if (!response || response.length === 0) {
      return [];
    }

    // Filter out deleted locations and convert to domain entities
    return CashLocationModel.filterAndConvertActive(response);
  }

  async submitSaleInvoice(invoice: SaleInvoice): Promise<{
    success: boolean;
    invoiceId?: string;
    error?: string;
  }> {
    // TODO: Implement RPC call for submitting sale invoice
    // This will be implemented when the backend RPC function is ready

    // For now, return a mock success response
    console.log('Submit invoice:', invoice);

    return {
      success: true,
      invoiceId: `INV-${Date.now()}`,
    };
  }
}
