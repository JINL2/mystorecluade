/**
 * useInvoice Hook
 * Custom hook wrapper for invoice Zustand store
 * Following 2025 Best Practice: Zustand + Custom Hooks Pattern
 */

import { useEffect } from 'react';
import { useInvoiceStore } from '../providers/invoice_provider';
import type { DateFilterType } from '../providers/states/types';

/**
 * Invoice hook that wraps Zustand store
 * Provides clean interface for components to access invoice state and actions
 */
export const useInvoice = (companyId: string) => {
  // ========== Select State from Zustand Store ==========
  const invoices = useInvoiceStore((state) => state.invoices);
  const loading = useInvoiceStore((state) => state.loading);
  const error = useInvoiceStore((state) => state.error);
  const pagination = useInvoiceStore((state) => state.pagination);
  const currentPage = useInvoiceStore((state) => state.currentPage);
  const searchQuery = useInvoiceStore((state) => state.searchQuery);
  const dateRange = useInvoiceStore((state) => state.dateRange);
  const selectedStoreId = useInvoiceStore((state) => state.selectedStoreId);
  const activeFilter = useInvoiceStore((state) => state.activeFilter);
  const selectedInvoice = useInvoiceStore((state) => state.selectedInvoice);
  const invoiceDetail = useInvoiceStore((state) => state.invoiceDetail);
  const detailLoading = useInvoiceStore((state) => state.detailLoading);
  const refunding = useInvoiceStore((state) => state.refunding);

  // ========== Select Actions from Zustand Store ==========
  const setSelectedStoreId = useInvoiceStore((state) => state.setSelectedStoreId);
  const setActiveFilter = useInvoiceStore((state) => state.setActiveFilter);
  const setSelectedInvoice = useInvoiceStore((state) => state.setSelectedInvoice);
  const changeDateRange = useInvoiceStore((state) => state.changeDateRange);
  const changeSearch = useInvoiceStore((state) => state.changeSearch);
  const changePage = useInvoiceStore((state) => state.changePage);
  const loadInvoices = useInvoiceStore((state) => state.loadInvoices);
  const fetchInvoiceDetail = useInvoiceStore((state) => state.fetchInvoiceDetail);
  const refundInvoice = useInvoiceStore((state) => state.refundInvoice);
  const refresh = useInvoiceStore((state) => state.refresh);
  const clearDetail = useInvoiceStore((state) => state.clearDetail);

  // ========== Auto-load Invoices on Mount or Filter Changes ==========
  useEffect(() => {
    if (companyId && companyId !== '') {
      console.log('🟡 useInvoice - useEffect triggered, loading invoices...');
      loadInvoices(companyId);
    } else {
      console.log('🟡 useInvoice - No companyId, skipping load');
    }
  }, [companyId, selectedStoreId, currentPage, searchQuery, dateRange, loadInvoices]);

  // ========== Wrapped Actions with Enhanced Logic ==========
  const handleStoreChange = (storeId: string | null) => {
    console.log('🟢 useInvoice.handleStoreChange - storeId:', storeId);
    setSelectedStoreId(storeId);
  };

  const handleDateFilterChange = (filter: DateFilterType, start: string, end: string) => {
    console.log('🟢 useInvoice.handleDateFilterChange:', { filter, start, end });
    setActiveFilter(filter);
    changeDateRange(start, end);
  };

  const handleRefresh = () => {
    console.log('🟢 useInvoice.handleRefresh - reloading...');
    refresh(companyId);
  };

  // ========== Return Interface ==========
  return {
    // State
    invoices,
    loading,
    error,
    pagination,
    currentPage,
    searchQuery,
    dateRange,
    selectedStoreId,
    activeFilter,
    selectedInvoice,
    invoiceDetail,
    detailLoading,
    refunding,

    // Actions
    setSelectedStoreId: handleStoreChange,
    setActiveFilter,
    setSelectedInvoice,
    changeDateRange: handleDateFilterChange,
    changeSearch,
    changePage,
    fetchInvoiceDetail,
    refundInvoice,
    refresh: handleRefresh,
    clearDetail,
  };
};
