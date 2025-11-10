import { useState, useEffect, useCallback } from 'react';
import { Store } from '../../domain/entities/Store';
import { StoreRepositoryImpl } from '../../data/repositories/StoreRepositoryImpl';

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

  const create = useCallback(async (storeName: string, address: string | null, phone: string | null) => {
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
