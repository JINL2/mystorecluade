/**
 * SaleProductDataSource
 * Handles RPC calls for sale product feature
 */

import { supabaseService } from '@/core/services/supabase_service';

export class SaleProductDataSource {
  /**
   * Get inventory products for sale
   * Calls get_inventory_page_v3 RPC function with timezone support
   * Supports store-specific pricing with fallback to default prices
   */
  async getProducts(
    companyId: string,
    storeId: string,
    page: number = 1,
    limit: number = 100,
    search?: string
  ) {
    const supabase = supabaseService.getClient();

    // Get user's local timezone from device
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const { data, error } = await supabase.rpc('get_inventory_page_v3', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: search || null,
      p_timezone: userTimezone,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data;
  }

  /**
   * Get base currency for a company
   * Calls get_base_currency RPC function
   */
  async getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    // Extract base_currency from response
    if (data && data.base_currency) {
      return {
        symbol: data.base_currency.symbol || '₫',
        code: data.base_currency.currency_code || 'VND',
      };
    }

    // Fallback to VND if no base currency found
    return {
      symbol: '₫',
      code: 'VND',
    };
  }

  /**
   * Get exchange rates for a company
   * Calls get_exchange_rate_v2 RPC function
   */
  async getExchangeRates(companyId: string): Promise<{
    base_currency: {
      currency_id: string;
      currency_code: string;
      currency_name: string;
      symbol: string;
    };
    exchange_rates: Array<{
      currency_id: string;
      currency_code: string;
      currency_name: string;
      symbol: string;
      rate: number;
    }>;
  }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_exchange_rate_v2', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data;
  }

  /**
   * Get cash locations for a company and store
   * Calls get_cash_locations RPC function
   */
  async getCashLocations(companyId: string, storeId: string | null): Promise<Array<{
    id: string;
    name: string;
    type: 'cash' | 'bank' | 'vault';
    storeId: string | null;
    isCompanyWide: boolean;
    isDeleted: boolean;
    currencyCode: string | null;
    bankAccount: string | null;
    bankName: string | null;
    locationInfo: string;
    transactionCount: number;
    additionalData: {
      cash_location_id: string;
      company_id: string;
      store_id: string | null;
      location_name: string;
      location_type: string;
      location_info: string;
      currency_code: string | null;
      bank_account: string | null;
      bank_name: string | null;
      is_deleted: boolean;
      deleted_at: string | null;
      created_at: string;
    };
  }>> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_cash_locations', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_location_type: null,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data || [];
  }

  /**
   * Submit sale invoice
   * Calls inventory_create_invoice_v4 RPC function with timestamptz support and inventory_logs
   */
  async submitInvoice(params: {
    companyId: string;
    storeId: string;
    userId: string;
    saleDate: string;
    items: Array<{
      product_id: string;
      quantity: number;
      unit_price?: number;
      discount_amount?: number;
    }>;
    paymentMethod: string;
    cashLocationId?: string | null;
    discountAmount?: number;
    taxRate?: number;
    notes?: string;
  }): Promise<{
    success: boolean;
    invoiceNumber?: string;
    totalAmount?: number;
    warnings?: string[];
    message?: string;
    error?: string;
  }> {
    const supabase = supabaseService.getClient();

    // Get user's local timezone from device
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams: Record<string, any> = {
      p_company_id: params.companyId,
      p_store_id: params.storeId,
      p_created_by: params.userId,
      p_sale_date: params.saleDate,
      p_items: params.items,
      p_payment_method: params.paymentMethod,
      p_timezone: userTimezone,
    };

    // Add optional parameters if provided
    if (params.cashLocationId) {
      rpcParams.p_cash_location_id = params.cashLocationId;
    }
    if (params.discountAmount !== undefined && params.discountAmount > 0) {
      rpcParams.p_discount_amount = params.discountAmount;
    }
    if (params.taxRate !== undefined && params.taxRate > 0) {
      rpcParams.p_tax_rate = params.taxRate;
    }
    if (params.notes) {
      rpcParams.p_notes = params.notes;
    }

    const { data, error } = await supabase.rpc('inventory_create_invoice_v4', rpcParams);

    if (error) {
      return {
        success: false,
        error: error.message,
      };
    }

    return data || { success: false, error: 'No response from server' };
  }

  /**
   * Submit journal entries for sales transaction
   * Calls insert_journal_with_everything_v2 RPC function twice:
   * 1. Sales Journal: Cash (debit) / Sales Revenue (credit) - totalAmount
   * 2. COGS Journal: COGS (debit) / Inventory (credit) - totalCost
   */
  async submitSalesJournalEntries(params: {
    companyId: string;
    storeId: string;
    userId: string;
    entryDateUtc: string;
    description: string;
    totalAmount: number;
    totalCost: number;
    cashLocationId: string;
    invoiceId: string; // Invoice ID from inventory_create_invoice_v4
  }): Promise<{
    success: boolean;
    salesJournalId?: string;
    cogsJournalId?: string;
    error?: string;
  }> {
    const supabase = supabaseService.getClient();

    // Fixed account IDs for sales transactions
    const CASH_ACCOUNT_ID = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
    const SALES_REVENUE_ACCOUNT_ID = 'e45e7d41-7fda-43a1-ac55-9779f3e59697';
    const COGS_ACCOUNT_ID = '90565fe4-5bfc-4c5e-8759-af9a64e98cae';
    const INVENTORY_ACCOUNT_ID = '8babc1b3-47b4-4982-8f50-099ab9cdcaf9';

    // Get user's local timezone from device
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // 1. Sales Journal: Cash (debit) / Sales Revenue (credit)
    const salesJournalParams = {
      p_base_amount: params.totalAmount,
      p_company_id: params.companyId,
      p_created_by: params.userId,
      p_description: params.description,
      p_time: params.entryDateUtc,
      p_lines: [
        // Debit: Cash Account
        {
          account_id: CASH_ACCOUNT_ID,
          description: params.description,
          debit: params.totalAmount.toString(),
          credit: '0',
          cash: {
            cash_location_id: params.cashLocationId,
          },
        },
        // Credit: Sales Revenue Account
        {
          account_id: SALES_REVENUE_ACCOUNT_ID,
          description: params.description,
          debit: '0',
          credit: params.totalAmount.toString(),
        },
      ],
      p_counterparty_id: null,
      p_if_cash_location_id: null,
      p_store_id: params.storeId,
      p_timezone: userTimezone,
      p_invoice_id: params.invoiceId, // Link journal to invoice
    };

    const { data: salesData, error: salesError } = await supabase.rpc(
      'insert_journal_with_everything_v2',
      salesJournalParams
    );

    if (salesError) {
      return {
        success: false,
        error: `Sales journal failed: ${salesError.message}`,
      };
    }

    // 2. COGS Journal: COGS (debit) / Inventory (credit)
    // Only create if totalCost > 0
    if (params.totalCost > 0) {
      const cogsDescription = params.description.replace('Sales', 'COGS');
      const cogsJournalParams = {
        p_base_amount: params.totalCost,
        p_company_id: params.companyId,
        p_created_by: params.userId,
        p_description: cogsDescription,
        p_time: params.entryDateUtc,
        p_lines: [
          // Debit: COGS Account
          {
            account_id: COGS_ACCOUNT_ID,
            description: cogsDescription,
            debit: params.totalCost.toString(),
            credit: '0',
          },
          // Credit: Inventory Account
          {
            account_id: INVENTORY_ACCOUNT_ID,
            description: cogsDescription,
            debit: '0',
            credit: params.totalCost.toString(),
          },
        ],
        p_counterparty_id: null,
        p_if_cash_location_id: null,
        p_store_id: params.storeId,
        p_timezone: userTimezone,
        p_invoice_id: params.invoiceId, // Link journal to invoice
      };

      const { data: cogsData, error: cogsError } = await supabase.rpc(
        'insert_journal_with_everything_v2',
        cogsJournalParams
      );

      if (cogsError) {
        return {
          success: false,
          error: `COGS journal failed: ${cogsError.message}`,
        };
      }

      return {
        success: true,
        salesJournalId: salesData,
        cogsJournalId: cogsData,
      };
    }

    return {
      success: true,
      salesJournalId: salesData,
    };
  }
}
