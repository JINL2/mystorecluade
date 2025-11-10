/**
 * useInvoice Hook
 * Custom hook for invoice management
 */

import { useState, useEffect, useCallback } from 'react';
import { Invoice } from '../../domain/entities/Invoice';
import { InvoiceRepositoryImpl } from '../../data/repositories/InvoiceRepositoryImpl';
import { PaginationInfo } from '../../domain/repositories/IInvoiceRepository';

export const useInvoice = (companyId: string, storeId: string | null) => {
  const [invoices, setInvoices] = useState<Invoice[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [pagination, setPagination] = useState<PaginationInfo | null>(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage] = useState(20);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [dateRange, setDateRange] = useState<{ start: string; end: string }>(() => {
    // Default to "all" - 10 years ago to today
    const today = new Date();
    const tenYearsAgo = new Date(today.getFullYear() - 10, 0, 1);
    return {
      start: tenYearsAgo.toISOString().split('T')[0],
      end: today.toISOString().split('T')[0],
    };
  });

  const repository = new InvoiceRepositoryImpl();

  const loadInvoices = useCallback(async () => {
    console.log('🟡 useInvoice.loadInvoices - starting...', {
      companyId,
      companyId_type: typeof companyId,
      storeId,
      storeId_type: typeof storeId,
      currentPage,
      searchQuery,
      dateRange,
      dateRange_start: dateRange.start,
      dateRange_end: dateRange.end,
    });

    setLoading(true);
    setError(null);

    try {
      const result = await repository.getInvoices(
        companyId,
        storeId,
        currentPage,
        itemsPerPage,
        searchQuery || null,
        dateRange.start,
        dateRange.end
      );

      console.log('🟡 useInvoice.loadInvoices - result:', result);
      console.log('🟡 useInvoice - DETAILED RESULT:', {
        success: result.success,
        data_exists: !!result.data,
        data_type: typeof result.data,
        data_is_array: Array.isArray(result.data),
        data_length: result.data?.length,
        first_invoice: result.data?.[0],
        pagination: result.pagination,
      });

      if (!result.success) {
        console.log('❌ useInvoice - Result not successful:', result.error);
        setError(result.error || 'Failed to load invoices');
        setInvoices([]);
        setPagination(null);
        return;
      }

      console.log('🟢 useInvoice - Setting invoices:', result.data?.length || 0);
      setInvoices(result.data || []);
      setPagination(result.pagination || null);
      console.log('🟡 useInvoice.loadInvoices - success, invoices:', result.data?.length);
    } catch (err) {
      console.error('❌ useInvoice.loadInvoices - error:', err);
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setInvoices([]);
      setPagination(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, currentPage, itemsPerPage, searchQuery, dateRange]);

  useEffect(() => {
    if (companyId && companyId !== '') {
      console.log('🟡 useInvoice - useEffect triggered, loading invoices...');
      loadInvoices();
    } else {
      console.log('🟡 useInvoice - No companyId, skipping load');
      setLoading(false);
    }
  }, [companyId, storeId, currentPage, searchQuery, dateRange, loadInvoices]);

  const changeDateRange = useCallback((start: string, end: string) => {
    console.log('🟡 useInvoice.changeDateRange:', { start, end });
    setDateRange({ start, end });
    setCurrentPage(1); // Reset to first page
  }, []);

  const changeSearch = useCallback((query: string) => {
    console.log('🟡 useInvoice.changeSearch:', query);
    setSearchQuery(query);
    setCurrentPage(1); // Reset to first page
  }, []);

  const changePage = useCallback((page: number) => {
    console.log('🟡 useInvoice.changePage:', page);
    setCurrentPage(page);
  }, []);

  const refresh = useCallback(() => {
    console.log('🟡 useInvoice.refresh - reloading invoices...');
    loadInvoices();
  }, [loadInvoices]);

  return {
    invoices,
    loading,
    error,
    pagination,
    currentPage,
    searchQuery,
    dateRange,
    changeDateRange,
    changeSearch,
    changePage,
    refresh,
  };
};
