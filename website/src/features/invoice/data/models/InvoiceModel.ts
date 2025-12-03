/**
 * InvoiceModel
 * DTO (Data Transfer Object) + Mapper for Invoice
 * Handles conversion between API data and Domain entities
 */

import { Invoice } from '../../domain/entities/Invoice';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class InvoiceModel {
  /**
   * Convert API response data to Invoice entity
   * Supports both get_invoice_page (v1) and get_invoice_page_v2 response structures
   */
  static fromJson(json: any, currencySymbol?: string): Invoice {
    const customerName = json.customer?.name || 'Walk-in';
    const customerPhone = json.customer?.phone || null;
    const itemCount = json.items_summary?.item_count || 0;
    const totalQuantity = json.items_summary?.total_quantity || 0;
    const totalAmount = json.amounts?.total_amount || 0;
    const totalCost = json.amounts?.total_cost || 0;
    const profit = json.amounts?.profit || 0;
    const subtotal = json.amounts?.subtotal || 0;
    const taxAmount = json.amounts?.tax_amount || 0;
    const discountAmount = json.amounts?.discount_amount || 0;
    const symbol = currencySymbol || json.amounts?.currency_symbol || json.store?.currency_symbol || '';
    const paymentMethod = json.payment?.method || 'cash';
    const paymentStatus = json.payment?.status || 'pending';
    // sale_date is already converted to local timezone by RPC (p_timezone)
    const saleDate = json.sale_date || json.invoice_date;
    const invoiceDate = saleDate ? new Date(saleDate).toISOString() : '';
    // Store info
    const storeId = json.store?.store_id || json.store_id || '';
    const storeName = json.store?.store_name || '';
    const storeCode = json.store?.store_code || '';
    // Cash location info
    const cashLocationId = json.cash_location?.cash_location_id || null;
    const cashLocationName = json.cash_location?.location_name || null;
    const cashLocationType = json.cash_location?.location_type || null;
    // Created by info
    const createdByName = json.created_by?.name || '';
    const createdByEmail = json.created_by?.email || '';
    // Created at timestamp
    const createdAt = json.created_at || '';

    return new Invoice(
      json.invoice_id,
      json.invoice_number,
      invoiceDate,
      storeId,
      cashLocationId,
      customerName,
      customerPhone,
      itemCount,
      totalQuantity,
      totalAmount,
      json.status,
      symbol,
      paymentMethod,
      paymentStatus,
      totalCost,
      profit,
      storeName,
      storeCode,
      cashLocationName,
      cashLocationType,
      subtotal,
      taxAmount,
      discountAmount,
      createdByName,
      createdByEmail,
      createdAt
    );
  }

  /**
   * Convert array of API response data to Invoice entities
   */
  static fromJsonArray(jsonArray: any[], currencySymbol?: string): Invoice[] {
    return jsonArray.map((json) => this.fromJson(json, currencySymbol));
  }

  /**
   * Convert Invoice entity to API request format
   */
  static toJson(invoice: Invoice): any {
    return {
      invoice_id: invoice.invoiceId,
      invoice_number: invoice.invoiceNumber,
      invoice_date: invoice.invoiceDate,
      store_id: invoice.storeId,
      cash_location_id: invoice.cashLocationId,
      customer_name: invoice.customerName,
      customer_phone: invoice.customerPhone,
      item_count: invoice.itemCount,
      total_quantity: invoice.totalQuantity,
      total_amount: invoice.totalAmount,
      total_cost: invoice.totalCost,
      profit: invoice.profit,
      status: invoice.status,
      currency_symbol: invoice.currencySymbol,
      payment_method: invoice.paymentMethod,
      payment_status: invoice.paymentStatus,
    };
  }

  /**
   * Convert array of Invoice entities to API request format
   */
  static toJsonArray(invoices: Invoice[]): any[] {
    return invoices.map((invoice) => this.toJson(invoice));
  }

  /**
   * Validate raw API data structure
   */
  static isValidApiResponse(json: any): boolean {
    return (
      json &&
      typeof json === 'object' &&
      typeof json.invoice_id === 'string' &&
      typeof json.invoice_number === 'string' &&
      typeof json.status === 'string'
    );
  }

  /**
   * Extract currency information from API response
   */
  static extractCurrencySymbol(json: any): string {
    return json.amounts?.currency_symbol || json.store?.currency_symbol || json.currency?.symbol || '';
  }

  /**
   * Extract pagination info from API response
   * Supports both v1 (current_page, total_count) and v2 (page, total) response structures
   */
  static extractPaginationInfo(response: any): {
    current_page: number;
    total_pages: number;
    total_count: number;
    has_next: boolean;
    has_prev: boolean;
  } | null {
    if (!response.pagination) return null;

    return {
      // v2 uses 'page', v1 uses 'current_page'
      current_page: response.pagination.page || response.pagination.current_page || 1,
      total_pages: response.pagination.total_pages || 1,
      // v2 uses 'total', v1 uses 'total_count'
      total_count: response.pagination.total || response.pagination.total_count || 0,
      has_next: response.pagination.has_next || false,
      has_prev: response.pagination.has_prev || false,
    };
  }
}
