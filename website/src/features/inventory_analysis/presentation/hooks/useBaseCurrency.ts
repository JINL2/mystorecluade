/**
 * useBaseCurrency Hook
 * Fetches base currency and company currencies from RPC
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { baseCurrencyRepository } from '../../data/repositories/BaseCurrencyRepository';
import type { BaseCurrencyResponse, CurrencyInfo, CompanyCurrency } from '../../domain/entities/baseCurrency';

export interface UseBaseCurrencyOptions {
  autoLoad?: boolean;
}

export interface UseBaseCurrencyResult {
  data: BaseCurrencyResponse | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
  // Convenience accessors
  baseCurrency: CurrencyInfo | null;
  currencySymbol: string;
  currencyCode: string;
  companyCurrencies: CompanyCurrency[];
  // Helper functions
  getCurrencyByCode: (code: string) => CompanyCurrency | undefined;
  getExchangeRate: (currencyCode: string) => number;
  convertToBase: (amount: number, fromCurrencyCode: string) => number;
}

export const useBaseCurrency = (
  companyId: string | undefined,
  options: UseBaseCurrencyOptions = {}
): UseBaseCurrencyResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<BaseCurrencyResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setData(null);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await baseCurrencyRepository.getBaseCurrency({
        companyId,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch base currency';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, fetchData]);

  // Convenience accessors
  const baseCurrency = data?.baseCurrency ?? null;
  const currencySymbol = data?.baseCurrency?.symbol ?? '₫';
  const currencyCode = data?.baseCurrency?.currencyCode ?? 'VND';
  const companyCurrencies = data?.companyCurrencies ?? [];

  // Helper functions
  const getCurrencyByCode = useCallback((code: string): CompanyCurrency | undefined => {
    return companyCurrencies.find((c) => c.currencyCode === code);
  }, [companyCurrencies]);

  const getExchangeRate = useCallback((code: string): number => {
    const currency = getCurrencyByCode(code);
    return currency?.exchangeRateToBase ?? 1;
  }, [getCurrencyByCode]);

  const convertToBase = useCallback((amount: number, fromCurrencyCode: string): number => {
    const rate = getExchangeRate(fromCurrencyCode);
    return amount * rate;
  }, [getExchangeRate]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
    baseCurrency,
    currencySymbol,
    currencyCode,
    companyCurrencies,
    getCurrencyByCode,
    getExchangeRate,
    convertToBase,
  };
};
