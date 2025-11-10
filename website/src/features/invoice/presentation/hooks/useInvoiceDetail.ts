/**
 * useInvoiceDetail Hook
 * Custom hook for fetching invoice details
 */

import { useState, useCallback } from 'react';
import { InvoiceRepositoryImpl } from '../../data/repositories/InvoiceRepositoryImpl';
import { InvoiceDetailResult } from '../../domain/repositories/IInvoiceRepository';

export const useInvoiceDetail = () => {
  const [detail, setDetail] = useState<InvoiceDetailResult['data'] | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const repository = new InvoiceRepositoryImpl();

  const fetchDetail = useCallback(async (invoiceId: string) => {
    setLoading(true);
    setError(null);

    try {
      const result = await repository.getInvoiceDetail(invoiceId);

      if (!result.success) {
        setError(result.error || 'Failed to load invoice detail');
        setDetail(null);
        return;
      }

      setDetail(result.data || null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setDetail(null);
    } finally {
      setLoading(false);
    }
  }, []);

  const clearDetail = useCallback(() => {
    setDetail(null);
    setError(null);
    setLoading(false);
  }, []);

  return {
    detail,
    loading,
    error,
    fetchDetail,
    clearDetail,
  };
};
