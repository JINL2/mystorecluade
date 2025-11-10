import { useState, useEffect, useCallback } from 'react';
import { Currency } from '../../domain/entities/Currency';
import { CurrencyRepositoryImpl } from '../../data/repositories/CurrencyRepositoryImpl';

export const useCurrency = (companyId: string) => {
  const [currencies, setCurrencies] = useState<Currency[]>([]);
  const [loading, setLoading] = useState(true);
  const repository = new CurrencyRepositoryImpl();

  const load = useCallback(async () => {
    if (!companyId) return;
    setLoading(true);
    const result = await repository.getCurrencies(companyId);
    if (result.success) setCurrencies(result.data || []);
    setLoading(false);
  }, [companyId]);

  useEffect(() => { load(); }, [load]);

  const setDefault = useCallback(async (currencyId: string) => {
    const result = await repository.setDefaultCurrency(currencyId);
    if (result.success) await load();
    return result;
  }, [load]);

  return { currencies, loading, setDefault };
};
