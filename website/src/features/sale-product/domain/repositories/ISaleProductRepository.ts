/**
 * ISaleProductRepository
 * Repository interface defining data operations for sale-product feature
 */

import { Product } from '../entities/Product';
import { ExchangeRate } from '../entities/ExchangeRate';
import { CashLocation } from '../entities/CashLocation';
import { SaleInvoice } from '../entities/SaleInvoice';

export interface PaginationResult<T> {
  items: T[];
  currentPage: number;
  totalPages: number;
  totalCount: number;
}

export interface ISaleProductRepository {
  /**
   * Get paginated products for sale
   */
  getProducts(
    companyId: string,
    storeId: string,
    page: number,
    limit: number,
    search?: string
  ): Promise<PaginationResult<Product>>;

  /**
   * Get base currency for a company
   */
  getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }>;

  /**
   * Get exchange rates for a company (excluding base currency)
   */
  getExchangeRates(companyId: string): Promise<ExchangeRate[]>;

  /**
   * Get cash locations for a company and store
   */
  getCashLocations(
    companyId: string,
    storeId: string | null
  ): Promise<CashLocation[]>;

  /**
   * Submit a sale invoice
   */
  submitSaleInvoice(invoice: SaleInvoice): Promise<{
    success: boolean;
    invoiceId?: string;
    error?: string;
  }>;
}
