/**
 * InvoiceDataSource
 * Data source for invoice operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export interface InvoicePageParams {
  p_company_id: string;
  p_store_id: string | null;
  p_page: number;
  p_limit: number;
  p_search: string | null;
  p_start_date: string;
  p_end_date: string;
}

export interface InvoicePageResponse {
  success: boolean;
  data?: {
    invoices: any[];
    pagination: {
      current_page: number;
      total_pages: number;
      total_count: number;
      has_next: boolean;
      has_prev: boolean;
    };
    currency?: {
      code: string;
      name: string;
      symbol: string;
    };
  };
  error?: string;
}

export interface InvoiceDetailResponse {
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

export interface RefundInvoiceResponse {
  success: boolean;
  message?: string;
  error?: string;
}

export class InvoiceDataSource {
  async getInvoices(
    companyId: string,
    storeId: string | null,
    page: number,
    limit: number,
    search: string | null,
    startDate: string,
    endDate: string
  ): Promise<InvoicePageResponse> {
    const supabase = supabaseService.getClient();

    const rpcParams: InvoicePageParams = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: search,
      p_start_date: startDate,
      p_end_date: endDate,
    };

    const { data, error } = await supabase.rpc('get_invoice_page', rpcParams);

    if (error) {
      console.error('❌ Error fetching invoices:', error);
      throw new Error(error.message);
    }

    return data as InvoicePageResponse;
  }

  async getInvoiceDetail(invoiceId: string): Promise<InvoiceDetailResponse> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_invoice_detail', {
      p_invoice_id: invoiceId,
    });

    if (error) {
      console.error('❌ Error fetching invoice detail:', error);
      throw new Error(error.message);
    }

    return data as InvoiceDetailResponse;
  }

  async refundInvoice(
    invoiceId: string,
    refundReason?: string,
    createdBy?: string
  ): Promise<RefundInvoiceResponse> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('inventory_refund_invoice', {
      p_invoice_id: invoiceId,
      p_refund_date: DateTimeUtils.nowUtc(), // Use DateTimeUtils for consistency
      p_refund_reason: refundReason || null,
      p_created_by: createdBy || null,
    });

    if (error) {
      console.error('❌ Error refunding invoice:', error);
      throw new Error(error.message);
    }

    return data as RefundInvoiceResponse;
  }
}
