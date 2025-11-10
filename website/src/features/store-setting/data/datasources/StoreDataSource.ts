import { supabaseService } from '@/core/services/supabase_service';
export class StoreDataSource {
  async getStores(companyId: string) {
    const { data, error } = await supabaseService.getClient().rpc('get_stores', { p_company_id: companyId });
    if (error) throw new Error(error.message);
    return data || [];
  }
  async createStore(companyId: string, storeName: string, address: string | null, phone: string | null) {
    const { error } = await supabaseService.getClient().rpc('create_store', { p_company_id: companyId, p_store_name: storeName, p_address: address, p_phone: phone });
    if (error) throw new Error(error.message);
  }
  async deleteStore(storeId: string) {
    const { error } = await supabaseService.getClient().rpc('delete_store', { p_store_id: storeId });
    if (error) throw new Error(error.message);
  }
}
