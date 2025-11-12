/**
 * InvoiceModel
 * DTO (Data Transfer Object) + Mapper for Invoice
 * Handles conversion between API data and Domain entities
 */

import { Invoice } from '../../domain/entities/Invoice';

export class InvoiceModel {
  /**
   * Convert API response data to Invoice entity
   */
  static fromJson(json: any, currencySymbol?: string): Invoice {
    const customerName = json.customer?.name || 'Walk-in';
    const customerPhone = json.customer?.phone || null;
    const itemCount = json.items_summary?.item_count || 0;
    const totalQuantity = json.items_summary?.total_quantity || 0;
    const totalAmount = json.amounts?.total_amount || 0;
    const symbol = currencySymbol || json.amounts?.currency_symbol || json.store?.currency_symbol || '';
    const paymentMethod = json.payment?.method || 'cash';
    const paymentStatus = json.payment?.status || 'pending';
    const invoiceDate = json.invoice_date || json.sale_date;

    return new Invoice(
      json.invoice_id,
      json.invoice_number,
      invoiceDate,
      customerName,
      customerPhone,
      itemCount,
      totalQuantity,
      totalAmount,
      json.status,
      symbol,
      paymentMethod,
      paymentStatus
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
      customer_name: invoice.customerName,
      customer_phone: invoice.customerPhone,
      item_count: invoice.itemCount,
      total_quantity: invoice.totalQuantity,
      total_amount: invoice.totalAmount,
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
      current_page: response.pagination.current_page || 1,
      total_pages: response.pagination.total_pages || 1,
      total_count: response.pagination.total_count || 0,
      has_next: response.pagination.has_next || false,
      has_prev: response.pagination.has_prev || false,
    };
  }
}
