/**
 * ProductReceiveDataSource
 * Handles Supabase RPC calls for product receiving
 */

import { supabaseService } from '@/core/services/supabase_service';

// Types for RPC responses
export interface SearchProductDTO {
  product_id: string;
  product_name: string;
  sku: string;
  barcode?: string;
  image_urls?: string[];
  stock: {
    quantity_on_hand: number;
    quantity_available: number;
    quantity_reserved: number;
  };
  price: {
    cost: number;
    selling: number;
    source: string;
  };
}

export interface SessionItemUserDTO {
  user_id: string;
  user_name: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SessionItemDTO {
  product_id: string;
  product_name: string;
  total_quantity: number;
  total_rejected: number;
  scanned_by: SessionItemUserDTO[];
}

export interface SessionItemsSummaryDTO {
  total_products: number;
  total_quantity: number;
  total_rejected: number;
}

export interface CurrencyDTO {
  symbol: string;
  code: string;
}

export interface SaveItemDTO {
  product_id: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SubmitItemDTO {
  product_id: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SubmitResultDTO {
  receiving_number?: string;
  items_count?: number;
  total_quantity?: number;
}

// DataSource interface
export interface IProductReceiveDataSource {
  searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page?: number,
    limit?: number
  ): Promise<{ products: SearchProductDTO[]; currency: CurrencyDTO }>;

  addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItemDTO[]
  ): Promise<void>;

  getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<{ items: SessionItemDTO[]; summary: SessionItemsSummaryDTO }>;

  submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItemDTO[],
    isFinal: boolean
  ): Promise<SubmitResultDTO>;
}

// DataSource implementation
export class ProductReceiveDataSource implements IProductReceiveDataSource {
  private getTimezone(): string {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  }

  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page: number = 1,
    limit: number = 10
  ): Promise<{ products: SearchProductDTO[]; currency: CurrencyDTO }> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('get_inventory_page_v3', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: query,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Search failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Search failed');
    }

    return {
      products: data.data?.products || [],
      currency: {
        symbol: data.data?.currency?.symbol || '₫',
        code: data.data?.currency?.code || 'VND',
      },
    };
  }

  async addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItemDTO[]
  ): Promise<void> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_add_session_items', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Save failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Save failed');
    }
  }

  async getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<{ items: SessionItemDTO[]; summary: SessionItemsSummaryDTO }> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_get_session_items', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Failed to load session items: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to load session items');
    }

    return {
      items: data.data?.items || [],
      summary: data.data?.summary || {
        total_products: 0,
        total_quantity: 0,
        total_rejected: 0,
      },
    };
  }

  async submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItemDTO[],
    isFinal: boolean
  ): Promise<SubmitResultDTO> {
    const client = supabaseService.getClient();
    const localTime = new Date().toISOString();

    const { data, error } = await client.rpc('inventory_submit_session', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_is_final: isFinal,
      p_time: localTime,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Submit failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Submit failed');
    }

    return {
      receiving_number: data.data?.receiving_number,
      items_count: data.data?.items_count,
      total_quantity: data.data?.total_quantity,
    };
  }
}

// Singleton instance
export const productReceiveDataSource = new ProductReceiveDataSource();
