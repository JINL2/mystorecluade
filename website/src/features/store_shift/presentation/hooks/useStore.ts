import { useState, useEffect, useCallback } from 'react';
import { Store } from '../../domain/entities/Store';
import { StoreRepositoryImpl } from '../../data/repositories/StoreRepositoryImpl';
import { StoreValidator } from '../../domain/validators/StoreValidator';

/**
 * useStore Hook - Store 비즈니스 로직 실행
 *
 * Clean Architecture Pattern:
 * 1. Validator 호출 (검증 실행)
 * 2. Repository 호출 (데이터 처리)
 */
export const useStore = (companyId: string) => {
  const [stores, setStores] = useState<Store[]>([]);
  const [loading, setLoading] = useState(true);
  const repository = new StoreRepositoryImpl();

  const load = useCallback(async () => {
    if (!companyId) return;
    setLoading(true);
    const result = await repository.getStores(companyId);
    if (result.success) setStores(result.data || []);
    setLoading(false);
  }, [companyId]);

  useEffect(() => { load(); }, [load]);

  /**
   * 상점 생성
   * 1. StoreValidator로 검증 실행
   * 2. Repository로 데이터 처리
   */
  const create = useCallback(async (storeName: string, address: string | null, phone: string | null) => {
    // 1. Validator 호출 (검증 실행)
    const validationErrors = StoreValidator.validateCreateStore(storeName, address, phone);
    if (validationErrors.length > 0) {
      return {
        success: false,
        error: validationErrors[0].message
      };
    }

    // 2. Repository 호출 (데이터 처리)
    const result = await repository.createStore(companyId, storeName, address, phone);
    if (result.success) await load();
    return result;
  }, [companyId, load]);

  const remove = useCallback(async (storeId: string) => {
    const result = await repository.deleteStore(storeId);
    if (result.success) await load();
    return result;
  }, [load]);

  return { stores, loading, create, remove };
};
