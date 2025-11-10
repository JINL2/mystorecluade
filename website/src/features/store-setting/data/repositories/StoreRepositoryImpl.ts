import { IStoreRepository, StoreResult } from '../../domain/repositories/IStoreRepository';
import { Store } from '../../domain/entities/Store';
import { StoreDataSource } from '../datasources/StoreDataSource';

export class StoreRepositoryImpl implements IStoreRepository {
  private dataSource = new StoreDataSource();
  async getStores(companyId: string): Promise<StoreResult> {
    try {
      const data = await this.dataSource.getStores(companyId);
      const stores = data.map((d: any) => new Store(d.store_id, d.company_id, d.store_name, d.address, d.phone, d.is_active));
      return { success: true, data: stores };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async createStore(companyId: string, storeName: string, address: string | null, phone: string | null) {
    try {
      await this.dataSource.createStore(companyId, storeName, address, phone);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
  async deleteStore(storeId: string) {
    try {
      await this.dataSource.deleteStore(storeId);
      return { success: true };
    } catch (error) {
      return { success: false, error: error instanceof Error ? error.message : 'Failed' };
    }
  }
}
