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
  p_timezone: string;
}

export interface InvoicePageResponse {
  success: boolean;
  data?: {
    invoices: any[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      total_pages: number;
      has_next: boolean;
      has_prev: boolean;
    };
    filters_applied: {
      search: string | null;
      store_id: string | null;
      date_range: {
        start_date: string;
        end_date: string;
      };
      timezone: string;
    };
    summary: {
      period_total: {
        invoice_count: number;
        total_amount: number;
        total_cost: number;
        profit: number;
        avg_per_invoice: number;
      };
      by_status: {
        completed: number;
        draft: number;
        cancelled: number;
      };
      by_payment: {
        cash: number;
        card: number;
        transfer: number;
      };
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
    endDate: string,
    timezone: string = 'Asia/Ho_Chi_Minh'
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
      p_timezone: timezone,
    };

    console.log('🔵 InvoiceDataSource.getInvoices - calling get_invoice_page_v2:', rpcParams);

    const { data, error } = await supabase.rpc('get_invoice_page_v2' as any, rpcParams);

    if (error) {
      console.error('❌ Error fetching invoices:', error);
      throw new Error(error.message);
    }

    console.log('🟢 InvoiceDataSource.getInvoices - response:', data);

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

    return data as unknown as InvoiceDetailResponse;
  }

  async refundInvoice(
    invoiceId: string,
    refundReason?: string,
    createdBy?: string,
    timezone: string = 'Asia/Ho_Chi_Minh'
  ): Promise<RefundInvoiceResponse> {
    const supabase = supabaseService.getClient();

    // v3 uses timestamptz - send ISO 8601 format
    const refundDate = new Date().toISOString();

    const { data, error } = await supabase.rpc('inventory_refund_invoice_v3' as any, {
      p_invoice_ids: [invoiceId],
      p_refund_date: refundDate,
      p_notes: refundReason || null,
      p_created_by: createdBy || null,
      p_timezone: timezone,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data as unknown as RefundInvoiceResponse;
  }

  async refundInvoices(
    invoiceIds: string[],
    notes: string,
    createdBy: string,
    timezone: string = 'Asia/Ho_Chi_Minh'
  ): Promise<BulkRefundInvoiceResponse> {
    const supabase = supabaseService.getClient();

    // v3 uses timestamptz - send ISO 8601 format
    const refundDate = new Date().toISOString();

    const { data, error } = await supabase.rpc('inventory_refund_invoice_v3' as any, {
      p_invoice_ids: invoiceIds,
      p_refund_date: refundDate,
      p_notes: notes || null,
      p_created_by: createdBy,
      p_timezone: timezone,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data as unknown as BulkRefundInvoiceResponse;
  }

  /**
   * Create refund journal entries
   * Following JOURNAL_INPUT_RPC_GUIDE.md for refund transactions
   * Creates TWO journal entries:
   * 1. Sales Revenue (Debit) / Cash (Credit) - refundAmount
   * 2. Inventory (Debit) / COGS (Credit) - totalCost
   */
  async insertRefundJournalEntry(params: {
    companyId: string;
    storeId: string;
    createdBy: string;
    invoiceNumber: string;
    refundAmount: number;
    totalCost: number;
    cashLocationId: string | null;
  }): Promise<{ success: boolean; journal_ids?: string[]; error?: string }> {
    const supabase = supabaseService.getClient();
    const journalIds: string[] = [];

    try {
      // Use unified description format: "Invoice# Refund"
      const lineDescription = `${params.invoiceNumber} Refund`;
      const entryDateUtc = DateTimeUtils.nowUtc();

      // ========== JOURNAL ENTRY 1: Sales Revenue / Cash ==========
      // Line 1: DEBIT Sales Revenue (reverse the sale)
      // Line 2: CREDIT Cash (payment going out)
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

      const salesCashLines = [
        {
          account_id: ACCOUNT_IDS.SALES_REVENUE,
          debit: params.refundAmount.toString(),
          credit: '0',
          description: lineDescription,
        },
        cashLine,
      ];

      const salesCashRpcParams = {
        p_base_amount: params.refundAmount,
        p_company_id: params.companyId,
        p_created_by: params.createdBy,
        p_description: `${params.invoiceNumber} refund`,
        p_entry_date_utc: entryDateUtc,
        p_lines: salesCashLines,
        p_store_id: params.storeId,
        p_counterparty_id: null,
        p_if_cash_location_id: null,
      };

      console.log('🔵 Creating refund journal entry 1 (Sales/Cash):', salesCashRpcParams);

      const { data: data1, error: error1 } = await supabase.rpc(
        'insert_journal_with_everything_utc' as any,
        salesCashRpcParams
      );

      if (error1) {
        console.error('❌ Error creating refund journal entry 1 (Sales/Cash):', error1);
        return {
          success: false,
          error: error1.message,
        };
      }

      console.log('✅ Refund journal entry 1 (Sales/Cash) created:', data1);
      journalIds.push(data1);

      // ========== JOURNAL ENTRY 2: Inventory / COGS ==========
      // Line 1: DEBIT Inventory (inventory returned)
      // Line 2: CREDIT COGS (reverse cost of goods sold)
      const inventoryCOGSLines = [
        {
          account_id: ACCOUNT_IDS.INVENTORY,
          debit: params.totalCost.toString(),
          credit: '0',
          description: lineDescription,
        },
        {
          account_id: ACCOUNT_IDS.COGS,
          debit: '0',
          credit: params.totalCost.toString(),
          description: lineDescription,
        },
      ];

      const inventoryCOGSRpcParams = {
        p_base_amount: params.totalCost,
        p_company_id: params.companyId,
        p_created_by: params.createdBy,
        p_description: `${params.invoiceNumber} refund (inventory)`,
        p_entry_date_utc: entryDateUtc,
        p_lines: inventoryCOGSLines,
        p_store_id: params.storeId,
        p_counterparty_id: null,
        p_if_cash_location_id: null,
      };

      console.log('🔵 Creating refund journal entry 2 (Inventory/COGS):', inventoryCOGSRpcParams);

      const { data: data2, error: error2 } = await supabase.rpc(
        'insert_journal_with_everything_utc' as any,
        inventoryCOGSRpcParams
      );

      if (error2) {
        console.error('❌ Error creating refund journal entry 2 (Inventory/COGS):', error2);
        return {
          success: false,
          journal_ids: journalIds, // Return first journal ID even if second fails
          error: error2.message,
        };
      }

      console.log('✅ Refund journal entry 2 (Inventory/COGS) created:', data2);
      journalIds.push(data2);

      return {
        success: true,
        journal_ids: journalIds,
      };
    } catch (error) {
      console.error('❌ Exception creating refund journal entries:', error);
      return {
        success: false,
        journal_ids: journalIds.length > 0 ? journalIds : undefined,
        error: error instanceof Error ? error.message : 'Failed to create journal entries',
      };
    }
  }
}
