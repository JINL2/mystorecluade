/**
 * ProductReceiveDataSource
 * Handles Supabase RPC calls for product receiving
 */

import { supabaseService } from '@/core/services/supabase_service';
import { OrderDTO } from '../models/OrderModel';
import { ReceiveItemDTO, ReceiveResponseDTO } from '../models/ReceiveResultModel';

export class ProductReceiveDataSource {
  /**
   * Get current user ID from Supabase session
   */
  async getCurrentUserId(): Promise<string | null> {
    try {
      const {
        data: { session },
        error,
      } = await supabaseService.getClient().auth.getSession();

      if (error || !session?.user?.id) {
        console.error('getCurrentUserId error:', error);
        return null;
      }

      return session.user.id;
    } catch (error) {
      console.error('getCurrentUserId error:', error);
      return null;
    }
  }

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
