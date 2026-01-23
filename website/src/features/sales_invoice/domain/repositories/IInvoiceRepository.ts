/**
 * IInvoiceRepository Interface
 * Repository interface for invoice operations
 */

import { Invoice } from '../entities/Invoice';
import { DateFilter, AmountFilter, InvoiceDetailItem } from '../../data/datasources/InvoiceDataSource';

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
    invoice_id: string;
    invoice_number: string;
    status: string;
    sale_date: string;
    payment_method: string;
    payment_status: string;
    store: {
      store_id: string;
      store_name: string;
      store_code: string;
    };
    customer: {
      customer_id: string;
      name: string;
      phone: string | null;
      email: string | null;
      address: string | null;
      type: string;
    } | null;
    cash_location: {
      cash_location_id: string;
      location_name: string;
      location_type: string;
    } | null;
    amounts: {
      subtotal: number;
      tax_amount: number;
      discount_amount: number;
      total_amount: number;
      total_cost: number;
      profit: number;
    };
    items: InvoiceDetailItem[];
    items_summary: {
      item_count: number;
      total_quantity: number;
    };
    journal: {
      journal_id: string;
      ai_description: string | null;
      attachments: Array<{
        attachment_id: string;
        file_url: string;
        file_name: string;
        file_type: string;
      }>;
    } | null;
    refund: {
      refund_date: string;
      refund_reason: string | null;
      refunded_by: {
        user_id: string;
        name: string;
        email: string;
        profile_image: string | null;
      } | null;
    } | null;
    created_by: {
      user_id: string;
      name: string;
      email: string;
      profile_image: string | null;
    } | null;
    created_at: string;
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
    startDate: string | null,
    endDate: string | null,
    dateFilter?: DateFilter,
    amountFilter?: AmountFilter
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
  refundInvoices(invoiceIds: string[], notes: string, createdBy: string, timezone?: string): Promise<BulkRefundResult>;
}
