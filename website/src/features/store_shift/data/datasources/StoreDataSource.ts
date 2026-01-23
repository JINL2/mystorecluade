import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * StoreDataSource - Supabase 테이블 직접 쿼리
 * Backup 방식: /backup/pages/settings/store-setting/index.html
 * RPC 함수 사용하지 않음
 */
export class StoreDataSource {
  /**
   * 회사의 모든 활성 상점 조회
   * Backup: lines 684-689
   */
  async getStores(companyId: string) {
    const { data, error } = await supabaseService
      .getClient()
      .from('stores')
      .select('store_id, store_name, store_address, store_phone, huddle_time, payment_time, allowed_distance')
      .eq('company_id', companyId)
      .eq('is_deleted', false)
      .order('created_at', { ascending: false });

    if (error) {
      throw new Error(`Failed to fetch stores: ${error.message}`);
    }

    return data || [];
  }

  /**
   * 새 상점 생성
   * Backup: lines 1120-1123
   */
  async createStore(
    companyId: string,
    storeName: string,
    address: string | null,
    phone: string | null
  ) {
    const storeData = {
      company_id: companyId,
      store_name: storeName,
      store_address: address || null,
      store_phone: phone || null,
      created_at: DateTimeUtils.nowUtc(),
      updated_at: DateTimeUtils.nowUtc(),
      is_deleted: false,
    };

    const { data, error } = await supabaseService
      .getClient()
      .from('stores')
      .insert(storeData)
      .select();

    if (error) {
      throw new Error(`Failed to create store: ${error.message}`);
    }

    return data;
  }

  /**
   * 상점 삭제 (Soft Delete)
   * Backup: lines 995-1001
   */
  async deleteStore(storeId: string) {
    const { error } = await supabaseService
      .getClient()
      .from('stores')
      .update({
        is_deleted: true,
        updated_at: DateTimeUtils.nowUtc(),
      })
      .eq('store_id', storeId);

    if (error) {
      throw new Error(`Failed to delete store: ${error.message}`);
    }
  }
}
