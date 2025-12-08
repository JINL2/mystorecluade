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
    try {
      // Map CartItem[] to RPC items format
      // Rule:
      // - 1개 상품: p_items[0].discount_amount에 할인, p_discount_amount = null
      // - 2개 이상: p_items에 discount_amount 안 넣고, p_discount_amount에 총 할인
      const isSingleItem = invoice.items.length === 1;
      const items = invoice.items.map(item => {
        const itemData: any = {
          product_id: item.productId,
          quantity: item.quantity,
          unit_price: item.unitPrice,
        };

        // 상품이 1개일 때만 첫 번째 아이템에 discount_amount 추가
        if (isSingleItem && invoice.discountAmount > 0) {
          itemData.discount_amount = invoice.discountAmount;
        }

        return itemData;
      });

      // Format as ISO string with timezone offset for timestamptz (e.g., "2025-12-03T18:47:56+07:00")
      const now = new Date();
      const saleDate = now.toISOString();

      const rpcParams = {
        companyId: invoice.companyId,
        storeId: invoice.storeId,
        userId: invoice.userId,
        saleDate,
        items,
        paymentMethod: invoice.cashLocation.type,
        cashLocationId: invoice.cashLocation.id,
        // 상품이 2개 이상일 때만 p_discount_amount 전달
        discountAmount: isSingleItem ? undefined : invoice.discountAmount,
      };

      // Call the RPC function
      const response = await this.dataSource.submitInvoice(rpcParams);

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to submit invoice',
        };
      }

      // Submit journal entries for accounting (Sales + COGS)

      // Format description as "yyyyMMdd Sales" (using `now` from above)
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const description = `${year}${month}${day} Sales`;

      const journalResult = await this.dataSource.submitSalesJournalEntries({
        companyId: invoice.companyId,
        storeId: invoice.storeId,
        userId: invoice.userId,
        entryDateUtc: saleDate,
        description,
        totalAmount: invoice.total,
        totalCost: invoice.totalCost,
        cashLocationId: invoice.cashLocation.id,
        invoiceId: response.invoice_id, // Pass invoice_id from inventory_create_invoice_v4 response
      });

      if (!journalResult.success) {
        return {
          success: false,
          error: `Invoice created but journal entries failed: ${journalResult.error}`,
        };
      }

      return {
        success: true,
        invoiceId: response.invoiceNumber,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
