/**
 * SaleProductDataSource
 * Handles RPC calls for sale product feature
 * v6: Updated to use get_inventory_page_v6 with variant support
 */

import { supabaseService } from '@/core/services/supabase_service';

// Type for v6 inventory response (until Supabase types are regenerated)
interface InventoryPageV6Response {
  success: boolean;
  data: {
    items: Array<{
      product_id: string;
      product_sku: string;
      product_name: string;
      brand_name: string;
      category_name: string;
      unit: string;
      image_urls: string[];
      price: { cost: number; selling: number };
      stock: { quantity_available: number; quantity_on_hand: number };
      variant_id: string | null;
      variant_name: string | null;
      variant_sku: string | null;
      variant_barcode: string | null;
      display_name: string;
      display_sku: string;
      display_barcode: string;
      has_variants: boolean;
    }>;
    pagination: {
      total_count: number;
      total_pages: number;
      current_page: number;
    };
    currency?: { symbol: string; code: string };
  };
}

export class SaleProductDataSource {
  /**
   * Get inventory products for sale
   * Calls get_inventory_page_v6 RPC function with timezone and variant support
   * v6: Returns items array with variant fields (display_name, display_sku, variant_id, etc.)
   */
  async getProducts(
    companyId: string,
    storeId: string,
    page: number = 1,
    limit: number = 100,
    search?: string
  ): Promise<InventoryPageV6Response> {
    const supabase = supabaseService.getClient();

    // Get user's local timezone from device
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_inventory_page_v6', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: search || null,
      p_availability: null,
      p_brand_id: null,
      p_category_id: null,
      p_timezone: userTimezone,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data as InventoryPageV6Response;
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    // Extract base_currency from response
    const response = data as { base_currency?: { symbol?: string; currency_code?: string } } | null;
    if (response && response.base_currency) {
      return {
        symbol: response.base_currency.symbol || '₫',
        code: response.base_currency.currency_code || 'VND',
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_exchange_rate_v2', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data as {
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
    };
  }

  /**
   * Get cash locations for a company and store
   * Calls get_cash_locations_v2 RPC function
   */
  async getCashLocations(companyId: string, storeId: string | null): Promise<Array<{
    cash_location_id: string;
    location_name: string;
    location_type: 'cash' | 'bank' | 'vault';
    store_id: string | null;
    store_name: string | null;
    company_id: string;
    is_company_wide: boolean;
    currency_code: string | null;
    currency_id: string | null;
    bank_account: string | null;
    bank_name: string | null;
    location_info: string | null;
    icon: string | null;
    note: string | null;
    main_cash_location: boolean;
    created_at: string;
    created_at_utc: string | null;
  }>> {
    const supabase = supabaseService.getClient();

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_cash_locations_v2', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_location_type: null,
    });

    if (error) {
      throw new Error(error.message);
    }

    return (data || []) as Array<{
      cash_location_id: string;
      location_name: string;
      location_type: 'cash' | 'bank' | 'vault';
      store_id: string | null;
      store_name: string | null;
      company_id: string;
      is_company_wide: boolean;
      currency_code: string | null;
      currency_id: string | null;
      bank_account: string | null;
      bank_name: string | null;
      location_info: string | null;
      icon: string | null;
      note: string | null;
      main_cash_location: boolean;
      created_at: string;
      created_at_utc: string | null;
    }>;
  }

  /**
   * Submit sale invoice
   * Calls inventory_create_invoice_v5 RPC function with variant support
   * v5: Added variant_id support in items array
   */
  async submitInvoice(params: {
    companyId: string;
    storeId: string;
    userId: string;
    saleDate: string;
    items: Array<{
      product_id: string;
      variant_id: string | null; // v5: variant support
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
    invoice_id?: string; // v5: returns invoice_id instead of invoiceNumber
    invoice_number?: string;
    subtotal?: number;
    tax_amount?: number;
    discount_amount?: number;
    total_amount?: number;
    total_cost?: number;
    profit?: number;
    warnings?: Array<{
      type: string;
      product: string;
      [key: string]: unknown;
    }>;
    message?: string;
    error?: string;
  }> {
    const supabase = supabaseService.getClient();

    // Get user's local timezone from device
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('inventory_create_invoice_v5', rpcParams);

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
    invoiceId: string; // Invoice ID from inventory_create_invoice_v5
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data: salesData, error: salesError } = await (supabase.rpc as any)(
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

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { data: cogsData, error: cogsError } = await (supabase.rpc as any)(
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
        salesJournalId: salesData as string,
        cogsJournalId: cogsData as string,
      };
    }

    return {
      success: true,
      salesJournalId: salesData as string,
    };
  }
}
