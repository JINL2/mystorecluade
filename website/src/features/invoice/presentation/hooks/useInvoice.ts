/**
 * useInvoice Hook
 * Custom hook wrapper for invoice Zustand store
 * Following 2025 Best Practice: Zustand + Custom Hooks Pattern
 */

import { useEffect } from 'react';
import { useInvoiceStore } from '../providers/invoice_provider';
import type { DateFilterType, DateFilter, AmountFilter } from '../providers/states/types';

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
  const itemsPerPage = useInvoiceStore((state) => state.itemsPerPage);
  const searchQuery = useInvoiceStore((state) => state.searchQuery);
  const dateRange = useInvoiceStore((state) => state.dateRange);
  const selectedStoreId = useInvoiceStore((state) => state.selectedStoreId);
  const activeFilter = useInvoiceStore((state) => state.activeFilter);
  const dateSortFilter = useInvoiceStore((state) => state.dateSortFilter);
  const amountSortFilter = useInvoiceStore((state) => state.amountSortFilter);
  const selectedInvoice = useInvoiceStore((state) => state.selectedInvoice);
  const invoiceDetail = useInvoiceStore((state) => state.invoiceDetail);
  const detailLoading = useInvoiceStore((state) => state.detailLoading);
  const refunding = useInvoiceStore((state) => state.refunding);

  // ========== Select Actions from Zustand Store ==========
  const setSelectedStoreId = useInvoiceStore((state) => state.setSelectedStoreId);
  const setActiveFilter = useInvoiceStore((state) => state.setActiveFilter);
  const setDateSortFilter = useInvoiceStore((state) => state.setDateSortFilter);
  const setAmountSortFilter = useInvoiceStore((state) => state.setAmountSortFilter);
  const setSelectedInvoice = useInvoiceStore((state) => state.setSelectedInvoice);
  const changeDateRange = useInvoiceStore((state) => state.changeDateRange);
  const changeSearch = useInvoiceStore((state) => state.changeSearch);
  const changePage = useInvoiceStore((state) => state.changePage);
  const loadInvoices = useInvoiceStore((state) => state.loadInvoices);
  const fetchInvoiceDetail = useInvoiceStore((state) => state.fetchInvoiceDetail);
  const refundInvoice = useInvoiceStore((state) => state.refundInvoice);
  const refundInvoices = useInvoiceStore((state) => state.refundInvoices);
  const refresh = useInvoiceStore((state) => state.refresh);
  const clearDetail = useInvoiceStore((state) => state.clearDetail);

  // ========== Auto-load Invoices on Mount or Filter Changes ==========
  // Note: searchQuery removed from dependencies - search is now client-side
  useEffect(() => {
    if (companyId && companyId !== '') {
      console.log('🟡 useInvoice - useEffect triggered, loading invoices...');
      loadInvoices(companyId);
    } else {
      console.log('🟡 useInvoice - No companyId, skipping load');
    }
  }, [companyId, selectedStoreId, currentPage, dateRange, dateSortFilter, amountSortFilter, loadInvoices]);

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
    itemsPerPage,
    searchQuery,
    dateRange,
    selectedStoreId,
    activeFilter,
    dateSortFilter,
    amountSortFilter,
    selectedInvoice,
    invoiceDetail,
    detailLoading,
    refunding,

    // Actions
    setSelectedStoreId: handleStoreChange,
    setActiveFilter,
    setDateSortFilter,
    setAmountSortFilter,
    setSelectedInvoice,
    changeDateRange: handleDateFilterChange,
    changeSearch,
    changePage,
    fetchInvoiceDetail,
    refundInvoice,
    refundInvoices,
    refresh: handleRefresh,
    clearDetail,
  };
};
