/**
 * ProductReceiveDataSource
 * Handles Supabase RPC calls for product receiving
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface OrderProductDTO {
  product_id: string;
  sku: string;
  product_name: string;
  barcode?: string;
  quantity_ordered: number;
  quantity_received_total: number;
  unit_price?: number;
  total_amount?: number;
}

export interface OrderDTO {
  order_id: string;
  order_number: string;
  supplier_name: string;
  status: string;
  order_date: string;
  summary?: {
    total_products: number;
    total_ordered: number;
    total_received: number;
    completion_rate: number;
  };
  items?: OrderProductDTO[]; // Products in this order
}

export interface ReceiveItemDTO {
  product_id: string;
  quantity_received: number;
}

export interface ReceiveResponseDTO {
  success: boolean;
  receipt_number?: string;
  message?: string;
  received_count?: number;
  warnings?: string[];
}

export class ProductReceiveDataSource {
  /**
   * Get list of orders from Supabase
   */
  async getOrders(companyId: string): Promise<{ orders: OrderDTO[] } | null> {
    try {
      const { data, error } = await supabaseService
        .getClient()
        .rpc('get_inventory_order_list', {
          p_company_id: companyId,
        });

      if (error) {
        console.error('getOrders RPC error:', error);
        throw error;
      }

      console.log('🔍 RPC Response:', data);
      if (data?.orders?.[0]) {
        console.log('🔍 First Order:', data.orders[0]);
        console.log('🔍 First Order Progress Fields:', {
          total_items: data.orders[0].total_items,
          received_items: data.orders[0].received_items,
          remaining_items: data.orders[0].remaining_items,
        });
      }

      return data;
    } catch (error) {
      console.error('getOrders error:', error);
      throw error;
    }
  }

  /**
   * Submit receive operation to Supabase
   */
  async submitReceive(
    companyId: string,
    storeId: string,
    orderId: string,
    userId: string,
    items: ReceiveItemDTO[],
    notes?: string | null
  ): Promise<ReceiveResponseDTO> {
    try {
      const { data, error} = await supabaseService
        .getClient()
        .rpc('inventory_order_receive', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_order_id: orderId,
          p_user_id: userId,
          p_items: items,
          p_notes: notes || null,
        });

      if (error) {
        console.error('submitReceive RPC error:', error);
        throw error;
      }

      return data;
    } catch (error) {
      console.error('submitReceive error:', error);
      throw error;
    }
  }
}
