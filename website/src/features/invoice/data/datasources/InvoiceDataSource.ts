/**
 * InvoiceDataSource
 * Data source for invoice operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { ACCOUNT_IDS } from '@/core/constants/account-ids';

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

export interface BulkRefundInvoiceResponse {
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

  async refundInvoices(
    invoiceIds: string[],
    notes: string,
    createdBy: string
  ): Promise<BulkRefundInvoiceResponse> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('inventory_refund_invoice', {
      p_invoice_ids: invoiceIds,
      p_refund_date: DateTimeUtils.nowUtc(),
      p_notes: notes || null,
      p_created_by: createdBy,
    });

    if (error) {
      console.error('❌ Error refunding invoices:', error);
      throw new Error(error.message);
    }

    return data as BulkRefundInvoiceResponse;
  }

  /**
   * Create refund journal entry
   * Following JOURNAL_INPUT_RPC_GUIDE.md for refund transactions
   */
  async insertRefundJournalEntry(params: {
    companyId: string;
    storeId: string;
    createdBy: string;
    invoiceNumber: string;
    refundAmount: number;
    cashLocationId: string | null;
  }): Promise<{ success: boolean; journal_id?: string; error?: string }> {
    const supabase = supabaseService.getClient();

    try {
      // Build journal lines following the guide
      // Line 1: DEBIT Sales Revenue (reverse the sale)
      // Line 2: CREDIT Cash (payment going out)
      // Use unified description format: "Invoice# Refund"
      const lineDescription = `${params.invoiceNumber} Refund`;

      const cashLine: any = {
        account_id: ACCOUNT_IDS.CASH,
        debit: '0',
        credit: params.refundAmount.toString(),
        description: lineDescription,
      };

      // Add cash object if cash_location_id is available
      if (params.cashLocationId) {
        cashLine.cash = {
          cash_location_id: params.cashLocationId,
        };
      }

      const lines = [
        {
          account_id: ACCOUNT_IDS.SALES_REVENUE,
          debit: params.refundAmount.toString(),
          credit: '0',
          description: lineDescription,
          // NO cash object - this is revenue account
        },
        cashLine,
      ];

      // Prepare RPC parameters following the guide
      const rpcParams = {
        p_base_amount: params.refundAmount,
        p_company_id: params.companyId,
        p_created_by: params.createdBy,
        p_description: `${params.invoiceNumber} refund`,
        p_entry_date: DateTimeUtils.toRpcFormat(new Date()),
        p_lines: lines,
        p_store_id: params.storeId,
        // CRITICAL: These MUST be null for refunds
        p_counterparty_id: null,
        p_if_cash_location_id: null,
      };

      console.log('🔵 Creating refund journal entry:', rpcParams);

      const { data, error } = await supabase.rpc('insert_journal_with_everything', rpcParams);

      if (error) {
        console.error('❌ Error creating refund journal entry:', error);
        return {
          success: false,
          error: error.message,
        };
      }

      console.log('✅ Refund journal entry created:', data);

      return {
        success: true,
        journal_id: data,
      };
    } catch (error) {
      console.error('❌ Exception creating refund journal entry:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to create journal entry',
      };
    }
  }
}
