/**
 * IInvoiceRepository Interface
 * Repository interface for invoice operations
 */

import { Invoice } from '../entities/Invoice';

export interface PaginationInfo {
  current_page: number;
  total_pages: number;
  total_count: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface InvoiceResult {
  success: boolean;
  data?: Invoice[];
  pagination?: PaginationInfo;
  error?: string;
}

export interface InvoiceDetailResult {
  success: boolean;
  data?: {
    invoice: {
      invoice_id: string;
      invoice_number: string;
      sale_date: string;
      status: string;
      store_id: string;
      store_name: string;
      store_code: string;
      company_id: string;
      customer_id: string | null;
      customer_name: string | null;
      created_at: string;
    };
    items: Array<{
      item_id: string;
      product_id: string;
      product_name: string;
      sku: string;
      quantity_sold: number;
      unit_price: number;
      unit_cost: number;
      discount_amount: number;
      total_amount: number;
    }>;
    amounts: {
      subtotal: number;
      tax_amount: number;
      discount_amount: number;
      total_amount: number;
    };
    payment: {
      method: string;
      status: string;
    };
    inventory_movements: Array<{
      product_id: string;
      product_name: string;
      quantity_change: number;
      stock_before: number;
      stock_after: number;
    }>;
  };
  message?: string;
  error?: string;
}

export interface RefundResult {
  success: boolean;
  message?: string;
  error?: string;
}

export interface BulkRefundResult {
  success: boolean;
  data?: {
    total_processed: number;
    total_succeeded: number;
    total_failed: number;
    total_amount_refunded: number;
    results: Array<{
      invoice_id: string;
      invoice_number: string;
      success: boolean;
      amount_refunded?: number;
      error_message?: string;
    }>;
  };
  error?: string;
}

export interface IInvoiceRepository {
  /**
   * Get invoices with pagination and filters
   */
  getInvoices(
    companyId: string,
    storeId: string | null,
    page: number,
    limit: number,
    search: string | null,
    startDate: string,
    endDate: string
  ): Promise<InvoiceResult>;

  /**
   * Get detailed invoice information
   */
  getInvoiceDetail(invoiceId: string): Promise<InvoiceDetailResult>;

  /**
   * Refund an invoice
   */
  refundInvoice(invoiceId: string, refundReason?: string, createdBy?: string): Promise<RefundResult>;

  /**
   * Refund multiple invoices
   */
  refundInvoices(invoiceIds: string[], notes: string, createdBy: string): Promise<BulkRefundResult>;
}
