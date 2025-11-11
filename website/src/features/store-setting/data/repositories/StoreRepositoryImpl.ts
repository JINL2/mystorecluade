import { IStoreRepository, StoreResult } from '../../domain/repositories/IStoreRepository';
import { Store } from '../../domain/entities/Store';
import { StoreDataSource } from '../datasources/StoreDataSource';

/**
 * StoreRepositoryImpl - IStoreRepository 구현체
 * Clean Architecture의 Data Layer에서 Domain Layer의 인터페이스를 구현
 * DataSource와 Domain Entity 사이의 매핑을 담당
 */
export class StoreRepositoryImpl implements IStoreRepository {
  private dataSource = new StoreDataSource();

  /**
   * 회사의 모든 활성 상점 조회
   */
  async getStores(companyId: string): Promise<StoreResult> {
    try {
      const data = await this.dataSource.getStores(companyId);

      // DTO → Domain Entity 변환
      // Backup과 동일한 필드 매핑: store_id, store_name, store_address, store_phone, huddle_time, payment_time, allowed_distance
      const stores = data.map((dto: any) =>
        new Store(
          dto.store_id,
          dto.company_id,
          dto.store_name,
          dto.store_address, // backup uses store_address
          dto.store_phone,   // backup uses store_phone
          !dto.is_deleted,   // is_active = NOT is_deleted
          dto.huddle_time,   // backup uses huddle_time
          dto.payment_time,  // backup uses payment_time
          dto.allowed_distance // backup uses allowed_distance
        )
      );

      return { success: true, data: stores };
    } catch (error) {
      console.error('StoreRepository.getStores error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch stores',
      };
    }
  }

  /**
   * 새 상점 생성
   */
  async createStore(
    companyId: string,
    storeName: string,
    address: string | null,
    phone: string | null
  ) {
    try {
      await this.dataSource.createStore(companyId, storeName, address, phone);
      return { success: true };
    } catch (error) {
      console.error('StoreRepository.createStore error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to create store',
      };
    }
  }

  /**
   * 상점 삭제 (Soft Delete)
   */
  async deleteStore(storeId: string) {
    try {
      await this.dataSource.deleteStore(storeId);
      return { success: true };
    } catch (error) {
      console.error('StoreRepository.deleteStore error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to delete store',
      };
    }
  }
}
