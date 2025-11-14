import { Store } from '../entities/Store';
export interface StoreResult { success: boolean; data?: Store[]; error?: string; }
export interface IStoreRepository {
  getStores(companyId: string): Promise<StoreResult>;
  createStore(companyId: string, storeName: string, address: string | null, phone: string | null): Promise<{ success: boolean; error?: string; }>;
  deleteStore(storeId: string): Promise<{ success: boolean; error?: string; }>;
}
