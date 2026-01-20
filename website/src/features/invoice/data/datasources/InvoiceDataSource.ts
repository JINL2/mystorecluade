/**
 * InvoiceDataSource
 * Data source for invoice operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { ACCOUNT_IDS } from '@/core/constants/account-ids';

export type DateFilter = 'newest' | 'oldest' | null;
export type AmountFilter = 'high' | 'low' | null;

export interface InvoicePageParams {
  p_company_id: string;
  p_store_id: string | null;
  p_page: number;
  p_limit: number;
  p_search: string | null;
  p_start_date: string | null;
  p_end_date: string | null;
  p_timezone: string;
  p_date_filter: DateFilter;
  p_amount_filter: AmountFilter;
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
        start_date: string | null;
        end_date: string | null;
      };
      timezone: string;
      date_filter: string;
      amount_filter: string | null;
      sort_applied: string;
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

export interface InvoiceDetailItem {
  invoice_item_id: string;
  // Product info (base product)
  product_id: string;
  product_name: string;
  product_sku: string | null;
  product_barcode: string | null;
  product_image: string | null;
  brand_name: string | null;
  category_name: string | null;
  // Variant info (null if product has no variants)
  variant_id: string | null;
  variant_name: string | null;
  variant_sku: string | null;
  variant_barcode: string | null;
  // Display fields (combined product + variant)
  display_name: string;
  display_sku: string | null;
  display_barcode: string | null;
  // Quantity and pricing
  quantity: number;
  unit_price: number;
  unit_cost: number;
  discount_amount: number;
  total_price: number;
  total_cost: number;
  // Meta
  has_variants: boolean;
}

export interface InvoiceDetailResponse {
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
  code?: string;
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
    startDate: string | null,
    endDate: string | null,
    timezone: string = 'Asia/Ho_Chi_Minh',
    dateFilter: DateFilter = null,
    amountFilter: AmountFilter = null
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
      p_date_filter: dateFilter,
      p_amount_filter: amountFilter,
    };

    console.log('🔵 InvoiceDataSource.getInvoices - calling get_invoice_page_v3:', rpcParams);

    const { data, error } = await supabase.rpc('get_invoice_page_v3' as any, rpcParams);

    if (error) {
      console.error('❌ Error fetching invoices:', error);
      throw new Error(error.message);
    }

    console.log('🟢 InvoiceDataSource.getInvoices - response:', data);

    return data as InvoicePageResponse;
  }

  async getInvoiceDetail(
    invoiceId: string,
    timezone: string = 'Asia/Ho_Chi_Minh'
  ): Promise<InvoiceDetailResponse> {
    const supabase = supabaseService.getClient();

    console.log('🔵 InvoiceDataSource.getInvoiceDetail - calling get_invoice_detail_v2:', {
      p_invoice_id: invoiceId,
      p_timezone: timezone,
    });

    const { data, error } = await supabase.rpc('get_invoice_detail_v2' as any, {
      p_invoice_id: invoiceId,
      p_timezone: timezone,
    });

    if (error) {
      console.error('❌ Error fetching invoice detail:', error);
      throw new Error(error.message);
    }

    console.log('🟢 InvoiceDataSource.getInvoiceDetail - response:', data);

    return data as unknown as InvoiceDetailResponse;
  }

  async refundInvoice(
    invoiceId: string,
    refundReason?: string,
    createdBy?: string,
    timezone: string = 'Asia/Ho_Chi_Minh'
  ): Promise<RefundInvoiceResponse> {
    const supabase = supabaseService.getClient();

    // v4 uses timestamptz - send ISO 8601 format
    const refundDate = new Date().toISOString();

    const { data, error } = await supabase.rpc('inventory_refund_invoice_v4' as any, {
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

    // v4 uses timestamptz - send ISO 8601 format
    const refundDate = new Date().toISOString();

    const { data, error } = await supabase.rpc('inventory_refund_invoice_v4' as any, {
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
