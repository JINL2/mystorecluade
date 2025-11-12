import { useState, useEffect, useCallback } from 'react';
import { Currency } from '../../domain/entities/Currency';
import type { CurrencyTypeDTO } from '../../data/models/CurrencyTypeModel';
import { CurrencyRepositoryImpl } from '../../data/repositories/CurrencyRepositoryImpl';
import { CurrencyValidator } from '../../domain/validators/CurrencyValidator';

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

  const getAllCurrencyTypes = useCallback(async (): Promise<CurrencyTypeDTO[]> => {
    const result = await repository.getAllCurrencyTypes();
    return result.success ? (result.data || []) : [];
  }, []);

  const setDefault = useCallback(async (currencyId: string) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    const result = await repository.setDefaultCurrency(currencyId, companyId);
    if (result.success) await load();
    return result;
  }, [load, companyId]);

  const updateExchangeRate = useCallback(async (currencyId: string, newRate: number | string) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    if (!userId) return { success: false, error: 'No user ID' };

    // Validate exchange rate using domain validator
    const validationResult = CurrencyValidator.validateExchangeRate(newRate);
    if (!validationResult.isValid) {
      return { success: false, error: validationResult.error };
    }

    const rate = typeof newRate === 'string' ? parseFloat(newRate) : newRate;
    const result = await repository.updateExchangeRate(currencyId, companyId, rate, userId);
    if (result.success) await load();
    return result;
  }, [load, companyId, userId]);

  const addCurrency = useCallback(async (currencyId: string, exchangeRate: number | string) => {
    if (!companyId) {
      return { success: false, error: 'No company selected' };
    }
    if (!userId) {
      return { success: false, error: 'No user ID' };
    }

    // Validate using domain validator (ARCHITECTURE.md pattern)
    const validationResult = CurrencyValidator.validateAddCurrency(currencyId, exchangeRate);
    if (!validationResult.isValid) {
      return { success: false, error: validationResult.error };
    }

    const rate = typeof exchangeRate === 'string' ? parseFloat(exchangeRate) : exchangeRate;
    const result = await repository.addCurrency(currencyId, companyId, rate, userId);

    if (result.success) await load();
    return result;
  }, [load, companyId, userId]);

  const removeCurrency = useCallback(async (currencyId: string) => {
    if (!companyId) return { success: false, error: 'No company selected' };
    const result = await repository.removeCurrency(currencyId, companyId);
    if (result.success) await load();
    return result;
  }, [load, companyId]);

  return { currencies, loading, getAllCurrencyTypes, setDefault, updateExchangeRate, addCurrency, removeCurrency };
};
