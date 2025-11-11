import { useState, useEffect, useCallback } from 'react';
import { Currency } from '../../domain/entities/Currency';
import { CurrencyType } from '../../domain/repositories/ICurrencyRepository';
import { CurrencyRepositoryImpl } from '../../data/repositories/CurrencyRepositoryImpl';

export const useCurrency = (companyId: string, userId: string) => {
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

  const getAllCurrencyTypes = useCallback(async (): Promise<CurrencyType[]> => {
    const result = await repository.getAllCurrencyTypes();
    return result.success ? (result.data || []) : [];
  }, []);

  const setDefault = useCallback(async (currencyId: string) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    const result = await repository.setDefaultCurrency(currencyId, companyId);
    if (result.success) await load();
    return result;
  }, [load, companyId]);

  const updateExchangeRate = useCallback(async (currencyId: string, newRate: number) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    if (!userId) return { success: false, error: 'No user ID' };
    const result = await repository.updateExchangeRate(currencyId, companyId, newRate, userId);
    if (result.success) await load();
    return result;
  }, [load, companyId, userId]);

  const addCurrency = useCallback(async (currencyId: string, exchangeRate: number) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    if (!userId) return { success: false, error: 'No user ID' };
    const result = await repository.addCurrency(currencyId, companyId, exchangeRate, userId);
    if (result.success) await load();
    return result;
  }, [load, companyId, userId]);

  return { currencies, loading, getAllCurrencyTypes, setDefault, updateExchangeRate, addCurrency };
};
