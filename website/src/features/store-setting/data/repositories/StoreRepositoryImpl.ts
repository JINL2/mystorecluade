import { IStoreRepository, StoreResult } from '../../domain/repositories/IStoreRepository';
import { StoreDataSource } from '../datasources/StoreDataSource';
import { StoreModel } from '../models/StoreModel';

/**
 * StoreRepositoryImpl - IStoreRepository 구현체
 * Clean Architecture의 Data Layer에서 Domain Layer의 인터페이스를 구현
 * DataSource와 Domain Entity 사이의 매핑을 담당
 * StoreModel을 사용하여 DTO ↔ Entity 변환
 */
export class StoreRepositoryImpl implements IStoreRepository {
  private dataSource = new StoreDataSource();

  /**
   * 회사의 모든 활성 상점 조회
   */
  async getStores(companyId: string): Promise<StoreResult> {
    try {
      const data = await this.dataSource.getStores(companyId);

      // DTO → Domain Entity 변환 (StoreModel 사용)
      const stores = data.map((dto: any) => StoreModel.fromJson(dto));

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
