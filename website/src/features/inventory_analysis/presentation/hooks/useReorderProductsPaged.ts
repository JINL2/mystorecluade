/**
 * useReorderProductsPaged Hook
 * Fetches reorder products with pagination from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { reorderProductsPagedRepository } from '../../data/repositories/ReorderProductsPagedRepository';
import type {
  ReorderProductsPaged,
  ReorderStatusFilter,
} from '../../domain/entities/reorderProductsPaged';

export interface UseReorderProductsPagedOptions {
  autoLoad?: boolean;
  categoryId?: string;
  statusFilter?: ReorderStatusFilter;
  pageSize?: number;
}

export interface UseReorderProductsPagedResult {
  data: ReorderProductsPaged | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
  // Pagination controls
  page: number;
  setPage: (page: number) => void;
  nextPage: () => void;
  prevPage: () => void;
  goToFirstPage: () => void;
  // Filter controls
  setCategoryId: (categoryId: string | undefined) => void;
  setStatusFilter: (filter: ReorderStatusFilter | undefined) => void;
  // Computed values
  totalPages: number;
  isFirstPage: boolean;
  isLastPage: boolean;
}

export const useReorderProductsPaged = (
  companyId: string | undefined,
  options: UseReorderProductsPagedOptions = {}
): UseReorderProductsPagedResult => {
  const {
    autoLoad = true,
    categoryId: initialCategoryId,
    statusFilter: initialStatusFilter,
    pageSize = 20,
  } = options;

  const [data, setData] = useState<ReorderProductsPaged | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Pagination state
  const [page, setPage] = useState(0);

  // Filter state
  const [categoryId, setCategoryId] = useState<string | undefined>(initialCategoryId);
  const [statusFilter, setStatusFilter] = useState<ReorderStatusFilter | undefined>(initialStatusFilter);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setData(null);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await reorderProductsPagedRepository.getReorderProductsPaged({
        companyId,
        categoryId,
        statusFilter,
        page,
        pageSize,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch reorder products';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, categoryId, statusFilter, page, pageSize]);

  // Reset page when filters change
  useEffect(() => {
    setPage(0);
  }, [categoryId, statusFilter]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, categoryId, statusFilter, page, pageSize, fetchData]);

  // Pagination helpers
  const totalPages = data ? Math.ceil(data.totalCount / data.pageSize) : 0;
  const isFirstPage = page === 0;
  const isLastPage = !data?.hasMore;

  const nextPage = useCallback(() => {
    if (data?.hasMore) {
      setPage((prev) => prev + 1);
    }
  }, [data?.hasMore]);

  const prevPage = useCallback(() => {
    if (page > 0) {
      setPage((prev) => prev - 1);
    }
  }, [page]);

  const goToFirstPage = useCallback(() => {
    setPage(0);
  }, []);

  // Filter setters with page reset
  const handleSetCategoryId = useCallback((newCategoryId: string | undefined) => {
    setCategoryId(newCategoryId);
  }, []);

  const handleSetStatusFilter = useCallback((newFilter: ReorderStatusFilter | undefined) => {
    setStatusFilter(newFilter);
  }, []);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
    page,
    setPage,
    nextPage,
    prevPage,
    goToFirstPage,
    setCategoryId: handleSetCategoryId,
    setStatusFilter: handleSetStatusFilter,
    totalPages,
    isFirstPage,
    isLastPage,
  };
};
